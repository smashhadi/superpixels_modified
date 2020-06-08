function image = generate_superpixels_edited(img, step, nc, img_edge)
    global NR_ITERATIONS;
    NR_ITERATIONS = 1;
    global clusters distances centers center_counts
    
    clusters =[];
    distances = [];
    centers = [];
    edge_pixels = [];
    init_data(img, step, img_edge)
    
    dx4 = [-1, 0, 1, 0];
    dy4 = [0, -1, 0, 1];
    for i=1:NR_ITERATIONS
        [h,w,c] = size(img);
        distances = zeros(h,w) + realmax;   
       
        for j=1:size(centers,1)
           %{ 
            edge_pixel = 1;
            
            a1 = centers(j,4) - step;
            a2 = centers(j,4) + step;
            b1 = centers(j,5) - step;
            b2 = centers(j,5) + step;
          
            for t = 0:step
                for t1 = (a1+t) : (a2-t)
                    if (t1 > 0) && (t1 <= h) && (b1 + t > 0) && (b2 - t <= w) && ((img_edge(t1, b1 + t) == 1) || (img_edge(t1, b2 - t) == 1))
                        edge_pixel = 1;
                        break;
                    end
                end
                for t1 = (b1+t) : (b2-t)
                    if (t1 > 0) && (t1 <= w) && (a1 + t > 0) && (a2 - t <= h) && ((img_edge(a1 + t, t1) == 1) || (img_edge(a2 - t, t1) == 1))
                        edge_pixel = 1;
                        break;
                    end
                end
                if edge_pixel == 1;
                    break;
                end
            end
            
            if edge_pixel == 0
                for k=(centers(j,4) - step):1:(centers(j,4) + step)
                    for l=(centers(j,5) - step):1:(centers(j,5) + step)
                        if k>0 && k<=h && l>0 && l<=w

                            pixel = img(k,l,:);
                            center = centers(j,:);

                            ds = double(sqrt(double(power(center(4)-k,2) + power(center(5)-l,2))));
                            dc = double(sqrt(double(power(center(1)-pixel(1),2) + power(center(2)-pixel(2),2) + power(center(3) - pixel(3),2))));

                            d = double(sqrt(double(power(ds/step, 2) + power(dc/nc,2))));

                            if d<distances(y,x)
                                distances(y,x) = d;
                                clusters(y,x) = j;
                            end
                        end

                    end
                end
               
            else                
            %}    
           
                window = zeros(size(centers(j,4) - step:centers(j,4) + step-1,2),size(centers(j,5) - step:centers(j,5) + step-1,2));
                %dx4 = [-1, 0, 1, 0];
                %dy4 = [0, -1, 0, 1];
                %dx8 = [-1 -1 0 1 1 1 0 -1];
                %dy8 = [0 -1 -1 -1 0 1 1 1];
                Q =[];
                
                Q = [centers(j,4) centers(j,5)];          
                window(step,step) = 1;
               clusters(centers(j,4), centers(j,5)) = j;
               distances(centers(j,4), centers(j,5)) = 0;
                while size(Q,1)~=0
                %{     
                for k = 1:4
                    y = Q(1,1) + dy4(k);
                    x = Q(1,2) + dx4(k);
                %}
                    
                    for k=1:4
                        x = Q(1,2) + dx4(k);
                        y = Q(1,1) + dy4(k);
                        
                        m = y-(centers(j,4)-step);
                        n = x-(centers(j,5)-step);
                        
                        if m>0 && m<=2*step && n>0 && n <= 2*step && window(m ,n) ~= 1 && x >0 && x<=w && y>0 && y<=h 
                            window(m,n) = 1;
                            if img_edge(y,x) ~= 1
                                
                                Q = [Q; y x];

                                pixel = img(y,x,:);
                                center = centers(j,:);

                                ds = double(sqrt(double(power(center(4)-y,2) + power(center(5)-x,2))));
                                dc = double(sqrt(double(power(center(1)-pixel(1),2) + power(center(2)-pixel(2),2) + power(center(3) - pixel(3),2))));

                                d = double(sqrt(double(power(ds/step, 2) + power(dc/nc,2))));

                                if d<distances(y,x)
                                    distances(y,x) = d;
                                    if clusters(y,x)~=-1
                                        center_counts(clusters(y,x)) = center_counts(clusters(y,x)) -1;
                                    end
                                    clusters(y,x) = j;
                                    center_counts(j) = center_counts(j) + 1;
                                end
                                %{
                            else
                                edge_pixels = [edge_pixels; y x];
                                %}
                            end
                        end
                                    
                     end
                     Q(1,:) = [];        
                end
            end                 
       % end
        %{
        for a=1:h
            for b=1:w
                if img_edge(a,b) == 1 && clusters(a,b)==-1
                     for k = 1:4
                        y = a + dy4(k);
                        x = b + dx4(k);

                        if y>0 && y<=h && x>0 && x<=w 
                            if clusters(y,x)~=-1
                                cen = centers(clusters(y,x),:); 
                                dc = double(sqrt(power(img(a,b,1)-cen(1),2)+power(img(a,b,2)-cen(2),2)+power(img(a,b,3)-cen(3),2))); 
                                ds = double(sqrt(power(cen(4)-a,2)+power(cen(5)-b,2)));
                                d = double(sqrt(power(ds/step,2)+power(dc/nc,2)));
                                
                                if(d < distances(a,b))
                                    clusters(a,b) = clusters(y,x);
                                    distances(a,b) = d;
                                end
                            end
                        end
                     end
                end
            end
        end
        
        
        %}
       %{
       while size(edge_pixels,1)~=0
           neighbours=[];
           for k = 1:4
                y = edge_pixels(1,1) + dy4(k);
                x = edge_pixels(1,2) + dx4(k);
               if x >0 && x<=w && y>0 && y<=h    
                    if clusters(y,x)~=-1
                        neighbours = [neighbours clusters(y,x)];
                    end
               end    
           end
            if size(neighbours,1)~=0
                    clusters(edge_pixels(1,1),edge_pixels(1,2)) = mode(neighbours);
            end
            edge_pixels(1,:) = [];
       end
       %}
       
       %{
       centers = zeros(size(centers,1), size(centers,2));
        center_counts = zeros(size(centers,1),1);
        for k=1:h
            for l=1:w
                c_id = clusters(k,l);
                 if c_id ~= -1 
                     colour = img(k, l,:);
                    
                    centers(c_id,1) = centers(c_id,1) + colour(1);
                    centers(c_id,2) = centers(c_id,2) + colour(2);
                    centers(c_id,3) = centers(c_id,3) + colour(3);
                    centers(c_id,4) = centers(c_id,4)+ k;
                    centers(c_id,5) = centers(c_id,5) + l;
                    
                    center_counts(c_id) = center_counts(c_id) + 1;
                 end
            end
        end
        
        for j =1:size(centers,1)
            centers(j,1) = round(double(centers(j,1)/center_counts(j)));
            centers(j,2) = round(double(centers(j,2)/center_counts(j)));
            centers(j,3) = round(double(centers(j,3)/center_counts(j)));
            centers(j,4) = round(double(centers(j,4)/center_counts(j)));
            centers(j,5) = round(double(centers(j,5)/center_counts(j)));
        end
       
       %}
    end
end
