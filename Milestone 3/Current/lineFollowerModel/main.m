%% Define constants

% Group 28 - TRBMAT002 ; WTZMIC001

groupNumber = 28;


% Select track by entering number 1, 2, or 3 below:

% ==================================================

SELECT_TRACK = 1 ;

% ==================================================


switch SELECT_TRACK
    case 1
        % TRACK 1
        line_fn = @(x) cos(x) + x.^2/10 - 1;
        line_fn_deriv = @(x) -sin(x) + 2*x/10;
    case 2
        
        % TRACK 2
        line_fn = @(x) sin(x);
        line_fn_deriv = @(x) cos(x);
    case 3
        
        % TRACK 3
        line_fn = @(x) sin(x.^2/2 + 1) - sin(1);
        line_fn_deriv = @(x) cos(x.^2/2 + 1) .* x;
end

% Define constants for robot (such as gear ratio, etc)
define_constants;

%% simulation
% Simulate the robot
out = sim("lineFollowerModel");

%% animation
% Animate the simulation

% Set to true if you want to save the animation as a video
% titled "wheeled_robot.mp4".
write_video = false;

% only animate every nth data point (eg. every 10th one) to make this run
% faster
every_nth = 10;

anim_lineFollower(out, row1, W, xLp, yLp, Z, write_video, every_nth)

%% plot the inner left line sensor signal
% figure;
% plot(linspace(0, out.tout(end), length(out.lineSig1)), out.lineSig1);
% title("Inner Left line sensor signal");
% xlabel("Time [s]");
% ylabel("Sensor value");
% grid on;
% shg
%
% %% plot the inner right line sensor signal
% figure;
% plot(linspace(0, out.tout(end), length(out.lineSig2)), out.lineSig2);
% title("Inner Right line sensor signal");
% xlabel("Time [s]");
% ylabel("Sensor value");
% grid on;
% shg
%
% %% plot the outer left line sensor signal
% figure;
% plot(linspace(0, out.tout(end), length(out.lineSig3)), out.lineSig3);
% title("Outer Left line sensor signal");
% xlabel("Time [s]");
% ylabel("Sensor value");
% grid on;
% shg
%
% %% plot the outer right line sensor signal
% figure;
% plot(linspace(0, out.tout(end), length(out.lineSig4)), out.lineSig4);
% title("Outer Right line sensor signal");
% xlabel("Time [s]");
% ylabel("Sensor value");
% grid on;
% shg

% %% plot the centre line sensor signal
% figure;
% plot(linspace(0, out.tout(end), length(out.lineSig5)), out.lineSig5);
% title("Centre line sensor signal");
% xlabel("Time [s]");
% ylabel("Sensor value");
% grid on;
% shg
