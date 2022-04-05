function [source, iterations, source_estimate, objective_values, distinguishing_set_found_in_iteration] = simple_algorithm(distances,oracle,test,caching,problem_nr,vertex_weights)
% usage: [source, iterations, source_estimate, objective_values, distinguishing_set_found_in_iteration] =
%        simple_algorithm(distances,oracle,test,caching,problem_nr,vertex_weights)
%
%   The simple algorithm function preforms a single source detection by iterative multiple linear regression.
%   The given graxph (represented by the shortest "distances"), is search by questioning the given "oracle"
%   about different nodes of the graph. The algorithm is terminated when the given termination "test" succeeds.
%   Other inputs are optional, on termination the estimated source and the number of iterations are returned.
%   Additionally source estimates and objective values in each iteration are given back as well as the iteratione
%   when an (affine) distinguishing set was encountered.

% deal with default arguments
if !exist("caching")
   caching = false;
   problem_nr = 0;
end

str_to_cache_file = ["../cache/_",num2str(problem_nr)];

if !exist("vertex_weights")
   vertex_weights = @() ones(length(distances),1);
end

if caching && exist(str_to_cache_file,'file')
  load(str_to_cache_file);
else
  disp('preparation...')
  [ ~, indices ] = min_variance_offset_pair(distances);
  if caching
    save(str_to_cache_file, "indices");
  end
end

timings = oracle(indices);
indices_excluded_from_questioning = indices;
source_estimate = [];
objective_values = [];
distinguishing_set_found = false;
distinguishing_set_found_in_iteration = inf;

debug = false;
output = false;

distinguishing_set_counter = 0;

disp("\n");
disp('start simple algorithm')
do
  if not(output)
    disp(['iteration: ',num2str(length(timings)+1)]);
  end

  % perform linear regression
  [slope, offset] = linear_regression(distances(indices,:),timings);
  squared_errors = eval_squared_error(slope, offset, distances(indices,:),timings);

  % prepare termination test
  [min_squared_error,current_source_estimate_idx] = min(squared_errors);
  t_sigma_est = sqrt(min_squared_error / max(1,(length(timings)-2)));
  velo_est = 1/max(1e-12,slope(current_source_estimate_idx));
  source_distances = min(distances(current_source_estimate_idx,:),distances(:,current_source_estimate_idx)');
  test_radius = max(1e-20,min(max(source_distances(source_distances<inf)),t_sigma_est*velo_est));
  indices_not_close_to_source = source_distances>=test_radius;
  min_squared_error_constrained = min(squared_errors(indices_not_close_to_source));

  % save source estimate hsitory
  source_estimate(end+1) = current_source_estimate_idx;
  objective_values(end+1,:) = squared_errors;
  
  if debug
    print_debug_info(squared_errors,distances,slope,offset,timings,...
indices,current_source_estimate_idx,min_squared_error,t_sigma_est,...
velo_est,test_radius,min_squared_error_constrained)
  end

  if output
    disp(['$',num2str(length(timings)+1),'$ & $',num2str(indices(end)),'$ & $',num2str(timings(end)),'$ & $',num2str(current_source_estimate_idx),'$ & $',num2str(min_squared_error),'$ & $',num2str(min_squared_error_constrained),'$ \\']);
  end

  % test for termination
  if test(min_squared_error,min_squared_error_constrained,length(timings))
    break;
  end

  % question oracle
  if not(distinguishing_set_found) && do_indices_distinguish_all_vertices(indices_excluded_from_questioning,distances)
    if not(output)
      disp('distinguishing set found');
    end
    distinguishing_set_found = true;
    distinguishing_set_found_in_iteration = length(timings)+1;
  end
  
  if length(indices_excluded_from_questioning) == length(distances)
    if not(output)
      disp('all vertices measured');
    end
    indices_excluded_from_questioning = [];
    distinguishing_set_counter++;
  end
  
  [~, oracle_index] = min_variance_offset(distances,indices,indices_excluded_from_questioning,vertex_weights(squared_errors));

  timings(end+1) = oracle(oracle_index);
  indices(end+1) = oracle_index;
  indices_excluded_from_questioning(end+1) = indices(end);

  if length(timings) > 1500
    debug = true;
    disp('debug enabled');
    pause();
  end

until false

source = current_source_estimate_idx;
iterations = length(timings);

end
