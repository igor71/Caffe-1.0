### How-TO
```
1. Make sure ubuntu:16.04 image existing on the target server
2. Make sure desired tensorflow package in .../Tensorflow/Current folder
3. Run parametrized Jenkins job and chose target server to build docker images
```

### Create caffe 1.0 docker image:
```
docker build -t yi/caffe:cpu -f Dockerfile .
```

### Create caffe-tensorflow docker image:
```
docker build -t yi/caffe:cpu-tf -f Dockerfile.tf .
```
### Running caffe docker image:
```
docker run -it yi/caffe:cpu /bin/bash
python
import caffe
import tensorflow as tf
```
```
docker run -ti yi/caffe:cpu ipython
```
### Running caffe-tensorflow docker image:
```
docker run -it yi/caffe:cpu-tf /bin/bash
python
import caffe
import tensorflow as tf
```
```
docker run -ti yi/caffe:cpu-tf ipython

docker run -it yi/caffe:cpu caffe --version

docker run -ti yi/caffe:cpu-tf ipython /cpu_tf_check.py
```
