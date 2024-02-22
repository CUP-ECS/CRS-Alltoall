#!/bin/bash

#SBATCH --nodes=4
#SBATCH --partition=pbatch
#SBATCH --time=5
#SBATCH --job-name=hypre_test
#SBATCH --output=hypre_test.%J.out
#SBATCH --error=hypre_test.%J.err
#SBATCH --account=unm

### Shell scripting
source ./vars.sh
STD_HYPRE=${CRS_DIR}/hypre
CRS_HYPRE=${CRS_DIR}/hypre_crs

# check for binary
if [ ! "$(ls "${STD_HYPRE}/src/test/cxx_ij")" ]
then
    echo "cxx_ij hypre_std driver not found"
    exit 1
fi
if [ ! "$(ls "${CRS_HYPRE}/src/test/cxx_ij")" ]
then
    echo "cxx_ij hypre_topo driver not found"
    exit 1
fi

# print run info
date; hostname
echo -n 'Run output directory: '; echo $PWD
echo -n 'JobID: '; echo $LSB_JOBID

ppn=32
n=512
p1=4
p2=4
p3=4

for nodes in {2..4}; do
    ranks=$((nodes*32))
    echo "Nodes: " $nodes ", Rank: " $ranks
    for RUN in {1..3}; do
        srun -N $nodes -n $ranks ${STD_HYPRE}/src/test/cxx_ij -rlx 6 -CF 0 -hmis -interptype 6 -Pmx 5 -agg_nl 1 -solver 0 -n ${n} ${n} ${n} -P ${p1} ${p2} ${p3} > std_${ranks}_${RUN}.txt
        srun -N $nodes -n $ranks ${CRS_HYPRE}/src/test/cxx_ij -rlx 6 -CF 0 -hmis -interptype 6 -Pmx 5 -agg_nl 1 -solver 0 -n ${n} ${n} ${n} -P ${p1} ${p2} ${p3} > topo_${ranks}_${RUN}.txt
    done
    nodes=$((nodes*2))
    case $((ranks*2 % 3)) in
        1)
            p1=$((p1*2))
            ;;
        2)
            p2=$((p2*2))
            ;;
        0)
            p3=$((p3*2))
            ;;
    esac
done
