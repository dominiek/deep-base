
.PHONY: dependencies
dependencies:
	apt-get -y install python-h5py python-yaml

.PHONY: src
src:
	git clone --recursive https://github.com/fchollet/keras.git src
	cd src; git checkout 1.2.2

.PHONY: build
build:
	cd src; python setup.py install

.PHONY: install
install:
	echo "OK"

.PHONY: load_test
load_test:
	python test/load.py
