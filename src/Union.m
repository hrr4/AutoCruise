function [ out ] = Union( arr1, arr2 )
% Fuzzy Union

% largest array
if length(arr1) > length(arr2)
    maxLen = length(arr1);
else
    maxLen = length(arr2);
end

temp = zeros([1, maxLen]);

for i = 1:maxLen
    if (i <= length(arr1))
        val1 = arr1(i);
    else
        val1 = 0;
    end
    if (i <= length(arr2))
        val2 = arr2(i);
    else
        val2 = 0;
    end
    
    if val1 > val2
        temp(i) = val1;
    else
        temp(i) = val2;
    end
end

out = temp;

end

