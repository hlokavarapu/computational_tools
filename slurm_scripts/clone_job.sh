#!/bin/bash

grid_resolution=('2' '3' '4' '5' '6' '7')
FEM_types=('Q1_P0' 'Q2_Q1' 'Q2_P-1' 'Q3_Q2' 'Q3_P-2')
param_temp_filename='solkz_compositional_field.prm'
job_temp_file=`echo $PWD/job_template.sh`
job_template_filename='job_template.sh'
aspect='/home/hlokavar/build/aspect/master/aspect'

for FEM_type in ${FEM_types[@]}; do
  top_level_dir=`echo $PWD`
  cd $FEM_type 
  for grid_res in ${grid_resolution[@]}; do
    second_level_dir=`echo $PWD`
    cd $grid_res
    
    cp $job_temp_file ./${job_template_filename}
    
    sed -i "s/SBATCH -J.*/SBATCH -J solcx_compositional_field_$((grid_res))_$((grid_res))/" $job_template_filename
    sed -i "s/SBATCH -e.*/SBATCH -e solcx_compositional_field_$((grid_res))x$((grid_res)).err/" $job_template_filename 
    sed -i "s/SBATCH -o.*/SBATCH -o solcx_compositional_field_$((grid_res))x$((grid_res)).out/" $job_template_filename 

    if [ $grid_res == '6' ]; then
      sed -i "s/SBATCH -n.*/SBATCH -n2/" $job_template_filename 
      sed -i "s/SBATCH --cpus-per-task.*/SBATCH --cpus-per-task=1/" $job_template_filename
      sed -i "s/SBATCH --mem-per-cpu.*/SBATCH --mem-per-cpu=2000/" $job_template_filename
    elif [ $grid_res == '7' ]; then
      sed -i "s/SBATCH -n.*/SBATCH -n4/" $job_template_filename 
      sed -i "s/SBATCH --cpus-per-task.*/SBATCH --cpus-per-task=1/" $job_template_filename
      sed -i "s/SBATCH --mem-per-cpu.*/SBATCH --mem-per-cpu=2000/" $job_template_filename
    else
      sed -i "s/SBATCH -n.*/SBATCH -n 1/" $job_template_filename 
      sed -i "s/SBATCH --cpus-per-task.*/SBATCH --cpus-per-task=1/" $job_template_filename
      sed -i "s/SBATCH --mem-per-cpu.*/SBATCH --mem-per-cpu=2000/" $job_template_filename
    fi
    
    abs_path_of_param_file=`readlink -e $param_temp_filename` 
    echo "export OMP_NUM_THREADS=1" >> $job_template_filename
    echo "mpirun $aspect $abs_path_of_param_file" >> $job_template_filename
    sbatch $job_template_filename

    cd $second_level_dir
  done 
  cd $top_level_dir
done
