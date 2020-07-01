import tensorflow as tf
import tensorflow.contrib.layers as layers
import tensorflow.contrib.slim as slim
import numpy as np
import math
import os
import json

from Lib.Utility import *
from Model.Base_TFModel import Basement_TFModel

class Depth_Decoder(Basement_TFModel):
    
    def __init__(self, value_sets, init_learning_rate, sess, config, is_training=True, *args, **kwargs):
        
        super(Depth_Decoder, self).__init__(sess=sess, config=config, learning_rate=init_learning_rate,is_training=is_training)

        (measurement, mat_sense, truth) = value_sets
        self.depth = mat_sense.get_shape().as_list()[-1]
        self.batch_size = truth.get_shape().as_list()[0]
                
        self.decoded_image = self.encdec_handler(measurement, mat_sense)
        self.metric_opt(self.decoded_image, truth)
        
    def encdec_handler(self, measurement, mat_sense):

        self.hyper_structure = [(3,64,3,3),(3,128,3,2),(3,256,3,2),(3,512,3,2),(3,800,3,2)]    #(lnum,knum,ksize,pstr)
        self.end_encoder = (2,1280,3)
        
        encoder_in = measurement
        output = self.inference(encoder_in, 0.8, phase_train=True)
        return output
    
    def inference(self, images, keep_probability, phase_train=True, bottleneck_layer_size=128, weight_decay=0.0, reuse=None):
        batch_norm_params = {
            # Decay for the moving averages.
            'decay': 0.995,
            # epsilon to prevent 0s in variance.
            'epsilon': 0.001,
            # force in-place updates of mean and variance estimates
            'updates_collections': None,
            'scale':True,
            'is_training':phase_train,
            # Moving averages ends up in the trainable variables collection
            'variables_collections': [tf.GraphKeys.TRAINABLE_VARIABLES],}
        
        with slim.arg_scope([slim.conv2d, slim.fully_connected,slim.conv2d_transpose],
                            weights_initializer=slim.initializers.xavier_initializer(),
                            weights_regularizer=slim.l2_regularizer(weight_decay),
                            normalizer_fn=slim.batch_norm,normalizer_params=batch_norm_params):
            return self.encoder_decoder(images, is_training=phase_train,dropout_keep_prob=keep_probability,reuse=reuse)
    
    
    def EncConv_module(self, net, module_ind, hyper_struc, flag_res=True, PoolValid=True):
        (lnum,knum,ksize,pstr) = hyper_struc
        for layer_cnt in range(1,1+lnum):
            if layer_cnt == 2 and flag_res == True:
                net = self.module_res2net(net,module_ind,4)
            else:
                net = slim.conv2d(net, knum, ksize, stride=1, padding='SAME',scope='en_%d_%d'%(module_ind,layer_cnt))
        self.end_points['encode_%d'%(module_ind)] = net
        if PoolValid is True:
            return slim.max_pool2d(net,pstr,stride=pstr,padding='SAME',scope='Pool%d'%(module_ind))
        else:
            return net

    def DecConv_module(self, net, module_ind, hyper_struc, flag_res=True, PoolValid=True, dif=None):
        (lnum,knum,ksize,pstr) = hyper_struc
        if PoolValid is True:
            net = slim.conv2d_transpose(net, knum, pstr, pstr, padding='SAME')
        if dif is not None:
            net = self.Decoder_reshape(net,dif,module_ind)
        net=tf.concat([net,self.end_points['encode_%d'%(module_ind)]],3)
        for layer_cnt in range(1,1+lnum):
            if layer_cnt == 2 and flag_res == True:
                net = self.module_res2net(net,module_ind,4,scope='Dec')
            else:
                net = slim.conv2d(net, knum, ksize, stride=1, padding='SAME',scope='de_%d_%d'%(module_ind,layer_cnt))
        return net
    
    def Decoder_reshape(self, decoder, dif, module_ind):
        kdepth = decoder.get_shape().as_list()[-1]
        decoder = slim.conv2d(decoder, kdepth, (1+dif,1+dif), padding='VALID', scope='conv_reshape_%d'%(module_ind))
        return decoder
    
    def module_res2net(self, net, module_ind=0, subsets=4,scope='Enc'):
        with tf.variable_scope(scope+'module_res_%d'%(module_ind)):
            (batch_size,height,width,num_feature) = net.get_shape().as_list()
            size_set = int(num_feature/subsets)
            output = net[:,:,:,:size_set]
            cube = slim.conv2d(net[:, :, :, size_set:2*size_set],size_set,3,stride=1,padding='SAME',scope='res_cube_1')
            output = tf.concat([output,cube],-1)
            for i in range(2,subsets):
                cube = output[:,:,:,-size_set:]+net[:, :, :, i*size_set:(i+1)*size_set]
                cube = slim.conv2d(cube, size_set, 3, stride=1,padding='SAME',scope='res_cube_%d'%(i))
                output = tf.concat([output, cube], -1)
        return output
            
    def encoder_decoder(self, inputs, is_training=True, dropout_keep_prob=0.8, reuse=None, scope='generator'):
        self.end_points = {}
        with tf.variable_scope(scope, 'generator', [inputs], reuse=reuse):
            with slim.arg_scope([slim.batch_norm, slim.dropout],is_training=is_training):
                with slim.arg_scope([slim.conv2d, slim.max_pool2d, slim.avg_pool2d],stride=1, padding='SAME'):
                    ############################# encoder ##############################################
                    net = self.EncConv_module(inputs,1,self.hyper_structure[0],False)
                    net = self.EncConv_module(net,2,self.hyper_structure[1])
                    net = self.EncConv_module(net,3,self.hyper_structure[2])
                    net = self.EncConv_module(net,4,self.hyper_structure[3])

                    for recur_ind in range(3):
                        with tf.variable_scope('Recur_%d'%(recur_ind)):
                            net = self.EncConv_module(net,5,self.hyper_structure[4])
                            (lnum,knum,ksize) = self.end_encoder
                            net = slim.conv2d(net, knum, ksize, stride=1, padding='SAME', scope='en_6')
                            net = slim.conv2d(net, knum, ksize, stride=1, padding='SAME', scope='en_7')
                            net = self.DecConv_module(net, 5, self.hyper_structure[4])

                    ############################# decoder ##############################################
                    net = self.DecConv_module(net,4,self.hyper_structure[3],dif=1)
                    net = self.DecConv_module(net,3,self.hyper_structure[2])
                    net = self.DecConv_module(net,2,self.hyper_structure[1])
                    net = self.DecConv_module(net,1,self.hyper_structure[0],False)
                        
                    net=slim.conv2d(net,self.depth,1,stride=1,padding='SAME',activation_fn=tf.nn.sigmoid)
        return net
    
    def metric_opt(self, model_output, ground_truth):
        
        if self.loss_func == 'MSE':
            self.loss = loss_mse(model_output, ground_truth)
        elif self.loss_func == 'RMSE':
            self.loss = loss_rmse(model_output, ground_truth)
        elif self.loss_func == 'SSIM':
            self.loss = loss_SSIM(model_output, ground_truth)
        else:
            self.loss = loss_rmse(model_output, ground_truth)
            
        self.metrics = calculate_metrics(model_output, ground_truth)
        global_step = tf.train.get_or_create_global_step()
            
        if self.is_training:
            optimizer = tf.train.AdamOptimizer(self.learning_rate)
            tvars = tf.trainable_variables()
            grads = tf.gradients(self.loss, tvars)
            grads, _ = tf.clip_by_global_norm(grads, self.max_grad_norm)
            self.train_op = optimizer.apply_gradients(zip(grads, tvars), global_step=global_step, name='train_op')
        self.info_merge = tf.summary.merge_all()
    