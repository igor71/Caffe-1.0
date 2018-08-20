### How-TO
```
1. Make sure nvidia/cuda:X.0-cudnnX-devel-ubuntu16.04 image existing on the target server
2. Make sure desired tensorflow package in .../Tensorflow/Current folder
3. Run parametrized Jenkins job and chose target server to build docker images
```

### Create caffe 1.0 docker image:
```
docker build -t yi/caffe:gpu -f Dockerfile .
```

### Create caffe-tensorflow docker image:
```
docker build -t yi/caffe:gpu-tf -f Dockerfile.tf .
```
### Running caffe docker image:
```
nvidia-docker run -it yi/caffe:gpu /bin/bash
python
import caffe
import tensorflow as tf
```
```
docker run -ti yi/caffe:gpu ipython
```
### Running caffe-tensorflow docker image:
```
nvidia-docker run -it yi/caffe:gpu-tf /bin/bash
python
import caffe
import tensorflow as tf
```
```
nvidia-docker run -ti yi/caffe:gpu-tf ipython

nvidia-docker run -it yi/caffe:gpu-tf caffe --version

nvidia-docker run -ti yi/caffe:gpu-tf ipython -c "import tensorflow; print(tensorflow.__version__)"

nvidia-docker run -ti yi/caffe:gpu-tf ipython /gpu_tf_check.py
```
