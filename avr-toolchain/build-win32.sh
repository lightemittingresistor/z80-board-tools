#!/bin/bash

export PATH=$PATH:`pwd`/outdir/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:`pwd`/outdir/lib

export BUILD_WIN32=1
make $@
