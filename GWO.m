function offpop = GWO(subpop, NS, lu, n, a, Alpha_pos, Beta_pos, Delta_pos)

offpop = [];
subpop = reshape(subpop, 2, NS)';

for i = 1 : NS %1:15

%     The following section describes the original GWO process.

%     % Choose the indices for mutation
%     indexSet = 1 : NS;
%     indexSet(i) = [];%15 times to input the U to offpop
% 
%     % Choose the first Index
%     temp = floor(rand * (NS - 1)) + 1;%random integer 1~15
%     nouse(1) = indexSet(temp);
%     indexSet(temp) = [];
% 
%     % Choose the second index
%     temp = floor(rand * (NS - 2)) + 1;
%     nouse(2) = indexSet(temp);
% 
%     % subpopsizetate
%     V = subpop(i, : ) + F .* (subpop(nouse(1), : ) - subpop(nouse(2), : ));
% 
%     % Handle the elements of the vector which violate the boundary
%     vioLow = find(V < lu(1, : ));  
%     V(1, vioLow) = lu(1, vioLow);%velocity boundary is the same with position???
%         
%     vioUpper = find(V > lu(2, : ));
%     V(1, vioUpper) =  lu(2, vioUpper);
%     
%     % Implement the binomial crossover
%     jRand = floor(rand * n) + 1;%random integer 1~15
%     t = rand(1, n) < CR;
%     t(1, jRand) = 1;
%     t_ = 1 - t;
%     U = t .* V + t_ .* subpop(i,  : );
    
    % GWO position update
%     Alpha_pos
    Alpha_pos = reshape(Alpha_pos, 2, NS)';
%     Beta_pos
    Beta_pos = reshape(Beta_pos, 2, NS)';
%     Delta_pos
    Delta_pos = reshape(Delta_pos, 2, NS)';
    for j=1:n
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Equation (12)
            C1=2*r2; % Equation (13)
            
            D_alpha=abs(C1*Alpha_pos(j)-subpop(i,j)); % Equation (14)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (15)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Equation (12)
            C2=2*r2; % Equation (13)
            
            D_beta=abs(C2*Beta_pos(j)-subpop(i,j)); % Equation (14)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (15)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % Equation (12)
            C3=2*r2; % Equation (13)
            
            D_delta=abs(C3*Delta_pos(j)-subpop(i,j)); % Equation (14)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (15)-part 3             
            
            subpop(i,j)=(X1+X2+X3)/3;% Equation (16-22)
    end
    
    U = subpop(i,:);
    
    offpop = [offpop U];

end
