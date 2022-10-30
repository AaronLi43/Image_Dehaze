clear

clc

close all

kenlRatio = .01;
minAtomsLight = 240;
% image_name =  'test images\21.bmp';

%image_name_list =  'img\input\';
% image_name = dir(strcat(image_name_list,'*.jpg'));
% img_num = length(image_name);
% I = cell(1, img_num);
% if img_num>0
%     for j = 1:img_num
%         name = image_name(j).name;
%         img_output = strcat('img\output\',name);
        img = imread('D:\Year4\First Half\DIP lab\P1\Dark channel prior (Matlab)\img\input\H1.jpg');
%img=imread(image_name);
figure,imshow(uint8(img)), title('src');

sz=size(img);

w=sz(2);

h=sz(1);

dc = zeros(h,w);

for y=1:h

    for x=1:w

        dc(y,x) = min(img(y,x,:));

    end

end


figure,imshow(uint8(dc)), title('Min(R,G,B)');

krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]))

dc2 = minfilt2(dc, [krnlsz,krnlsz]);%using Vanherk iterative algorithm to accelerate the calculation

dc2(h,w)=0;

figure,imshow(uint8(dc2)), title('After filter ');

t = 255 - 0.95*dc2;% 0.95 is the dehazing ratio, setting it as .95 rather than 1 can reduce the write block in the graph
figure,imshow(uint8(t)),title('t');

t_d=double(t)/255; %quantization

sum(sum(t_d))/(h*w)


A = min([minAtomsLight, max(max(dc2))])% set the minimal AL to make the dehazed picture more natural

J = zeros(h,w,3);

img_d = double(img);

J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;

J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;

J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

figure,imshow(uint8(J)), title('J');
%figure,imshow(rgb2gray(uint8(abs(J-img_d)))), title('J-img_d');
% a = sum(sum(rgb2gray(uint8(abs(J-img_d))))) / (h*w)
% return;
%----------------------------------
r = krnlsz*4
eps = 10^-6;

% filtered = guidedfilter_color(double(img)/255, t_d, r, eps);
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);% guilded filter to obtain a more precise image of transmission

t_d = filtered;

figure,imshow(t_d,[]),title('filtered t');

J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;

J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;

J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
% 

img_d(1,3,1)
%imwrite(uint8(J),'c:\11.bmp');
figure,imshow(uint8(J)), title('J_guild_filter');

%----------------------------------
% imwrite(uint8(J), img_output)
% 
%     end
% end