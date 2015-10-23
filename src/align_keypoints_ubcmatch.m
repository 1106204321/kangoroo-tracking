function [ X_n Y_n ] = align_keypoints_ubcmatch( I1,I2,bounds)
% number of keypoints we compare
m = 1000;
%ALIGN_KEYPOINTS_UBCMATCH Summary of this function goes here
%   Detailed explanation goes here
rect = [bounds(1) bounds(2) bounds(1)+bounds(3) bounds(2)+bounds(4)];
I1 = smoothen_image(I1);
[f1,d1] = vl_dsift(I1,'bounds',rect);

while size(f1,2) < m
    disp('bigger now')
    [x1 y1 w1 h1] = enlarge_rectangle(bounds(1), bounds(2), bounds(1)+bounds(3), bounds(2)+bounds(4), 0.1)
    rect = [x1 y1 w1 h1];
    [f1,d1] = vl_dsift(I1,'bounds',rect);
end

perm = randperm(size(f1,2));
index = perm(1:m);
f1 = f1(:,index);
d1 = d1(:,index);

% factor = 0.5;
% make window bigger
% [x2, y2, w2, h2] = enlarge_rectangle(x1, y1, w1, h1, factor);

[x2, y2, w2, h2] = enlarge_rectangle(bounds(1), bounds(2), bounds(1)+bounds(3), bounds(2)+bounds(4), 0.01);
I2 = smoothen_image(I2);
[f2,d2] = vl_dsift(I2,'bounds',[x2, y2, w2, h2]);


perm = randperm(size(f2,2));
index = perm(1:m);
f2 = f2(:,index);
d2 = d2(:,index);


[match,score] = vl_ubcmatch(d1,d2);
perm = randperm(size(match,2));

if length(perm)<50
    disp('object lost')
    perm = randperm(size(f1,2));
    sel = perm(1:50);
    X_o = f1(1,sel);
    Y_o = f1(2,sel);
    X_n = f2(1,sel);
    Y_n = f2(2,sel);
else
    sel = perm(1:50);

    match = match(:,sel);
    X_n = f2(1,match(2,:));
    Y_n = f2(2,match(2,:));
end


end