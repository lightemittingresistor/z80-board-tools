ZASM_REPO=http://k1.spdns.de/Git/zasm-4.0.git
ZASM_LIBS_REPO=http://k1.spdns.de/Git/Libraries.git

ZASM_TAG=4.1.5

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
	cd download && git clone ${ZASM_REPO} zasm-src
	cd download/zasm-src && git checkout ${ZASM_TAG}
	touch $@

download/zasm-libs-cloned:
	mkdir -p download
	cd download && git clone ${ZASM_LIBS_REPO} Libraries
	cd download/Libraries && git checkout zasm-4.0
	touch $@

download/zasm-libsfixed: download/zasm-cloned download/zasm-libs-cloned
	mkdir -p download
	cd download/zasm-src/ && rm Libraries && ln -s ../Libraries/ Libraries
	cd download/zasm-src/ && rm lib-z80 && ln -s ../Libraries/lib-z80 lib-z80
	touch $@

# make a tarball to avoid cloning too much
download/zasm.tar.gz: download/zasm-libsfixed
	cd download && tar -czf zasm.tar.gz zasm-src Libraries

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

