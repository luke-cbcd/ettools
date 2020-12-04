function [smry, tab_tall, tab_wide, looks] = etSummariseAOI(varargin)

    % convert in matrix to logical 
    varargin{1} = logical(varargin{1});

    [smry, tab_tall, tab_wide, looks] = etSummariseIn('aoi', varargin{:});
    
end