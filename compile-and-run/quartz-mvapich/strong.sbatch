#!/bin/bash

#SBATCH --nodes=64
#SBATCH --partition=pbatch
#SBATCH --time=60
#SBATCH --job-name=hypre_topo_scale
#SBATCH --output=hypre_topo_scale.%J.out
#SBATCH --error=hypre_topo_scale.%J.err
#SBATCH --account=unm

### Shell scripting
HYPRE=~/hypre
HYPRE_TOPO=~/hypre_neighbor

# check for binary
if [ ! "$(ls "${HYPRE}/src/test/cxx_ij")" ]
then
    echo "cxx_ij hypre_std driver not found"
    exit 1
fi
if [ ! "$(ls "${HYPRE_TOPO}/src/test/cxx_ij")" ]
then
    echo "cxx_ij hypre_topo driver not found"
    exit 1
fi

# print run info
date; hostname
echo -n 'Run output directory: '; echo $PWD
echo -n 'JobID: '; echo $LSB_JOBID

nodes=2
ranks=64
n=512
p1=4
p2=4
p3=4

for SCALE in {1..6}; do
    for RUN in {1..3}; do
        echo "Scale: " $SCALE ", RUN: " $RUN
        echo "Ranks: " $ranks ", nodes: " $nodes ", n: " $n ", p: " $p1 " " $p2 " " $p3
        srun -N $nodes -n $ranks ${HYPRE}/src/test/cxx_ij -rlx 6 -CF 0 -hmis -interptype 6 -Pmx 5 -agg_nl 1 -solver 0 -n ${n} ${n} ${n} -P ${p1} ${p2} ${p3} > std_${ranks}_${RUN}.txt
        srun -N $nodes -n $ranks ${HYPRE_TOPO}/src/test/cxx_ij -rlx 6 -CF 0 -hmis -interptype 6 -Pmx 5 -agg_nl 1 -solver 0 -n ${n} ${n} ${n} -P ${p1} ${p2} ${p3} > topo_${ranks}_${RUN}.txt
    done
    ranks=$((ranks*2))
    nodes=$((nodes*2))
    case $((SCALE % 3)) in
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
