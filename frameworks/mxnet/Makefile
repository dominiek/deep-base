
.PHONY: dependencies
dependencies:
	echo "OK"

.PHONY: src
src:
	git clone --recursive https://github.com/dmlc/mxnet src
	cd src; git checkout v0.9.3

.PHONY: build
build:
	cd src; make -j4

.PHONY: install
install:
	export PYTHONPATH=/workdir/frameworks/mxnet/src/python:$$PYTHONPATH
	echo 'export PYTHONPATH=/workdir/frameworks/mxnet/src/python:$$PYTHONPATH' >> ~/.bashrc

.PHONY: load_test
load_test:
	PYTHONPATH=/workdir/frameworks/mxnet/src/python:$(PYTHONPATH) python test/load.py
