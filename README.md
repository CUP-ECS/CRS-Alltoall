# CRS-Alltoall
Code and tests for MPI_Alltoall_crs and MPI_Alltoallv_crs

## Compiling
To compile all code:
```
cd compile-and-run
cd computer-plus-mpi
sh compile.sh
```

## MPI_Alltoall_crs Benchmarks:
To run MPI_Alltoall_crs benchmarks:
```
cd compile-and-run
cd computer-plus-mpi
submit bench_alltoall_crs script
```

## MPI_Alltoallv_crs Benchmarks:
To run MPI_Alltoallv_crs benchmarks:
```
cd compile-and-run
cd computer-plus-mpi
submit bench_alltoallv_crs script
```

## Adding to hypre
Add all changes to hypre_crs directory.  More information on changes to be made is available in hypre_crs/README.md.
To test these changes:
```
cd compile-and-run
cd computer-plus-mpi
submit test_hypre script
```

## Running Hypre Scaling Study
To run a scaling study of hypre with MPI_Alltoallv_crs:
```
cd compile-and-run
cd computer-plus-mpi
submit scale_hypre script
```
