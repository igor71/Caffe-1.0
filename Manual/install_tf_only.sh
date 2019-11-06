#!/bin/bash

###################################
# Install TensorFlow GPU version. #
###################################

cd /
FTP_PATH=ftp://jenkins-cloud/pub/Current/tensorflow_gpu-1.12.3-cp35-cp35m-manylinux1_x86_64.whl
FILE_NAME=tensorflow_gpu-1.12.3-cp35-cp35m-manylinux1_x86_64.whl

### Installing numpy latest compatible with TF version 1.12.3
numpy_version=$(pip list | grep numpy | cut -d' ' -f16)
echo "Installed ver.$numpy_version"
if [ $numpy_version == 1.16.5 ] ; then
   echo " Requirement already satisfied: installed version $numpy_version"
else
    pip uninstall -y numpy
    pip --no-cache-dir install numpy==1.16.5
fi
#############################################################

curl -OSL ${FTP_PATH} -o ${FILE_NAME}
pip --no-cache-dir install ${FILE_NAME}
rm -f ${FILE_NAME}
apt-get clean
rm -rf /var/lib/apt/lists/*

## Verify Tensorflow Installation
cd /tmp
ldconfig
updatedb
echo "Installed TF version: `${PY} -c "import tensorflow as tf; print(tf.__version__)"`"
echo " Checking TF Computation Abilities: `${PY} -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"`"
