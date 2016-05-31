
.PHONY: dependencies
dependencies:
	echo "OK"

.PHONY: src
src:
	git clone --recursive https://github.com/torch/distro.git src

.PHONY: build
build:
	cd src; bash install-deps

.PHONY: install
install:
	cd src; ./install.sh

.PHONY: load_test
load_test:
	. ~/.bashrc; th -h
