# IMLR
Iterative multiple linear regression

This octave implementation of the iterative multiple linear regression algorithm uses iterative linear regression to solve
single source detection problems on graphs.
Therefore iteratively an oracle is questioned about different graph vertices to estimate the source of the spreading process.

## Installation

This instruction assumes that you have an octave installation with the statistics package installed.
Then you can clone this repository and have a look at the scripts folder in which example simulations are performed for
user input graphs in an adjacency list format.

## Usage

To perform an simulation the test problems function can be called with one or more paths to saved problem files (containing the adjancency list).
Otherwise the simple algorithm function in the functions folder can be called directly, similar to the code in the test problems function.
