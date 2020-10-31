function [newX, newY] = iterate(Ainv, x, y, Eext, gamma, kappa)

% Get fx and fy
% fx = conv2(Eext, [-1 1], 'same');
% fy = conv2(Eext, [-1; 1], 'same');
[fx, fy] = gradient(Eext);      % a more stable way

% Iterate
fxi = interp2(fx, x, y);
fyi = interp2(fy, x, y); 

newX = Ainv * (gamma * x' + kappa * fxi');
newY = Ainv * (gamma * y' + kappa * fyi');

points = [newX newY];

% Clamp points to be inside of image
index = 1;
while true
    if (index > size(points, 1))
        break
    else
       % 1 <= x <= col of image
       if (points(index, 1) < 1)
           points(index, 1) = 1;
       end
       if (points(index, 1) > size(fx, 2))
           points(index, 1) = size(fx, 2);
       end
       % 1 <= y <= row of image
       if (points(index, 2) < 1)
           points(index, 2) = 1;
       end
       if (points(index, 2) > size(fy, 1))
           points(index, 2) = size(fy, 1);
       end
    end
    index = index + 1;
end

% Concatenate the last point with the first point in the points
points(end, 1) = points(1, 1);
points(end, 2) = points(1, 2);

% assign the new value back to x & y
newX = points(:, 1)';
newY = points(:, 2)';

end

