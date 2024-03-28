#!/bin/bash

# Import variables from vars.sh
source ./vars.sh

# Compile MPI Advance's sparse alltoall branch 
cd ${CRS_DIR}/mpi_advance
mkdir -p build
cd build
CC=mpicc CXX=mpicxx cmake ..
make -j

# Compile both versions of hypre (master and version with alltoallv_crs)
#for hypre_dir in hypre hypre_crs hypre_level
#do
hypre_dir=hypre_level
    cd ${CRS_DIR}/${hypre_dir}/src
    make clean
    make distclean
    CC=mpicc CXX=mpicxx ./configure --enable-persistent --with-MPI-include=${CRS_DIR}/mpi_advance/src --with-MPI-lib-dirs=${CRS_DIR}/mpi_advance/build/src/ --with-MPI-libs=mpi_advance --with-node-aware-mpi
    make -j 10
    cd test
    make cxx_ij
#done

