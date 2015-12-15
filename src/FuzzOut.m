function [out, B, unionSupports] = FuzzOut(arrs, supps, alphas)
% Generate a Fuzzy Output.

% Run along each support (which has a firing level)
% Store all values <= firing level.

outSz = 0;

Values = [];

for i = 1:length(alphas)
    alpha = alphas(i);
    
    if alpha == 0
        continue;
    end

    arr = arrs{i};
    
    % Find all fuzzy values <= the firing lvl.
    v = arr;
    v(v > alpha) = alpha;

    outSz = outSz + length(v);
    
    Values(i, 1:numel(v)) = v;
end

out = Values;

Btemp = zeros(1, length(Values)); 
unionSuppTemp = zeros(1, length(Values));

% Find B, which is the max between the mins.
for i = 1:size(Values, 1)
    Btemp = Union(Btemp, Values(i, :));
    unionSuppTemp = Union(unionSuppTemp, supps{i});
end

unionSupports = unionSuppTemp;
B = Btemp;

end