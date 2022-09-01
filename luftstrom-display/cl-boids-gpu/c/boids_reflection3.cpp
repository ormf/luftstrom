float4 vlimit(float4 v, float limit)
{
  if (fast_length(v) == 0.0)
    return (v);
  else return(fast_normalize(v) * min (fast_length(v) , limit));
}

__kernel void boids_reflection3(
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
                                __constant int* obstacle_maxidx,
                                int maxidx,
                                int num_obstacles,
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

  int bwidth=width/5;
  int bheight=height/5;

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
    if ((board_x[i]+bxpos > 0) &&
        (board_x[i]+bxpos < bwidth) &&
        (board_y[i]+bypos > 0) &&
        (board_y[i]+bypos < bheight)) {

      bidx = (board_x[i]+bxpos) + 
        ((board_y[i]+bypos) * bwidth);
      sep = sep + (board_sep[i]*board_weight[bidx]);
      coh = coh + (board_coh[i]*board_weight[bidx]);
      align = align + board_align[bidx];
    }
  }
  if (fast_length(sep) != 0) {sep=vlimit((fast_normalize(sep)*maxspeed)-v[tid], maxforce)*sepmult;}
  if (fast_length(coh) != 0) {coh=vlimit ((fast_normalize(coh)*maxspeed)-v[tid], maxforce)*cohmult;}
  if (fast_length(align) != 0) {align=vlimit((fast_normalize(align)*maxspeed), maxforce)*alignmult;}

  force[tid]=align;
  v[tid]=vlimit(v[tid]+vlimit(
                              align + coh + sep ,maxforce), maxspeed);
    
  float4 tmp = pos[tid4]+v[tid];
  float xdev=0.0;
  float ydev=0.0;
  int dist = 50;
  float maxf = 5*maxforce*fast_length(v[tid]);
  if (tmp.x > (width - dist)) {
    if (fabs(v[tid].y) < 0.1) v[tid].y=0.1;
    if (tmp.x < width) xdev = -1 * maxf/(width-tmp.x);
    else xdev = -1 * maxf;}
  if (tmp.x < dist) {
    if (fabs(v[tid].y) < 0.1) v[tid].y=-0.1;
    if (tmp.x > 0) xdev = maxf/tmp.x;
    else xdev = 0.2;}
  if (tmp.y > (height - dist)) {
    if (fabs(v[tid].x) < 0.1) v[tid].x=0.1;
    if (tmp.y < height) ydev = -1 * maxf/(height-tmp.y); 
    else ydev = -1 * maxf;}
  if (tmp.y < dist) {
    if (fabs(v[tid].x) < 0.1) v[tid].x=-0.1;
    if (tmp.y > 0) ydev = maxf/tmp.y;
    else ydev = maxf;}
  v[tid] += (float4) (xdev, ydev, 0.0, 0.0);
  if (fast_length (v[tid]) < 0.01) v[tid]=fast_normalize(v[tid])*maxforce;
  float4 p = fmod(pos[tid4]
                  + v[tid]
                  + (float4) ((float) width, (float) height, 0.0, 0.0),
                  (float4) ((float) width, (float) height, 1000000.0, 1000000.0));


  pos[tid4] = p;
  pos[tid4+2] = p - (length * fast_normalize(v[tid]));
}
