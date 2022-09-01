float4 vlimit(float4 v, float limit)
{
  if (fast_length(v) == 0.0)
    return (v);
    else return(fast_normalize(v) * min (fast_length(v) , limit));
  //    else return(fast_normalize(v) );
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

// The boids function is called on every boid in parallel (once for
// every frame). This code calculates the new properties for one
// boid. It calculates:
//
// - its new position (start and end)
// - its new velocity
// - its new life value
// - a trigger value to trigger sound (depending on life (auto
//   trigger) or being within reach of an obstacle)
//
// To calc its new velocity and pos, each boid has to take its
// surrounding into account (using the rules for alignment, separation
// and coherence). A global (constant) seq contains the (x y) tile
// offsets relative to the current (x y) tile position of the boid,
// sorted by distance: (0, -1) (-1, 0) (0 1) and (1 0) are the
// neighboring tiles, (-1 -1), (-1 1) (1 -1) and (1 1) are further
// away, etc. A maxidx indicates the maximum index into the sequence
// for a given radius around the boid.

//
// When calling the boids routine, the obstacle board already contains
// a bitfield for every tile on the board, indicating, which obstacle
// is within reach of the board-position of the tile (for a boid
// located on that tile) (the respective bit of a visible obstacle is
// set to 1). Note: These calculations are done in the lisp routines
// whenever an obstacle changes state (e.g. position, type, radius,
// lookahead, etc.)
//
// Checking this in get_closest_obst_idx is therefore as simple as
// checking all bits in the obstacles of the board-idx of a boid
// whether they are set to 1, calculating the distance of the obstacle
// to the current position and returning the smallest. In case an
// obstacle is a predator, the routine immediately returns, without
// checking if another predator might be closer. (this is a
// preliminary routine and can be corrected in case it is necessary).
// TODO: Determining the closest obstacle should be precalculated,
// either on the lisp side or (probably better) in the calc_board
// routine, so that each board tile already contains the index of the
// closest obstacle within reach.

// obstacle-types:

#define no_interact 0
#define plucker 1
#define avoider 2
#define attractor 3
#define predator 4

#define HANDLE_CASE(type)   \
case type:                                                              \
if (predator_found > type) {                                            \
  return(closest_obstacle); }                                           \
if (predator_found < type) {                                            \
  mindist = 1e30;                                                       \
  predator_found = type;                                                \
 }                                                                      \
if (predator_found == type) {                                           \
  currdist = fast_length(obst_pos[idx]-boid_pos)-obst_radius[idx];      \
  if (currdist < mindist) {                                             \
    mindist=currdist;                                                   \
    closest_obstacle=idx;                                               \
  }                                                                     \
 }                                                                      \
break;                                                                  \


int get_closest_obstacle_idx (int obstacles, __constant float4 *obst_pos, __constant int *obst_radius, __constant int *obst_type, float4 boid_pos)
{
  float mindist = 1e30;
  int closest_obstacle = -1;
  float currdist;
  int idx=0;
  int predator_found = 0;
  while ((obstacles != 0)&&(idx<30)) {
    if (obstacles&1) {
      switch (obst_type[idx]) {
        HANDLE_CASE(predator);
        HANDLE_CASE(attractor);
        HANDLE_CASE(avoider);
        HANDLE_CASE(plucker);
      default :
        if (predator_found == 0) { // only set mindistance if no obstacle
                             // has been found yet
          if (currdist < mindist) {
            mindist=currdist;
            closest_obstacle=idx;
          }
        }
        break;        
      }
    }
    obstacles >>= 1;
    idx++;
  }
  return(closest_obstacle);
}

__kernel void boids(__global float4* pos, // Pos[numBoids] of boid 
                    __global float4* v,   // Velocity[numBoids] of boid
                    __global float4* force,
                    __global int* board_idx, // Pos[boardsize] on Board
                    __global float* life,    // life[numBoids] of boid
                    __global int4* retrig,   // retrig[numBoids] of boid
                    __global float4* color,  // color[numBoids] of boid
                    __constant int* board_weight, // weight[boardsize] board
                    __constant float4* board_align, // alignment[boardsize] board
                    __constant int* board_dx, // a seq of dx values moving in a spiral around the current board pos.
                    __constant int* board_dy, // a seq of dy values moving in a spiral around the current board pos.
                    __constant float* board_dist, // a seq of distance values moving in a spiral around the current board pos.
                    __constant float4* board_coh, // a seq of coherence vectors, scaled by distance around the current board pos.
                    __constant float4* board_sep, // a seq of seperation vectors, scaled by the square of the distance around the current board pos.
                    __constant int* board_obstacles, // obstacle[boardsize] board
                    __constant float4* obstacles_pos, // pos[maxobstacles] of obstacle
                    __constant int* obstacles_radius, // radius[maxobstacles] of obstacle
                    __constant int* obstacles_type, // type[maxobstacles] of obstacle
                    __constant int* obstacles_maxidx, // maxidx[maxobstacles] into board_dx, board_dy... of obstacle, depending on lookahead
                    __constant float* obstacles_lookahead, // lookahead[maxobstacles] of obstacle
                    __constant float* obstacles_multiplier, // multiplier[maxobstacles] of obstacle
                    int num_obstacles,
                    int clock,
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
                    float maxlife,
                    float lifemult,
                    int count,
                    int pixelsize,
                    int width,
                    int height)
{ int bwidth=width/pixelsize;
  int bheight=height/pixelsize;

  size_t tid = get_global_id(0); // the index of the boid to be calculated
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
  if (tid==0) highlight = 1; // red obstacle
  color[tid] = (float4) (-1.0, -1.0, -1.0, -1.0);
  //  if (life[tid]>0) {
  if (1) {
    pos[tid4].w = 0.0;
    if (board_obstacles[bidx]>0) { // obstacle at the boid's position?
      //      highlight=1;
      closest_obst_idx = get_closest_obstacle_idx((int)board_obstacles[bidx],
                                                  obstacles_pos, obstacles_radius, obstacles_type,
                                                  pos[tid4]);
      switch (obstacles_type[closest_obst_idx]) {
      case predator: {
        float4 v_obst = (pos[tid4]-obstacles_pos[closest_obst_idx]);
        float p_dist = fast_length(v_obst);
        float flee_dist = (obstacles_lookahead[closest_obst_idx] * obstacles_radius[closest_obst_idx]);

        // color is used as temporary storage (info for lisp side)
        
        color[tid].x = p_dist;
        color[tid].y = flee_dist;
        color[tid].z = angle(v[tid], v_obst);
        color[tid].w = 0.0;
        if (p_dist > 0) {
          v[tid]= fast_normalize(v_obst)*
            native_powr((obstacles_multiplier[closest_obst_idx]*maxspeed)/maxspeed,(flee_dist-p_dist)/flee_dist);
        }
        else {
          v[tid]= fast_normalize(v_obst)*(obstacles_multiplier[closest_obst_idx]*maxspeed)*0;
        }
        if (retrig[tid].w > 60) { // last trigger > 60 frames?
          life[tid]= 0;
          retrig[tid].y = closest_obst_idx;
          retrig[tid].z = 0;
          retrig[tid].w = 0;
        }
        maxspeed*=obstacles_multiplier[closest_obst_idx];
        break;
      }
      case attractor: {
        float4 v_obst = (obstacles_pos[closest_obst_idx]-pos[tid4]);
        float p_dist = fast_length(v_obst);
        float attract_dist = (obstacles_lookahead[closest_obst_idx] * obstacles_radius[closest_obst_idx]);
        color[tid].x = p_dist;
        color[tid].y = attract_dist;
        color[tid].z = angle(v[tid], v_obst);
        color[tid].w = 0.0;
        if (p_dist > 0) {
          v[tid]= fast_normalize(v_obst)*maxspeed*
            native_powr((obstacles_multiplier[closest_obst_idx]*maxspeed)/maxspeed,(attract_dist-p_dist)/attract_dist);
        }
        else {
          v[tid]= v_obst*(obstacles_multiplier[closest_obst_idx]*maxspeed);
        }
        break;
      }
      case plucker: {
        if (retrig[tid].w > 60) {
          life[tid]= 0;
          retrig[tid].y = closest_obst_idx;
          retrig[tid].z = 0;
          retrig[tid].w = 0;
        }
        break;
      }
      case avoider : {
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
    }
    
    // normal case: No predator in the way, maybe not even an obstacle
    if ((board_weight[bidx] - 1) > 0) { // other boids are present in same tile
      sep = vrot2d(fast_normalize(v[tid]), randomangplusminus45deg(tid,count));
        // sep  fastvrot2d(fast_normalize(v[tid]), tid);
      float randforce=(1+(0.1*maxspeed*random(tid, count)));;
      v[tid]=vlimit(v[tid] * randforce, 1000);
      //      v[tid]=(float4) (1.0,1.0,0.0,0.0);
    }
    else { coh = sep = align = (float4) (0.0, 0.0, 0.0, 0.0);
      for (int i=1;i<maxidx;i++) { // move in spiral around the current boids pos
        bidx = ((board_dx[i]+bxpos+bwidth)%bwidth) + 
          (((board_dy[i]+bypos+bheight)%bheight) * bwidth); // calc index of tile
        sep = sep + (board_sep[i]*board_weight[bidx]); // increment sep by sep weight multiplied by weight (num boids) of tile
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
      //      v[tid]=(float4) (1.0,1.0,0.0,0.0);
    }

    float4 p = fmod(pos[tid4] 
                    + v[tid]
                    + (float4) ((float) width, (float) height, 0.0, 1.0),
                    (float4) ((float) width, (float) height, 1000000.0, 1000000.0));
    pos[tid4] = p;
    pos[tid4+2] = p - (length * fast_normalize(v[tid]));

    if (highlight == 0) {
      if (retrig[tid].z <= 10)
        pos[tid4+3].w = pos[tid4+1].w = 1-(retrig[tid].z*0.0125);
      else
        pos[tid4+3].w = pos[tid4+1].w = 0.4;
      pos[tid4+3].x = pos[tid4+1].x = 1.0;
      pos[tid4+3].y = pos[tid4+1].y = 1.0;
      pos[tid4+3].z = pos[tid4+1].z = 1.0;
    }
    else {
      if ((life[tid]/maxlife) > 0.98) {
        pos[tid4+3].w = pos[tid4+1].w = 0.38+6.2*(life[tid]/maxlife-0.9); }
      else {
        pos[tid4+3].w = pos[tid4+1].w = 0.2+0.2*life[tid]/maxlife; }
      pos[tid4+3].x = pos[tid4+1].x = 1.0;
      pos[tid4+3].y = pos[tid4+1].y = 0.0;
      pos[tid4+3].z = pos[tid4+1].z = 0.5;
    }
    life[tid]-=lifemult+(lifemult*fast_length(v[tid])*0.1);
    //    life[tid]-=lifemult;
    if (life[tid] <= 0) { // trigger pending?
      if (clock) {
        life[tid] = maxlife;
        retrig[tid].x = retrig[tid].y + 1; // closest obst-idx + 1 (0 if no obstacle aka auto-induced)
        retrig[tid].y = -1; // reset obst-idx to no trigger
        retrig[tid].z = 0; // reset last trigger timer
      }
      else {
        life[tid] = 0.001;
      }
    }
    else {
      retrig[tid].x = -1; // no trigger!
    }
    retrig[tid].z += 1; // increment last trigger timer
    retrig[tid].w += 1; // increment last trigger timer for obstacle-induced triggers
    //  life[tid]=0;
    //  life[tid]= (int) 65536*random(tid,count);
  }
}
