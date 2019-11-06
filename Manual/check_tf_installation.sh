#! /bin/bash

## Verify Tensorflow Installation

export PY=python3.5

echo "Installed TF version: `${PY} -c "import tensorflow as tf; print(tf.__version__)"`"
${PY} -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"
echo " Checking TF Computation Abilities: `${PY} -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"`"
