#!/bin/bash

git submodule init
git submodule update --remote

module load mvapich2/2.3.7
module load cmake/3.23.1

export CRS_DIR=${HOME}/CRS-Alltoall

echo "Exported CRS_DIR=${CRS_DIR}"
