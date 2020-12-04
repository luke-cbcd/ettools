function bin = etBinariseAOIMask(mask, def)

    numAOIs = size(def, 1);
    w = size(mask, 2);
    h = size(mask, 1);
    bin = false(h, w, numAOIs);
    tol = 10;
    
    for a = 1:numAOIs
        
        % find number of colours in aoi
        numCols = length(def{a, 2});
        for c = 1:numCols
            
            % extract colour
            col = def{a, 2}{1};
            
            % find aoi colours
            idx = mask(:, :, 1) - col(1) < tol;
            idx = idx & mask(:, :, 2) - col(2) < tol;
            idx = idx & mask(:, :, 3) - col(3) < tol;
            bin(:, :, a) = bin(:, :, a) | idx;
            
        end
 
    end

end