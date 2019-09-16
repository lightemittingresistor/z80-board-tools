###################################
# Makefile for AVR toolchain
###################################

#URL bases for downloads
BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/"
GCC_URL="ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-9.2.0/"
GMP_URL="https://gmplib.org/download/gmp/"
MPFR_URL="http://www.mpfr.org/mpfr-current/"
MPC_URL="https://ftp.gnu.org/gnu/mpc/"
LIBC_URL="http://download.savannah.gnu.org/releases/avr-libc/"
LIBUSB_URL="https://github.com/libusb/libusb/releases/download/v1.0.23/"
AVRDUDE_URL="http://download.savannah.gnu.org/releases/avrdude/"

#filenames for downloads
BINUTILS_FILE=binutils-2.32.tar.gz
GCC_FILE=gcc-9.2.0.tar.gz
GMP_FILE=gmp-6.1.2.tar.bz2
MPFR_FILE=mpfr-4.0.2.tar.bz2
MPC_FILE=mpc-1.1.0.tar.gz
LIBC_FILE=avr-libc-2.0.0.tar.bz2
LIBUSB_FILE=libusb-1.0.23.tar.bz2
AVRDUDE_FILE=avrdude-6.3.tar.gz

OUTDIR=$(CURDIR)/outdir
BUILDDIR=$(CURDIR)/build
TARGETNAME=z80-board-tools
export PATH := ${OUTDIR}/bin:$(PATH)

ifdef BUILD_WIN64
CROSS=1
CROSS_TARGET=x86_64-w64-mingw32
CONFIG_EXTRAS=-host=${CROSS_TARGET} --enable-shared --disable-static
OUTDIR:=${OUTDIR}-w64
BUILDDIR:=${BUILDDIR}-w64
TARGETNAME:=${TARGETNAME}-win64
endif

ifdef BUILD_WIN32
CROSS=1
CROSS_TARGET=i686-w64-mingw32
CONFIG_EXTRAS=-host=${CROSS_TARGET} --enable-static --disable-shared
OUTDIR:=${OUTDIR}-w32
BUILDDIR:=${BUILDDIR}-w32
TARGETNAME:=${TARGETNAME}-win32
endif

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

${BUILDDIR}/binutils.extracted: downloads/${BINUTILS_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${BINUTILS_FILE}
	touch $@

${BUILDDIR}/binutils.patched : ${BUILDDIR}/binutils.extracted
	(cd ${BUILDDIR}/binutils*/ && patch -p0 ) < ${CURDIR}/avr-size.patch
	touch $@

${BUILDDIR}/binutils.built: ${BUILDDIR}/binutils.patched
	mkdir -p ${OUTDIR}
	cd ${BUILDDIR}/binutils*/ && mkdir -p build
	cd ${BUILDDIR}/binutils*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR} --target=avr --disable-nls
	cd ${BUILDDIR}/binutils*/build && ${MAKE}
	cd ${BUILDDIR}/binutils*/build && ${MAKE} install
	touch $@

binutils: ${BUILDDIR}/binutils.built

###################
# gmp
###################
${BUILDDIR}/gmp.extracted: downloads/${GMP_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${GMP_FILE}
	touch $@

${BUILDDIR}/gmp.built: ${BUILDDIR}/gmp.extracted
	mkdir -p ${OUTDIR}
	cd ${BUILDDIR}/gmp*/ && mkdir -p build
	cd ${BUILDDIR}/gmp*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR}
	cd ${BUILDDIR}/gmp*/build && ${MAKE}
	if [ "${CROSS}" != "1" ]; \
	then \
		cd ${BUILDDIR}/gmp*/build && ${MAKE} check; \
	fi;
	cd ${BUILDDIR}/gmp*/build && ${MAKE} install
	touch $@

gmp: ${BUILDDIR}/gmp.built

###################
# mpfr
###################
${BUILDDIR}/mpfr.extracted: downloads/${MPFR_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${MPFR_FILE}
	touch $@

${BUILDDIR}/mpfr.built: ${BUILDDIR}/mpfr.extracted ${BUILDDIR}/gmp.built
	cd ${BUILDDIR}/mpfr*/ && mkdir -p build
	cd ${BUILDDIR}/mpfr*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR} --with-gmp=${OUTDIR}
	cd ${BUILDDIR}/mpfr*/build && ${MAKE}
	if [ "${CROSS}" != "1" ]; \
	then \
		cd ${BUILDDIR}/mpfr*/build && ${MAKE} check; \
	fi;
	cd ${BUILDDIR}/mpfr*/build && ${MAKE} install
	touch $@

mpfr: ${BUILDDIR}/mpfr.built

###################
# mpc
###################
${BUILDDIR}/mpc.extracted: downloads/${MPC_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${MPC_FILE}
	touch $@

${BUILDDIR}/mpc.built: ${BUILDDIR}/mpc.extracted ${BUILDDIR}/gmp.built ${BUILDDIR}/mpfr.built
	cd ${BUILDDIR}/mpc*/ && mkdir -p build
	cd ${BUILDDIR}/mpc*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR} --with-gmp=${OUTDIR} --with-mpfr=${OUTDIR}
	cd ${BUILDDIR}/mpc*/build && ${MAKE}
	if [ "${CROSS}" != "1" ]; \
	then \
		cd ${BUILDDIR}/mpc*/build && ${MAKE} check; \
	fi;
	cd ${BUILDDIR}/mpc*/build && ${MAKE} install
	touch $@

mpc: ${BUILDDIR}/mpc.built

###################
# gcc
###################
${BUILDDIR}/gcc.extracted: downloads/${GCC_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${GCC_FILE}
	touch $@

${BUILDDIR}/gcc.built: ${BUILDDIR}/gcc.extracted ${BUILDDIR}/gmp.built ${BUILDDIR}/mpfr.built ${BUILDDIR}/mpc.built ${BUILDDIR}/binutils.built
	cd ${BUILDDIR}/gcc*/ && mkdir -p build
	cd ${BUILDDIR}/gcc*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR} --with-gmp=${OUTDIR} \
		--with-mpfr=${OUTDIR} --with-mpc=${OUTDIR} --target=avr --enable-languages="c,c++" \
		--disable-nls --disable-libssp --with-dwarf2
	cd ${BUILDDIR}/gcc*/build && ${MAKE}
	cd ${BUILDDIR}/gcc*/build && ${MAKE} install
	touch $@

gcc: ${BUILDDIR}/gcc.built

###################
# libc
###################
${BUILDDIR}/libc.extracted: downloads/${LIBC_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${LIBC_FILE}
	touch $@

${BUILDDIR}/libc.built: ${BUILDDIR}/libc.extracted ${BUILDDIR}/gcc.built
	mkdir -p ${OUTDIR}
	cd ${BUILDDIR}/avr-libc* && mkdir -p build
	cd ${BUILDDIR}/avr-libc*/build && ../configure --prefix=${OUTDIR} --host=avr
	cd ${BUILDDIR}/avr-libc*/build && ${MAKE}
	cd ${BUILDDIR}/avr-libc*/build && ${MAKE} install
	touch $@

libc: ${BUILDDIR}/libc.built

###################
# libusb
###################
${BUILDDIR}/libusb.extracted: downloads/${LIBUSB_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${LIBUSB_FILE}
	touch $@

${BUILDDIR}/libusb.built: ${BUILDDIR}/libusb.extracted
	mkdir -p ${OUTDIR}
	cd ${BUILDDIR}/libusb*/ && mkdir -p build
	cd ${BUILDDIR}/libusb*/build && ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR}
	cd ${BUILDDIR}/libusb*/build && ${MAKE}
	if [ "${CROSS}" != "1" ]; \
	then \
		cd ${BUILDDIR}/libusb*/build && ${MAKE} check; \
	fi;
	cd ${BUILDDIR}/libusb*/build && ${MAKE} install
	touch $@

libusb: ${BUILDDIR}/libusb.built

###################
# avrdude
###################
${BUILDDIR}/avrdude.extracted: downloads/${AVRDUDE_FILE}
	mkdir -p ${BUILDDIR}
	cd ${BUILDDIR} && tar -xf ../downloads/${AVRDUDE_FILE}
	touch $@

AVRDUDE_CFLAGS="${CFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
AVRDUDE_CXXFLAGS="${CXXFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include/libusb-1.0/ -L${OUTDIR}/lib"
AVRDUDE_LDFLAGS="${LDFLAGS} -I${OUTDIR}/include -I${OUTDIR}/include -L${OUTDIR}/lib"

${BUILDDIR}/avrdude.built: ${BUILDDIR}/avrdude.extracted ${BUILDDIR}/libusb.built
	mkdir -p ${OUTDIR}
	cd ${BUILDDIR}/avrdude*/ && mkdir -p build
	cd ${BUILDDIR}/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ../configure ${CONFIG_EXTRAS} --prefix=${OUTDIR}
	cd ${BUILDDIR}/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE}
	cd ${BUILDDIR}/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE} check
	cd ${BUILDDIR}/avrdude*/build && CFLAGS=${AVRDUDE_CFLAGS} CPPFLAGS=${AVRDUDE_CFLAGS} \
		CXXFLAGS=${AVRDUDE_CXXFLAGS} LDFLAGS=${AVRDUDE_LDFLAGS} ${MAKE} install
	touch $@

avrdude: ${BUILDDIR}/avrdude.built

##################
# clean
##################

clean:
	rm -rf ${BUILDDIR}

clean-all: clean
	rm -rf ${OUTDIR}

clean-downloads: clean
	rm -rf downloads

zip: all
	cp /usr/${CROSS_TARGET}/sys-root/mingw/bin/lib*.dll ${OUTDIR}/bin
	cd ${OUTDIR} && zip -r -6 ../${TARGETNAME}.zip * 
