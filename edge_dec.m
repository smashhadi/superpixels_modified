I = imread('...\BSDS500\images\test\268074.jpg');
img = im2double(I);
cform = makecform('srgb2lab');
lab = applycform(img,cform);
[h,w,c] = size(img);
gray=rgb2gray(img);
BW1 = edge(gray,'zerocross');
BW2 = edge(gray,'log');
figure, imshow(BW1)
figure, imshow(BW2)
