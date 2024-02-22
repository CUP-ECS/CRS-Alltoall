#!/bin/bash

git submodule init
git submodule update --remote

module load mvapich2/2.3.7
module load cmake/3.23.1

CRS_DIR=${HOME}/CRS-Alltoall

cd ${CRS_DIR}/mpi_advance
rm -rf build
mkdir build
cd build
CC=mpicc CXX=mpicxx cmake ..
make

for hypre_dir in hypre hypre_crs
do
    cd ${CRS_DIR}/${hypre_dir}/src
    CC=mpicc CXX=mpicxx ./configure --enable-persistent --with-MPI-include=${CRS_DIR}/mpi_advance/src --with-MPI-lib-dirs=${CRS_DIR}/mpi_advance/build/src/ --with-MPI-libs=mpi_advance --with-node-aware-mpi
    make clean
    make -j 10
    cd test
    rm cxx_ij*
    make cxx_ij
    cd ../../..
done

