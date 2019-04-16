img = imread('IMG_1398.jpg');

img = imresize(img,[512 1024]);

img=rgb2gray(img);

tmp=img;
img = edge(img,'roberts');
img=bwareaopen(img,10);



se=strel('cube',125);
img=imdilate(img,se);   

[L,num] = bwlabel(img);
box=regionprops(L,'Area', 'BoundingBox'); 

maxi_area=-1;
idx_of_max=0;
for k = 1:numel(box)
    if maxi_area<box(k).Area
        maxi_area=box(k).Area;
        idx_of_max=k;
    end
end

img=bwareaopen(img,maxi_area);

xs=box(idx_of_max).BoundingBox(1)-0.5;
ys=box(idx_of_max).BoundingBox(2)-0.5;

xe=xs+box(idx_of_max).BoundingBox(3);
ye=ys+box(idx_of_max).BoundingBox(4);

%cropped_image = tmp(xs:xe,ys:ye,:);
cropped_image = imcrop(tmp,[xs,ys,xe,ye]);
cropped_image = imresize(cropped_image,[512 1024]);

img=cropped_image;

T = adaptthresh(img,0.5,'ForegroundPolarity','dark');
img = imbinarize(img,T);
img=~img;

img=bwareaopen(img,10);
img = imresize(img,[512 1024]);

se=strel('cube',125);
img=imdilate(img,se); 
%figure,imshow(img);

%start
[L,num] = bwlabel(img);
box=regionprops(L,'Area', 'BoundingBox'); 

maxi_area=-1;
idx_of_max=0;
for k = 1:numel(box)
    if maxi_area<box(k).Area
        maxi_area=box(k).Area;
        idx_of_max=k;
    end
end

img=bwareaopen(img,maxi_area);

xs=box(idx_of_max).BoundingBox(1)-0.5;
ys=box(idx_of_max).BoundingBox(2)-0.5;

xe=xs+box(idx_of_max).BoundingBox(3);
ye=ys+box(idx_of_max).BoundingBox(4);

%cropped_image = tmp(xs:xe,ys:ye,:);
cropped_image = imcrop(cropped_image,[xs,ys,xe,ye]);

img=cropped_image;
T = adaptthresh(img,0.5,'ForegroundPolarity','dark');
img = imbinarize(img,T);
img=~img;
img=bwareaopen(img,10);

%end

%img=cropped_image;
[n,m]=size(img);
Last=-1;
angle=0;
%img = imrotate(img,-5);
se=strel('square',2);
img=imerode(img,se); 

for i=0:360
    tmp = imrotate(img,i);
    res=CountWhite(tmp);
    if res>=Last
       Last=res; 
       angle=i;
    end

end
disp(angle);
img = imrotate(img,angle);

%Staaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaartttttttttt
img=bwareaopen(img,30);

lines=0;
word=0;
char=0;

flag=0;
s=0;
e=0;
max=0;
min=1000;
for i=1:n
    sum=0;
    
    for j=1:m
        sum=sum+img(i,j);
    end
    if sum~=0 
        if flag==0
            s=i;
            flag=1;
        end   
    else
        if flag==1
            e=i; 
            flag=0;
            if e-s>0
            lines=lines+1;
            flag2=0;
            sb=0;
            eb=0;
            space=0;
                for K=1:m
                    sum_ver=0;
                    for l=s:e
                        sum_ver=sum_ver+img(l,K);
                    end
                    if sum_ver>0
                        flag2=1;
                        if sb~=0
                            eb=K;
                            space=eb-sb;
                            if space>max
                               max=space; 
                            end
                            if space<min
                                min=space;
                            end
                            if space>(max+min)/3
                                word=word+1;
                            end
                            eb=0;
                            sb=0;
                        end
                    end
                      if sum_ver==0 && flag2==1
                          char=char+1;
                          flag2=0;
                          sb=K;
                      end
                end
            end
         end           
    end
end
[a,b]=bwlabel(img);
word=word+lines;
disp(lines);
disp(word);
disp(char);
disp(b);
box=regionprops(a,'Area', 'BoundingBox'); 
mat=zeros(size(img));
figure, imshow(img), hold on
for k = 1 : numel(box)
  rectangle('Position', box(k).BoundingBox,'EdgeColor','r');
end

%figure,imshow(img);
