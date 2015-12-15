function [out] = Triangular(vec, step)
a = vec(1);
b = vec(2);
c = vec(3);

out = zeros([length(a:c), 1]);

i = 1;

if nargin < 2
    step = 1;
end

for x = a:step:c
    if x > a && x < b
        out(i) = (x-a)/(b-a);
    elseif x == b
        out(i) = 1;
    elseif x > b && x < c
        out(i) = (c-x)/(c-b);
    else
        out(i) = 0;
    end
    
    i = i + 1;
end

end