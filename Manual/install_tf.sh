export PY=python3.5

##############################################################
#            Installing Caffe & TF Dependences               #
##############################################################

apt-get update && apt-get install -y --no-install-recommends \
  libzmq3-dev \
  libcurl3-dev \
  libgoogle-perftools-dev \
  python3-tk


##################################################################
#              Pick up some TF dependencies                      #
##################################################################

curl -SL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/Caffe/tf_requirements.txt -o /tmp/tf_requirements.txt
for tf_req in $(cat /tmp/tf_requirements.txt); do ${PY} -m pip --no-cache-dir install $tf_req; done
${PY} -m ipykernel.kernelspec


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
echo "Installed TF version: `${PY} -c "import tensorflow as tf; print(tf.__version__)"`"
${PY} -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"
echo " Checking TF Computation Abilities: `${PY} -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"`"


##################################################
# Configure the build for our CUDA configuration #
##################################################

export CI_BUILD_PYTHON=python
export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
export TF_NEED_CUDA=1
export TF_CUDA_COMPUTE_CAPABILITIES=5.2,6.1
export TF_CUDA_VERSION=9.0
export TF_CUDNN_VERSION=7
export TF_NCCL_VERSION=2.4
