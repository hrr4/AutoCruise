%% AutoCruise Test Case (Self-driving vehicle)
% Author: Jason Dempsey

% These values are modifiable and should affect the Fuzzy output of the
% system.
% Antecedents: Velocity, Sensor values
% Consequences: Acceleration

Vel = 26; %(m/s), 26 m/s ~ 60 mph
t = .016; % f = 60Hz, t = 1/60

% Velocity input
X0 = 10; %m/s ~25mph
% Sensor input
Y0 = 7; %m

% Should not modify below this line!

% Average acceleration of a car is ~3.5 m/s^2 (it's 3-4 usually)

% Calculate Sensor Values (Compensate range vs velocity)
Max_Range = 10; %(m)

C = Vel * t + Max_Range;

%% Antecedents (Inputs) (Velocity, Sensors)

Vel_Low  = [0; 0; Vel - Vel*.8; Vel-Vel*.5];
Vel_Med  = [Vel - Vel*.8; Vel - Vel*.5; Vel - Vel*.5; Vel];
Vel_High = [Vel-Vel*.5; Vel-Vel*.2; Vel; Vel];

Sens_High = [0; 0; C * (1/4); C * (2/4)];
Sens_Med = [C * (1/4); C * (2/4); C * (2/4); C * (3/4)];
Sens_Low = [C * (2/4); C * (3/4); Max_Range; Max_Range];

%% Consequences (Outputs) (Acceleration, Braking)
Accel_Low = [0; 0; .5; 1];
Accel_Med = [.5; 1.5; 1.5; 2];
Accel_High = [1.5; 2.5; 3.5; 3.5];

Brake_Low = Accel_Low;
Brake_Med = Accel_Med;
Brake_High = Accel_High;

%% Membership Functions
Vel_Step = .05;

Vel_A1 = Trapezoid(Vel_Low, Vel_Step);
Vel_A2 = Trapezoid(Vel_Med, Vel_Step);
Vel_A3 = Trapezoid(Vel_High, Vel_Step);

Sensor_Step = .001;

Sens_A4 = Trapezoid(Sens_Low, Sensor_Step);
Sens_A5 = Trapezoid(Sens_Med, Sensor_Step);
Sens_A6 = Trapezoid(Sens_High, Sensor_Step);

Accel_Step = .05;

Accel_C1 = Trapezoid(Accel_Low, Accel_Step);
Accel_C2 = Trapezoid(Accel_Med, Accel_Step);
Accel_C3 = Trapezoid(Accel_High, Accel_Step);

Brake_Step = .05;

Brake_C4 = Trapezoid(Brake_Low, Brake_Step);
Brake_C5 = Trapezoid(Brake_Med, Brake_Step);
Brake_C6 = Trapezoid(Brake_High, Brake_Step);

%% Firing Levels
% Velocity
VelSupports = {Support(Vel_Low, Vel_Step); ...
               Support(Vel_Med, Vel_Step); ...
               Support(Vel_High, Vel_Step)};

Vel_Ants = {Vel_A1.';Vel_A2.';Vel_A3.'};

Vel_alphas = FireLevels(VelSupports, Vel_Ants, X0);

% Sensors
SensSupports = {Support(Sens_Low, Sensor_Step); ...
                Support(Sens_Med, Sensor_Step); ...
                Support(Sens_High, Sensor_Step)};

Sens_Ants = {Sens_A4.';Sens_A5.';Sens_A6.'};

Sens_alphas = FireLevels(SensSupports, Sens_Ants, Y0);


%% Fuzzy Output
% Acceleration
Accel_Cons = {Accel_C1.';Accel_C2.';Accel_C3.'};

AccelSupports = {Support(Accel_Low, Accel_Step); ...
                 Support(Accel_Med, Accel_Step); ...
                 Support(Accel_High, Accel_Step)};

[FuzzAccel, Baccel, AccelUnionSupport] = FuzzOut(Accel_Cons, AccelSupports, Vel_alphas);

% Brake
Brake_Cons = {Brake_C4.';Brake_C5.';Brake_C6.'};

BrakeSupports = {Support(Brake_Low, Brake_Step); ...
                 Support(Brake_Med, Brake_Step); ...
                 Support(Brake_High, Brake_Step)};

[FuzzBrake, Bbrake, BrakeUnionSupport] = FuzzOut(Brake_Cons, BrakeSupports, Sens_alphas);

%% DeFuzzify
AccelCOG = DeFuzz(Baccel, AccelUnionSupport)
BrakeCOG = DeFuzz(Bbrake, BrakeUnionSupport)

%% Plots
% Antecedents
figure('Name', 'Antecedents Plots', 'NumberTitle', 'off');
subplot(2,1,1);

plot(Support(Vel_Low, Vel_Step), Vel_A1, 'green');
hold on;
plot(Support(Vel_Med, Vel_Step), Vel_A2, 'blue');
hold on;
plot(Support(Vel_High, Vel_Step), Vel_A3, 'red');
for i = 1:length(Vel_alphas)
   hold on;
   line(0, Vel_alphas(i), 'Marker', 'x');
end
title('(Antecedents w/ Firing Levels) Velocity');
legend('Low', 'Medium', 'High');


subplot(2,1,2);
plot(Support(Sens_Low, Sensor_Step), Sens_A4, 'green');
hold on;
plot(Support(Sens_Med, Sensor_Step), Sens_A5, 'blue');
hold on;
plot(Support(Sens_High, Sensor_Step), Sens_A6, 'red');
for i = 1:length(Sens_alphas)
   hold on;
   line(0, Sens_alphas(i), 'Marker', 'x');
end
title('(Antecedents w/ Firing Levels)s Front Diagonal Sensors');
legend('Low', 'Medium', 'High');

% Consequences
figure('Name', 'Consequences Plots', 'NumberTitle', 'off');
subplot(2,1,1);
plot(Support(Accel_Low, Accel_Step), Accel_C1);
hold on;
plot(Support(Accel_Med, Accel_Step), Accel_C2);
hold on;
plot(Support(Accel_High, Accel_Step), Accel_C3);
for i = 1:length(Vel_alphas)
   hold on;
   line(0, Vel_alphas(i), 'Marker', 'x');
end
title('(Consequences) Acceleration');
legend('Low', 'Medium', 'High');

subplot(2,1,2);
plot(Support(Brake_Low, Brake_Step), Brake_C4);
hold on;
plot(Support(Brake_Med, Brake_Step), Brake_C5);
hold on;
plot(Support(Brake_High, Brake_Step), Brake_C6);
for i = 1:length(Sens_alphas)
   hold on;
   line(0, Sens_alphas(i), 'Marker', 'x');
end
title('(Consequences) Brake');
legend('High', 'Medium', 'Low');

% Fuzzy Outputs
% Acceleration
figure('Name', 'Fuzzy Outputs', 'NumberTitle', 'off');
subplot(2, 1, 1);
if size(FuzzAccel, 1) >= 1
    plot(AccelSupports{1}, FuzzAccel(1, 1:length(AccelSupports{1})));
    hold on;
end
if size(FuzzAccel, 1) >= 2
    plot(AccelSupports{2}, FuzzAccel(2, 1:length(AccelSupports{2})));
    hold on;
end
if size(FuzzAccel, 1) >= 3
    plot(AccelSupports{3}, FuzzAccel(3, 1:length(AccelSupports{3})));
end

title('(Fuzzy Output) Acceleration');
legend('Low', 'Medium', 'High');

subplot(2,1,2);
plot(AccelUnionSupport, Baccel);
hold on;

% Plot COG
line(AccelCOG, 0:.05:1, 'Marker', '.');
title('(COG) Acceleration');

%Brake
figure('Name', 'Fuzzy Outputs', 'NumberTitle', 'off');
subplot(2, 1, 1);
if size(FuzzBrake, 1) >= 1
    plot(BrakeSupports{1}, FuzzBrake(1, 1:length(BrakeSupports{1})));
    hold on;
end
if size(FuzzBrake, 1) >= 2
    plot(BrakeSupports{2}, FuzzBrake(2, 1:length(BrakeSupports{2})));
    hold on;
end
if size(FuzzBrake, 1) >= 3
    plot(BrakeSupports{3}, FuzzBrake(3, 1:length(BrakeSupports{3})));
end

title('(Fuzzy Output) Brake');
legend('High', 'Medium', 'Low');

subplot(2,1,2);
plot(BrakeUnionSupport, Bbrake);
hold on;

% Plot COG
line(BrakeCOG, 0:.05:1, 'Marker', '.');
title('(COG) Brake');
