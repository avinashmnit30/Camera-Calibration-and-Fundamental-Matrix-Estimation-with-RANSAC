% Fundamental Matrix Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

normalise = 1;

noOfPts = size(Points_a,1);

%% Normalising of Coordinate (Extra Credit)
if normalise == 1

    %Mean Coordinates for Points a and b
    C1 = mean(Points_a);
    Cu1 = C1(1,1);
    Cv1 = C1(1,2);
    
    C2 = mean(Points_b);
    Cu2 = C2(1,1);
    Cv2 = C2(1,2);
    
    %Finding total Euclidean Distance of each point from Cu,Cv for each image
    dist1 = 0; dist2 = 0;
    for i = 1:noOfPts
        dist1 = dist1 + (Points_a(i,1)-Cu1)^2 + (Points_a(i,2)-Cv1)^2;
        dist2 = dist2 + (Points_b(i,1)-Cu2)^2 + (Points_b(i,2)-Cv2)^2;
    end
    %dist1/noOfPoints * s1 = 2; --> s1 = 2/(dist1/noOfPoints)
    avgsqdist1 = dist1/noOfPts;
    avgsqdist2 = dist2/noOfPts;
    
    %Finding scale transformation for point set a and b
    s1 = sqrt(2/(avgsqdist1));
    s2 = sqrt(2/(avgsqdist2));
    
    %Transformation Matrix for Set of Points A and B
    Ta = [s1 0 0;0 s1 0;0 0 1] * [1 0 -Cu1;0 1 -Cv1;0 0 1];
    Tb = [s2 0 0;0 s2 0;0 0 1] * [1 0 -Cu2;0 1 -Cv2;0 0 1];
        
    Points_a_T = zeros(noOfPts,2);
    Points_b_T = zeros(noOfPts,2);
    
    for i = 1:noOfPts
        
        pts1 = transpose(Ta * [Points_a(i,1); Points_a(i,2); 1]);
        Points_a_T(i,:) = pts1(1,1:2);
        
        pts2 = transpose(Tb * [Points_b(i,1); Points_b(i,2); 1]);
        Points_b_T(i,:) = pts2(1,1:2);
    end
    
    Points_a = Points_a_T;
    Points_b = Points_b_T;
        
end



%% Computation of Fundamental Matrix
A = ones(noOfPts,9);

for i=1:noOfPts
    
    u1 = Points_a(i,1);
    v1 = Points_a(i,2);
    u2 = Points_b(i,1);
    v2 = Points_b(i,2);

    A(i,:) = [u2*u1 u2*v1 u2 v2*u1 v2*v1 v2 u1 v1 1];
end

%Solving for f using Singular Vector Decomposition
[U, S, V] = svd(A);
f = V(:,end);
F = reshape(f, [3 3])';

%Resolving det(F) =0 constraint using SVD
[U, S, V] = svd(F);
S(3,3) = 0;
F_matrix= U*S*V';

if normalise == 1
    F_temp = F_matrix;
    F_matrix = transpose(Tb)*F_temp*Ta;
end

end

