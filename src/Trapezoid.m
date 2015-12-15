function [out] = Trapezoid(vec, step) %a,b,c,d)
a = vec(1);
b = vec(2);
c = vec(3);
d = vec(4);

out = zeros([length(a:d), 1]);

i = 1;

if nargin < 2
    step = 1;
end

for x = a:step:d
    if x > a && x < b
        out(i) = (x-a)/(b-a);
    elseif x >= b && x <= c 
        out(i) = 1;
    elseif x > c && x < d
        out(i) = (d-x)/(d-c);
    else
        out(i) = 0;
    end
    
    i = i + 1;
end

end