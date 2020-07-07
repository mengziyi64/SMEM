# Snapshot Multispectral Endomicriscopy (SMEM)
This repository contains the codes for paper **Snapshot Multispectral Endomicriscopy** (***Optics Letter (2020)***) by [Ziyi Meng](https://github.com/mengziyi64), Mu Qiao, Jiawei Ma, Zhenming Yu, Kun Xu, [Xin Yuan](https://www.bell-labs.com/usr/x.yuan).
[[pdf]](https://www.osapublishing.org/ol/abstract.cfm?uri=ol-45-14-3897)  [[data (One Drive)]](https://1drv.ms/u/s!Au_cHqZBKiu2gYEx13twAfSXQz7T-A?e=nigUp7)  [[data (Baidu Drive pw:drnu)]](https://pan.baidu.com/s/1Irf7U4oOjt6kDjB3G-zwQg)

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
Fig. 2 Imaging results of blood sample. Upper row: reconstruction of fresh blood sample. lower row: reconstruction of the blood sample settled in the air for 5 minutes. The oxygen saturation (OS) of the selected regions were calculated using the reconstructed spectra. 

<p align="center">
<img src="Result/Images/Media.gif" width="800">
</p>
Fig. 3 A reconstructed multispectral video of moving red blood cells.

## Usage
### Download the SMEM repository and model file
0. Requirements are Python 3.6 and Tensorflow 1.13.
1. Download this repository via git
```
git clone https://github.com/mengziyi64/SMEM
```
or download the [zip file](https://github.com/mengziyi64/SMEM/archive/master.zip) manually.

3. Download the model file (2.16 GB) via [Google Drive](https://drive.google.com/file/d/1B2bDLyeb3fQqoZSqO94evGQHdpb9hsq4/view?usp=sharing) or [One Drive](https://1drv.ms/u/s!Au_cHqZBKiu2gYEvyPAm-tqXy35Lwg?e=6SaQcH) or [Baidu Drive (pw:k7wg)](https://pan.baidu.com/s/1dEKjnrLs2Lo0lCyHt4wo1g) and put the file into path 'Result/Model-Condig/Model-Chechpoint1/'.

### Testing on real data
Run **test.py** to reconstruct 5 real datasets (blood sample1, blood sample2, dog olfactory membrane, fern root, resolution target). The results will be saved in 'Result/Testing-Result/' in the MatFile format.

### Training 
0. Put multispectral datasets (Ground truth) into corrsponding path, i.e., 'Data/Training_truth/' for training data and 'Data/Valid_truth/' for validation data. For our setting, the data should be scaled to 0-1 and with a size of 660×660×24.
1. Adjust training parameter by modify **Model/Config.yaml**.
2. Run **train.py**.

## Citation
@article{Meng_2020_OL_SMEM,
author = {Ziyi Meng and Mu Qiao and Jiawei Ma and Zhenming Yu and Kun Xu and Xin Yuan},
journal = {Opt. Lett.},
number = {14},
pages = {3897--3900},
publisher = {OSA},
title = {Snapshot multispectral endomicroscopy},
volume = {45},
month = {Jul},
year = {2020},
}
## Contact
Ziyi Meng, Beijing University of Posts and Telecommunications, Email: mengziyi@bupt.edu.cn, zm233@njit.edu

Xin Yuan, Bell Labs, Email: xyuan@bell-labs.com
