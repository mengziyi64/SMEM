# Snapshot Multispectral Endomicriscopy (SMEM)
This repository contains the codes for paper **Snapshot Multispectral Endomicriscopy** (***Optics Letter (2020)***) by [Ziyi Meng](https://github.com/mengziyi64), Mu Qiao, Jiawei Ma, Zhenming Yu, Kun Xu, [Xin Yuan](https://www.bell-labs.com/usr/x.yuan).
[[pdf]](https://www.osapublishing.org/DirectPDFAccess/E232E79A-630F-4A1A-BA414C23A65AC2F0_ads393213.pdf?da=1&adsid=393213&journal=3&seq=0&mobile=no) [[data (Google Drive)]](https://drive.google.com/drive/folders/1_j7iCS6phfYd4ecbGy9cjPppnU6lAn5K?usp=sharing)  [[data (One Drive)]](https://1drv.ms/u/s!Au_cHqZBKiu2gYEx13twAfSXQz7T-A?e=nigUp7)  [[data (Baidu Drive pw:drnu)]](https://pan.baidu.com/s/1Irf7U4oOjt6kDjB3G-zwQg)

## Overviewer
This source code provides a end-to-end DNN for the reconstruction of multisprctral endomicroscopy images captured by a snapshot compressiver imager. This snapshot compressiver imager is based on [SD-CASSI](https://www.osapublishing.org/ao/abstract.cfm?uri=ao-47-10-B44) prototype system, in which 3D spectral cubes can be recovered from captured 2D compressive measurements by optimazation algorithms or DNNs. The real cuptured data has been included in this repository.

## Results
<p align="center">
<img src="Result/Images/fern_root_recon.png" width="1200">
</p>
Fig. 1 Reconstructed multispectral images of a fern root section. Left: an RGB image (top) and the compressed measurement (bottom) of the sample. Middle: multispectral images with 24 spectral channels reconstructed from the developed DNN model. Right: reconstructed spectra of two selected regions indicated in the RGB image.

<p align="center">
<img src="Result/Images/blood_sample_recon.png" width="600">
</p>
Fig. 2 Imaging results of blood sample. Upper row: reconstruction of fresh blood sample. lower row: reconstruction of the blood sample settled in the air for 5 minutes. The oxygen
saturation (OS) of the selected regions were calculated using the reconstructed spectra. A reconstructed hyperspectral video of moving red blood cells is shown in [Video1].

## Usage
### Download the SMEM repository and model file
0. Requirements are Python 3.6 and Tensorflow 1.13.
1. Download this repository via git
```
git clone https://github.com/mengziyi64/SMEM
```
or download the [zip file](https://github.com/mengziyi64/SMEM/archive/master.zip) manually.

3. Download the model file (2.16 GB) via [Google Drive] (https://drive.google.com/file/d/1B2bDLyeb3fQqoZSqO94evGQHdpb9hsq4/view?usp=sharing) or [One Drive](https://1drv.ms/u/s!Au_cHqZBKiu2gYEvyPAm-tqXy35Lwg?e=6SaQcH) or [Baidu Drive (pw:k7wg)] (https://pan.baidu.com/s/1dEKjnrLs2Lo0lCyHt4wo1g) and put the file into path 'Result/Model-Condig/Model-Chechpoint1/'.

### Testing on real data
Run **test.py** to reconstruct 5 real datasets (blood sample1, blood sample2, dog olfactory membrane, fern root, resolution target). The results will be saved in 'Result/Testing-Result/' in the MatFile format.

### Training 
0. Put multispectral datasets (Ground truth) into corrsponding path, i.e., 'Data/Training_truth/' for training data and 'Data/Valid_truth/' for validation data. For our setting, the data should be scale to 0-1 and with a size of 660×660×24.
1. Adjust training parameter by modify **Model/Config.yaml**.
2. Run **train.py**.

## Citation

## Contact
Ziyi Meng, Beijing University of Posts and Telecommunications, Email: mengziyi@bupt.edu.cn, zm233@njit.edu

Xin Yuan, Bell Labs, Email: xyuan@bell-labs.com
