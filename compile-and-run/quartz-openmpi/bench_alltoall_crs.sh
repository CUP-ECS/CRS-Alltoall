#!/bin/bash

#SBATCH --output=alltoall_crs.%j.out
#SBATCH --error=alltoall_crs.%j.err
#SBATCH --nodes=32
#SBATCH --tasks-per-node=32
#SBATCH --cores-per-socket=16
#SBATCH --cpus-per-task=1
#SBATCH --time=00:25:00
#SBATCH --partition=pbatch

source ./vars.sh

cd ${CRS_DIR}/mpi_advance/build/benchmarks
echo ${CRS_DIR}/mpi_advance/build/benchmarks
folder=${CRS_DIR}/benchmark_mats
for mat in delaunay_n22.pm dielFilterV2clx.pm germany_osm.pm human_gene1.pm NLR.pm
do
    echo $folder/$mat
    for (( nodes = 2; nodes <= 32; nodes*=2 ));
    do
        procs=$((32*nodes))
        srun -n $procs -N $nodes ./alltoall_crs $folder/$mat
    done
done
