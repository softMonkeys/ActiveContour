clc;
clear;
close all;

imgin = im2double(imread('./large1.jpg'));

if (ndims(imgin) == 3)
    imgin = rgb2gray(imgin);
end

[imh, imw, nb] = size(imgin);

assert(nb==1);
% the image is grayscale

% Initialize counter, A (sparse matrix) and b.
rows_i = zeros(1, 5 * imw * imh);
columns_j = zeros(1, 5 * imw * imh);
values_v = zeros(1, 5 * imw * imh);
b = zeros(imw * imh, 1);
lookUp = imgin(:);

% fill the elements in A and b, for each pixel in the image
topLeft = 1;
topRight = imw * imh - imh;
bottomLeft = imh;
bottomRight = imw * imh;
totalPixel = imw * imh;

for index = 1 : (imw * imh)
    % Four control points (top left, top right, bottom left and bottom right)
    if index == topLeft || index == topRight || index == bottomLeft || index == bottomRight
        rows_i(index) = index;
        rows_i(index + totalPixel) = index;
        rows_i(index + totalPixel * 2) = index;
        rows_i(index + totalPixel * 3) = index;
        rows_i(index + totalPixel * 4) = index;

        columns_j(index) = index;
        columns_j(index + totalPixel) = index;
        columns_j(index + totalPixel * 2) = index;
        columns_j(index + totalPixel * 3) = index;
        columns_j(index + totalPixel * 4) = index;

        % v = S
        values_v(index) = 1;
        values_v(index + totalPixel) = 0;
        values_v(index + totalPixel * 2) = 0;
        values_v(index + totalPixel * 3) = 0;
        values_v(index + totalPixel * 4) = 0;
        
        b(topLeft) = lookUp(topLeft) + 0;
        b(topRight) = lookUp(topRight) + 0;
        b(bottomLeft) = lookUp(bottomLeft) + 0;
        b(bottomRight) = lookUp(bottomRight) + 1;
        
    elseif (1 < index && bottomLeft > index) || (topRight < index && bottomRight > index)       % 2 edges on the left and right side of the image
        rows_i(index) = index;
        rows_i(index + totalPixel) = index;
        rows_i(index + totalPixel * 2) = index;
        rows_i(index + totalPixel * 3) = index;
        rows_i(index + totalPixel * 4) = index;

        columns_j(index) = index;
        columns_j(index + totalPixel) = index;
        columns_j(index + totalPixel * 2) = index;
        columns_j(index + totalPixel * 3) = index + 1;
        columns_j(index + totalPixel * 4) = index - 1;

        % 2 * v - v(x, y + 1) - v(x, y - 1) = S_down + S_up
        values_v(index) = 2;
        values_v(index + totalPixel) = 0;
        values_v(index + totalPixel * 2) = 0;
        values_v(index + totalPixel * 3) = -1;
        values_v(index + totalPixel * 4) = -1;
        
        b(index) = 2 * lookUp(index) - lookUp(index + 1) - lookUp(index - 1);
        
    elseif (mod(index, imh) == 1) || (mod(index, imh) == 0)     % 2 edges on the top and bottom of the image
        rows_i(index) = index;
        rows_i(index + totalPixel) = index;
        rows_i(index + totalPixel * 2) = index;
        rows_i(index + totalPixel * 3) = index;
        rows_i(index + totalPixel * 4) = index;

        columns_j(index) = index;
        columns_j(index + totalPixel) = index + imh;
        columns_j(index + totalPixel * 2) = index - imh;
        columns_j(index + totalPixel * 3) = index;
        columns_j(index + totalPixel * 4) = index;

        % 2 * v - v(x + 1, y) - v(x - 1, y) = S_right + S_left
        values_v(index) = 2;
        values_v(index + totalPixel) = -1;
        values_v(index + totalPixel * 2) = -1;
        values_v(index + totalPixel * 3) = 0;
        values_v(index + totalPixel * 4) = 0;
        
        b(index) = 2 * lookUp(index) - lookUp(index + imh) - lookUp(index - imh);
    else        % anything inside the edges
        rows_i(index) = index;
        rows_i(index + totalPixel) = index;
        rows_i(index + totalPixel * 2) = index;
        rows_i(index + totalPixel * 3) = index;
        rows_i(index + totalPixel * 4) = index;

        columns_j(index) = index;
        columns_j(index + totalPixel) = index + imh;
        columns_j(index + totalPixel * 2) = index - imh;
        columns_j(index + totalPixel * 3) = index + 1;
        columns_j(index + totalPixel * 4) = index - 1;

        % 4 * v - v(x, y + 1) - v(x, y + 1) - v(x + 1, y) - v(x - 1, y) = S_left + S_right + S_up + S_down
        values_v(index) = 4;
        values_v(index + totalPixel) = -1;
        values_v(index + totalPixel * 2) = -1;
        values_v(index + totalPixel * 3) = -1;
        values_v(index + totalPixel * 4) = -1;
        
        b(index) = 4 * lookUp(index) - lookUp(index + imh) - lookUp(index - imh) - lookUp(index + 1) - lookUp(index - 1);
    end
end

A = sparse(rows_i, columns_j, values_v); 
%use "lscov" or "\", please google the matlab documents
solution = A \ b;
error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);

imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);

