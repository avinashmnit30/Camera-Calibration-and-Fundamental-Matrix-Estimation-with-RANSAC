Name: Wei Yang Quek

In estimate_fundamental_matrix.m, you can toggle between the normalised algorithm and the original algorithm through setting the variable 'normalise' as 1 or 0 respectively.

For ransac_fundamental_matrix.m, you can set the a few variables.

The first set of variables are:
s: number of point correspondence to use as inputs for each test,
threshold: the threshold of which points can be considered as inlier
p: probability that at least one random sample is free from outlier and
e: outlier ratio.

These 4 variables can be edited to calculate N, the number of test that you want. Alternatively, you can set N explicitly by changing N from '0' to other positive values. To use the formula to calculate the number of tests that you want, just change N back to 0 again.

The next variable is matchCap, which limits the number of matches to show. The default is 30, to prevent over-cluttering, but can be set to whichever number you want. If matchCap is set to 0, the maximum number of matches is used. If it is set as any other positive values, the maximum value of either the number of matches or the value of matchCap is used.