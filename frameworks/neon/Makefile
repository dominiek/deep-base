
.PHONY: dependencies
dependencies:
	apt-get -y install python-virtualenv

.PHONY: src
src:
	git clone --recursive https://github.com/NervanaSystems/neon.git src
	cd src; git checkout v1.8.2

.PHONY: build
build:
	cd src; make sysinstall

.PHONY: install
install:
	echo "OK"

.PHONY: load_test
load_test:
	python test/load.py
