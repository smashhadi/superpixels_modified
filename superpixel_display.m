clc;
clear all;
close all;

img_root = 'C:\Users\SAYEMA\Documents\ECE613\Research\Testing code\BSDS500\images\train\';
des_root = 'C:\Users\SAYEMA\Documents\ECE613\Research\Code\SLIC Train results\';

img_root1 = strcat(img_root,'*.jpg');
list = dir(img_root1);

for i=1:size(list,1)
    img_name = fullfile(img_root,list(i).name);
    [filepath,name1,ext] = fileparts(img_name);
    img=imread(img_name);
    [L,N] = superpixels(img,250,'Compactness',40,'Method','slic');
    %figure(i)
    BW = boundarymask(L);
    %imshow(imoverlay(img,BW,'cyan'),'InitialMagnification',67)
    result = imoverlay(img,BW,'cyan');
    outputfilename = fullfile(des_root,list(i).name);
    imwrite(result, outputfilename, 'jpg');
end  
