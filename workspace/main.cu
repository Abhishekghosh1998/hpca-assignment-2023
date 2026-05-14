#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <ctime>
#include <chrono>
#include <fstream>
#include <unistd.h>
using namespace std;

#include "gpu_thread.h"

// Used to cross-check answer. DO NOT MODIFY!
void reference( int input_row, 
                int input_col,
                int *input, 
                int kernel_row, 
                int kernel_col, 
                int *kernel,
                int output_row, 
                int output_col, 
                long long unsigned int *output ) 
{

    for(int i = 0; i < output_row * output_col; ++i)
        output[i] = 0;

    for(int output_i = 0; output_i< output_row; output_i++)
    {
        for(int output_j = 0; output_j< output_col; output_j++)
        {
            for(int kernel_i = 0; kernel_i< kernel_row; kernel_i++)
            {
                for(int kernel_j = 0; kernel_j< kernel_col; kernel_j++)
                {
                    int input_i = (output_i + 2*kernel_i) % input_row;
                    int input_j = (output_j + 2*kernel_j) % input_col;
                    output[output_i * output_col + output_j] += input[input_i*input_col +input_j] 
                                                                * kernel[kernel_i*kernel_col +kernel_j];
                }
            }
        }
    }
}

int main(int argc, char *argv[])
{
    // Define default file names
    string input_file_name = "data/128.in";
    string kernel_file_name = "data/64.in";

    // Parse command line arguments
    int opt;
    while ((opt = getopt(argc, argv, "hi:k:")) != -1) {
        switch (opt) {
            case 'h':
                std::cout << "Program expects two command line arguments:" << std::endl;
                std::cout << "  -i <input_file_name>: Name of the file for the input matrix" << std::endl;
                std::cout << "  -k <kernel_file_name>: Name of the file for the kernel matrix" << std::endl;
                std::cout << "If either of them is not mentioned, it takes the default as:" << std::endl;
                std::cout << "  - data/128.in for the input matrix" << std::endl;
                std::cout << "  - data/64.in for the kernel matrix" << std::endl;
                return 0;
            case 'i':
                input_file_name = optarg;
                break;
            case 'k':
                kernel_file_name = optarg;
                break;
            default:
                std::cerr << "Usage: " << argv[0] << " [-h] [-i <input_file_name>] [-k <kernel_file_name>]" << std::endl;
                return 1;
        }
    }

    // Print input and kernel file names
    std::cout << "Input file name: " << input_file_name << std::endl;
    std::cout << "Kernel file name: " << kernel_file_name << std::endl;

    int input_row, input_col, kernel_row, kernel_col;
    
    ifstream input_file; 
    input_file.open(input_file_name); 
    input_file >> input_row >> input_col;
    cout << "Input matrix dimensions : " << input_row <<"x"<<input_col<< endl;
    
    // Input matrix 
    int *input = new int[input_row * input_col];    
    for(int i = 0; i < input_row; ++i)
        for(int j = 0; j < input_col; ++j)
            input_file >> input[i * input_col + j];

    ifstream kernel_file; 
    kernel_file.open(kernel_file_name); 
    kernel_file >> kernel_row >> kernel_col;
    cout << "Kernel matrix dimensions : " << kernel_row <<"x"<<kernel_col<< endl;
    
    // Kernel matrix 
    int *kernel = new int[kernel_row * kernel_col];    
    for(int i = 0; i < kernel_row; ++i)
        for(int j = 0; j < kernel_col; ++j)
            kernel_file >> kernel[i * kernel_col + j];

    int output_row = input_row - kernel_row + 1;
    int output_col = input_col - kernel_col + 1;
    
    // Execute reference program
    long long unsigned int *output_reference = new long long unsigned int[output_row * output_col];
    reference(input_row, input_col, input, kernel_row, kernel_col, kernel, output_row, output_col, output_reference);    
    
    // Execute gpuThread
    long long unsigned int *output_gpu = new long long unsigned int[output_row * output_col];
    gpuThread(input_row, input_col, input, kernel_row, kernel_col, kernel, output_row, output_col, output_gpu);    
    
    for(int i = 0; i < output_row * output_col; ++i)
        if(output_gpu[i] != output_reference[i]) {
            cout << "Mismatch at " << i << "\n";
            cout << "GPU output: " << output_gpu[i] << ", required output: " << output_reference[i] << "\n";
            exit(0);
        }
    input_file.close();
    kernel_file.close(); 
    return 0;  
}
