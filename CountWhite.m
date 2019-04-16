function [ ans ] = CountWhite( img )
[n,m]=size(img);
sum=0;
maxi=-1;
for i=1:n
    sum=0;
    for j=1:m
        if img(i,j)~=0
        sum=sum+img(i,j);
        end
    end
    if sum>maxi
        maxi=sum;
    end
end
ans=maxi;

end

