function centers = digit_positions(frames)
%DIGIT_POSITIONS  Position of each of the two digits in every frame of a sequence.
%   centers = digit_positions(frames)
%   frames  : 64 x 64 x 20 array (one sequence)
%   centers : 20 x 2 x 2 array, centers(t, :, d) = [x y] of digit d in frame t
%             NaN when the frame does not have exactly two components
%
%   A digit is a connected component of the binary image frame > 30.
%   Betti-0 = number of connected components [768-topology.pdf p.17],
%   with 4-neighbor connectivity [768-TDA.pdf p.11].
%   When Betti-0 = 2, the two digits are apart and the center of each
%   component is the position of a digit. Otherwise (the digits touch, or a
%   stroke is broken) the frame is skipped.
%   Intuitively, the position of a digit is the center of its blob of bright
%   pixels. Since a digit only moves a few pixels per frame, each blob is
%   matched with the closest digit of the previous frame, so that digit 1
%   stays digit 1 even when the two digits cross.


numFrames = size(frames, 3);                        % number of frames (20)
centers = nan(numFrames, 2, 2);                     % start with NaN = "no position" everywhere
previous = [];                                      % positions in the last frame with 2 components
for t = 1:numFrames                                 % loop over the frames
    components = bwconncomp(frames(:,:,t) > 30, 4);  % connected components of the binary image
    if components.NumObjects ~= 2                   % not exactly 2 components (Betti-0 ~= 2)?
        continue                                    % skip this frame: its centers stay NaN
    end                                             
    stats = regionprops(components, "Centroid");    % center of each component
    current = [stats(1).Centroid; stats(2).Centroid];   % row d = [x y] of digit d

    % Keep the same numbering as in the previous frame
    if ~isempty(previous)                           % only if an earlier frame had 2 components
        sameOrder = norm(current(1,:) - previous(1,:)) + norm(current(2,:) - previous(2,:));  % total move if we keep the order
        swapped = norm(current(2,:) - previous(1,:)) + norm(current(1,:) - previous(2,:));    % total move if we swap the two
        if swapped < sameOrder                      % swapping makes the digits move less?
            current = current([2 1], :);            % then swap rows 1 and 2
        end                                         
    end                                             
    centers(t, :, 1) = current(1, :);               % store the position of digit 1
    centers(t, :, 2) = current(2, :);               % store the position of digit 2
    previous = current;                             % remember them for the next frame
end                                                 
end                                                 
