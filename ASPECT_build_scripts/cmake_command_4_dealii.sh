cmake \
  -DCMAKE_INSTALL_PREFIX=$PWD/install \
  -DCMAKE_BUILD_TYPE=Release 
  -DDEAL_II_WITH_MPI=ON \
  -DDEAL_II_WITH_HDF5=OFF \
  -DDEAL_II_WITH_PETSC=OFF \
  -DDEAL_II_WITH_SLEPC=OFF \
  -DDEAL_II_WITH_P4EST=ON \
  -DDEAL_II_WITH_64BIT_INDICES=ON \
  -DP4EST_DIR=$HOME/p4est/ \
  -DTRILINOS_DIR=/home/hlokavar/build/trilinos_mpi_pthreads_tbb_no_openmp/install \
  -DDEAL_II_ALLOW_BUNDLED=ON \
~/dealii/