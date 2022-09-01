float4 vlimit(float4 v, float limit)
{
  if (fast_length(v) == 0.0)
    return (v);
  else return(fast_normalize(v) * min (fast_length(v) , limit));
}

__kernel void boids_fade (
                          __global float4* pos, 
                          __global float4* v,
                          __global float4* force,
                          __global int* board_idx,
                          __global float* life,
                          __global int* retrig,
                          __global float4* color,
                          __constant int* board_weight,
                          __constant float4* board_align,
                          __constant int* board_x,
                          __constant int* board_y,
                          __constant float* board_dist,
                          __constant float4* board_coh,
                          __constant float4* board_sep,
                          __constant int* board_obstacles,
                          __constant float4* obstacle_pos,
                          __constant int* obstacle_radius,
                          __constant int* obstacle_maxidx,
                          int num_obstacles,
                          int maxidx,
                          float length,
                          float dt,
                          float x,
                          float y,
                          float z,
                          float maxspeed, 
                          float maxforce, 
                          float alignmult,
                          float sepmult,
                          float cohmult,
                          float randang,
                          int pixelsize,
                          int width,
                          int height)
{

  int bwidth = width/5;
  int bheight = height/5;

  size_t tid = get_global_id(0);
  size_t tid4 = tid*4;

  int bxpos = (int) floor(pos[tid4].x/pixelsize);
  int bypos = (int) floor(pos[tid4].y/pixelsize);
  int bidx = bxpos + (bypos * bwidth);
  board_idx[tid] = bidx;
  float4 sep;
  float4 coh;
  float4 align;
  if ((board_weight[bidx] - 1) > 0)
    { align = board_align[bidx];
      coh = (board_coh[0]*(board_weight[bidx] - 1));
      sep = (v[tid]-board_align[bidx])*2;
    }
  else { coh = sep = align = (float4) (0.0, 0.0, 0.0, 0.0);}
  for (int i=1;i<maxidx;i++) {
    bidx = ((board_x[i]+bxpos+bwidth)%bwidth) + 
      (((board_y[i]+bypos+bheight)%bheight) * bwidth);
    sep = sep + (board_sep[i]*board_weight[bidx]);
    coh = coh + (board_coh[i]*board_weight[bidx]);
    align = align + board_align[bidx];
  }
  if (fast_length(sep) != 0)
    {sep=vlimit((fast_normalize(sep)*maxspeed)-v[tid], maxforce)*sepmult;}
  if (fast_length(coh) != 0)
    {coh=vlimit ((fast_normalize(coh)*maxspeed)-v[tid], maxforce)*cohmult;}
  if (fast_length(align) != 0)
    {align=vlimit((fast_normalize(align)*maxspeed), maxforce)*alignmult;}

  force[tid]=align;
  v[tid]=vlimit(v[tid]+vlimit(
                              (float4) (0.0,0.0,0.0,0.0) + align + coh + sep , maxforce), maxspeed);
  float4 p = fmod(pos[tid4] 
                  + v[tid]
                  + (float4) ((float) width, (float) height, 0.0, 0.0),
                  (float4) ((float) width, (float) height, 1000000.0, 1000000.0));
  pos[tid4] = p;
  pos[tid4+2] = p - (length * fast_normalize(v[tid4/4]));
}
