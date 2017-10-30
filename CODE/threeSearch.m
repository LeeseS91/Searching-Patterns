function np = threeSearch(p,ss,object,boundary,i);
        ang = rand(1).*(2*pi);
        ang2 =  rand(1).*(2*pi);
        updatex = ss.*cos(ang).*sin(ang2);
        updatey = ss.*sin(ang).*sin(ang2);
        updatez = ss.*cos(ang2);
        np.x = p.x+updatex;
        np.y = p.y+updatey;
        np.z = p.z+updatez;
end