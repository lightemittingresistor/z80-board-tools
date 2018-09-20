ZASM_REPO=https://bitbucket.org/megatokio/zasm.git
ZASM_LIBS_REPO=https://bitbucket.org/megatokio/libraries.git

ZASM_TAG=master

OUTDIR=$(CURDIR)/outdir

all: zasm

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    ZASM_DIR=Linux
    QMAKE=qmake-qt5
endif
ifeq ($(UNAME_S),Darwin)
    ZASM_DIR=OSX
    QMAKE=qmake
endif

download/zasm-cloned:
	mkdir -p download
	cd download && git clone --recurse-submodules ${ZASM_REPO} zasm-src
	cd download/zasm-src && git checkout ${ZASM_TAG}
	touch $@

# make a tarball to avoid cloning too much
download/zasm.tar.gz: download/zasm-cloned
	cd download && tar -czf zasm.tar.gz zasm-src

build/zasm-extracted: download/zasm.tar.gz
	mkdir -p build
	cd build && tar -xf ../download/zasm.tar.gz

build/zasm-built: build/zasm-extracted
	mkdir -p ${OUTDIR}/bin
	cd build/zasm-src/${ZASM_DIR} && ${QMAKE} PREFIX=${OUTDIR}
	cd build/zasm-src/${ZASM_DIR} && make
	cp build/zasm-src/${ZASM_DIR}/zasm ${OUTDIR}/bin
	touch $@

zasm: build/zasm-built

clean:
	rm -rf build
	rm -rf outdir

