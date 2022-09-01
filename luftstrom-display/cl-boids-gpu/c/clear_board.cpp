#pragma OPENCL EXTENSION cl_khr_int64_base_atomics : enable
__kernel void clear_board(
                          __global int* board,
                          __global float4* align,
                          __global int* obstacle_board,                          
                          __constant float4* obstacles_pos,                          
                          __constant int* obstacles_radius,
                          __constant float* obstacles_lookahead,
                          uint active_obstacle_mask,
                          int num_obstacles,
                          int pixelsize,
                          int width,
                          int height
                          )

// this function is parallelized for all board positions.
// for it's position it:
// - clears the boid count board (board[tidx]) at position
// - clears the alignment vector board (align[tidx]) at position
//
// - sets a flag for all active obstacles on obstacle_board[tidx],
//   indicating whether the obstacle is visible for a boid located at
//   the board position.

// TODO: obstacle handling should be restructured: Rather than
// indicating that an obstacle (and which) is visible in a tile, the
// "winning" (most influential) obstacle could already be determined
// here for each tile (including distance, direction, tidx and
// forces), removing the need to determine this for every boid in
// boids.cpp (using "get_closest_obstacle").

{
  size_t tid = get_global_id(0);
  board[tid]=0;
  obstacle_board[tid]=0;
  align[tid]= (float4) (0.0, 0.0, 0.0, 0.0);
  int i;
  float bpos_x = (float)(pixelsize*fmod(tid,(float)width));
  float bpos_y = (float)(pixelsize*(int)floor(tid/(float)width));
  for (i=0;i<num_obstacles;i++) {
    if ((active_obstacle_mask&(1<<i)) &&
        (fast_length((float4) (obstacles_pos[i].x,obstacles_pos[i].y,0.0,0.0)
                     - (float4) (bpos_x,bpos_y,0.0,0.0)))
        < (obstacles_lookahead[i] * obstacles_radius[i]))
      obstacle_board[tid] += (1<<i);
  }
}
