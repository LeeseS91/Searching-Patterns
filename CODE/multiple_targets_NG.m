function tf = multiple_targets_NG(r,N_object,moving,method)
%If no variables use this
if nargin==0
    method=1; N_object = 5; r=1; moving = 1;
end

% Define the starting position
boundary = 5;       p.x = randi(boundary,1);        p.y = randi(boundary,1);    p.ang = 0;
p.n = 0;

for i = 1:N_object
    object.x(i) = randi([ceil(r).*boundary,floor(boundary-r).*boundary],1,1)./boundary;
    object.y(i) = randi([ceil(r).*boundary,floor(boundary-r).*boundary],1,1)./boundary;
    object.r(i) = r;
end

%Predfine the variables
ss = 0.1;       t_step = 1;     n_steps = 100000;       found = 0;      tf = n_steps;



for i = 1:t_step:n_steps
    ix = p.x;
    iy = p.y;
    if i==1
        start=[p.x p.y];
    end
    % Something sams doing
    locstorex(i)=p.x;
    locstorey(i)=p.y;
    % Use the chosen method to determine new position
    p = SearchMethod(p,ss,object,boundary,i,0,method,start,locstorex,locstorey);
    % CHeck it hasent passed the boundarys
    p = boundarys(p,boundary);
    [found,object] = o_goal(p,object,found);
    if found==N_object || i==n_steps;
        tf = (i);
        return
    end
    pstorex(i) = p.x;
    pstorey(i) = p.y;
    if moving == 1;
        object = movingTarget(object,p,ss,boundary);
        object = Aboundarys(object,boundary);
    end
    
end
end
function [found,object] = o_goal(p,object,found)
for i = 1:length(object.x)
    if (abs(p.x-object.x(i))<object.r(i))&&(abs(p.y-object.y(i))<object.r(i))
        found = found+ 1;
        object.x(i) = NaN;
        object.y(i) = NaN;
    else
        found = found+0;
    end
end
end
function p = boundarys(p,boundary)
if p.x>boundary
    p.x = p.x-boundary;
end
if p.y > boundary
    p.y = p.y-boundary;
end
if p.x<0
    p.x = p.x+boundary;
end
if p.y<0
    p.y = p.y+boundary;
end
end
function p = Aboundarys(p,boundary)
for i = 1:length(p.x)
    if p.x(i)>boundary
        p.x(i) = p.x(i)-boundary;
    end
    if p.y(i) > boundary
        p.y(i) = p.y(i)-boundary;
    end
    if p.x(i)<0
        p.x(i) = p.x(i)+boundary;
    end
    if p.y(i)<0
        p.y(i) = p.y(i)+boundary;
    end
end
end
function nobject = movingTarget(object,p,ss,boundary)
for i = 1:length(object.x)
    ang = rand(1).*(2*pi);
    updatex = ss.*cos(ang);
    updatey = ss.*sin(ang);
    
    nobject.x(i) = object.x(i)+updatex;
    nobject.y(i) = object.y(i)+updatey;
end
nobject = Aboundarys(nobject,boundary);
nobject.r = object.r;
end