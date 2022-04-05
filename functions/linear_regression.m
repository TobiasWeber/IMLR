function [slope, offset] = linear_regression(x, y)
% usage: [slope, offset] = linear_regression(x, y)
%
% The function calculates 1d linear trend to x, y data, minimising squared errors between trend and y data.
%	Also works with vectorized (i.e matrix) input, gives vectorized output then, cols of x and y
%	are interpreted as data sets, if x or y have just one col it is used for all other cols of
%	the other data matrix. If some x/y entries are infinite the calculation is performed on the 
%       subset of entries with mathing infinity pattern.

if any(any(x == inf)) || any(any(y == inf))

  slope = zeros(1,size(x,2));    
  offset = zeros(1,size(x,2));  

  y_infty_pattern = (y == inf);
  x_infty_pattern = (x == inf);
  possible_source_indices = all(bsxfun(@eq, y_infty_pattern, x_infty_pattern));
  if (sum(not(y_infty_pattern)) > 1)
    [slope(possible_source_indices), offset(possible_source_indices)] = do_regression(x(not(y_infty_pattern),possible_source_indices), y(not(y_infty_pattern)));
  elseif sum(not(y_infty_pattern)) == 1
    offset(possible_source_indices) = y(not(y_infty_pattern))';
  end

else

  [slope, offset] = do_regression(x, y);
  
end

end


function [slope, offset] = do_regression(x, y)

x_mean = mean(x);
y_mean = mean(y);

x_minus_x_mean = bsxfun(@minus, x, x_mean);

slope = max(1e-10,sum(bsxfun(@times, x_minus_x_mean, bsxfun(@minus, y, y_mean))) ./ sum(x_minus_x_mean.*x_minus_x_mean));
offset = y_mean - slope .* x_mean;

end

%!test
%! slope = [1,-5,7]; offset = [-5,33,51];
%! x=[1,2,3;4,5,6]; y=bsxfun(@plus, bsxfun(@times, slope, x), offset);
%! [calculated_slope,calculated_offset] = linear_regression(x,y);
%! negative_slope_index = find(slope<0);
%! offset(negative_slope_index) = mean(y(:,negative_slope_index));
%! assert([max(slope,0),offset], [calculated_slope,calculated_offset])
