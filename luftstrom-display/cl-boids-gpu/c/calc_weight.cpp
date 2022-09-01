#pragma OPENCL EXTENSION cl_khr_int64_base_atomics : enable

// upper version taken from: https://streamhpc.com/blog/2016-02-09/atomic-operations-for-floats-in-opencl-improved/

void atomicAdd_g_f(volatile __global float *addr, float val)
{
  union {
    unsigned int u32;
    float f32;
  } next, expected, current;
  current.f32 = *addr;
  do {
    expected.f32 = current.f32;
    next.f32 = expected.f32 + val;
    current.u32 = atomic_cmpxchg( (volatile __global unsigned int *)addr,
                                  expected.u32, next.u32);
  } while( current.u32 != expected.u32 );
}

// this version taken from: http://simpleopencl.blogspot.com/2013/05/atomic-operations-and-floats-in-opencl.html

void atomic_add_global(__global float *source, const float operand) {
    union {
        unsigned int intVal;
        float floatVal;

    } newVal;
    union {
        unsigned int intVal;
        float floatVal;
    } prevVal;
 
    do {
        prevVal.floatVal = *source;
        newVal.floatVal = prevVal.floatVal + operand;
    } while (atomic_cmpxchg((volatile global unsigned int *)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}

// calc weight is called on each boid with its pos in "pos[]".

// explanation of globals:

// pos[numBoids] - array containing the position of all boids
// board[boardSize] - array containing the number of Boids (= weight) of each tile,
// vel[numBoids] - array containing the velocities of all boids.
// align[boardSize] - array containing the sum of the alignments of boids in each tile.
//
// alignments needs to get normalized (= divided by the weight) after
// the whole board is calculated. This is done in the boids.cpp stage.

__kernel void calc_weight(
__global float4* pos,
__global int* board,
__global float4* vel,
__global float* align, 
int pixelsize, 
int width, 
int height)
{
    size_t tid = get_global_id(0)*4;
    int boardidx = (int)(floor(pos[tid].x/pixelsize)
                         + ((width/pixelsize)*((floor(pos[tid].y/pixelsize)))));
    atomic_inc(board+boardidx);
    atomicAdd_g_f(align+(4*boardidx), vel[tid/4].x); // x component of velocity
    atomicAdd_g_f(align+(4*boardidx)+1, vel[tid/4].y); // y component of velocity
}
