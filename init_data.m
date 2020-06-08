function init_data(img, step, img_edge)
    global clusters distances centers center_counts
    
    [h,w,c] = size(img);
    clusters = zeros(h,w) - 1;
    distances = zeros(h,w) + realmax;   
    
    for j=step:step:(w-step/2) %should start  step/2
        for i = step:step:(h - step/2)
            if size(centers,1)==336
                k = 9;
            end
            x = find_local_minimum(img,[round(i) round(j)], img_edge);
            center = [double(img(x(1), x(2), 1)) double(img(x(1), x(2), 2)) double(img(x(1), x(2), 3)) x(1) x(2)];
            centers = [centers ; center];
        end
    end
    center_counts = zeros(size(centers,1),1);
end
