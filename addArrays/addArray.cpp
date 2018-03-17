#include <iostream>
#include <math.h>
#include <sys/time.h> // provides resolution of 1 us


// function to add the elements of two arrays
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
	float *x = new float[N];
	float *y = new float[N];

	// initialize x and y arrays on the host
	for(int i = 0; i < N; i++)
	{
		x[i] = 1.0f;
		y[i] = 2.0f;
	}

	// timestamp t1
	gettimeofday(&t1, NULL);

	//Run kernel on 1M elements on the CPU
	//aka the real stuff
	add(N, x, y);

	// timestamp t2
    gettimeofday(&t2, NULL);

	//Free memory
	delete [] x;
	delete [] y;


	// compute and print the elapsed time in millisec
    elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
    elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms

	std::cout << "Amount of time to add 1 Million elements : " << elapsedTime << " millisec." << std::endl;

	return 0;
}