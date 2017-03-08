
.PHONY: dependencies
dependencies:
	apt-get -y install libboost-python-dev cmake
	pip install dlib
	. ~/.bashrc; for lib in dpnn nn optim optnet csvigo cutorch cunn fblualib torchx tds; do \
		luarocks install $$lib ; \
	done

.PHONY: src
src:
	git clone --recursive https://github.com/cmusatyalab/openface.git src
	cd src; git checkout 0.2.1

.PHONY: build
build:
	echo "OK"

.PHONY: install
install:
	cd src; python setup.py install

.PHONY: load_test
load_test:
	echo "Skip"
