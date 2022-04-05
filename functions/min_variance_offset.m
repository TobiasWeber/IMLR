function [ variance, index, min_number_of_not_finite_values ] = min_variance_offset( distance_matrix, indices_already_questioned, indices_excluded_from_questioning, weights)
% usage: [ variance, index, min_number_of_not_finite_values ] = min_variance_offset( distance_matrix, indices_already_questioned, indices_excluded_from_questioning, weights)
%
% The function calculates the index that produces the minimal variance of the offset of a linear regression performed
% over already choosen locations and calculated index.
%	Calculation is averaged over all possible linear regressions, i.e. all vertices and can handle infinite distances and variance.

infty_pattern = (distance_matrix == inf);

if any(any(infty_pattern))

  [ variance, index, min_number_of_not_finite_values ] = do_min_variance_offset( infty_pattern, indices_already_questioned, indices_excluded_from_questioning, weights);

  min_variance_pattern = infty_pattern(index,:);
  possible_min_variance_indices = all(bsxfun(@eq, min_variance_pattern, infty_pattern)');
  if sum(possible_min_variance_indices) > 1
    tmp_indices = cumsum(possible_min_variance_indices).*possible_min_variance_indices;
    tmp_distances = distance_matrix(possible_min_variance_indices, min_variance_pattern == 0);
    tmp_indices_already_questioned = tmp_indices(indices_already_questioned);
    tmp_indices_excluded_from_questioning = tmp_indices(indices_excluded_from_questioning);
    [ variance, index, min_number_of_not_finite_values ] = do_min_variance_offset( tmp_distances, tmp_indices_already_questioned(tmp_indices_already_questioned>0), tmp_indices_excluded_from_questioning(tmp_indices_excluded_from_questioning>0), weights(min_variance_pattern == 0));
    index = find(index == tmp_indices);
  end
else
  [ variance, index, min_number_of_not_finite_values ] = do_min_variance_offset( distance_matrix, indices_already_questioned, indices_excluded_from_questioning, weights);
end

end

function [ variance, index, min_number_of_not_finite_values ] = do_min_variance_offset( distance_matrix, indices_already_questioned, indices_excluded_from_questioning, weights)

variance = inf;
min_number_of_not_finite_values = inf;
index = 0;

if isempty(indices_already_questioned)
   index = 1;
   return;
end

all_indices = 1:length(distance_matrix(:,1));
indices_to_question = setdiff(all_indices,indices_excluded_from_questioning);

if all(weights == 0)
   index = indices_to_question(1);
   return;
end

for i=indices_to_question
    distance_matrix_reduced=[distance_matrix(indices_already_questioned,:);distance_matrix(i,:)];
    % calculate the total variance
    number_of_not_finite_values = (~isfinite(meansq(distance_matrix_reduced)./var(distance_matrix_reduced)))*weights;
    variance_of_index = length(indices_already_questioned)*(meansq(distance_matrix_reduced(:,weights > 0))./var(distance_matrix_reduced(:,weights > 0)))*weights(weights > 0);

    if ~isfinite(variance_of_index) && ~isfinite(variance) && number_of_not_finite_values > 0 && number_of_not_finite_values < min_number_of_not_finite_values
        min_number_of_not_finite_values = number_of_not_finite_values;
        index = i;
    elseif variance_of_index < variance
        variance = variance_of_index;
        index = i;
    end
end

end
