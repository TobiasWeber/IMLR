
clear all
close all
clc

% load all problems file locations
problems = glob("~/octave/IMLR_implementation/graph_data_snap/*/*");

repetitions = 1;

test_problems(problems,1e6,repetitions);
