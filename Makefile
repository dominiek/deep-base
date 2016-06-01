
GPU_SUPPORT ?= 0

.PHONY: docker.build
docker.build:
	-@docker stop deep-base
	-@docker rm deep-base
	docker build --build-arg GPU_SUPPORT=$(GPU_SUPPORT) -t deep-base .

.PHONY: docker.clean
docker.clean:
	docker rm $(shell docker ps -a -q)
	docker rmi $(shell docker images -q)

.PHONY: global_dependencies
global_dependencies:
ifeq ($(GPU_SUPPORT),1)
	@echo "Building with GPU support, installing CUDA/CUDNN"
	-curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb; \
		dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb; \
		apt-get update; \
		apt-get -y install cuda-toolkit-7.5
	tar xfzv downloads/cudnn-7.5-linux-x64-v5.0-ga.tgz; \
		cp cuda/lib64/* /usr/local/cuda/lib64/.; \
		cp cuda/include/* /usr/local/cuda/include/.; \
		rm -rf cuda
else
	@echo "Building CPU-only, not installing CUDA/CUDNN"
endif

.PHONY: clean_global_dependencies
clean_global_dependencies:
	apt-get remove -y g++ git-core curl gcc make
ifeq ($(GPU_SUPPORT),1)
	apt-get remove -y cuda-samples-7-5 cuda-documentation-7-5 cuda-visual-tools-7-5
endif
