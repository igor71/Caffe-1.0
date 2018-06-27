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
```
