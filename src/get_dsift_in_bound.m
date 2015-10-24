function [ f,d ] = get_dsift_in_bound( I, bounds, m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

rect = [bounds(1) bounds(2) bounds(1)+bounds(3) bounds(2)+bounds(4)];
I = smoothen_image(I);
[f,d] = vl_dsift(I,'bounds',rect,'norm','fast');
numKeypointsFound = size(f,2);
if numKeypointsFound < m
    fprintf('> Not enough key points found: only %d key points found.',numKeypointsFound)
end

% plot_tmp(I1,f1(1,:),f1(2,:));

% get 50 points with most contrast. Approach failed because only a small
% part of image was chosen because contrast was highest there
% [~,index] = sortrows(f1',3);
% index = index(length(index)-m:end)';

% pick random key points
perm = randperm(size(f,2));
index = perm(1:m);


f = f(:,index);
d = d(:,index);

end
