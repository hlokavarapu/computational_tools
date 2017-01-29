#!/bin/bash

interpolation=('bilinear' 'biquadratic') # 'cell_average')
grid_resolution=('128' '256')
#grid_resolution=('256')
#grid_resolution=('128')
#list_of_number_of_particles_per_cell_in_x=('4' '8')
#list_of_number_of_particles_per_cell_in_x=('16')
#list_of_number_of_particles_per_cell_in_x=('64')
#list_of_number_of_particles_per_cell_in_x=('32' '64')
list_of_number_of_particles_per_cell_in_x=('4' '8' '16' '32' '64')
#interpolation=('bilinear' 'biquadratic' 'cell_average')
#interpolation=('bilinear')
#interpolation=('cell_average')
#grid_resolution=('32' '64')
#grid_resolution=('128') # '96' '112') # '128')
#grid_resolution=('256')
# '144' '160' '176' '192' '208' '224' '240' '256')
#list_of_number_of_particles_per_cell_in_x=('4' '8' '16')
#list_of_number_of_particles_per_cell_in_x=('64')
#list_of_number_of_particles_per_cell_in_x=('32')
#list_of_number_of_particles_per_cell_in_x=('4' '8' '16' '32' '64')


for interpolation_scheme in ${interpolation[@]}; do
  top_level_dir=`echo $PWD`
  cd $interpolation_scheme
  for grid_res in ${grid_resolution[@]}; do
    second_level_dir=`echo $PWD`
    cd $grid_res
    for n_p_x in ${list_of_number_of_particles_per_cell_in_x[@]}; do
      cd $n_p_x
      echo $PWD
#     cat job_template.sh
#      sbatch job_template.sh
#    tail -n 10 $((grid_res))x$((grid_res))_$((n_p_x))_output/log.txt
#        echo $((grid_res))_$((n_p_x))
        cat solcx_$((grid_res))x$((grid_res))_$((n_p_x)).out
        cat solcx_$((grid_res))x$((grid_res))_$((n_p_x)).err
      cd ..
    done
    cd $second_level_dir
  done 
  cd $top_level_dir
done
