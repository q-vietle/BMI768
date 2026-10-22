function [dGeo, dTop, dWass] = frame_distances(A, B)
%FRAME_DISTANCES  Geometric and topological distances between two frames A and B.
%   [dGeo, dTop, dWass] = frame_distances(A, B)
%
%   dGeo  : geometric distance = pixelwise Euclidean distance
%           [768-wasserstein.pdf p.2: geometric vs. topological distance]
%   dTop  : difference in topology = |change in # components| + |change in # holes|,
%           using the persistent Betti numbers. Same idea as d_top in
%           [768-wasserstein.pdf p.2]: a circle and a square have d_top = 0,
%           a broken circle and a circle have d_top = 1 (one hole less).
%   dWass : 2-Wasserstein distance between the graph filtrations of A and B
%           [768-wasserstein.pdf p.13-14]: match the i-th smallest birth of A
%           with the i-th smallest birth of B (0D topology) and the i-th
%           smallest death with the i-th smallest death (1D topology).
%           = sqrt( sum (birthA - birthB)^2 + sum (deathA - deathB)^2 )

dGeo = norm(double(A(:)) - double(B(:)));           % Euclidean distance between all pixel values

[componentsA, holesA] = persistent_betti(A);        % persistent # components and # holes of A
[componentsB, holesB] = persistent_betti(B);        % same for B
dTop = abs(componentsA - componentsB) + abs(holesA - holesB);  % change in # components + change in # holes

[~, birthsA, deathsA] = graph_filtration(A);        % sorted births and deaths of A
[~, birthsB, deathsB] = graph_filtration(B);        % sorted births and deaths of B
dWass = sqrt(sum((birthsA - birthsB).^2) + sum((deathsA - deathsB).^2));  % i-th birth with i-th birth, i-th death with i-th death
end                                                 
