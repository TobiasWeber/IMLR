function [distances] = Simple_Matrix_Multiplication_APSP_weighted(adjacency_list)

graph_size = numel(adjacency_list);

% cost matrix
distances = cost_from_adjacency_list( adjacency_list );

disp('start algorithm	');

% turn off broadcasting warnings
warning("off");

for i=1:graph_size
   disp(["iteration: ",num2str(i)]);
   
   % split calculations for big graphs, because octave seems to have (memory/index) problems otherwise
   distances_old = distances;
   tmp = reshape(distances_old,[1,size(distances_old)]);
   batch_size = 200;
   batches = ceil(graph_size/batch_size);
   batch_range = 0;
   for j=1:batches-1
      batch_range = (batch_size*(j-1)+1):batch_size*j;
      distances(:,batch_range) = reshape(min(distances_old+tmp(:,:,batch_range),[],2),graph_size,batch_size);
   end
   last_batch_index = batch_range(end);
   distances(:,last_batch_index+1:end) = reshape(min(distances_old+tmp(:,:,last_batch_index+1:end),[],2),graph_size,length(distances)-last_batch_index);

   if distances_old == distances
      break;
   end
end

end
