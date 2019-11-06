## Building Caffe && Faffe-TF images manually

*Note, this image will use distributed python v.3.5.2 as default for all users*

*Note-2, Latest version of TF which working with python 3.5.2 & caffe v.1.0.0 is 1.12.3. Newer TF version may not work on Ubuntu 16*

### Building Caffe Only Image Manually

```
image_id="$(docker images -q yi/tflow-gui:latest)"

if [ "$image_id" != "b957ba8c24f2" ]; then docker rmi -f yi/tflow-gui:latest; fi

pv -f /media/common/DOCKER_IMAGES/Tflow-GUI/9.0-cudnn7-base/yi-tflow-gui-1.13.tar | docker load

docker tag b957ba8c24f2 yi/tflow-gui:latest

git clone --branch=gpu-ubuntu-16-py-3.6-CUDA-9 --depth=1 https://github.com/igor71/Caffe-1.0/

cd Caffe-1.0

docker build -f Dockerfile.Caffe -t yi/tflow-vnc:caffe-python-3.5 .

yi-docker tflow-vnc run :<port_number> --version=caffe-python-3.5

yi-dockeradmin $USER-tflow-vnc
```

### Building Caffe-TF Image Manually

```
image_id="$(docker images -q yi/tflow-gui:latest)"

if [ "$image_id" != "b957ba8c24f2" ]; then docker rmi -f yi/tflow-gui:latest; fi

pv -f /media/common/DOCKER_IMAGES/Tflow-GUI/9.0-cudnn7-base/yi-tflow-gui-1.13.tar | docker load

docker tag b957ba8c24f2 yi/tflow-gui:latest

yi-docker tflow-vnc run :13  --image=yi/tflow-gui --version=latest

yi-dockeradmin $USER-tflow-vnc

git clone --branch=gpu-ubuntu-16-py-3.6-CUDA-9 --depth=1 https://github.com/igor71/Caffe-1.0/

cd Caffe-1.0/Manual

bash install_caffe.sh

bash install_tf.sh

docker ps

docker tag <IMAGE_ID> yi/tflow-vnc:caffe-1.12.3-python-3.5

yi-docker tflow-vnc run :13  --version=caffe-1.12.3-python-3.5

yi-dockeradmin $USER-tflow-vnc

#### Verify Tensorflow Installation ####

PY=python3.5

echo "Installed TF version: `${PY} -c "import tensorflow as tf; print(tf.__version__)"`"

${PY} -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"

echo " Checking TF Computation Abilities: `${PY} -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"`"
```

### Running CAFFE Benchmark Tests
```
yi-docker-run <<container_ID>>

yi-dockeradmin <<container_name>>

cd $CAFFE_ROOT

./data/mnist/get_mnist.sh

./examples/mnist/create_mnist.sh
```
Run Benchmark on CPU:

`./build/tools/caffe time --model=examples/mnist/lenet_train_test.prototxt`

Run Benchmark on GPU:

`./build/tools/caffe time --model=examples/mnist/lenet_train_test.prototxt --gpu 0`
