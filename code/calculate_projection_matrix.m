% Projection Matrix Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% Returns the projection matrix for a given set of corresponding 2D and
% 3D points. 

% 'Points_2D' is nx2 matrix of 2D coordinate of points on the image
% 'Points_3D' is nx3 matrix of 3D coordinate of points in the world

% 'M' is the 3x4 projection matrix


function M = calculate_projection_matrix( Points_2D, Points_3D )

% To solve for the projection matrix. You need to setup a homogenous
% set of equations using the corresponding 2D and 3D points:

%                                                     [M11       [ u1
%                                                      M12         v1
%                                                      M13         .
%                                                      M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1          M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*Z1 -v1*Y1 -v1*Z1          M22         .
%  .  .  .  . .  .  .  .    .     .      .          *  M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn          M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Zn -vn*Yn -vn*Zn ]        M31         .
%                                                      M32         un
%                                                      M33         vn ]

% Then you can solve this using least squares with the '\' operator or SVD.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs.

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

%Ax=b form
M = zeros(3,4);
noOfPts = size(Points_2D,1);

A = zeros(noOfPts*2, 11);
b = zeros(noOfPts*2, 1);

for i= 1:noOfPts
   
   X = Points_3D(i,1);
   Y = Points_3D(i,2);
   Z = Points_3D(i,3);
   
   u = Points_2D(i,1);
   v = Points_2D(i,2);
   
%    fprintf('iteration %d, X = %d, Y = %d, Z = %d, u = %d, v = %d\n',i,X,Y,Z,u,v);
   
   A(2*i-1,:) = [X Y Z 1 0 0 0 0 -u*X -u*Y -u*Z];
   A(2*i,:) = [0 0 0 0 X Y Z 1 -v*X -v*Y -v*Z];
   
   b(2*i-1) = u;
   b(2*i) = v;
end


M = A\b;
M = [M;1];
M = reshape(M,[],3)';


end

