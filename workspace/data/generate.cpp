#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char *argv[])
{
    int N; 
    if (argc < 2) 
        N = 8192;
    else 
        N = atoi(argv[1]); 
    ofstream output_file; 
    string file_name = "data/" + to_string(N) + ".in";  
    output_file.open(file_name); 

    // Set seed
    srand(1);
    
    // Output row and column of the matrix size
    output_file << N << "\n";
    output_file << N << "\n"; 
    // Generate matrix A
    for(int i = 0; i < N; ++i) {
        for(int j = 0; j < N; ++j)
            output_file << rand() % 256 << " ";
        output_file << "\n";
    }
    output_file.close(); 
    return 0; 
}
