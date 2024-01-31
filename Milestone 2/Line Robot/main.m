%% A possible workflow
% a 'cell' is defined as the code between %%
% if your cursor is in a cell, it should be highlighted yellow
% pressing 'ctrl+enter' will evaluate a cell

% One possible workflow would be to open the simulink model by double
% clicking "lineFollowerModel.lx" in the file explorer panel to the left,
% modify the model as needed (eg add a controller, etc) and then run the
% three cells below to observe whether it worked or not

%% define constants
% set your group number:
groupNumber = 28;

% and choose a line shape to follow:
line_fn = @(x) cos(x) + x.^2/10 - 1;
line_fn_deriv = @(x) -sin(x) + 2*x/10;

% line_fn = @(x) sin(x);
% line_fn_deriv = @(x) cos(x);

% line_fn = @(x) sin(x.^2/2 + 1) - sin(1);
% line_fn_deriv = @(x) cos(x.^2/2 + 1) .* x;

% this needs to be run once in the beginning. It defines constants in the
% robot (such as gear ratio, etc)
define_constants;

%% simulation
% next, simulate the robot. You can do that using the command below, or by
% opening simulink, clicking on the "SIMULATION" tab and clicking "Run"
out = sim("lineFollowerModel");

%% animation
% finally, if you want to see an animation of the simulation, run the line
% below. Look at the start of the anim_lineFollower.m file to get a better
% idea of how it works. Aside from just passing it the data needed to
% animate the robot, there are some useful flags you might want to use:

% set this variable to true if you want to save the animation as a video
% titled "wheeled_robot.mp4". The animation will run a bit slower, though
write_video = false;

% only animate every nth data point (eg. every 10th one) to make this run
% faster
every_nth = 10;
anim_lineFollower(out, row1, W, xLp, yLp, Z, write_video, every_nth)

%% plot the line sensor signal
figure;
plot(out.tout, out.lineSig);
title("Line sensor signal");
xlabel("Time [s]");
ylabel("Sensor value");
grid on;
shg
