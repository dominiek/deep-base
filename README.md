
# Deep Learning Base Image

Today's deep learning frameworks require an extraordinary amount of work to install and run. This Docker container bundles all popular deep learning frameworks into a single Docker instance. Ubuntu Linux is the base OS of choice for this container (it is a requirement for CUDA and all DL frameworks play nice with it).

Supported DL frameworks:

- [Tensorflow](https://www.tensorflow.org/) (v1.0.1)
- [Caffe](http://caffe.berkeleyvision.org/) (RC5)
- [Theano](http://deeplearning.net/software/theano/)
- [Keras](http://keras.io/) (v1.2.2)
- [MXNet](http://mxnet.readthedocs.io/en/latest/) (v0.9.3)
- [Torch](http://torch.ch/)
- [Chainer](http://chainer.org/)
- [Neon](http://neon.nervanasys.com/docs/latest/index.html) (v1.8.2)
- [Transferflow](http://github.com/dominiek/transferflow) (v0.1.4)

Other ML frameworks:

- Python / SciPy / Numpy / DLib
- [Scikit-Learn](http://scikit-learn.org/stable/)
- [Scikit-Image](http://scikit-image.org/)
- [OpenFace](https://cmusatyalab.github.io/openface/) (v0.2.1)

### Usage

_For GPU usage see below_

Run the latest version. All DL frameworks are available at your fingertips:

```
docker run -it dominiek/deep-base:latest python
import tensorflow
import matplotlib
matplotlib.use('Agg')
import caffe
import openface
```

Or a specific version tag:

```
docker pull dominiek/deep-base:v1.3
```

In order to use `deep-base` as a base for your deployment's docker container specify the right `FROM` directive following in your `Dockerfile`:

```
FROM dominiek/deep-base:v1.3
```

To run code from the Host OS simply mount the source code dir:

```
mkdir code
echo 'import tensorflow' > code/app.py
docker run --volume `pwd`/code:/code -it dominiek/deep-base:latest python /code/app.py
```

### GPU Usage

GPU support requires many additional libraries like Nvidia CUDA and CuDNN. There is a separate Docker repository for the GPU version:

```
FROM dominiek/deep-base-gpu:v1.3
```

Running the GPU image requires you to bind the host OS's CUDA libraries and devices. This requires the same CUDA version on the host OS as inside deep-base (Cuda 8.0)

The most reliable way to do this is to use [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker):

```bash
nvidia-docker run -it dominiek/deep-base-gpu /bin/bash
```

Alternatively, you can use vanilla docker and bind the devices:

```bash
export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda.* | xargs -I{} echo '-v {}:{}')
export CUDA_DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device {}:{}')
docker run --privileged $CUDA_SO $CUDA_DEVICES -it dominiek/deep-base-gpu /bin/bash
```

Now, to make sure that the GPU hardware is working correctly, use the `cuda_device_query` command inside the container:

```bash
root@37a895460633:/workdir# cuda_device_query
...
Result = PASS
```

### Build a customized Docker image

This is optional. In order to start the build process execute:

```
  make docker.build
```

During the build process small tests will be done to make sure compiled Python bindings load properly.

For GPU support (requires CUDA-compatible host hardware and Linux host OS):

```
  make docker.build.gpu
```

### Performance

There is a CPU and a GPU version of this Docker container. The latter will require [CUDA compatible hardware](https://developer.nvidia.com/cuda-gpus) which include AWS GPU instances. When running Docker on a Linux host OS there is no virtual machine used and all CUDA hardware can be fully utilized.

Note however that on Windows and Mac OS X a virtual machine like VirtualBox is used which does not support GPU passthrough. This means no GPU can be used on these host OS's. The recommended pattern here is to use virtualization in a Windows/Mac based local development environment, but really use Linux for staging and production environments.

### TODO

- Add the MNIST example that can be run easily
- Create a benchmark utility that shows performance of frameworks in running instance
- Use OpenBlas for frameworks that support it
- Reduce container size footprint of image
