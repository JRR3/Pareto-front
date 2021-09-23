function pareto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Pareto example
%%%Javier Ruiz Ramírez
%%%September 23, 2021
%%%Simple example to illustrate the Pareto optimality concept.
%%%Input: None
%%%Ouput: Plot of non-dominated points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;

%Objetive functions
%Feel free to choose your own and experiment.
f1 = @(x,y) (x-5).^2 + (y-1).^2;
f2 = @(x,y) (x-1).^2 + (y-5).^2;

%Point evaluation
% fvec = @(x,y)[f1(x,y), f2(x,y)];
% fvec(5,3)
% fvec(6,4)

hold on;
dt = 0.1;
range = 0:dt:10;
[X,Y] = meshgrid(range);

z1 = f1(X,Y);
z2 = f2(X,Y);

%Unroll matrices
z1 = z1(:);
z2 = z2(:);

v = [z1,z2];

%Plot functional values
plot(z1,z2,'ko');
xlabel('f_1');
ylabel('f_2');
set(gca,'fontsize',18);
axis equal;

%%%Get the complement of the dominated points to get the non-dominated.
non_dom = ~get_dominated(v);

%%%How many non-dominated points do we have?
disp(['# of non-dominated points:', num2str(nnz(non_dom))]);

%If you want to display the non-dominated points with their corresponding
%functional values, uncomment the next line.
% Q = [X(dom),Y(dom),z1(dom),z2(dom)]

%Plot non-dominated points
plot(z1(non_dom),z2(non_dom),'bo','markerfacecolor','b')


function is_dominated = get_dominated(v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Function that identifies points that are dominated.
%%%Javier Ruiz Ramírez
%%%September 23, 2021
%%%Input: A matrix of size N x 2, where each row is the 
%%%functional value (f1(x),f2(x)).
%%%Output: Logical vector where the i-th entry is true if the i-th
%%%point was found to be dominated. Otherwise, the entry is false.
%%%Complexity: O(N^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = size(v,1);

%%%We start assuming all the points are non-dominated.
is_dominated = false(L,1);

for k = 1:L
    if is_dominated(k)
        %If this point is dominated, ignore it and try another one.
        continue
    end
    %Iterate over the remaining points
    %Compare the point v(k) with the point v(i)
    %Note that v(k) is fixed.
    for i = k+1:L
        if all(v(k,:) < v(i,:))
            %If v(k) dominates v(i), update the vector at (i).
            %Keep comparing v(k) against the remaining points. 
            is_dominated(i) = true;
        elseif all(v(i,:) < v(k,:))
            %If v(k) is dominated by v(i), update the vector at (k).
            %Terminate the inner loop and try with the next available point
            %to test if it is dominated.
            is_dominated(k) = true;
            break
        end
    end
end
