function [Eext] = getExternalEnergy(I,Wline,Wedge,Wterm)

% E_line        This energy is equal to the intensities of the image (the image itself ).
Eline = I;    

% E_edge        An edge in an image is a contour with a large image gradient.
[Gx, Gy] = imgradientxy(I);
Eedge = -1 * sqrt(Gx.^2 + Gy.^2);

% E_term        The curvature of the snake has to be taken into account in order to find corners.
%               This is done by using the first and second order derivatives of the image.
Cx = conv2(I, [-1 1], 'same');
Cxx = conv2(I, [1 -2 1], 'same');
Cy = conv2(I, [-1; 1], 'same');
Cyy = conv2(I, [1; -2; 1], 'same');
Cxy = conv2(I, [1 -1; -1 1], 'same');

Eterm = (Cyy .* Cx.^2 - 2 * Cxy .* Cx .* Cy + Cxx .* Cy.^2) ./ (1 + Cx.^2 + Cy.^2).^(3/2);

% E_ext
Eext = Wline * Eline + Wedge * Eedge + Wterm * Eterm;

end

