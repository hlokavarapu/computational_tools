#!/bin/bash

grid_resolution=('2' '3' '4' '5' '6' '7')
FEM_types=('Q1_P0' 'Q2_Q1' 'Q2_P-1' 'Q3_Q2' 'Q3_P-2')

for FEM_type in ${FEM_types[@]}; do
  top_level_dir=`echo $PWD`
  echo $FEM_type 
  cd $FEM_type 
  for grid_res in ${grid_resolution[@]}; do
    second_level_dir=`echo $PWD`
    cd $grid_res
    
    echo $grid_res
    grep -i "Error" output/log.txt #| cut -d':' -f2 | cut -d',' -f4

    cd $second_level_dir
  done 
  cd $top_level_dir
done
