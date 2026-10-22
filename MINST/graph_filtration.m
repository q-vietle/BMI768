function [G, births, deaths] = graph_filtration(img)
%GRAPH_FILTRATION  Graph filtration of an image and its birth and death sets.
%   [G, births, deaths] = graph_filtration(img)
%
%   G      : weighted graph X = (V, w) [768-TDA.pdf p.17] with one node per
%            pixel and one edge between 4-neighbor pixels [768-TDA.pdf p.11].
%            Edge weight = min(intensity of the two pixels) (to
%            turn an image into a weighted graph).
%            The graph filtration X_eps0 > X_eps1 > ... keeps the edges with
%            weight > eps, for increasing eps [768-TDA.pdf p.17].
%   births : sorted weights of the birth set E0 = maximum spanning tree
%   deaths : sorted weights of the death set E1 = all other edges
%            Birth and death sets partition the edge set [768-TDA.pdf p.34]:
%            deleting a birth edge creates a component, deleting a death
%            edge destroys a cycle [768-TDA.pdf p.33].

img = double(img);                                  % uint8 -> double, so we can do math with it
[numRows, numCols] = size(img);                     % image size: 64 x 64
nodeId = reshape(1:numRows*numCols, numRows, numCols);     % node number of each pixel

% Edges between 4-neighbor pixels: each pixel with its right neighbor,
% then each pixel with the pixel below it
s = [reshape(nodeId(:, 1:end-1), [], 1); reshape(nodeId(1:end-1, :), [], 1)];  % first node of each edge
t = [reshape(nodeId(:, 2:end), [], 1);   reshape(nodeId(2:end, :), [], 1)];    % second node of each edge
w = min(img(s), img(t));                            % edge weight = the darker of the two pixels
G = graph(s, t, w);                                 % the weighted graph of the image

% Maximum spanning tree = minimum spanning tree of the negative weights
T = minspantree(graph(s, t, -w));                   % maximum spanning tree of G
inTree = ismember(G.Edges.EndNodes, T.Edges.EndNodes, "rows");  % true for the edges of the tree

births = sort(G.Edges.Weight(inTree))';             % weights of the tree edges, sorted (birth set)
deaths = sort(G.Edges.Weight(~inTree))';            % weights of the other edges, sorted (death set)
end                                                 
