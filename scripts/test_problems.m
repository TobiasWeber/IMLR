function test_problems(problems,problem_number_offset,repetitions)

addpath("../functions/");

setup_environment();

if !exist("repetitions")
   repetitions = 1;
end

% save results in variables
iterations_of_problem = [];
distance_to_source = [];
velo_true = [];
offset_true = [];
origin_true = [];
problems_nr = [];
problem_size = [];
problem_edges = [];
problem_adj_diameter = [];
sigma_true = [];
component_number = [];
problem_name = [];
distinguishing_set_found_in_iteration = [];

% load an solve problems
for i = 1:numel(problems)
   if i<0
      continue;
   end
   if isempty(strfind(problems{i},'facebook'))
      %continue
   end


   disp(i);
   disp(problems{i});

   % load problem graph
   load(problems{i});

   if length(graph) > 1000
      disp('scip too large graph.');
      continue;
   end

   disp(['size of graph: ',num2str(length(graph))]);

   %% make problem (model)
   disp('prepare problem');

   % calculate shortest distances
   disp('calculate shortest distances');
   distances = Simple_Matrix_Multiplication_APSP_weighted(graph);

   tmp = repetitions;
   if not(isempty(strfind(problems{i},'deezer')))
      tmp = 1;
   end
   for j=1:tmp

      disp('repetition of problem:');
      disp(j);

      % make oracle handle
      exp_mean = 1.0;
      velocity_true = exprnd(exp_mean)
      %velocity_true = 0.5; % slope 2
      %offset = -1;
      standard_deviation = 10.0;
      offset =  normrnd(0.0,standard_deviation)
      %t_sigma_true = max(distances(~isinf(distances)))/(20.0*velocity_true);
      t_sigma_true = 1/(5*velocity_true);
      %t_sigma_true = exprnd(exp_mean)
      origin_idx_true = unidrnd(length(distances));
      oracle = @(idx) model (distances(idx, origin_idx_true), velocity_true, offset, t_sigma_true);

      % make test handle
      alpha = 0.05;
      test = @(obj_val1, obj_val2, iteration) f_test_heur (obj_val1, obj_val2, iteration-4, 1, alpha);

      % make vertex weight handle
      weights =@(objective_values) 1./(objective_values'+1);

      %% solve problem
      disp('solve problem');
      % start algorithm
      caching = true;
      problem_nr = problem_number_offset+i;
      [source_idx_estimate, iterations, estimate_in_iteration, objective_values, distiguishing_set_in_iteration] = simple_algorithm(distances,oracle,test,caching,problem_nr,weights);

      disp('distance to true source:');
      disp(distances(source_idx_estimate,origin_idx_true));

      iterations_of_problem(j,i) = iterations;
      distance_to_source(j,i) = distances(source_idx_estimate,origin_idx_true);
      velo_true(j,i) = velocity_true;
      offset_true(j,i) = offset;
      origin_true(j,i) = origin_idx_true;
      sigma_true(j,i) = t_sigma_true;
      number_of_nodes_worse_than_estimate_during_iterations{j,i} = sum(distances(:,origin_idx_true) > distances(origin_idx_true,estimate_in_iteration));
      number_of_nodes_better_than_estimate_during_iterations{j,i} = sum(distances(:,origin_idx_true) < distances(origin_idx_true,estimate_in_iteration));
      object_values_triple{j,i} = [min(objective_values,[],2), objective_values(:,origin_idx_true),max(objective_values,[],2)];
      distinguishing_set_found_in_iteration(j,i) = distiguishing_set_in_iteration;
   end
   problem_nr(i) = problem_nr;
   problem_size(i) = length(graph);
   problem_edges(i) = length([graph{:}]);
   problem_adj_diameter(i) = max(distances(~isinf(distances)));
   problem_name{i} = name;

end

% save results
time_and_date = ctime(time());
time_and_date = strrep(time_and_date, " ", "_");
time_and_date = strrep(time_and_date, ":", "..");
pos = strfind(problems{1},"graph_data_");
problem_set = problems{1}(pos+11:pos+14);
if  strcmp(problem_set(1:3),"col")
   problem_set =  problem_set(1:3);
end
result_file_name = ["results_",num2str(repetitions),"repetitions_",problem_set,"_problems_",time_and_date];
save(["../results/",result_file_name], "iterations_of_problem", "distance_to_source", "velo_true", "offset_true", "problem_nr", "origin_true"
,"sigma_true","problem_size","problem_edges","problem_adj_diameter","problem_name"
,"number_of_nodes_worse_than_estimate_during_iterations","number_of_nodes_better_than_estimate_during_iterations","object_values_triple"
,"distinguishing_set_found_in_iteration");

end

