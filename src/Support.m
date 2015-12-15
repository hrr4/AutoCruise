function[out] = Support(vec, step)
    if nargin < 2
        step = 1;
    end
    
    out = vec(1):step:vec(length(vec));
end