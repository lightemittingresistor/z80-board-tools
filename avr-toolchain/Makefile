###################################
# Makefile for AVR toolchain
###################################

#URL bases for downloads
BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/"
GCC_URL="ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.2.0/"
GMP_URL="https://gmplib.org/download/gmp/"
MPFR_URL="http://www.mpfr.org/mpfr-current/"
MPC_URL="https://ftp.gnu.org/gnu/mpc/"
LIBC_URL="http://download.savannah.gnu.org/releases/avr-libc/"
LIBUSB_URL="https://github.com/libusb/libusb/releases/download/v1.0.21/"
AVRDUDE_URL="http://download.savannah.gnu.org/releases/avrdude/"

#filenames for downloads
BINUTILS_FILE=binutils-2.29.1.tar.gz
GCC_FILE=gcc-7.2.0.tar.gz
GMP_FILE=gmp-6.1.2.tar.bz2
MPFR_FILE=mpfr-4.0.1.tar.bz2
MPC_FILE=mpc-1.1.0.tar.gz
LIBC_FILE=avr-libc-2.0.0.tar.bz2
LIBUSB_FILE=libusb-1.0.21.tar.bz2
AVRDUDE_FILE=avrdude-6.3.tar.gz

OUTDIR=$(CURDIR)/outdir
export PATH := ${OUTDIR}/bin:$(PATH)

#dummy target for all
all: binutils gcc libc avrdude

# downloads
downloads/${BINUTILS_FILE} :
	mkdir -p downloads
	curl -L ${BINUTILS_URL}${BINUTILS_FILE} -o downloads/${BINUTILS_FILE}

downloads/${GCC_FILE} :
	mkdir -p downloads
	curl -L ${GCC_URL}${GCC_FILE} -o $@

downloads/${GMP_FILE} :
	mkdir -p downloads
	curl -L ${GMP_URL}${GMP_FILE} -o $@

downloads/${MPFR_FILE} :
	mkdir -p downloads
	curl -L ${MPFR_URL}${MPFR_FILE} -o $@

downloads/${MPC_FILE} :
	mkdir -p downloads
	curl -L ${MPC_URL}${MPC_FILE} -o $@

downloads/${LIBC_FILE} :
	mkdir -p downloads
	curl -L ${LIBC_URL}${LIBC_FILE} -o $@

downloads/${LIBUSB_FILE} :
	mkdir -p downloads
	curl -L ${LIBUSB_URL}${LIBUSB_FILE} -o $@

downloads/${AVRDUDE_FILE} :
	mkdir -p downloads
	curl -L ${AVRDUDE_URL}${AVRDUDE_FILE} -o $@

###################
# binutils
###################

build/binutils.extracted: downloads/${BINUTILS_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${BINUTILS_FILE}
	touch $@

build/binutils.patched : build/binutils.extracted
	(cd build/binutils*/ && patch -p0 ) < ${CURDIR}/avr-size.patch
	touch $@

build/binutils.built: build/binutils.patched
	mkdir -p ${OUTDIR}
	cd build/binutils*/ && mkdir -p build
	cd build/binutils*/build && ../configure --prefix=${OUTDIR} --target=avr --disable-nls
	cd build/binutils*/build && ${MAKE}
	cd build/binutils*/build && ${MAKE} install
	touch $@

binutils: build/binutils.built

###################
# gmp
###################
build/gmp.extracted: downloads/${GMP_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${GMP_FILE}
	touch $@

build/gmp.built: build/gmp.extracted
	mkdir -p ${OUTDIR}
	cd build/gmp*/ && mkdir -p build
	cd build/gmp*/build && ../configure --prefix=${OUTDIR}
	cd build/gmp*/build && ${MAKE}
	cd build/gmp*/build && ${MAKE} check
	cd build/gmp*/build && ${MAKE} install
	touch $@

gmp: build/gmp.built

###################
# mpfr
###################
build/mpfr.extracted: downloads/${MPFR_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${MPFR_FILE}
	touch $@

build/mpfr.built: build/mpfr.extracted build/gmp.built
	cd build/mpfr*/ && mkdir -p build
	cd build/mpfr*/build && ../configure --prefix=${OUTDIR} --with-gmp=${OUTDIR}
	cd build/mpfr*/build && ${MAKE}
	cd build/mpfr*/build && ${MAKE} check
	cd build/mpfr*/build && ${MAKE} install
	touch $@

mpfr: build/mpfr.built

###################
# mpc
###################
build/mpc.extracted: downloads/${MPC_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${MPC_FILE}
	touch $@

build/mpc.built: build/mpc.extracted build/gmp.built build/mpfr.built
	cd build/mpc*/ && mkdir -p build
	cd build/mpc*/build && ../configure --prefix=${OUTDIR} --with-gmp=${OUTDIR} --with-mpfr=${OUTDIR}
	cd build/mpc*/build && ${MAKE}
	cd build/mpc*/build && ${MAKE} check
	cd build/mpc*/build && ${MAKE} install
	touch $@

mpc: build/mpc.built

###################
# gcc
###################
build/gcc.extracted: downloads/${GCC_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${GCC_FILE}
	touch $@

build/gcc.built: build/gcc.extracted build/gmp.built build/mpfr.built build/mpc.built build/binutils.built
	cd build/gcc*/ && mkdir -p build
	cd build/gcc*/build && ../configure --prefix=${OUTDIR} --with-gmp=${OUTDIR} \
		--with-mpfr=${OUTDIR} --with-mpc=${OUTDIR} --target=avr --enable-languages="c,c++" \
		--disable-nls --disable-libssp --with-dwarf2
	cd build/gcc*/build && ${MAKE}
	cd build/gcc*/build && ${MAKE} install
	touch $@

gcc: build/gcc.built

###################
# libc
###################
build/libc.extracted: downloads/${LIBC_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${LIBC_FILE}
	touch $@

build/libc.built: build/libc.extracted build/gcc.built
	mkdir -p ${OUTDIR}
	cd build/avr-libc* && mkdir -p build
	cd build/avr-libc*/build && ../configure --prefix=${OUTDIR} --host=avr
	cd build/avr-libc*/build && ${MAKE}
	cd build/avr-libc*/build && ${MAKE} install
	touch $@

libc: build/libc.built

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
# avrdude
###################
build/avrdude.extracted: downloads/${AVRDUDE_FILE}
	mkdir -p build
	cd build && tar -xf ../downloads/${AVRDUDE_FILE}
	touch $@

AVRDUDE_CFLAGS="${CFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
AVRDUDE_CXXFLAGS="${CXXFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
AVRDUDE_LDFLAGS="${LDFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include -L${OUTDIR}/lib"

build/avrdude.built: build/avrdude.extracted build/libusb.built
	mkdir -p ${OUTDIR}
	cd build/avrdude*/ && mkdir -p build
	cd build/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ../configure --prefix=${OUTDIR}
	cd build/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE}
	cd build/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE} check
	cd build/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE} install
	touch $@

avrdude: build/avrdude.built

##################
# clean
##################

clean:
	rm -rf build
	rm -rf outdir

clean-downloads: clean
	rm -rf downloads


