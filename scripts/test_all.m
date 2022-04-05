
clear all
close all
clc


repetitions = 1;

% load all problems file locations
problems = glob("~/octave/IMLR_implementation/graph_data_col/*");

test_problems(problems,1000,repetitions);


problems = glob("~/octave/IMLR_implementation/graph_data_snap/*/*");

test_problems(problems,1e6,repetitions);


problems = glob("~/octave/IMLR_implementation/graph_data_misc/*/*");

test_problems(problems,1e9,repetitions);
