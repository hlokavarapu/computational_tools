#!/bin/bash
#
#SBATCH -p low
#SBATCH -J solkz_16x16
#SBATCH -e solkz_16x16.err
#SBATCH -o solkz_16x16.out
#SBATCH -n8
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1
