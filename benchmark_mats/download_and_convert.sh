mats=("delaunay_n22" "dielFilterV2clx" "germany_osm" "human_gene1" "NLR")
fns=("DIMACS10/delaunay_n22.tar.gz" "Dziekonski/dielFilterV2clx.tar.gz" "DIMACS10/germany_osm.tar.gz" "Belcastro/human_gene1.tar.gz" "DIMACS10/NLR.tar.gz")
filepath="https://suitesparse-collection-website.herokuapp.com/MM"
n_mats=4

for i in $(seq 0 $n_mats);
do
    mat=${mats[i]}
    echo "Testing i $i, mat ${mats[i]}"
    if test -f ${mat}.pm; then
        echo "${mat}.pm already exists"
    else
        wget $filepath/${fns[i]}
        tar -xzvf ${mat}.tar.gz
        mv ${mat}/${mat}.mtx .
        rm -rf ${mat}
        rm ${mat}.tar.gz
        python3 convert_petsc.py ${mat}.mtx ${mat}.pm
        rm ${mat}.mtx
    fi 
done


