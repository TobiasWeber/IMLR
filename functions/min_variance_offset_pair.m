function [ variance, indices ] = min_variance_offset_pair(distance_matrix)
% usage: [ variance, indices ] = min_variance_offset_pair(distance_matrix)
%
% The min_variance_offset_pair function calculates an index pair that produces the minimal variance of the offset of a linear regression performed
% just on the two indices.

variance = inf;
num_infties = inf;
indices = [0,0];

for i=2:length(distance_matrix(:,1))
    [variance_of_index,idx, number_infinities] = min_variance_offset(distance_matrix(1:i,:) , i,[], ones(length(distance_matrix),1));

    disp(i/length(distance_matrix(:,1)));  

    if variance_of_index < variance || number_infinities < num_infties
        num_infties = number_infinities;
        variance = variance_of_index;
        indices = [i,idx];
    end
end

end
