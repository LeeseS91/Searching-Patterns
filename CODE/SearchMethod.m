function np = SMethod(p,ss,object,boundary,i,j,method,start,locstorex, locstorey)
t = i+j;
switch method
    
    % Completely Random walk
    case 1
        ang = rand(1).*(2*pi);
        updatex = ss.*cos(ang);
        updatey = ss.*sin(ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
        
        % Straight line grid search
    case 2
        loopcount=0;
        direct=1;
        while direct<5
            if direct==1
                ang=0;
            elseif direct==2
                ang=pi/2;
            elseif direct==3
                ang=pi;
            elseif direct==4
                ang=3*pi/2;
            end
            xpos=str2num(num2str(p.x+ss*cos(ang)));
            ypos=str2num(num2str(p.y+ss*sin(ang)));
            if length(locstorex)>100
                prevx=str2num(num2str(locstorex(end-100:end)));
                prevy=str2num(num2str(locstorey(end-100:end)));
            else
                prevx=str2num(num2str(locstorex));
                prevy=str2num(num2str(locstorey));
            end
            if max(max(ismember(prevx,xpos)+ismember(prevy,ypos)))>=2
                direct=direct+1;
            elseif loopcount>=10 %direct==5
                ang=randi(4);
                direct=6;
            elseif direct==5
                ang=0;
            else
                direct=6;
            end
        end
            updatex = ss.*cos(ang);
            updatey = ss.*sin(ang);
            np.x = p.x+updatex;
            np.y = p.y+updatey;
        
        
        %Diagonal Line grid search
    case 3
        ang=rand(1)*(pi/4);
        updatex = ss.*cos(ang);
        updatey = ss.*sin(ang);
        np.x = updatex+p.x;
        np.y = updatey+p.y;
        
        % Attempt at a star
    case 4
        t = i+j;
        
        if p.x>start(1)-0.3 && p.x<start(1)+0.3 && p.y>start(2)-0.3 && p.y<start(2)+0.3 && t>20
            np.ang=p.ang+pi/16;
        else
            np.ang=p.ang;
        end
        updatex = ss.*cos(np.ang);
        updatey = ss.*sin(np.ang);
        np.x = updatex+p.x;
        np.y = updatey+p.y;
        
        % Form of Levy Search
    case 5
        if rem(t,100)>80
            np.ang=p.ang;
        else
            np.ang = rand(1).*(2*pi);
        end
        updatex = ss.*cos(np.ang);
        updatey = ss.*sin(np.ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
        
        % Spiral
    case 6
        np.n=p.n;
        if rem(t,2000)==0
            np.n=(p.n)+1;
            t=t-(2000*np.n-1);
        else
            t=t-2000*np.n;
        end
        
        np.ang=p.ang+20*t*(pi/t^2);
        updatex = ss.*cos(np.ang);
        updatey = ss.*sin(np.ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
        
        % Random Grid search with minor previous location knowledge
    case 7
        direct=randi(4);
        loopcount=0;
        while direct<5
            if direct==1
                ang=0;
            elseif direct==2
                ang=pi/2;
            elseif direct==3
                ang=pi;
            elseif direct==4
                ang=3*pi/2;
            end
            xpos=str2num(num2str(p.x+ss*cos(ang)));
            ypos=str2num(num2str(p.y+ss*sin(ang)));
            if length(locstorex)>100
                prevx=str2num(num2str(locstorex(end-100:end)));
                prevy=str2num(num2str(locstorey(end-100:end)));
            else
                prevx=str2num(num2str(locstorex));
                prevy=str2num(num2str(locstorey));
            end
            if max(max(ismember(prevx,xpos)+ismember(prevy,ypos)))>=2
                direct=direct+1;
                %                 direct=randi(4);
                loopcount=loopcount+1;
            elseif loopcount>=10 %direct==5
                ang=randi(4);
                direct=6;
            elseif direct==5
                ang=randi(4);
            else
                direct=6;
            end
            updatex = ss.*cos(ang);
            updatey = ss.*sin(ang);
            np.x = p.x+updatex;
            np.y = p.y+updatey;
        end
        
        %Completely Random grid search
    case 8
        direct=randi(4);
        if direct==1
            ang=0;
            
        elseif direct==2
            ang=pi/2;
            
        elseif direct==3
            ang=pi;
            
        elseif direct==4
            ang=3*pi/2;
            
        end
        updatex = ss.*cos(ang);
        updatey = ss.*sin(ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
        
        % Spiral combined with Levy
    case 9
        np.n=p.n;
        if rem(t,300)==0
            np.n=(p.n)+1;
            t=t-(300*np.n-1);
        else
            t=t-300*np.n;
        end
        if rem(t,300)>280
            np.ang=p.ang;
        else
            np.ang=p.ang+10*t*(pi/t^2);
        end
        updatex = ss.*cos(np.ang);
        updatey = ss.*sin(np.ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
    
    % slowly rotating angle    
    case 10
        if rem(t,100)==50
            np.ang=p.ang+pi/32;
        else
            np.ang=p.ang;
        end
        updatex = ss.*cos(np.ang);
        updatey = ss.*sin(np.ang);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
end