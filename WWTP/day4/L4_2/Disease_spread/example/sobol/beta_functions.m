% Create beta distributions
clear all;
clc;
X = 0:.01:1;
b1 = betapdf(X,2,7);
plot(X,b1)

b2 = betacdf(X,2,7);
plot(X,b2);
