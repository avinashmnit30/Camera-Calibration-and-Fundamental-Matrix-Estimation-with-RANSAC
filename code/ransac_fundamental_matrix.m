% RANSAC Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

%number of matches to show
matchCap = 0;

N = 0;
% noOfPointCorr is the Number of Point Correspondence
s = 8;
%threshold of which points can be considered inliers
threshold = 0.005;
%p = Probability at least one random sample is free from outlier
p = 0.99;
%e = outlier ratio, i.e. the probability that a point is an outlier 
e = 0.6;

%N is the number of samples derived from #samples s to get a probability p
%that at least one random sample is free from outlier.

if N == 0
    N = log(1-p)/log(1-(1-e).^s);
end
noOfPossibleMatches = size(matches_a,1);

tempNoOfCorrectMatches = 0;
noOfCorrectMatches = 0;

indicesUsed = zeros(1,s);

tempCorrectMatchInd = [];
correctMatchInd = [];

for testNo=1:N
    
    %get 8 random indices
    ind = randperm(noOfPossibleMatches,s);
    %get fundamental matrix with the 8 random indices
    tempFMat = estimate_fundamental_matrix(matches_b(ind,:), matches_a(ind,:));
    
    %resetting temp values
    tempNoOfCorrectMatches = 0;
    tempCorrectMatchInd = [];
    
    %iterate through possible matches to find how many lie within threshold
    for i = 1:noOfPossibleMatches
        val = [matches_b(i,:) 1] * tempFMat * [matches_a(i,1); matches_a(i,2); 1];
        
        if abs(val) <= threshold
            tempNoOfCorrectMatches = tempNoOfCorrectMatches + 1;
            tempCorrectMatchInd = [tempCorrectMatchInd; i];
        end
    end
    
    %break if all FMatrix Matches match everything perfectly
    if tempNoOfCorrectMatches == noOfPossibleMatches
        noOfCorrectMatches = tempNoOfCorrectMatches;
        Best_Fmatrix = tempFMat;
        indicesUsed = ind;
        correctMatchInd = tempCorrectMatchInd;
        break;
    end

    if tempNoOfCorrectMatches > noOfCorrectMatches
        noOfCorrectMatches = tempNoOfCorrectMatches;
        Best_Fmatrix = tempFMat;
        indicesUsed = ind;
        correctMatchInd = tempCorrectMatchInd;
    end
end
disp('Test Completed.');
fprintf('s = %d, threshold = %d, p = %d, e = %d\n',s,threshold,p,e);
fprintf('#Times Run = %d, #Correct Matches = %d, Set of Indices Used = ',testNo, noOfCorrectMatches);
disp(indicesUsed);

if matchCap == 0 || matchCap>size(correctMatchInd,1)
    matchCap = size(correctMatchInd,1);
end

inliers_b = matches_b(correctMatchInd(1:matchCap),:);
inliers_a = matches_a(correctMatchInd(1:matchCap),:);

% %placeholders, you can delete all of this
% Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
% inliers_a = matches_a(1:30,:);
% inliers_b = matches_b(1:30,:);

end

