import sys
import scipy.io, PetscBinaryIO

def convert(file_in, file_out):
    A = scipy.io.mmread(file_in)
    A = A.tocsr()
    PetscBinaryIO.PetscBinaryIO().writeMatSciPy(open(file_out,'w'), A)

if __name__ == "__main__":
   convert(sys.argv[1], sys.argv[2])
