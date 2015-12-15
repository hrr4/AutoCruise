function [alphas] = FireLevels(support, ants, x0)

% Find out how many antecedents we have (Should be array of arrays)
ant_len = length(ants);

% Run through each antecedent and find the firing level.
found = 0;

temp = zeros([1, ant_len]);
valid_ants = zeros([1, ant_len]);

for i = 1:ant_len
    ant = ants{i};
    supp = support{i};
    max_val = supp(length(ant));
    
    % Try to exclude x0
    % Test if it can even exist within the support
    if x0 < supp(1) || x0 > max_val
        continue;
    end

    % Insert into valid_ants, we'll go through them later. (Complexity)
    valid_ants(found+1) = i;
    found = found + 1;
end

if (isempty(valid_ants))
    alphas = [];
    return;
end
    
epsilon = .0001;

valid_ants = valid_ants(1:found);

for i = 1:length(valid_ants)
    valid = valid_ants(i);

    if valid == 0
        continue; 
    end;

    ant = ants{valid};
    supp = support{valid};
    
    % Find the position of x0 within the support.
    % Use that index to map into the Fuzzy Out.
    [v, idx] = find(abs(supp-x0) < epsilon);
    
    if ~isempty(v)
        temp(i) = ant(idx);
    end
end

alphas = temp;

end