
DEEP_BASE_VERSION = 1.0
GPU_SUPPORT ?= 0

.PHONY: docker.build.gpu
docker.build.gpu:
	-@docker stop dominiek/deep-base
	-@docker rm dominiek/deep-base
	docker build -t dominiek/deep-base-gpu -f Dockerfile.gpu .

.PHONY: docker.build
docker.build:
	-@docker stop dominiek/deep-base
	-@docker rm dominiek/deep-base
	docker build -t dominiek/deep-base .

.PHONY: docker.clean
docker.clean:
	docker rm $(shell docker ps -a -q)
	docker rmi $(shell docker images -q)

.PHONY: global_dependencies
global_dependencies:
	echo $(DEEP_BASE_VERSION) > /etc/deep_base_version
	ln -s /dev/null /dev/raw1394
	pip install cython
	pip install scikit-learn
	pip install bhtsne
ifeq ($(GPU_SUPPORT),1)
	@echo "Building with GPU support"
	#echo 'export PYTHONPATH=/workdir/frameworks/caffe/src/python:$$PYTHONPATH' >> ~/.bashrc
	#echo 'export LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:/usr/local/cuda/lib64' >> ~/.bashrc
	cd utils/cuda_device_query; make; cp deviceQuery /usr/local/bin/cuda_device_query
else
	@echo "Building CPU-only"
endif

.PHONY: clean_global_dependencies
clean_global_dependencies:
	apt-get remove -y git-core curl
