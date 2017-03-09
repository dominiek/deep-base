
.PHONY: dependencies
dependencies:
	echo "OK"

.PHONY: src
src:
	git clone --recursive https://github.com/dominiek/transferflow.git src
	cd src; git checkout v0.1.4

.PHONY: build
build:
	cd src; make

.PHONY: install
install:
	cd src; python setup.py install

.PHONY: load_test
load_test:
	python test/load.py
