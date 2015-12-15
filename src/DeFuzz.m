function [ value ] = DeFuzz( B, supps )
% DeFuzz Calculates the COG of the support.

supLen = length(supps);

numer = 0;
denom = 0;

% Numerator
for i = 1:supLen
    numer = numer + B(i) * supps(i); 
end

% Denominator
for i = 1:supLen
    denom = denom + B(i);
end

value = numer / denom;

end

