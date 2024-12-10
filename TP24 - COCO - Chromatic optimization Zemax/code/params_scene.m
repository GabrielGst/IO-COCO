% Define a struct using the struct function
parameters_scene = struct('Readme', 'The objects varies in distance from 1 to 5 metters in front of the add_on by step of 2.5 cm.', 'Distance', 1000:25:5000);
save("scene_params.mat", "parameters_scene")