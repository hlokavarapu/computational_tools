#!/bin/bash

#The various interpolation schemes and grid resolution tests.
# Note that, one could add or delete to grid_resolution to run various models. 
grid_resolution=('2' '3' '4' '5' '6' '7')
FEM_types=('Q1_P0' 'Q2_Q1' 'Q2_P-1' 'Q3_Q2' 'Q3_P-2')

#These variables are user specific and will need to be appropriately changed:
# 
# Assuming that setup of models will be done from the same working directory as the script is executed.
#The name of the template parameter file.
param_temp_filename="solkz_compositional_field.prm"
#Assuming that the parameter file is in the present working directory...
parameter_template_file=`echo ${PWD}/${param_temp_filename}`
# Change this to the absolute path to compiled benchmark library. 
# Make sure that each forward slash is delimted by a back slash. I.e. '\/'
path_to_benchmark_library='\/home\/hlokavar\/runs\/solkz_compositional_field\/libsolkz_compositional_field.so'

for FEM_type in ${FEM_types[@]}; do
  if [ ! -d $FEM_type ]; then
    mkdir $FEM_type 
    echo $FEM_type 
  fi
  
  top_level_dir=`echo $PWD`
  cd $FEM_type 
  for grid_res in ${grid_resolution[@]}; do
    if [ ! -d $grid_res ]; then
      mkdir $grid_res 
      echo $grid_res 
    fi 

    second_level_dir=`echo $PWD`
    cd $grid_res

    cp ${parameter_template_file} ./${param_temp_filename}

    sed -i "s/set Additional shared libraries.*/set Additional shared libraries = ${path_to_benchmark_library}/" $param_temp_filename
    sed -i "s/set Output directory.*/set Output directory = output/" $param_temp_filename  

    sed -i "s/set Initial global refinement.*/set Initial global refinement = $((grid_res))/" $param_temp_filename    
       
    if [ $FEM_type == 'Q1_P0' ]; then
      sed -i "s/set Stokes velocity polynomial degree.*/set Stokes velocity polynomial degree = 1/" $param_temp_filename
      sed -i "s/set Use locally conservative discretization =.*/set Use locally conservative discretization = true/" $param_temp_filename
    elif [ $FEM_type == 'Q2_Q1' ]; then
      sed -i "s/set Stokes velocity polynomial degree.*/set Stokes velocity polynomial degree = 2/" $param_temp_filename
      sed -i "s/set Use locally conservative discretization =.*/set Use locally conservative discretization = false/" $param_temp_filename
    elif [ $FEM_type == 'Q2_P-1' ]; then
      sed -i "s/set Stokes velocity polynomial degree.*/set Stokes velocity polynomial degree = 2/" $param_temp_filename
      sed -i "s/set Use locally conservative discretization =.*/set Use locally conservative discretization = true/" $param_temp_filename
    elif [ $FEM_type == 'Q3_Q2' ]; then
      sed -i "s/set Stokes velocity polynomial degree.*/set Stokes velocity polynomial degree = 3/" $param_temp_filename
      sed -i "s/set Use locally conservative discretization =.*/set Use locally conservative discretization = false/" $param_temp_filename
    elif [ $FEM_type == 'Q3_P-2' ]; then
      sed -i "s/set Stokes velocity polynomial degree.*/set Stokes velocity polynomial degree = 3/" $param_temp_filename
      sed -i "s/set Use locally conservative discretization =.*/set Use locally conservative discretization = true/" $param_temp_filename
    fi

    cd $second_level_dir
  done 
  cd $top_level_dir
done

echo "FINISHED"
