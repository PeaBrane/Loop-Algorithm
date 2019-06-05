# Loop-Algorithm

This repository contains MATLAB scripts for generating and solving instances based on the random and structured loop algorithms described 
in the following paper:
https://arxiv.org/abs/1905.05334

main.m: This file is the main script that generates problem instances using both the random and structured loop algorithm, 
solves the instances using simulated annealing (SA), and records the number of sweeps to solution.

loop_rand.m: Generates an RBM instance using the random loop algorithm.

loop_struct.m: Generates an RBM instance using the structured loop algorithm.

get_time_gibbs.m: Solves the problem instance using simulated annealing (SA), and records the total number of sweeps to solution.

convert_to_SAT.m: Convert the spin glass instance into a MAX-2-SAT problem.

wcnf: This folder contains the source codes for generating weighted MAX-2-SAT instances in the wcnf format directly. The codes are designed to generate instances with a large number of literals, since only the non-zero elements of the weight matrix is stored for memory efficiency.
