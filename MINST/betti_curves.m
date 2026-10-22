function [beta0, beta1] = betti_curves(img, thresholds)
%BETTI_CURVES  Betti plots of the image filtration K_t = {img >= t}.
%   [beta0, beta1] = betti_curves(img, thresholds)
%   beta0(k) = number of connected components of K_t at t = thresholds(k)
%   beta1(k) = number of holes (1D loops) of K_t at t = thresholds(k)
%
%   K_t is a cubical complex with 4-neighbor connectivity [768-TDA.pdf p.11].
%   Betti-0 = # connected components, Betti-1 = # 1D holes, and the Euler
%   characteristic is chi = Betti-0 - Betti-1 [768-topology.pdf p.17].
%   bwconncomp counts the components, and bweuler computes the Euler
%   characteristic of a binary image [768-topology.pdf p.14], so
%   Betti-1 = Betti-0 - chi.

beta0 = zeros(1, numel(thresholds));                % one Betti-0 value per threshold
beta1 = zeros(1, numel(thresholds));                % one Betti-1 value per threshold
for k = 1:numel(thresholds)                         % loop over the thresholds
    K = img >= thresholds(k);                       % binary image K_t: true = pixel with img >= t
    components = bwconncomp(K, 4);                  % connected components, 4-neighbor connectivity
    beta0(k) = components.NumObjects;               % Betti-0 = number of components
    beta1(k) = beta0(k) - bweuler(K, 4);            % Betti-1 = Betti-0 - Euler characteristic
end                                                 
end                                                 
