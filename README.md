
### Running an official image

You can run one of the automatic [builds](https://hub.docker.com/r/bvlc/caffe). E.g. for the CPU version:

`docker run -it bvlc/caffe:gpu caffe --version`

or for GPU support (You need a CUDA 8.0 capable driver and
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker)):

`nvidia-docker run -it bvlc/caffe:gpu caffe --version`

You might see an error about libdc1394, ignore it.

### Docker run options

By default caffe runs as root, thus any output files, e.g. snapshots, will be owned
by root. It also runs by default in a container-private folder:

`yi-docker-admin <<container_ID>>`

You can change this using flags, like user (-u), current directory, and volumes (-w and -v).
E.g. this behaves like the usual caffe executable:

Option #1 -->> Using original cafee docker image:

`docker run --rm -u $(id -u):$(id -g) -v $(pwd):$(pwd) -w $(pwd) bvlc/caffe:gpu caffe train --solver=example_solver.prototxt`

Option #2 -->> Using yi/tflow-vnc:tag docker image:

`yi-docker-run`

Original containers can also be used interactively, specifying e.g. `bash` or `ipython`
instead of `caffe`.

```
docker run -it bvlc/caffe:gpu ipython
import caffe
...
```

The caffe build requirements are included in the container, so this can be used to
build and run custom versions of caffe. Also, `caffe/python` is in PATH, so python
utilities can be used directly, e.g. `draw_net.py`, `classify.py`, or `detect.py`.

### Building Caffe only images yourself

Example:
```
git clone --branch=gpu-py-3.6 --depth=1 https://github.com/igor71/Caffe-1.0/

cd Caffe-1.0

docker build -f Dockerfile.Caffe -t yi/tflow-vnc:caffe-python-3.6 .
```
You can also build original Caffe docker image and run the tests inside:

`docker run -it bvlc/caffe:gpu ipython bash -c "cd /opt/caffe/build; make runtest"`

Please Note, prior to build docker image need build from the sources Tensorflow CPU/GPU package on desired server

