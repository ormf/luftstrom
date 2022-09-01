float4 vlimit(float4 v, float limit)
{
  if (fast_length(v) == 0.0)
    return (v);
  else return(fast_normalize(v) * min (fast_length(v) , limit));
}

float angle(float4 v1, float4 v2)
{
  return (fmod(2+atan2pi(v2.y, v2.x)-atan2pi(v1.y,v1.x),2) - 1);
}

float randomangplusminus45deg(size_t tid, uint count)
{
  return(((float)tid/count) * 1.5707963267948966
         -  0.7853981633974483);
}

float random (size_t tid, uint count)
{
  return ((float)tid/count); 
}

float4 vrot2d(float4 v, float phi)
{
  float x2,y2,sinus,cosinus;
  sinus=sin(phi);
  cosinus=cos(phi);
  x2 = v.x*cosinus-v.y*sinus;
  y2 = v.x*sinus+v.y*cosinus;
  v.x = x2;
  v.y = y2;
  return((float4) (x2,y2,v.z,v.w));
}

//   int i = obstacle_board[posidx]

int get_closest_obstacle_idx (int obstacles, __constant float4 *obst_pos, __constant int *obst_radius, __constant int *obst_type, float4 boid_pos)
{
  float mindist = 1e30;
  int closest_obstacle = -1;
  float currdist;
  int idx=0;
  int predator = 0;
  while ((obstacles != 0)&&(idx<30)) {
    if (obstacles&1) {
      if (obst_type[idx] == 1) {
        predator = 1;}
      else {
        if (predator) return(closest_obstacle);
      }
      currdist = fast_length(obst_pos[idx]-boid_pos)-obst_radius[idx];
      if (currdist < mindist) {
        mindist=currdist;
        closest_obstacle=idx;
      }
    }
    obstacles >>= 1;
    idx++;
  }
  return(closest_obstacle);
}


__kernel void boids(__global float4* pos, 
                    __global float4* v,
                    __global float4* force,
                    __global int* board_idx,
                    __global float* life,
                    __global float* retrig,
                    __global float4* color,
                    __constant int* board_weight,
                    __constant float4* board_align,
                    __constant int* board_dx,
                    __constant int* board_dy,
                    __constant float* board_dist,
                    __constant float4* board_coh,
                    __constant float4* board_sep,
                    __constant int* board_obstacles,
                    __constant float4* obstacles_pos,
                    __constant int* obstacles_radius,
                    __constant int* obstacles_type,
                    __constant int* obstacles_maxidx,
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
                    float predmult,
                    float maxlife,
                    float lifemult,
                    int count,
                    int pixelsize,
                    int width,
                    int height)
{ int bwidth=width/pixelsize;
  int bheight=height/pixelsize;

  size_t tid = get_global_id(0);
  size_t tid4 = tid*4;

  int bxpos = (int) floor(pos[tid4].x/pixelsize); // x-pos of boid in board-coordinates
  int bypos = (int) floor(pos[tid4].y/pixelsize); // y-pos of boid in board-coordinates
  int bidx = bxpos + (bypos * bwidth); // index of boid's pos into the board-array
  board_idx[tid] = bidx;
  float4 sep;
  float4 coh;
  float4 align;

  float4 obst_force = (float4) (0.0, 0.0, 0.0, 0.0);
  int closest_obst_idx = -1;
  int highlight = 0;
  color[tid] = (float4) (-1.0, -1.0, -1.0, -1.0);
  if (life[tid]>0) {
    pos[tid4].w = 0.0;
    if (board_obstacles[bidx]>0) {
      //      highlight=1;
      closest_obst_idx = get_closest_obstacle_idx((int)board_obstacles[bidx],
                                                  obstacles_pos, obstacles_radius, obstacles_type,
                                                  pos[tid4]);

      if (obstacles_type[closest_obst_idx] != 1) {
        float4 v_obst = obstacles_pos[closest_obst_idx]-pos[tid4]; // vector boid -> obstacle-center
        float pdist=fast_length(cross(v_obst, fast_normalize(v[tid]))); // shortest distance of boid-trajectory and obstacle-center
        color[tid].x = pdist;
        color[tid].y = obstacles_radius[closest_obst_idx];
        color[tid].z = angle(v[tid], v_obst);
        color[tid].w = 0.0;
        //fast_length(vcross(v_obst, v)) / fast_length (v);
        if (pdist < (float)obstacles_radius[closest_obst_idx]) {
        
          if (angle(v[tid], v_obst) > 0.0) {
            obst_force = fast_normalize((float4) ((float)(v[tid].y)*-1, (float) v[tid].x, 0.0, 0.0));
          }
          else {
            obst_force = fast_normalize((float4) ((float)(v[tid].y), (float) v[tid].x*-1, 0.0, 0.0));
          }
        }
      }
    }
    if ((board_obstacles[bidx]>0) && (obstacles_type[closest_obst_idx] == 1))  {
      v[tid]= fast_normalize(pos[tid4]-obstacles_pos[closest_obst_idx])*predmult;
    }
    else {
      if ((board_weight[bidx] - 1) > 0) {
        sep = vrot2d(fast_normalize(v[tid]), randomangplusminus45deg(tid,count));
        // sep = fastvrot2d(fast_normalize(v[tid]), tid);
        float randforce=(1+(0.1*maxspeed*random(tid, count)));;
        v[tid]=v[tid] * randforce;
      }
      else { coh = sep = align = (float4) (0.0, 0.0, 0.0, 0.0);
        for (int i=1;i<maxidx;i++) {
          bidx = ((board_dx[i]+bxpos+bwidth)%bwidth) + 
            (((board_dy[i]+bypos+bheight)%bheight) * bwidth);
          sep = sep + (board_sep[i]*board_weight[bidx]);
          coh = coh + (board_coh[i]*board_weight[bidx]);
          align = align + board_align[bidx];
        }
        if (fast_length(sep) != 0) {sep=vlimit((fast_normalize(sep)*maxspeed)-v[tid], maxforce)*sepmult;}
        if (fast_length(coh) != 0) {coh=vlimit ((fast_normalize(coh)*maxspeed)-v[tid], maxforce)*cohmult;}
        if (fast_length(align) != 0) {align=vlimit((fast_normalize(align)*maxspeed), maxforce)*alignmult;}
        float4 curr_force =  vlimit((float4) (0.0,0.0,0.0,0.0) + align + coh + sep + obst_force ,maxforce);
        force[tid] = obst_force;
        board_idx[tid] = closest_obst_idx;
        v[tid]= vlimit(v[tid]+curr_force, maxspeed);
      }
    }
    float4 p = fmod(pos[tid4] 
                    + v[tid]
                    + (float4) ((float) width, (float) height, 0.0, 1.0),
                    (float4) ((float) width, (float) height, 1000000.0, 1000000.0));
    pos[tid4] = p;
    pos[tid4+2] = p - (length * fast_normalize(v[tid4/4]));

    if (highlight == 0) {
      pos[tid4+3].w = pos[tid4+1].w = 0.5+0.5*life[tid]/maxlife;
      pos[tid4+3].x = pos[tid4+1].x = 1.0;
      pos[tid4+3].y = pos[tid4+1].y = 1.0;
      pos[tid4+3].z = pos[tid4+1].z = 1.0;
    }
    else {
      pos[tid4+3].w = pos[tid4+1].w = 0.5+0.5*life[tid]/maxlife;
      pos[tid4+3].x = pos[tid4+1].x = 1.0;
      pos[tid4+3].y = pos[tid4+1].y = 0.0;
      pos[tid4+3].z = pos[tid4+1].z = 1.0;
    }
    life[tid]-=lifemult*fast_length(v[tid]);
    if (life[tid] <= 0) {
      life[tid] = maxlife;
      retrig[tid] = 1.0;
    }
    else {
      retrig[tid] = 0.0;
    }
    //  life[tid]=0;
    //  life[tid]= (int) 65536*random(tid,count);
  }
}
