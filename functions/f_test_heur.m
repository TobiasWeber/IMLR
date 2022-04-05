function result = f_test_heur(squared_error,squared_error_constrained,degrees_of_freedom,number_of_constraints,confidence_level)

squared_error = max(squared_error,1e-20);
squared_error_constrained = max(squared_error_constrained,1e-20);

test_statistics = (squared_error_constrained-squared_error)*degrees_of_freedom/(squared_error*number_of_constraints);

cutoff_value = finv(1-confidence_level,number_of_constraints,degrees_of_freedom);

result = (test_statistics > cutoff_value);

end

