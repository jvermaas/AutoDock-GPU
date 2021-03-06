/*

AutoDock-GPU, an OpenCL implementation of AutoDock 4.2 running a Lamarckian Genetic Algorithm
Copyright (C) 2017 TU Darmstadt, Embedded Systems and Applications Group, Germany. All rights reserved.
For some of the code, Copyright (C) 2019 Computational Structural Biology Center, the Scripps Research Institute.

AutoDock is a Trade Mark of the Scripps Research Institute.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

*/




__kernel void __attribute__ ((reqd_work_group_size(NUM_OF_THREADS_PER_BLOCK,1,1)))
gpu_sum_evals(	       
		       uint pop_size,
	      __global int* restrict dockpars_evals_of_new_entities,
              __global int* restrict evals_of_runs
)
//The GPU global function sums the evaluation counter states
//which are stored in evals_of_new_entities array foreach entity,
//calculates the sums for each run and stores it in evals_of_runs array.
//The number of blocks which should be started equals to num_of_runs,
//since each block performs the summation for one run.
{
	int entity_counter;
	int sum_evals;
	__local int partsum_evals[NUM_OF_THREADS_PER_BLOCK];

	partsum_evals[get_local_id(0)] = 0;

  	for (entity_counter = get_local_id(0);
	     entity_counter < pop_size;
	     entity_counter+= NUM_OF_THREADS_PER_BLOCK) {
		partsum_evals[get_local_id(0)] += dockpars_evals_of_new_entities[get_group_id(0)*pop_size + entity_counter];
	}

	barrier(CLK_LOCAL_MEM_FENCE);

	if (get_local_id(0) == 0) {
		sum_evals = partsum_evals[0];

		for (entity_counter = 1;
		     entity_counter < NUM_OF_THREADS_PER_BLOCK;
		     entity_counter++) {
			sum_evals += partsum_evals[entity_counter];
		}

		evals_of_runs[get_group_id(0)] += sum_evals;
	}
}
