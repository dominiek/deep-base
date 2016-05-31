FROM ubuntu:14.04
ARG GPU_SUPPORT
WORKDIR /workdir
ADD . /workdir
RUN apt-get update --fix-missing
RUN apt-get -y install curl wget python python-numpy python-scipy python-dev python-pip git-core vim

RUN make global_dependencies

# Compile Caffe
WORKDIR /workdir/frameworks/caffe
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make test

# Compile Tensorflow
WORKDIR /workdir/frameworks/tensorflow
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make load_test

# Compile MXNet
WORKDIR /workdir/frameworks/mxnet
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make load_test

# Compile Torch
WORKDIR /workdir/frameworks/torch
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make load_test

# Compile Openface
WORKDIR /workdir/frameworks/openface
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make load_test

# Cleanup to make container smaller
WORKDIR /workdir
RUN make clean_global_dependencies
