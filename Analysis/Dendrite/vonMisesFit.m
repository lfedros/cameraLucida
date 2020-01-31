
%% segment analysis in V [axial theta]
load('theta.mat');
alpha = theta.theta_deg; % [deg]
alpha_rad = deg2rad(alpha); % [rad]
[thetahat, kappa] = circ_vmpar( alpha_rad ); % [von Mises parameters]
[p, ~] = circ_vmpdf( alpha_rad, thetahat, kappa ); % [von Mises pdf]

%%
fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

f = fit(alpha , p, 'smoothingspline'); % [spline fit]
h = plot(f);
set(h,'LineWidth',2)
hold on;
yyaxis right;
hist(alpha , 20);
h = findobj(gca,'Type','patch');
set(h,'facealpha',0.75);

% delete legend
legend('hide')

% axes labels
str = '$$ \theta $$';
xlabel(str, 'Interpreter', 'latex');
yyaxis left;
ylabel('p');
yyaxis right;
ylabel('counts', 'Rotation', 90);

%% box analysis in V [axial theta]
load('thetaBox.mat');
alpha = (thetaBox.theta_axial).*2; % [deg]
alpha_rad = deg2rad(alpha); % [rad]
[thetahat, kappa] = circ_vmpar( alpha_rad ); % [von Mises parameters]
[p, ~] = circ_vmpdf( alpha_rad, thetahat, kappa ); % [von Mises pdf]

%%
fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

f = fit(alpha , p, 'smoothingspline'); % [spline fit]
h = plot(f);
set(h,'LineWidth',2)
set(h,'Color', cell2mat(retino_tree.color(1)) );
hold on;
yyaxis right;
hist( thetaBox.theta_axial , 20);
h = findobj(gca,'Type','patch');
set(h,'facealpha',0.9);
set(h,'facecolor', 'black');

% delete legend
legend('hide')

% axes labels
str = '$$ \theta $$';
xlabel(str, 'Interpreter', 'latex');
yyaxis left;
ylabel('p');
yyaxis right;
ylabel('counts', 'Rotation', 90);


