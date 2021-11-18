// this file was generate by hipify-clang
#include <hip/hip_runtime.h>
#include <iostream>
#include <stdlib.h>

#define NUM_MAX (1 << 10)
#define BLOCK_SIZE (1 << 5)
#define GRID_SIZE (1 << 13)
#define VERIFY 0

template <typename T>
__global__ void foo(T *x, T *y, T *p, T *q)
{
  extern __shared__ int shared_x[];
  extern __shared__ int shared_y[];
  extern __shared__ int shared_p[];
  extern __shared__ int shared_q[];
  const unsigned int tid = threadIdx.x;
  int offset = blockIdx.x * BLOCK_SIZE;
  shared_x[tid] = x[offset + tid];
  shared_y[tid] = y[offset + tid];
  shared_p[tid] = p[offset + tid];
  shared_q[tid] = q[offset + tid];

  __syncthreads();
  T t1 = 0;
  T t2 = 0;
  T t3 = 0;
  T t4 = 0;
  T t5 = 0;
  for (unsigned int i = 0; i < BLOCK_SIZE; ++i)
  {
    for (unsigned int j = 0; j < BLOCK_SIZE; j++)
    {
      t1 = 0;
      t2 = 0;
      t3 = 0;
      t4 = 0;
      t5 = 0;
      if (tid % 2 == 0)
      {

        if (tid % 4 == 0)
        {
          t1 = ((((shared_y[i] ^ shared_x[i]) + (shared_x[i] - shared_x[i])) * ((shared_x[i] ^ shared_x[i]) * (shared_y[i] & shared_y[i]))) + (((shared_y[i] * shared_y[i]) * (shared_x[i] - shared_x[i])) / (abs(((shared_y[i] ^ shared_x[i]) * (shared_x[i] ^ shared_x[i]))) + 1)));
        }

        if (tid % 6 == 0)
        {
          t2 = ((((shared_y[i] * shared_x[i]) - (shared_x[i] ^ shared_y[i])) - ((shared_y[i] | shared_y[i]) ^ (shared_y[i] ^ shared_x[i]))) * (((shared_x[i] + shared_y[i]) ^ (shared_x[i] | shared_y[i])) / (abs(((shared_y[i] + shared_x[i]) ^ (shared_x[i] ^ shared_x[i]))) + 1)));
        }

        if (tid % 8 == 0) {
          t3 = ((((shared_y[i] - shared_y[i]) | (shared_x[i] ^ shared_x[i])) & ((shared_y[i] - shared_x[i]) * (shared_y[i] ^ shared_x[i]))) * (((shared_y[i] | shared_x[i]) | (shared_x[i] + shared_y[i])) / (abs(((shared_y[i] * shared_y[i]) | (shared_x[i] & shared_x[i]))) + 1)));
        }
      }
      else
      {
        if (tid % 3 == 0)
        {
          t4 = ((((shared_q[j] * shared_p[j]) - (shared_p[j] + shared_p[j])) & ((shared_q[j] | shared_p[j]) & (shared_p[j] & shared_q[j]))) * (((shared_q[j] & shared_q[j]) & (shared_q[j] + shared_q[j])) - ((shared_p[j] ^ shared_q[j]) / (abs((shared_q[j] & shared_p[j])) + 1))));
        }

        if (tid % 5 == 0) {
          t5 = ((((shared_p[j] | shared_q[j]) - (shared_p[j] | shared_q[j])) / (abs(((shared_p[j] & shared_p[j]) + (shared_q[j] * shared_p[j]))) + 1)) * (((shared_q[j] ^ shared_q[j]) * (shared_p[j] + shared_q[j])) & ((shared_p[j] & shared_q[j]) + (shared_p[j] + shared_q[j]))));
        }


      }
      shared_x[i] = t1 - t2;
      shared_y[i] = t3 + t2;
      shared_p[i] = t4 - t5;
      shared_q[i] = t4 + t5;
      __syncthreads();
    }
  }

  x[offset + tid] = shared_x[tid];
  y[offset + tid] = shared_y[tid];
  p[offset + tid] = shared_p[tid];
  q[offset + tid] = shared_q[tid];
}


template <typename T>
void init_random(T *x, T *y, T *p, T *q)
{
  for (int j = 0; j < GRID_SIZE; j++)
  {
    for (int i = 0; i < BLOCK_SIZE; i++)
    {
      x[j * BLOCK_SIZE + i] = static_cast<T>(rand() % NUM_MAX);
      y[j * BLOCK_SIZE + i] = static_cast<T>(rand() % NUM_MAX);
      p[j * BLOCK_SIZE + i] = static_cast<T>(rand() % NUM_MAX);
      q[j * BLOCK_SIZE + i] = static_cast<T>(rand() % NUM_MAX);
    }
  }
}

template <typename T>
void run_test()
{

  T *x_h, *y_h, *p_h, *q_h;
  T *x_d, *y_d, *p_d, *q_d;
  // T *x_cpu, *y_cpu, *p_cpu, *q_cpu;
  T *x_gpu, *y_gpu, *p_gpu, *q_gpu;

  // deterministic random numbers
  srand(0);

  hipEvent_t start, stop;
  hipEventCreate(&start);
  hipEventCreate(&stop);

  int size = BLOCK_SIZE * GRID_SIZE;

  // malloc host
  x_h = (T *)malloc(sizeof(T) * size);
  y_h = (T *)malloc(sizeof(T) * size);
  p_h = (T *)malloc(sizeof(T) * size);
  q_h = (T *)malloc(sizeof(T) * size);

  // malloc for results
  x_gpu = (T *)malloc(sizeof(T) * size);
  y_gpu = (T *)malloc(sizeof(T) * size);
  p_gpu = (T *)malloc(sizeof(T) * size);
  q_gpu = (T *)malloc(sizeof(T) * size);

  // x_cpu = (T *)malloc(sizeof(T) * size);
  // y_cpu = (T *)malloc(sizeof(T) * size);
  // p_cpu = (T *)malloc(sizeof(T) * size);
  // q_cpu = (T *)malloc(sizeof(T) * size);

  // malloc device
  hipMalloc(&x_d, sizeof(T) * size);
  hipMalloc(&y_d, sizeof(T) * size);
  hipMalloc(&p_d, sizeof(T) * size);
  hipMalloc(&q_d, sizeof(T) * size);

  // initialize host
  init_random<T>(x_h, y_h, p_h, q_h);

  // make a copy
  // memcpy(x_cpu, x_h, sizeof(T) * size);
  // memcpy(y_cpu, y_h, sizeof(T) * size);
  // memcpy(p_cpu, p_h, sizeof(T) * size);
  // memcpy(q_cpu, q_h, sizeof(T) * size);
  /*for(int i=0; i<N*BLOCK_SIZE; i++)*/
  /*std::cout << x_h[i] << std::endl;*/

  // copy to device
  hipMemcpy(x_d, x_h, sizeof(T) * size, hipMemcpyHostToDevice);
  hipMemcpy(y_d, y_h, sizeof(T) * size, hipMemcpyHostToDevice);
  hipMemcpy(p_d, p_h, sizeof(T) * size, hipMemcpyHostToDevice);
  hipMemcpy(q_d, q_h, sizeof(T) * size, hipMemcpyHostToDevice);

  // run kernel
  hipEventRecord(start);
  hipLaunchKernelGGL(HIP_KERNEL_NAME(foo), dim3(GRID_SIZE), dim3(BLOCK_SIZE), sizeof(T) * BLOCK_SIZE * 4, 0, x_d, y_d, p_d, q_d);
  hipEventRecord(stop);

  hipDeviceSynchronize();

  // copy to host
  hipMemcpy(x_gpu, x_d, sizeof(T) * size, hipMemcpyDeviceToHost);
  hipMemcpy(y_gpu, y_d, sizeof(T) * size, hipMemcpyDeviceToHost);
  hipMemcpy(p_gpu, p_d, sizeof(T) * size, hipMemcpyDeviceToHost);
  hipMemcpy(q_gpu, q_d, sizeof(T) * size, hipMemcpyDeviceToHost);

  hipEventSynchronize(stop);
  float milliseconds = 0;
  hipEventElapsedTime(&milliseconds, start, stop);

  std::cout << "execution time = " << milliseconds << std::endl;


  // free host
  free(x_h);
  free(y_h);
  free(p_h);
  free(q_h);
  // free(x_cpu);
  // free(y_cpu);
  // free(p_cpu);
  // free(q_cpu);
  free(x_gpu);
  free(y_gpu);
  free(p_gpu);
  free(q_gpu);

  // free device
  hipFree(x_d);
  hipFree(y_d);
  hipFree(p_d);
  hipFree(q_d);

  hipDeviceReset();
}

int main(int argc, char **argv)
{
  // double input_bias = atof(argv[1]);
  run_test<int>();
  return 0;
}
