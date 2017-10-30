% tf = OS_MM(r,N_object,moving,graphdraw,method)
ss = 0.1;
t_step = 5;
n_steps = 100000;

rad = linspace(0.1,1.5,100);

for i = 1:100
    for k = 1:1000
    for j = 1:9
        time_taken(k,j) = multiple_targets_NG(rad(i),1,0,j);
    end
    end
    ave_time(i,:) = sum(time_taken);
end