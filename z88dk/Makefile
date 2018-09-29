Z88DK_REPO=https://github.com/mich181189/z88dk.git

LIBXML_TARBALL=libxml2-2.9.8.tar.gz
LIBXML_URL=ftp://xmlsoft.org/libxml2/${LIBXML_TARBALL}

OUTDIR=$(CURDIR)/outdir

export PATH := $(CURDIR)/build/z88dk/bin:${OUTDIR}/bin:$(PATH)
export LD_LIBRARY_PATH := ${OUTDIR}/lib:$(LD_LIBRARY_PATH)
export ZCCCFG := $(CURDIR)/build/z88dk/lib/config/

all: z88dk

download/${LIBXML_TARBALL}:
	curl -L ${LIBXML_URL} -o download/${LIBXML_TARBALL}

build/libxml-extracted: download/${LIBXML_TARBALL}
	mkdir -p build
	cd build && tar -xf ../download/${LIBXML_TARBALL}
	touch $@

build/libxml-built: build/libxml-extracted
	mkdir -p ${OUTDIR}/bin
	cd build/libxml*/ && mkdir -p build
	cd build/libxml*/build && ../configure --prefix=${OUTDIR} --without-python
	cd build/libxml*/build && make
	cd build/libxml*/build && make install
	touch $@

libxml: build/libxml-built

download/z88dk-cloned:
	mkdir -p download
	cd download && git clone --recursive ${Z88DK_REPO} z88dk
	touch $@

download/z88dk.tar.gz: download/z88dk-cloned
	cd download && tar -czf z88dk.tar.gz z88dk

build/z88dk-extracted: download/z88dk.tar.gz
	mkdir -p build
	cd build && tar -xf ../download/z88dk.tar.gz

build/z88dk-built: build/z88dk-extracted build/libxml-built
	mkdir -p ${OUTDIR}/bin
	cd build/z88dk && CFLAGS="-I${OUTDIR}/include" make
	cd build/z88dk && make -C libsrc
	cd build/z88dk && make -C libsrc/_DEVELOPMENT
	touch $@

z88dk: build/z88dk-built

clean:
	rm -rf build
	rm -rf outdir

update:
	cd download/z88dk && git pull && git submodule init && git submodule update
	touch download/z88dk-cloned