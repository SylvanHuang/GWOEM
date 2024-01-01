function offpop = DE(subpop, NS, lu, n, F, CR)

offpop = [];
subpop = reshape(subpop, 2, NS)';

for i = 1 : NS

    % Choose the indices for mutation
    indexSet = 1 : NS;
    indexSet(i) = [];

    % Choose the first Index
    temp = floor(rand * (NS - 1)) + 1;
    nouse(1) = indexSet(temp);
    indexSet(temp) = [];

    % Choose the second index
    temp = floor(rand * (NS - 2)) + 1;
    nouse(2) = indexSet(temp);

    % subpopsizetate
    V = subpop(i, : ) + F .* (subpop(nouse(1), : ) - subpop(nouse(2), : ));

    % Handle the elements of the vector which violate the boundary
    vioLow = find(V < lu(1, : ));
    V(1, vioLow) = lu(1, vioLow);
        
    vioUpper = find(V > lu(2, : ));
    V(1, vioUpper) =  lu(2, vioUpper);

    % Implement the binomial crossover
    jRand = floor(rand * n) + 1;
    t = rand(1, n) < CR;
    t(1, jRand) = 1;
    t_ = 1 - t;
    U = t .* V + t_ .* subpop(i,  : );

    offpop = [offpop U];

end
