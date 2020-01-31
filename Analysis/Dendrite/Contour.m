%% Retinotopy Analysis 
% contour lines

x = micronsSomaX;                                           % X-Range
y = micronsSomaY;                                           % Y-Range
[X,Y] = meshgrid(x,y);                                      % Create Matrix Arguments
figure(1)
[C,h] = contour(X, Y, theta < angle_rad+0.1 & theta > angle_rad-0.1 );
grid
Lvls = h.LevelList;
for k1 = 1:length(Lvls)
    idxc{k1} = find(C(1,:) == Lvls(k1));
    Llen{k1} = C(2,idxc{k1});
    conturc{k1,1} = C(:,idxc{k1}(1)+1 : idxc{k1}(1)+1+Llen{k1}(1)-1);
    conturc{k1,2} = C(:,idxc{k1}(2)+1 : idxc{k1}(2)+1+Llen{k1}(2)-1);
end
figure(2)
plot(conturc{1,1}(1,:), conturc{1,1}(2,:))
grid