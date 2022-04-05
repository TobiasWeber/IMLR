
clear all
close all
clc

% load all problems file locations
problems = glob("~/octave/IMLR_implementation/graph_data_misc/*/*");

repetitions = 1;

test_problems(problems,1e9,repetitions);
