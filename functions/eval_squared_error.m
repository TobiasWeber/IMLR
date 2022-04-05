function result = eval_squared_error(slope, offset, x, y)
%function calculates the squared error between the linear trend and the x, y data.
%	Also works with vectorized (i.e matrix) input, gives vectorized output then, cols of x and y
%	are interpreted as data sets, if x or y have just one col it is used for all other cols of
%	the other data matrix. If infinities are present only non infinity values are considered

if any(any(x == inf)) || any(any(y == inf))

  y_infty_pattern = (y == inf);
  x_infty_pattern = (x == inf);
  possible_source_indices = all(bsxfun(@eq, y_infty_pattern, x_infty_pattern));

  result = inf(1,size(x,2));
  trend = bsxfun(@plus, bsxfun(@times, slope(possible_source_indices), x(not(y_infty_pattern),possible_source_indices)), offset(possible_source_indices));
  difference = bsxfun(@minus, y(not(y_infty_pattern)), trend);
  result(possible_source_indices) = sum(difference.*difference);

else

  trend = bsxfun(@plus, bsxfun(@times, slope, x), offset);
  difference = bsxfun(@minus, y, trend);
  result = sum(difference.*difference);

end

end

%!test
%! slope = [1,-5,7]; offset = [-5,33,51];
%! x=[1,2,3;4,5,6]; y=bsxfun(@plus, bsxfun(@times, slope, x), offset);
%! result = eval_squared_error(slope,offset,x,y);
%! assert(result, zeros(1,3))
