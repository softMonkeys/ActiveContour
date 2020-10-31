clc;
clear;
close all;

% %% matrix
% A = [2 -3; 1 1];
% b = [1; 4];
% 
% V = inv(A) * b;
% % Or
% V = A\b;
% 
% %% u v w x y z
% A = [1 1 0 0 0 0; 
%     0 1 1 0 0 0; 
%     0 0 1 1 0 0;
%     0 0 0 1 1 0;
%     0 0 0 0 1 1;
%     -1 0 0 0 0 1;];
% b = [3; 5; 7; 9; 11; 5];
% V = A\b;
% 
% %% Conflict in b
% A = [1 1; 
%     1 1; 
%     1 0];
% b = [1; 2; 1];
% V = A\b;

%% Curve reconstruction from gradient domain
X = 1 : 100;
Y = sin(X .* X / 500);
figure;
plot(Y);
dY = Y(2 : 100) - Y(1 : 99);
figure;
plot(dY);
Y1 = Y(1);

A = zeros(100, 100);
b = zeros(100, 1);

% for each pixel
for i = 1 : 99
    A(i, i) = -1;
    A(i, i + 1) = 1;
    b(i) = dY(i);
end

% additional constraint
A(100, 1) = 1;
b(100) = Y1;

V = A \ b;

figure;
plot(V);



