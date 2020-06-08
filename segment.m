function [segment] = segment(img,k)
global centers distances clusters center_counts new_clusters

img = im2double(img);
cform = makecform('srgb2lab');
lab = applycform(img,cform);

[h,w,c] = size(img);
nr_superpixels = k;
nc = 40;
step = round(sqrt(double((w * h) / nr_superpixels)));

gray=rgb2gray(img);
img_edge = edge(gray);
%img_edge = edge(gray,'canny');
generate_superpixels_edited(lab, step,nc,img_edge);
create_connectivity_edited(lab,img_edge,nc,step);

%generate_superpixels(lab, step,nc,img_edge);
%create_connectivity(lab);
segment = clusters;
%[l, Am, Sp, d] = slic(img, nr_superpixels, nc, 1.2);


end
