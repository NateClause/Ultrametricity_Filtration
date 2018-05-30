clc; clear; close all;
import edu.stanford.math.plex4.*;

N = 30;
[x,y] = ginput(N);

X= zeros(N,2);
X(:,1)= x;
X(:,2)= y;
dX=  L2_distance(X',X');
dim= 2;

f1= figure;
figure(f1);
scatter(X(:,1),X(:,2))

Compute_Ult3_Filtration(dX,N,dim, "Ult in disconnected components");


