
# Deep Learning Base Image

Today's deep learning frameworks require an extraordinary amount of work to install and run. This Docker container bundles all popular deep learning frameworks into a single Docker instance. Ubuntu Linux is the base OS of choice for this container (it is a requirement for CUDA and all DL frameworks play nice with it).

Supported DL frameworks:

- [Tensorflow](https://www.tensorflow.org/)
- [Caffe](http://caffe.berkeleyvision.org/)
- [Theano](http://deeplearning.net/software/theano/)
- [Keras](http://keras.io/)
- [MXNet](http://mxnet.readthedocs.io/en/latest/)
- [Torch](http://torch.ch/)
- [Chainer](http://chainer.org/)
- [Neon](http://neon.nervanasys.com/docs/latest/index.html)

Other ML frameworks:

- Python / SciPy / Numpy / DLib
- [Scikit-Learn](http://scikit-learn.org/stable/)
- [Scikit-Image](http://scikit-image.org/)
- [OpenFace](https://cmusatyalab.github.io/openface/)

### Use the Docker image

If you are running on a Linux host OS with CUDA-compatible hardware, use the `gpu` tag when pulling the Docker image:

```
docker pull dominiek/deep-base:gpu
```

Otherwise for CPU-only run:

```
docker pull dominiek/deep-base:cpu
```

You can now use any of the supported frameworks inside the Docker container:

```
docker -it dominiek/deep-base:gpu --privileged python
import tensorflow
import matplotlib
matplotlib.use('Agg')
import caffe
import openface
```

To run code from the Host OS simply mount the source code dir:
```
mkdir code
echo 'import tensorflow' > code/app.py
docker run --volume `pwd`/code:/code -it dominiek/deep-base:gpu --privileged python /code/app.py
I tensorflow/stream_executor/dso_loader.cc:108] successfully opened CUDA library libcublas.so.7.5 locally
I tensorflow/stream_executor/dso_loader.cc:108] successfully opened CUDA library libcudnn.so.5 locally
I tensorflow/stream_executor/dso_loader.cc:108] successfully opened CUDA library libcufft.so.7.5 locally
I tensorflow/stream_executor/dso_loader.cc:108] successfully opened CUDA library libcuda.so locally
I tensorflow/stream_executor/dso_loader.cc:108] successfully opened CUDA library libcurand.so.7.5 locally
```

In order to use `deep-base` as a base for your deployment's docker container specify the right `FROM` directive following in your `Dockerfile`:

```
FROM dominiek/deep-base:gpu
```

### Build a customized Docker image

This is optional. In order to start the build process execute:

```
  make docker.build
```

During the build process small tests will be done to make sure compiled Python bindings load properly.

For GPU support (requires CUDA-compatible host hardware and Linux host OS):

```
  GPU_SUPPORT=1 make docker.build
```

### Performance

There is a CPU and a GPU version of this Docker container. The latter will require [CUDA compatible hardware](https://developer.nvidia.com/cuda-gpus) which include AWS GPU instances. When running Docker on a Linux host OS there is no virtual machine used and all CUDA hardware can be fully utilized.

Note however that on Windows and Mac OS X a virtual machine like VirtualBox is used which does not support GPU passthrough. This means no GPU can be used on these host OS's. The recommended pattern here is to use virtualization in a Windows/Mac based local development environment, but really use Linux for staging and production environments.

### TODO

- Create the MNIST example that can be run easily
- Create a benchmark utility that shows performance of frameworks in running instance
- Use OpenBlas for frameworks that support it
- Reduce container size footprint of image
