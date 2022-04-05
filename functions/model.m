function arrival_time = model(distance,velocity,initial_time,sigma_t)
if sigma_t > 0
  randomness = normrnd(0,ones(size(distance),1)*sigma_t);
else
  randomness = zeros(size(distance),1);
end
arrival_time = distance/velocity+initial_time;
arrival_time += randomness;
end
