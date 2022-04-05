function print_debug_info(squared_errors,distances,slope,offset,timings,indices,current_source_estimate_idx,min_squared_error,t_sigma_est,velo_est,test_radius,min_squared_error_constrained)
    [a,b]=sort(squared_errors);
    sq_errors=a(1:min(end,10))
    source_estimates = b(1:min(end,10))
    dist=distances(current_source_estimate_idx,source_estimates)
    best_slopes = slope(source_estimates)
    best_offsets = offset(source_estimates)
    [timings,indices']
    disp(['estimated source idx: ',num2str(current_source_estimate_idx)]);
    disp(['min objective: ',num2str(min_squared_error)]);
    disp(['standard deviation: ',num2str(t_sigma_est)]);
    disp(['velocity estimate: ',num2str(velo_est)]);
    disp(['test radius: ',num2str(test_radius)]);
    disp(['min objective constrained: ',num2str(min_squared_error_constrained)]);
    disp('----------------------------------------------')
end
