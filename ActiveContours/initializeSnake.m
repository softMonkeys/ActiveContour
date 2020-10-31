function [x, y] = initializeSnake(I)

% Show figure
imshow(I);
hold on;

% Get initial points
[x, y] = getpts();      % matlab helper function let user click anywhere on the figure

if (size(x, 1) < 2 || size(y, 1) < 2)
    error("point needs to be >= 2");
end

% Concatenate the last point with the first point in the cPoly
x(end + 1) = x(1);
y(end + 1) = y(1);

cPoly = [x y];      % save it to the control polygon
plot(cPoly(:,1), cPoly(:,2),'r-s', 'MarkerFaceColor', 'r');

hold on;

% Interpolate
interPoints = 200;
numberOfPoints = size(cPoly, 1);
sampleSpace = 1 : (numberOfPoints / interPoints) : numberOfPoints;

x = spline(1 : size(x, 1), x, sampleSpace);
y = spline(1 : size(y, 1), y, sampleSpace);

points = [x' y'];

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
       if (points(index, 1) > size(I, 2))
           points(index, 1) = size(I, 2);
       end
       % 1 <= y <= row of image
       if (points(index, 2) < 1)
           points(index, 2) = 1;
       end
       if (points(index, 2) > size(I, 1))
           points(index, 2) = size(I, 1);
       end
    end
    index = index + 1;
end

% Concatenate the last point with the first point in the points
points(end, 1) = points(1, 1);
points(end, 2) = points(1, 2);

% assign the new value back to x & y
x = points(:, 1)';
y = points(:, 2)';

plot(x, y, 'r');

end

