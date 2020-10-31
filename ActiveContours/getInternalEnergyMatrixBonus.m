function [Ainv] = getInternalEnergyMatrix(nPoints, alpha, beta, gamma)

%     | 2*alpha+6*beta  -alpha-4*beta        beta            0           0              0    ...  beta  -alpha-4*beta |
%     | -alpha-4*beta   2*alpha+6*beta  -alpha-4*beta       beta         0              0    ...   0        beta      | 
% A = |      beta        -alpha-4*beta  2*alpha+6*beta  -alpha-4*beta   beta            0    ...   0         0        |
%     |      0               beta       -alpha-4*beta   2*alpha+6*beta  -alpha-4*beta  beta  ...   0         0        |
%     |     ...             ...             ...             ...         ...             ...  ...  ...       ...       |
% Start with the diagonal in the middle and work our way to the top right
% and botom left hand corners

XiMinus2 = beta;
XiMinus1 = -alpha - 4 * beta;
Xi = 2 * alpha + 6 * beta;
XiPlus1 = -alpha - 4 * beta;
XiPlus2 = beta;

% 2 * alpha + 6 * beta
A = diag(Xi * ones(1, nPoints), 0);

% -alpha - 4 * beta
A = A + diag(XiPlus1 * ones(1, nPoints - 1), 1);
A = A + diag(XiMinus1 * ones(1, nPoints - 1), -1);

% beta
A = A + diag(XiPlus2 * ones(1, nPoints - 2), 2);
A = A + diag(XiMinus2 * ones(1, nPoints - 2), -2);

% beta
A = A + diag(XiPlus2 * ones(1, 2), nPoints - 2);
A = A + diag(XiMinus2 * ones(1, 2), -(nPoints - 2));

% -alpha - 4 * beta
A = A + diag(XiPlus1 * ones(1, 1), nPoints - 1);
A = A + diag(XiMinus1 * ones(1, 1), -(nPoints - 1));

Ainv = inv(A + gamma * eye(nPoints));

end

