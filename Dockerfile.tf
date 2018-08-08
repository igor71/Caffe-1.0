FROM yi/caffe:cpu

LABEL MAINTAINER="Igor Rabkin<igor.rabkin@xiaoyi.com>"

################################################
#          Basic desktop environment           #
################################################

# Locale, language
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

#################################################
#          Set Time Zone Asia/Jerusalem         #
#################################################

ENV TZ=Asia/Jerusalem
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#################################################
#     Very basic installations                  #
#################################################

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends \
    python-software-properties \
    software-properties-common \
    python-dev \
    build-essential \
    iputils-ping \
    zip \
    unzip \
    tree \
    tzdata \
    pkg-config && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/


##################################################################
#                Pick up some TF dependencies                    #
##################################################################

RUN apt-get update && apt-get install -y --no-install-recommends \
    emacs \
    golang && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

################################
# Updating PIP and Dependences #
################################

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install --upgrade \
    pip setuptools

###################################
# Install TensorFlow GPU version. #
###################################

  RUN cd /
  ARG CRED="server:123server123"
  TF_BRANCH=$(curl ftp://$CRED@yifileserver/DOCKER_IMAGES/Tensorflow/CPU/ | sort -V | tail -n 1)
  RUN  curl -u ${CRED} ftp://yifileserver/DOCKER_IMAGES/Tensorflow/CPU/${TF_BRANCH} -o ${TF_BRANCH} && \
       pip --no-cache-dir install ${TF_BRANCH} && \
       rm -f ${TF_BRANCH}

################# Setting UP Environment ###################
ENV CI_BUILD_PYTHON=python \
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH} \
    PYTHON_BIN_PATH=/usr/bin/python \
    PYTHON_LIB_PATH=/usr/local/lib/python2.7/dist-packages

############################################################


################ INTEL MKL SUPPORT #################
ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ARG CRED="server:123server123"
RUN cd /usr/local/lib && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libiomp5.so -o libiomp5.so && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libmklml_gnu.so -o libmklml_gnu.so && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libmklml_intel.so -o libmklml_intel.so

####################################################


#################################
# Check Tensorflow Installation #
#################################

COPY cpu_tf_check.py /


#########################################
# Add Welcome Message With Instructions #
#########################################


RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' \
	>> /etc/bash.bashrc \
	; echo "\
||||||||||||||||||||||||||||||||||||||||||||||||||\n\
|                                                |\n\
| Docker container running Ubuntu                |\n\
| with TensorFlow ${TF_BRANCH} optimized for CPU             |\n\
| with Intel(R) MKL Support                      |\n\
|                                                |\n\
||||||||||||||||||||||||||||||||||||||||||||||||||\n\
\n "\
	> /etc/motd

