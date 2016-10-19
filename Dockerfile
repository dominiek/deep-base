FROM ubuntu:14.04

ARG GPU_SUPPORT

ENV PYTHONPATH="/workdir/frameworks/mxnet/src/python:/workdir/frameworks/caffe/src/python:/workdir/frameworks/caffe/src/python:"
ENV PATH="/workdir/frameworks/torch/src/install/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV DYLD_LIBRARY_PATH="/workdir/frameworks/torch/src/install/lib:"
ENV LD_LIBRARY_PATH="/workdir/frameworks/torch/src/install/lib::/usr/local/cuda/lib64"
ENV LUA_CPATH="/workdir/frameworks/torch/src/install/lib/?.so;/root/.luarocks/lib/lua/5.1/?.so;/workdir/frameworks/torch/src/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"
ENV LUA_PATH="/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/workdir/frameworks/torch/src/install/share/lua/5.1/?.lua;/workdir/frameworks/torch/src/install/share/lua/5.1/?/init.lua;./?.lua;/workdir/frameworks/torch/src/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"

RUN apt-get update --fix-missing
RUN apt-get -y install curl wget python python-numpy python-scipy python-dev python-pip git-core vim

RUN make global_dependencies

WORKDIR /workdir
ADD . /workdir

# Compile Caffe
WORKDIR /workdir/frameworks/caffe
RUN make dependencies
RUN make src
RUN make build
RUN make install
RUN make load_test

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
RUN ln -s /dev/null /dev/raw1394
