function [loc_min] = find_local_minimum(img, x, img_edge)
    loc_min = x;
    min_grad = realmax;
    no_edge = [];
    
    if img_edge(x(1), x(2))~=1
        no_edge = [no_edge; x(1) x(2)];
    end
    
    for i=(x(1)-1):1:(x(1)+1)
        for j=x(2)-1:1:x(2)+1
            c = img(i,j,1);
            cy = img(i+1,j,1);
            cx = img(i,j+1,1);
            
            grad = double(sqrt(double(power(c-cx,2) + power(c-cy,2))));
            if grad<min_grad && img_edge(i,j)~=1
                min_grad = grad;
                loc_min = [i j];
                no_edge = [no_edge; i j];
            end
        end
    end
    if img_edge(loc_min(1), loc_min(2)) == 1 && size(no_edge,1) ~= 0
        loc_min = no_edge(1,:);
    end
end
