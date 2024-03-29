function clus = etCluster3D_meanShift(gaze, bandwidth, timeScale)

    if ~exist('gaze', 'var') || isempty(gaze) || ~isa(gaze, 'etGazeData')
        error('Must supply ''gaze'', a teGazeData object.')
    end
    
    if ~exist('bandwidth', 'var') || isempty(bandwidth)
        bandwidth = 0.1;
        warning('''bandwidth'' was not specified, so has defaulted to 0.1.')
    end
    
    % timeScale determines how to scale the temporal dimension of the data
    % so that suitable-length clusters are identified, given the bandwidth
    % parameter. timeScale is a factor that relates 1s of data to the
    % bandwith. For example, with a default bandwidth of 0.1, a timeScale
    % of 10 would scale the time data by 10x, resulting in an effective
    % temporal bandwidth of 1s. Note that to achieve this scaling, time is
    % first normalised. 
    if ~exist('timeScale', 'var') || isempty(timeScale)
        timeScale = 10;
    end
    
    % reshape gaze into one long matrix
    m_x = reshape(gaze.X, 1, []);
    m_y = reshape(gaze.Y, 1, []);
    
    % scale time
    t = gaze.Time';
    t = (t ./ max(t)) * (gaze.Duration / timeScale);
    m_t = repmat(t, 1, gaze.NumSubjects);    
    
    % format gaze and time for clustering
    m_gaze = [m_x; m_y; m_t];
    
    % remove missing
    missing                         = any(isnan(m_gaze), 1);
    m_gaze(:, missing)              = [];
    gNumPoints                      = size(m_gaze, 2);
    
    % cluster
    [cluster_centre, cluster_idx, cluster_members] =...
        HGMeanShiftCluster(m_gaze, bandwidth, 'gaussian', false);
    
    % validate clusters - must have > 1% of gaze samples
    clNumPoints                     = cellfun(@(x) size(x, 2), cluster_members);
    clPropPoints                    = clNumPoints ./ gNumPoints;
    clVal                           = clPropPoints >= 0.01;
    numClus                         = length(clVal);
    numValClus                      = sum(clVal);
    
    %store
    clus.gaze                        = gaze;
    clus.gaze_matrix                 = m_gaze;
    clus.time_scaled                 = t;
    clus.numGazePoints               = gNumPoints;
    clus.numClusters                 = numClus;
    clus.numValidClusters            = numValClus;
    clus.cluster_centre              = cluster_centre;
    clus.cluster_idx                 = cluster_idx;
    clus.cluster_members             = cluster_members;
    clus.cluster_validity            = clVal;
    clus.cluster_propGaze            = clPropPoints;
    clus.cluster_numGazePoints       = clNumPoints;
    
end