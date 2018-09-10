#!/bin/r

# Omega 1 is blue particles and omega 2 is red particles. 
# Blue particles are positioned in the upper half and vice versa.
count_particles_omega_1_to_omega_2 <- function(fileName)
{
  t1 <- read.table(fileName, sep=',', header=T)
  length(t1$id[t1$Points.1 < 1e6 & t1$function. == 0])
}

count_particles_omega_2_to_omega_1 <- function(fileName)
{
  t1 <- read.table(fileName, sep=',', header=T)
  length(t1$id[t1$Points.1 > 1e6 & t1$function. == 1])
}
