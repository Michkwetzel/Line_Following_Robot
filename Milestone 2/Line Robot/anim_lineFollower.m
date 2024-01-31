%% This function will animate the differential steered robot
% 17 July 2020

function anim_lineFollower(out, row1, W, xLp, yLp, zLp, write_video, every_nth)
close all;

wheelWidth = 0.05;
blockColour = 'c';

x = out.q(:,1);
y = out.q(:,2);
th = out.q(:,3);
phi1 = out.q(:,4);
phi2 = out.q(:,5);

if write_video
    writerObj = VideoWriter('wheeled_robot.mp4');
    open(writerObj);
end

% you don't really need to understand the code below

%% Draw Initial Block - Robot's body
% Calculate Rotation Matrix - from inertial to body
% Compute propagation of vertices and patches
for i_time = 1:length(th)
    
    RI_1 = RotZ(th(i_time));
    
    % Vertices
    temp = [x(i_time), y(i_time), 0] - (RI_1'*[2*row1, W, 0]'/2)';
    VertexData(:,:,i_time) = GeoVerMakeBlock(temp, RI_1', [2*row1,W,0.125]);
    [X,Y,Z] = GeoPatMakeBlock(VertexData(:,:,i_time));
    
    PatchData_X(:,:,i_time) = X;
    PatchData_Y(:,:,i_time) = Y;
    PatchData_Z(:,:,i_time) = Z;
end

%% Draw Wheel1
% Calculate Rotation Matrix - from inertial to body
% Compute propagation of vertices and patches
for i_time = 1:length(th)
    
    RI_1 = RotZ(th(i_time));
    % Determine wheel spoke pos
    R1_W = RotY(phi1(i_time));
    
    %Vertices - may need to change the height
    temp = [x(i_time), y(i_time), 0] - (RI_1'*[0,W+2*wheelWidth,-2*row1]'/2)';
    
    
    tempSpoke1(:,i_time) = temp'+ RI_1'*R1_W'*[row1,0,0]';
    tempHub1(:,i_time) = temp';
    
    Vertex1Data(:,:,i_time) = GeoVerMakeCyl( temp, RI_1'*R1_W', row1, wheelWidth );
    [X,Y,Z] = GeoPatMakeCyl(Vertex1Data(:,:,i_time));
    
    Patch1Data_X(:,:,i_time) = X;
    Patch1Data_Y(:,:,i_time) = Y;
    Patch1Data_Z(:,:,i_time) = Z;
    
    % Create wheel caps
    temp =  Patch1Data_X(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap1Data_X(:,i_time) = temp;
    temp =  Patch1Data_Y(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap1Data_Y(:,i_time) = temp;
    temp =  Patch1Data_Z(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap1Data_Z(:,i_time) = temp;

    % Create wheel caps
    temp =  Patch1Data_X(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap2Data_X(:,i_time) = temp;
    temp =  Patch1Data_Y(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap2Data_Y(:,i_time) = temp;
    temp =  Patch1Data_Z(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch1Cap2Data_Z(:,i_time) = temp;
end


%% Draw Wheel2
% Calculate Rotation Matrix - from inertial to body
% Compute propagation of vertices and patches
for i_time = 1:length(th)
    
    R1_W = RotY(phi2(i_time));
    RI_1 = RotZ(th(i_time));
    
    %Vertices - may need to change the height
    temp = [x(i_time), y(i_time), 0] - (RI_1'*[0,-W,-2*row1]'/2)';
    Vertex1Data(:,:,i_time) = GeoVerMakeCyl( temp, RI_1'*R1_W', row1, wheelWidth);
    [X,Y,Z] = GeoPatMakeCyl(Vertex1Data(:,:,i_time));
    
    tempSpoke2(:,i_time) = temp'+ RI_1'*R1_W'*[row1,0,0]';
    tempHub2(:,i_time) = temp';
    
    Patch2Data_X(:,:,i_time) = X;
    Patch2Data_Y(:,:,i_time) = Y;
    Patch2Data_Z(:,:,i_time) = Z;
    
    % Create wheel caps
    temp =  Patch2Data_X(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap1Data_X(:,i_time) = temp;
    temp =  Patch2Data_Y(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap1Data_Y(:,i_time) = temp;
    temp =  Patch2Data_Z(1:2,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap1Data_Z(:,i_time) = temp;
    
    % Create wheel caps
    temp =  Patch2Data_X(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap2Data_X(:,i_time) = temp;
    temp =  Patch2Data_Y(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap2Data_Y(:,i_time) = temp;
    temp =  Patch2Data_Z(3:4,:,i_time);
    temp =  reshape(temp,20*2,1);
    Patch2Cap2Data_Z(:,i_time) = temp;
end

%% PLOT
% Draw patches
figure(1);
ground.vertices=[10 -10 0; -10 -10 0; -10 10 0; 10 10 0]; %square
ground.faces=[1 2 3 4]; %connect vertices
hground = patch('Faces',ground.faces,'Vertices',ground.vertices,'FaceColor',[211,211,211]/255);
set(hground,'FaceLighting','phong','EdgeLighting','phong','FaceAlpha',0.5);
hold on;
h0 = patch(PatchData_X(:,:,1),PatchData_Y(:,:,1),PatchData_Z(:,:,1),'FaceColor',blockColour);
set(h0,'FaceLighting','phong','EdgeLighting','phong','FaceAlpha',0.8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%% WAS THIS (based on equation)
% draw the line on the floor
% plot(xL, line_fn(xL), 'k', 'LineWidth', 3);

% %%%%%%% WANT THIS (the actual Z matrix)
% figure;
idxs = find(zLp);  % nonzeros of Z
[Xp, Yp] = meshgrid(xLp, yLp);
Z2 = zLp;  % copy Z
Z2(idxs) = 0.0001;  % fill with a small number
scatter3(Xp(idxs), Yp(idxs), Z2(idxs), 3, 'k');
% idxs = find(Z);
% [Xp, Yp] = meshgrid(xLp, yLp);
% Z2 = Z;  % copy Z
% Z2(idxs) = 0.0001;
% scatter3(Xp(idxs), Yp(idxs), Z2(idxs), 3);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = patch(Patch1Data_X(:,:,1),Patch1Data_Y(:,:,1),Patch1Data_Z(:,:,1),'FaceColor','r');
set(h1,'FaceLighting','phong','EdgeLighting','phong','FaceAlpha',1,'EdgeColor','k');
h1_cap1 = patch(Patch1Cap1Data_X(:,1),Patch1Cap1Data_Y(:,1),Patch1Cap1Data_Z(:,1),'FaceColor','k');
h1_cap2 = patch(Patch1Cap2Data_X(:,1),Patch1Cap2Data_Y(:,1),Patch1Cap2Data_Z(:,1),'FaceColor','k');

h2 = patch(Patch2Data_X(:,:,1),Patch2Data_Y(:,:,1),Patch2Data_Z(:,:,1),'FaceColor','r');
set(h2,'FaceLighting','phong','EdgeLighting','phong','FaceAlpha',1,'EdgeColor','k');
h2_cap1 = patch(Patch2Cap1Data_X(:,1),Patch2Cap1Data_Y(:,1),Patch2Cap1Data_Z(:,1),'FaceColor','k');
h2_cap2 = patch(Patch2Cap2Data_X(:,1),Patch2Cap2Data_Y(:,1),Patch2Cap2Data_Z(:,1),'FaceColor','k');

hSpoke1 = animatedline('Color','r','LineWidth',1);
hSpoke2 = animatedline('Color','r','LineWidth',1);

FigHandle = gcf;
grid on
hold on;

xlabel({'X Position (m)'},'FontSize',14,'FontName','AvantGarde');
ylabel({'Y Position (m)'},'FontSize',14,'FontName','AvantGarde');
zlabel({'Z Position (m)'},'FontSize',14,'FontName','AvantGarde');

% Create title
title({'Awesome-O Robot'},'FontWeight','bold','FontSize',24,...
    'FontName','AvantGarde');

axis([-0.5 5.5 -2.5 2.5 -0.1 1.9])
camlight;
grid on;
view([30,45]);
set(FigHandle, 'Position', [100, 100, 1200, 800]);
%%{
for i = 1:every_nth:length(x)
    set(h0,'XData',PatchData_X(:,:,i));
    set(h0,'YData',PatchData_Y(:,:,i));
    set(h0,'ZData',PatchData_Z(:,:,i));
    set(h1,'XData',Patch1Data_X(:,:,i));
    set(h1,'YData',Patch1Data_Y(:,:,i));
    set(h1,'ZData',Patch1Data_Z(:,:,i));
    set(h2,'XData',Patch2Data_X(:,:,i));
    set(h2,'YData',Patch2Data_Y(:,:,i));
    set(h2,'ZData',Patch2Data_Z(:,:,i));
    set(h1_cap1,'XData',Patch1Cap1Data_X(:,i));
    set(h1_cap1,'YData',Patch1Cap1Data_Y(:,i));
    set(h1_cap1,'ZData',Patch1Cap1Data_Z(:,i));
    set(h1_cap2,'XData',Patch1Cap2Data_X(:,i));
    set(h1_cap2,'YData',Patch1Cap2Data_Y(:,i));
    set(h1_cap2,'ZData',Patch1Cap2Data_Z(:,i));
    
    set(h2_cap1,'XData',Patch2Cap1Data_X(:,i));
    set(h2_cap1,'YData',Patch2Cap1Data_Y(:,i));
    set(h2_cap1,'ZData',Patch2Cap1Data_Z(:,i));
    set(h2_cap2,'XData',Patch2Cap2Data_X(:,i));
    set(h2_cap2,'YData',Patch2Cap2Data_Y(:,i));
    set(h2_cap2,'ZData',Patch2Cap2Data_Z(:,i));
    
    addpoints(hSpoke1,[tempSpoke1(1,i) tempHub1(1,i)],[tempSpoke1(2,i) tempHub1(2,i)],[tempSpoke1(3,i) tempHub1(3,i)] );
    addpoints(hSpoke2,[tempSpoke2(1,i) tempHub2(1,i)],[tempSpoke2(2,i) tempHub2(2,i)],[tempSpoke2(3,i) tempHub2(3,i)] );

    drawnow;
    clearpoints(hSpoke1)
    clearpoints(hSpoke2)
    
    if write_video
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end

    xlim('manual')
    ylim('manual')
end

if write_video
    close(writerObj);
end
%%}
end

function rot = RotY(th)
    rot = [ cos(th) 0 -sin(th)
                  0 1        0
            sin(th) 0  cos(th)];
end

function rot = RotZ(th)
    rot = [ cos(th) sin(th) 0
           -sin(th) cos(th) 0
                  0       0 1];
end