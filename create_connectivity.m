function create_connectivity_edited(img, img_edge,nc,step)
    global centers clusters center_counts distances;
    label = [];
    adj_label = 0;
    [h,w,c] = size(img);
    
    lims = h*w/size(centers,1); 
    dx4 = [-1, 0, 1, 0];
    dy4 = [0, -1, 0, 1];
    
    center = size(centers,1);
    new_clusters = zeros(h,w) - 1;
    
    for i=1:h
        for j=1:w
            if clusters(i,j) == -1 && new_clusters(i,j) == -1 && img_edge(i,j) ~= 1
                center = center + 1;
                count = 1;
                m = 0;
                elements = [];
                elements = [elements; i j];
                new_clusters(i,j) = 0;
                clusters(i,j) = center;
                centers=[centers; img(i,j,1) img(i,j,2) img(i,j,3) i j];
                %while size(elements,1)~=0
                 while m<count
                     m = m+1;
                    for k = 1:4
                        y = elements(m,1) + dy4(k);
                        x = elements(m,2) + dx4(k);
                        
                        if y>0 && y<=h && x>0 && x<=w                        
                            if clusters(y,x) == -1 && new_clusters(y,x)== -1
                                elements = [elements; y x];
                                new_clusters(y,x) = 0;
                                count = count+1;
                                centers(center,:) = centers(center,:) + [img(y,x,1) img(y,x,2) img(y,x,3) y x];
                                clusters(y,x) = center;
                                
                            elseif clusters(y,x) ~= -1 && new_clusters(y,x) == -1                               
                                label = clusters(y,x);
                                new_clusters(y,x) = 0;                                
                            end
                        end
                    end
                end
                centers(center,:) = centers(center,:)/count;
                centers(center,4) = round(centers(center,4));
                centers(center,5) = round(centers(center,5));
                center_counts(center) = count;
                
                if count <= lims/8
                    for n = 1:count
                        clusters(elements(n,1),elements(n,2)) = label;
                        centers(label,:) = centers(label,:) + [img(elements(n,1),elements(n,2),1) img(elements(n,1),elements(n,2),2) img(elements(n,1),elements(n,2),3) elements(n,1) elements(n,2)];
                    end
                    centers(center,:) = [];
                    center_counts(center) = [];
                    center = center-1;
                end
                
           % go through all centers and find small ones. they should be
           % merged with nearest center
            elseif clusters(i,j) == -1 && img_edge(i,j)==1
                 for k = 1:4
                    y = i + dy4(k);
                    x = j + dx4(k);
                    
                    if y>0 && y<=h && x>0 && x<=w                        
                            if clusters(y,x) ~= -1
                                c = centers(clusters(y,x),:);
                                pixel = [img(i,j,1) img(i,j,2) img(i,j,3) y x];
                                
                                ds = double(sqrt(double(power(c(4)-y,2) + power(c(5)-x,2))));
                                dc = double(sqrt(double(power(c(1)-pixel(1),2) + power(c(2)-pixel(2),2) + power(c(3) - pixel(3),2))));

                                d = double(sqrt(double(power(ds/step, 2) + power(dc/nc,2))));

                                if d<distances(i,j)
                                    distances(i,j) = d;
                                    clusters(i,j) = clusters(y,x);
                                end
                            end
                    end
                 end
            end            
        end
    end
end
