# CRS-Alltoall
Code and tests for MPI\_Alltoall\_crs and MPI\_Alltoallv\_crs

## Compiling
To compile all code:
```
cd compile-and-run
cd computer-plus-mpi
sh compile.sh
```

## MPI\_Alltoall\_crs Benchmarks:
To run MPI\_Alltoall\_crs benchmarks:
```
cd benchmark_mats
sh download_and_convert.sh
cd ../compile-and-run
cd computer-plus-mpi
submit bench_alltoall_crs script
```

## MPI\_Alltoallv\_crs Benchmarks:
To run MPI\_Alltoallv\_crs benchmarks:
```
cd benchmark_mats
sh download_and_convert.sh
cd ../compile-and-run
cd computer-plus-mpi
submit bench_alltoallv_crs script
```

## Adding to hypre
Add all changes to hypre\_crs directory.  More information on changes to be made is available in hypre\_crs/README.md.
To test these changes:
```
cd compile-and-run
cd computer-plus-mpi
submit test_hypre script
```

## Running Hypre Scaling Study
To run a scaling study of hypre with MPI\_Alltoallv\_crs:
```
cd compile-and-run
cd computer-plus-mpi
submit scale_hypre script
```
