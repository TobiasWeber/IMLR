function cost = cost_from_adjacency_list( adjacency_list )

graph_size = numel(adjacency_list);

cost = inf(graph_size,graph_size);

for i=1:graph_size
   if not(isempty(adjacency_list{i}))
      indices = adjacency_list{i}(1,:);
      if length(unique(indices)) ~= length(indices)
         disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
         disp('warning: non unique edge.');
         disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
         pause();
      end
      if size(adjacency_list{i},1) > 1
         weights = adjacency_list{i}(2,:);
      else
         weights = 1;
      end
      cost(i,indices) = weights;
   end
   cost(i,i) = 0;
end

end
