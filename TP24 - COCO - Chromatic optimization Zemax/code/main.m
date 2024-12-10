result = get_RMS_Spot_Size;

params = load("scene_params.mat");
disp(params.parameters_scene.Readme)
object = params.parameters_scene.Distance;
n = size(object);
n = n(2);

dx = 25; %mm
pp = 5.6; %µm

threshold = pp * ones(size(object));

figure()
plot(object, result(2,:), 'red')
hold on
plot(object, result(3,:), 'green')
hold on
plot(object, result(4,:), 'blue')
hold on
plot(object, result(1,:), 'black')
hold on
plot(object, threshold, '--', 'Color', 'black')

legend('Red', 'Green', 'Blue', 'Pan', 'Pixel pitch');
title('RMS spot size of R,G,B channels with distance to camera');
xlabel('Distance to camera (mm)');
ylabel('RMS values(µm)');



R = result(2,:)<pp;
V = result(3,:)<pp;
B = result(4,:)<pp;
gdof = (sum(R(:) == 1) + sum(V(:) == 1) + sum(B(:) == 1) ) * dx;
%gdof = length(union(union(R,V),B)) * dx;
disp(gdof)





