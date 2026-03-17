clc;
clear;
close all;
nn = 2;
areax = 10;
areay = 10;
x = rand(1, nn) * areax;
y = rand(1, nn) * areay;
figure;
scatter(x, y, 100, 'm', 'filled');
hold on;
grid on;
for i = 1:nn
    for j = i+1:nn
        plot([x(i) x(j)], [y(i) y(j)], 'b');
    end
end
title('Sensor Network');
xlabel('X-axis');
ylabel('Y-axis'); 
d = sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);
energy = 1; 
k = 0.02;             
E_tx = k * d;         
E_rx = 1;          
E1(i)=energy-E_tx;
E2(i)=energy-E_rx;


E1_remaining = energy - E_tx;
E2_remaining = energy - E_rx;
fprintf('Energy used by Node 1 (TX): %.2f J\n', E_tx);
fprintf('distance :%.2f \n',d);



