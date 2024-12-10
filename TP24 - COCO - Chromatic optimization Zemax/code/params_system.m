parameters_system = struct('Readme', 'The curvature radius varies between 10 and 100 000 mm by steps of 10 mm from 10 to 1000 mm, of 1000 mm from 1000 to 10 000 mm, of 10 000 mm from 10 000 to 100 000mm.', 'Radius', [10:10:1000,2000:1000:10000,20000:10000:100000]);
save("system_params.mat", "parameters_system")