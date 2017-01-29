#!/bin/bash

#The various interpolation schemes and grid resolution tests.
# Note that, one could add or delete to grid_resolution to run various models. 
MPI_tasks=('20' '40' '80' '160' '320')

#These variables are user specific and will need to be appropriately changed:
# 
# Assuming that setup of models will be done from the same working directory as the script is executed.
#The name of the template parameter file.
param_temp_filename="DGBP_Ra_1e5_B_1_k_3.prm"
#Assuming that the parameter file is in the present working directory...
parameter_template_file=`echo ${PWD}/${param_temp_filename}`

for MPI_task in ${MPI_tasks[@]}; do
  if [ ! -d $MPI_task ]; then
    mkdir $MPI_task 
    echo $MPI_task 
  fi
  
  top_level_dir=`echo $PWD`
  cd $MPI_task

  cp ${parameter_template_file} ./${param_temp_filename}

  sed -i "s/set Output directory.*/set Output directory = output/" $param_temp_filename  

  cd $top_level_dir
done

echo "FINISHED"
