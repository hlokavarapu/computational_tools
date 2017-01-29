#!/bin/bash
#
#SBATCH -p gpu
#SBATCH -J BPDG_320
#SBATCH -e BPDG_320.err
#SBATCH -o BPDG_320.out
#SBATCH -n 320
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
module unload intel cuda hdf5
module load gcc/4.9.3
export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/work/03000/vandemar/maverick/aspect_dependencies/install"
ibrun /work/03000/vandemar/maverick/aspect_dependencies/aspect/build/hack_dsf/aspect /work/03000/vandemar/maverick/2017_PEPI_DSF_PAPER/00COMPUTATIONS/PARAMETER_FILES/DGBP/strong_scaling/DGBP_Ra_1e5_B_1_k_3.prm
module unload intel cuda hdf5
module load gcc/4.9.3
export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/work/03000/vandemar/maverick/aspect_dependencies/install"
ibrun /work/03000/vandemar/maverick/aspect_dependencies/aspect/build/hack_dsf/aspect /work/03000/vandemar/maverick/2017_PEPI_DSF_PAPER/00COMPUTATIONS/PARAMETER_FILES/DGBP/strong_scaling/DGBP_Ra_1e5_B_1_k_3.prm
module unload intel cuda hdf5
module load gcc/4.9.3
export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/work/03000/vandemar/maverick/aspect_dependencies/install"
ibrun /work/03000/vandemar/maverick/aspect_dependencies/aspect/build/hack_dsf/aspect /work/03000/vandemar/maverick/2017_PEPI_DSF_PAPER/00COMPUTATIONS/PARAMETER_FILES/DGBP/strong_scaling/DGBP_Ra_1e5_B_1_k_3.prm
module unload intel cuda hdf5
module load gcc/4.9.3
export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/work/03000/vandemar/maverick/aspect_dependencies/install"
ibrun /work/03000/vandemar/maverick/aspect_dependencies/aspect/build/hack_dsf/aspect /work/03000/vandemar/maverick/2017_PEPI_DSF_PAPER/00COMPUTATIONS/PARAMETER_FILES/DGBP/strong_scaling/DGBP_Ra_1e5_B_1_k_3.prm
