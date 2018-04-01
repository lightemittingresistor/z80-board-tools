OPENOCD_URL=http://downloads.sourceforge.net/openocd/
LIBUSB_URL=https://github.com/libusb/libusb/releases/download/v1.0.21/
LIBFTDI_URL=https://www.intra2net.com/en/developer/libftdi/download/

OPENOCD_FILE=openocd-0.10.0.tar.bz2
LIBUSB_FILE=libusb-1.0.21.tar.bz2
LIBFTDI_FILE=libftdi1-1.4.tar.bz2

OUTDIR=$(CURDIR)/outdir

all: openocd

downloads/${OPENOCD_FILE} :
	mkdir -p downloads
	curl -L ${OPENOCD_URL}${OPENOCD_FILE} -o downloads/${OPENOCD_FILE}

downloads/${LIBUSB_FILE} :
	mkdir -p downloads
	curl -L ${LIBUSB_URL}${LIBUSB_FILE} -o $@

downloads/${LIBFTDI_FILE} :
	mkdir -p downloads
	curl -L ${LIBFTDI_URL}${LIBFTDI_FILE} -o $@

###################
# libusb
###################
build/libusb.extracted: downloads/${LIBUSB_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${LIBUSB_FILE}
	touch $@

build/libusb.built: build/libusb.extracted
	mkdir -p ${OUTDIR}
	cd build/libusb*/ && mkdir -p build
	cd build/libusb*/build && ../configure --prefix=${OUTDIR}
	cd build/libusb*/build && ${MAKE}
	cd build/libusb*/build && ${MAKE} check
	cd build/libusb*/build && ${MAKE} install
	touch $@

libusb: build/libusb.built

###################
# libftdi
###################
build/libftdi.extracted: downloads/${LIBFTDI_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${LIBFTDI_FILE}
	touch $@

build/libftdi.built: build/libftdi.extracted
	mkdir -p ${OUTDIR}
	cd build/libftdi1-*/ && mkdir -p build
	cd build/libftdi1-*/build && PKG_CONFIG_PATH=${OUTDIR}/lib/pkgconfig cmake .. -DCMAKE_INSTALL_PREFIX:PATH=${OUTDIR}
	cd build/libftdi1-*/build && ${MAKE}
	cd build/libftdi1-*/build && ${MAKE} check
	cd build/libftdi1-*/build && ${MAKE} install
	touch $@

libftdi: build/libftdi.built

###################
# openocd
###################

OPENOCD_CFLAGS="${CFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
OPENOCD_CXXFLAGS="${CXXFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
OPENOCD_LDFLAGS="${LDFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include -L${OUTDIR}/lib"

build/openocd.extracted: downloads/${OPENOCD_FILE} build/libusb.built build/libftdi.built
	mkdir -p build
	cd build && tar -xf ../downloads/${OPENOCD_FILE}
	cd build/openocd* && patch -p1 < ../../0001-Add-fallthrough-comments.patch
	cd build/openocd* && patch -p1 < ../../0002-Workaround-new-warnings-generated-by-GCC-7.patch
	cd build/openocd* && patch -p1 < ../../0003-armv7a-Add-missing-break-to-fix-fallthrough-warning.patch
	cd build/openocd* && patch -p1 < ../../0004-Fix-overflow-warning.patch
	cd build/openocd* && patch -p1 < ../../0005-command-Move-the-fall-through-comment-to-right-scope.patch

	touch $@

build/openocd.built: build/openocd.extracted
	mkdir -p ${OUTDIR}
	cd build/openocd*/ && mkdir -p build
	cd build/openocd*/build && ../configure --prefix=${OUTDIR} \
		PKG_CONFIG_PATH=${OUTDIR}/lib/pkgconfig
	cd build/openocd*/build && ${MAKE}
	cd build/openocd*/build && ${MAKE} install
	touch $@

openocd: build/openocd.built

##################
# clean
##################

clean:
	rm -rf build
	rm -rf outdir

clean-downloads: clean
	rm -rf downloads