#!/bin/bash

MPI_tasks=('20' '40' '80' '160' '320')
#MPI_tasks=('20') # '40' '80' '160' '320')
param_temp_filename='DGBP_Ra_1e5_B_1_k_3.prm'
job_temp_file=`echo $PWD/job_template.sh`
job_template_filename='job_template.sh'
aspect='/work/03000/vandemar/maverick/aspect_dependencies/aspect/build/hack_dsf/aspect'
job_name='BPDG'

for MPI_task in ${MPI_tasks[@]}; do
  top_level_dir=`echo $PWD`
  cd $MPI_task 
    
    cp $job_temp_file ./${job_template_filename}
    
    sed -i "s/SBATCH -J.*/SBATCH -J ${job_name}_$((MPI_task))/" $job_template_filename
    sed -i "s/SBATCH -e.*/SBATCH -e ${job_name}_$((MPI_task)).err/" $job_template_filename 
    sed -i "s/SBATCH -o.*/SBATCH -o ${job_name}_$((MPI_task)).out/" $job_template_filename 

      sed -i "s/SBATCH -n.*/SBATCH -n $((MPI_task))/" $job_template_filename 
      sed -i "s/SBATCH --cpus-per-task.*/SBATCH --cpus-per-task=1/" $job_template_filename
#      sed -i "s/SBATCH --mem-per-cpu.*/SBATCH --mem-per-cpu=12000/" $job_template_filename
    
    abs_path_of_param_file=`readlink -e $param_temp_filename` 
    echo "module unload intel cuda hdf5" >> $job_template_filename
    echo "module load gcc/4.9.3" >> $job_template_filename
    echo "export OMP_NUM_THREADS=1" >> $job_template_filename
    echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:/work/03000/vandemar/maverick/aspect_dependencies/install\"" >> $job_template_filename
    echo "ibrun $aspect $abs_path_of_param_file" >> $job_template_filename
    sbatch $job_template_filename

  cd $top_level_dir
done
