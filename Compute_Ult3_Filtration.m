function Compute_Ult3_Filtration(dX,N,dim, string)
    import edu.stanford.math.plex4.*;
    
    T= max(max(dX))/2;
    
    % get a new ExplicitSimplexStream
    stream = api.Plex4.createExplicitSimplexStream(T);
    
    for i=1:N
        stream.addVertex(i,0);
    end
    
    for i=2:N
        for j=1:(i-1)
            stream.addElement([j,i],0);
        end
    end
    
    M=zeros(N,N,N);
    for i=1:(N-2)
        for j=(i+1):(N-1)
            for k=(j+1):N
                x= dX(i,j);
                y= dX(j,k);
                z= dX(k,i);
                aux=1;
                if (x>=y) && (y>=z)
                    aux= x-y;
                elseif (x>=z) && (z>=y)
                    aux= x-z;
                elseif (y>=x) && (x>=z)
                    aux= y-x;
                elseif (y>=z) && (z>=x)
                    aux= y-z;
                elseif (z>=x) && (x>=y)
                    aux= z-x;
                else
                    aux= z-y;
                end
    
                stream.addElement( [i,j,k], aux);
                M(i,j,k)= aux;
                M(i,k,j)= aux;
                M(j,i,k)= aux;
                M(j,k,i)= aux;
                M(k,i,j)= aux;
                M(k,j,i)= aux;
            end
        end
    end
    
    if( dim== 2 )
        S=zeros(4);
        for i=4:N
            for j=3:(i-1)
               for k=2:(j-1)
                   for l=1:(k-1)
                        S(1)=M(k,j,i);
                        S(2)=M(l,j,i);
                        S(3)=M(l,k,i);
                        S(4)=M(l,k,j);
                        stream.addElement( [i,j,k,l],max([S(1),S(2),S(3),S(4)]));
                   end
               end
            end
        end
    end
        
    
    
    
    stream.finalizeStream();
    
    %% Computing persistence
    if( dim== 1)
        max_dimension = 2;
    end
    if(dim== 2)
        max_dimension = 3;
    end
    max_filtration_value = T;
    num_divisions = 400;
    
    
    % get persistence algorithm over Z/2Z
    persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);
    
    % compute the intervals
    intervals = persistence.computeIntervals(stream);
    
    % create the barcode plots
    options.filename = string;
    options.max_filtration_value = max_filtration_value;
    options.max_dimension = max_dimension - 1;
    plot_barcodes(intervals, options);
    intervals
    
    
end

