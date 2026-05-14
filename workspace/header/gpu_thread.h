#include <cuda.h>
#include <cuda_runtime.h>

#include <math.h>

#define THREADS_PER_BLOCK 768

#define gpuErrchk(ans)                                                         \
  { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line,
                      bool abort = true) {
  if (code != cudaSuccess) {
    fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file,
            line);
    if (abort)
      exit(code);
  }
}

__global__ void
calculateOneOuputSomeOptimization(int input_row, int input_col, int *input,
                                  int kernel_row, int kernel_col, int *kernel,
                                  int output_row, int output_col,
                                  long long unsigned int *output) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  if (index >= output_col * output_row)
    return;

  int cur_output_row = index / output_col;
  int cur_output_col = index % output_col;

  long long unsigned int output_var = 0;

  int i = cur_output_row;
  int i_col = i * input_col;

  for (int kernel_i = 0; kernel_i < kernel_row; kernel_i++) {
    int j = cur_output_col;
    int ki = kernel_i * kernel_col;
    for (int kernel_j = 0; kernel_j < kernel_col; kernel_j++) {
      output_var += input[i_col + j] * kernel[ki + kernel_j];
      j += 2;
      if (j >= input_col) {
        j -= input_col;
      }
    }
    i += 2;
    if (i >= input_row) {
      i -= input_row;
    }
    i_col = i * input_col;
  }
  output[index] = output_var;
}


void gpuThread(int input_row, int input_col, int *input, int kernel_row,
               int kernel_col, int *kernel, int output_row, int output_col,
               long long unsigned int *output) {

  if (output_col <= 0 || output_row <= 0)
    return;

  int *device_input;
  int *device_kernel;
  long long unsigned int *device_output;

  gpuErrchk(cudaMalloc((void **)&device_output, sizeof(long long unsigned int) * output_row * output_col));
  gpuErrchk(cudaMalloc((void **)&device_input, sizeof(int) * input_row * input_row));
  gpuErrchk(cudaMalloc((void **)&device_kernel, sizeof(int) * kernel_col * kernel_row));

  gpuErrchk(cudaMemset(device_output, 0, sizeof(long long unsigned int) * output_row * output_col));
  gpuErrchk(cudaMemcpy(device_kernel, kernel, sizeof(int) * kernel_col * kernel_row, cudaMemcpyHostToDevice));
  gpuErrchk(cudaMemcpy(device_input, input, sizeof(int) * input_row * input_col, cudaMemcpyHostToDevice));

  int threadBlocks = (output_col * output_row) / THREADS_PER_BLOCK + 1;
  
  calculateOneOuputSomeOptimization<<<threadBlocks, THREADS_PER_BLOCK>>>(
      input_row, input_col, device_input, kernel_row, kernel_col, device_kernel,
      output_row, output_col, device_output);

  gpuErrchk(cudaPeekAtLastError());
  gpuErrchk(cudaDeviceSynchronize());

  gpuErrchk(cudaMemcpy(output, device_output,
                       sizeof(long long unsigned int) * output_row * output_col,
                       cudaMemcpyDeviceToHost));

  gpuErrchk(cudaFree(device_output));
  gpuErrchk(cudaFree(device_input));
}
