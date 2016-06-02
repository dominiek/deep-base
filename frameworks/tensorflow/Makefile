
GPU_SUPPORT ?= 0

.PHONY: dependencies
dependencies:
	apt-get -y install software-properties-common
	add-apt-repository -y ppa:webupd8team/java
	apt-get update
	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	apt-get -y install oracle-java8-installer unzip
	wget "https://github.com/bazelbuild/bazel/releases/download/0.2.3/bazel-0.2.3-jdk7-installer-linux-x86_64.sh"
	chmod +x bazel-0.2.3-jdk7-installer-linux-x86_64.sh
	./bazel-0.2.3-jdk7-installer-linux-x86_64.sh
	rm -f bazel-0.2.3-jdk7-installer-linux-x86_64.sh
	bash /usr/local/lib/bazel/bin/bazel-complete.bash
	apt-get -y install swig

.PHONY: src
src:
	git clone --recurse-submodules https://github.com/tensorflow/tensorflow src

.PHONY: build
build:
ifeq ($(GPU_SUPPORT),1)
	cd src; GCC_HOST_COMPILER_PATH=/usr/bin/gcc PYTHON_BIN_PATH=/usr/bin/python TF_NEED_GCP=0 CUDA_TOOLKIT_PATH="/usr/local/cuda" CUDNN_INSTALL_PATH="/usr/local/cuda" TF_NEED_CUDA=1 TF_CUDA_COMPUTE_CAPABILITIES="3.0" TF_CUDNN_VERSION="5" TF_CUDA_VERSION="7.5" TF_CUDA_VERSION_TOOLKIT=7.5 ./configure
	cd src; bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
else
	cd src; PYTHON_BIN_PATH=/usr/bin/python TF_NEED_GCP=0 TF_NEED_CUDA=0 ./configure
	cd src; bazel build -c opt //tensorflow/tools/pip_package:build_pip_package
endif

.PHONY: install
install:
	cd src; bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
	pip install /tmp/tensorflow_pkg/*

.PHONY: load_test
load_test:
ifeq ($(GPU_SUPPORT),1)
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):/usr/local/cuda/lib64 python test/load.py
else
	python test/load.py
endif
