#include <iostream>
#include <math.h>
#include <sys/time.h> // provides resolution of 1 us

//Number of threads in one thread block
#define THREAD_NUM (256) 

// cuda kernel to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
	for(int i = 0; i < n; i++)
		y[i] = x[i] + y[i];
}


int main(void)
{
	timeval t1, t2;
	double elapsedTime;

	int N = 1 << 20;

	float *x, *y;

	//Allocate Unified memory -accessible from both CPU or GPU 🤘
	//Conceptually, foes the same function as new 
	cudaMallocManaged(&x, N*sizeof(float));
	cudaMallocManaged(&y, N*sizeof(float));

	// initialize x and y arrays on the host
	for(int i = 0; i < N; i++)
	{
		x[i] = 1.0f;
		y[i] = 2.0f;
	} 

	// timestamp t1
	gettimeofday(&t1, NULL);

	//Run kernel on 1M elements on the CPU
	add<<<1, THREAD_NUM>>>(N, x, y);

	// timestamp t2
    gettimeofday(&t2, NULL);

	//Wait for GPU to finish before accessing on host
	//Why: to make CPU wait from accessing GPU result
	cudaDeviceSynchronize();

	//Free memory
	cudaFree(x);
	cudaFree(y);


	// compute and print the elapsed time in millisec
    elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
    elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms

	std::cout << "Amount of time to add 1 Million elements (with CUDA cores): " << elapsedTime << " millisec." << std::endl;


	return 0;
}