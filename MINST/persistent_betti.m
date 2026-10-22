function [numComponents, numHoles] = persistent_betti(img)
%PERSISTENT_BETTI  Number of persistent components and holes of one frame.
%   [numComponents, numHoles] = persistent_betti(img)
%
%   Features that are detected over a wide range of scales are more likely
%   true features, not noise [768-TDA.pdf p.7]. So I compute the Betti
%   plots of the image filtration over the whole range t = 5, 10, ..., 255
%   (every 5th threshold, to be fast) and keep the Betti numbers that last
%   the longest, i.e. the values seen most often.

thresholds = 5:5:255;                               % every 5th threshold
[beta0, beta1] = betti_curves(img, thresholds);     % Betti plots of the image filtration
numComponents = mode(beta0);                        % Betti-0 value seen most often
numHoles = mode(beta1);                             % Betti-1 value seen most often
end                                                 
