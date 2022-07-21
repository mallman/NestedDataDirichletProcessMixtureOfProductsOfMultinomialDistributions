#include <metal_stdlib>
using namespace metal;

kernel void NDPMPM(constant long* SKR,
                   constant int* H,
                   constant int* P,
                   constant int* Q,
                   device atomic<int>* C,
                   uint2 ij [[ thread_position_in_grid ]]) {
  long S = SKR[0];
  long K = SKR[1];
  long R = SKR[2];

  int i = ij.x;
  int j = ij.y;
  int g = H[i];
  int s = P[i * R + j];
  int k = Q[i * R + j];
  atomic_fetch_add_explicit(&C[g * S * K + s * K + k],
                            1,
                            memory_order_relaxed);
}
