# HPCA Assignment
In this assignment, your task is to optimize the problem of “Dilated Convolution (DC)” which involves an input matrix and a kernel matrix. The sample algorithm is depicted below using an animation.

### Input:  

A. Input Matrix of dimensions: $\text{Input-Row} \times \text{Input-Column}$.

B. Kernel Matrix of dimensions: $\text{Kernel-Row} \times \text{Kernel-Column}$. 

### Output:  

An Output Matrix of dimensions: $(\text{Input-Row}-\text{Kernel-Row}+1)  \times (\text{Input-Column} - \text{Kernel-Column} +1)$ 

### Explanation and algorithm of DC: 

Dilated Convolution (DL) is a variant of the convolution operation. Following is the explanation of the algorithm: 

Let us assume for the explanation of the algorithm that the dimensions of the Input Matrix and Kernel Matrix are as follows: 

A. Input Matrix $(I)$: $4\times4$

B. Kernel Matrix $(K)$: $2\times2$ 

So, dimensions of the Output Matrix $(O)$ shall be (based on calculation): $3\times3$. 

[ $\text{Output-Row} = \text{Input-Row} - \text{Kernel-Row} + 1 = 4 - 2 + 1 = 3$. Calculation is similar for $\text{Output-Column}$.] 

The Kernel Matrix $(K)$ slides over the Input Matrix $(I)$ and produces each cell of the Output Matrix $(O)$ as shown below. In the animation below, The Kernel Matrix $(K)$ is the left-most, the Input-Matrix $(I)$ is in the middle, and the Output Matrix $(O)$ is the right-most.

![Algorithm Animation](./docs/Dilated_convolution.gif)

---

## Optimize dilated convolution using hardware counters.
Contained are two folders:
* workspace: Contains setup for GPU program.
* test: Contains a test program to aid in understanding the algorithm.

Each of the workspace folder contains two sub-folders, a Makefile, and a main program.
* Makefile: Contains commands necessary to compile, generate inputs, and run the program.
* data folder: Contains program that generates input, and will contain input once generated.
* header folder: Files containing the function that performs the operation. Modify the files in this folder.
* main.cpp: Program that takes inputs and executes the functions. DO NOT MODIFY THIS.

Navigate to workspace directory to begin setting up the system.

### Compiling and generating input
Use the following command to compile the programs and generate required input:
```
make
```

### Running program
You can use make to run the executable with the following command:
```
make run
```
Alternatively, you can manually run the program for the different input sets using the following commands:
```
./dilated_conv -i data/4096.in -k data/13.in
./dilated_conv -i data/8192.in -k data/64.in
./dilated_conv -i data/16384.in -k data/3.in
```
Note: the `-i` flag is for the input matrix and `-k` flag is for the kernel matrix.


## test

This directory contains a simple program to help you understand how the algorithm works. You can play around with the sizes of the Input-Matrix $(I)$ and Kernel-Matrix $(K)$ to get a flavor of how each cell of Output-Matrix $(O)$ is generated. A stripped output of test executable mentioned above for the example discussed is as follows:

![test_example_output](./docs/test_example.png)