function tf = multiple_targets(r,N_object,moving,graphdraw,method)
if nargin==0
    method=1; N_object = 5; graphdraw=1; r=0.1; moving = 1;
end
boundary = 5;
p.x = randi(boundary,1);
p.y = randi(boundary,1);
p.ang = 0;
for i = 1:N_object
    if rand <0.5
        object.x(i) = randi([ceil(r).*boundary,floor(boundary-r).*boundary],1,1)./boundary;
        object.y(i) = 0;
        object.ang(i) = 80.*(pi./180);
    else
        object.y(i) = randi([ceil(r).*boundary,floor(boundary-r).*boundary],1,1)./boundary;
        object.x(i) = 0;
        object.ang(i) = pi./18;
    end
    object.r(i) = r;
end
ss = 0.1;
t_step = 5;
n_steps = 100000;
found = 0;
tf = n_steps;
if graphdraw == 1
    figure;
    axes('XLim',[0 boundary],'YLim',[0 boundary]);
    for i = 1:N_object
        rectangle('Position', [(object.x(i)-r),(object.y(i)-r),2*r,2*r],'Curvature',[1 1],'FaceColor','r')
    end
end
for i = 1:t_step:n_steps
    ix = p.x;
    iy = p.y;
    
    if i==1
        start=[p.x p.y];
    end
    for j = 1:t_step;
        locstorex(i,j)=p.x;
        locstorey(i,j)=p.y;
        p = SearchMethod(p,ss,object,boundary,i,j,method,start,locstorex,locstorey);
        
        p = boundarys(p,boundary);
        [found,object] = o_goal(p,object,found,graphdraw);
        if found==N_object || i==n_steps;
            tf = (i+j);
            return
        end
        pstorex(j) = p.x;
        pstorey(j) = p.y;
        if moving == 1;
            object = movingTarget(object,p,ss,boundary);
        end
        if graphdraw == 1 && moving ==1
            for i = 1:length(object.x)
                if isnan(object.x(i)) == 0;
                    rectangle('Position', [(object.x(i)-object.r(i)),(object.y(i)-object.r(i)),(2*object.r(i)),(2*object.r(i))]...
                        ,'Curvature',[1 1],'FaceColor','r')
                    drawnow
                end
            end
        end
    end
    if graphdraw==1
        hold on
        plot(pstorex,pstorey,'bx');
        drawnow
    end
end
end
function [found,object] = o_goal(p,object,found,graphdraw)
for i = 1:length(object.x)
    if (abs(p.x-object.x(i))<object.r(i))&&(abs(p.y-object.y(i))<object.r(i))
        found = found+ 1;
        if graphdraw==1
            hold on
            plot(p.x,p.y,'cd','linewidth',10);
        end
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
%     ang = rand(1).*(2*pi);
    ang  = object.ang(i);
    updatex = ss.*cos(ang);
    updatey = ss.*sin(ang);
    
    nobject.x(i) = object.x(i)+updatex;
    nobject.y(i) = object.y(i)+updatey;
end
nobject = Aboundarys(nobject,boundary);
nobject.r = object.r;
nobject.ang = object.ang;
end