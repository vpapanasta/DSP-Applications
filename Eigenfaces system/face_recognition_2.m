s=[];
sr=[];
k1=[];

for i=1:40
    k=fix(rand(1)*10+1);
    k1=[k1 k];
    for j=1:10
    str=['C:\Users\betty\Desktop\lab_07\orl_faces\s',int2str(i),'\',int2str(j),'.pgm'];
    sn=imread(str);
    sn=im2double(sn);
    sn=(sn);
    sn=sn(:);
        if j==k
        sr=[sr sn];
        else
        s=[s sn];
        end;     
    end;
end;


z=(1/360)*(sum(s(:)));
a=(s-z*ones(size(s)));
[u,g,v]=svds(a,40);

x=[];
y=[];
d=[];
xr=[];
yr=[];

for m=1:40
t1=u(:,1);
t2=u(:,2);
x1=t1*sr(m)';
y1=t2*sr(m)';
x=[x x1];
y=[y y1];
end;

d3=[];
for k=1:360
x2=t1*s(k)';
y2=t2*s(k)';
xr=[xr x2];
yr=[yr y2];
end;
g=[];
ll=[];
for b=1:10
    d1=abs(xr-(x(:,b)*ones(1,360)))+abs(yr-(y(:,b)*ones(1,360)))
    %d1=abs(sqrt((xr.^2-(x(:,b)*ones(1,360)).^2)+(yr.^2-(y(:,b)*ones(1,360).^2).^2)));
    %d1=abs(sqrt((xr-(x(:,b)*ones(1,360))).^2+(yr-(y(:,b)*ones(1,360)).^2)));
    for c=1:360
d2(c)=sum(d1(:,c));
g1=min(d2(c));
if d2(c)==g1
  l=c;
    end;
    end;
    ll=[ll l];
    g=[g g1];
    d=[d d2];
    pic1=reshape(s(:,l),112,92);
    pic2=reshape(sr(:,b),112,92);
    figure
    imshow([pic1  pic2])
    colormap('gray')
end;






