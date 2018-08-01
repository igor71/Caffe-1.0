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

nvidia-docker run -it yi/caffe:gpu caffe --version

nvidia-docker run -ti yi/caffe:gpu-tf ipython /gpu_tf_check.py
```
