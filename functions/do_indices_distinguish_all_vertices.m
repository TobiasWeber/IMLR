% function to decide if a set of vertices distinguishes all vertices from all sources
function indices_do_distinguish = do_indices_distinguish_all_vertices(indices,distances)
indices_do_distinguish = false;

if length(indices) == 1
   return;
end

for i=1:length(distances)
  timings = distances(indices,i);

  [slope, offset] = linear_regression(distances(indices,:),timings);
  squared_errors = eval_squared_error(slope, offset, distances(indices,:), timings);

  cutoff = min(squared_errors) + 1e-7;
  indices_do_distinguish = sum(squared_errors < cutoff) == 1;

  if !indices_do_distinguish
    return;
  end
end

end
