############################################################
#            Installing Caffe & Python Dependences         #
############################################################

apt-get install -y --no-install-recommends \
         mlocate \
         doxygen  \
         libatlas-base-dev \
         libboost-all-dev \
         libgflags-dev \
         libgoogle-glog-dev \
         libhdf5-serial-dev \
         libleveldb-dev  \
         liblmdb-dev \
         libopencv-dev \
         libprotobuf-dev \
         libsnappy-dev \
         libopenblas-dev \
         protobuf-compiler


#################################################
#          Setting Build ENV Variables          #
#################################################

export PYTHONPATH="${PYTHONPATH}:/opt/caffe/python"
export CUDA_ARCH_BIN="52 61 70"

#######################################
#            Installing CAFFE         #
#######################################

cd /opt
git clone https://github.com/BVLC/caffe.git
cd caffe/python
sed -i 's/python-dateutil>=1.4,<2/python-dateutil>=2.6.1/g' requirements.txt
for req in $(cat requirements.txt) pydot; do pip install $req; done && cd ..
sed -i '425d' Makefile
sed -i '424 a NVCCFLAGS += -D_FORCE_INLINES -ccbin=$(CXX) -Xcompiler -fPIC $(COMMON_FLAGS)' Makefile
curl -OSL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/Caffe/Makefile-PY-3.5.config -o Makefile.config
###### Installing NCCL, latest  version from github repository ############################
git clone --branch=master --depth=1 https://github.com/NVIDIA/nccl.git
cd nccl
sed -i '28d' makefiles/common.mk
sed -i '28d' makefiles/common.mk
sed -i '27 a CUDA8_GENCODE = -gencode=arch=compute_35,code=sm_35 \\' makefiles/common.mk
##### Reduce the binary size, to only include the architecture of the target platforms #####
make -j$nc src.build NVCC_GENCODE="-gencode=arch=compute_52,code=sm_52 -gencode=arch=compute_61,code=sm_61 -gencode=arch=compute_70,code=sm_70" && \
make install && \
##### Checking installed NCCL verion #############################
updatedb && \
locate nccl| grep "libnccl.so" | tail -n1 | sed -r 's/^.*\.so\.//' && \
cd .. && rm -rf nccl && \
cd /opt/caffe
echo $PWD
################# Continue with CAFEE build ######################
mkdir build
sed -i '35d' CMakeLists.txt
sed -i '34 a set(python_version "3" CACHE STRING "Specify which Python version to use")' CMakeLists.txt
cd build
cmake -D CUDA_ARCH_NAME=Manual -D CUDA_ARCH_BIN="${CUDA_ARCH_BIN}" \
      -D USE_CUDNN=1 -D USE_NCCL=1 ..
make -j$nc
make pycaffe -j$nc
apt-get clean
rm -rf /var/lib/apt/list/*


#################################################
#          Setting CAFFE ENV Variables          #
#################################################

export CAFFE_ROOT=/opt/caffe
export PYCAFFE_ROOT=$CAFFE_ROOT/python
export PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
