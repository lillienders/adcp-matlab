%Brian Polagye
%June 14, 2010

%Description: routine to generate signed speed (flood positive) from time
%   series

function [s_signed_all] = sign_speed(u_all, v_all, s_all, dir_all, flood_heading)

%initialize signed magnitude
s_signed_all = NaN(size(s_all));

%generate signed speed
for i = 1:size(s_all,2)

    %determine signed speed
    u = u_all(:,i);     %u-component
    v = v_all(:,i);     %v-component
    dir = dir_all(:,i); %direction
    s = s_all(:,i);     %speed

    %determine principal axes - potentially a problem if axes are very kinked
    %   since this would misclassify part of ebb and flood
    [PA ~] = principal_axis(u, v);

    %sign speed - eliminating wrap-around
    dir_PA = dir - PA;

    dir_PA(dir_PA<-90) = dir_PA(dir_PA<-90) + 360;
    dir_PA(dir_PA>270) = dir_PA(dir_PA>270) - 360;

    %general direction of flood passed as input argument
    if PA >=flood_heading(1) && PA <=flood_heading(2)
        ind_fld = find(dir_PA >= -90 & dir_PA<90);
        s_signed = -s;
        s_signed(ind_fld) = s(ind_fld);
    else
        ind_ebb = find(dir_PA >= -90 & dir_PA<90);
        s_signed = s;
        s_signed(ind_ebb) = -s(ind_ebb);
    end
    
    s_signed_all(:,i) = s_signed;

end

end