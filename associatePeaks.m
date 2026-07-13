function xDetected = associatePeaks(xPos, xPeak)
%ASSOCIATEPEAKS Associate detected peaks to true positions.
%
%   xDetected = associatePeaks(xPos, xPeak)
%
%   For each true position in xPos, the function selects the closest
%   detected peak from xPeak. Once a peak is assigned, it is removed
%   from the available peak list to avoid multiple assignments.
%
%   Inputs:
%       xPos  - True target positions
%       xPeak - Detected peak positions
%
%   Output:
%       xDetected - Selected peak positions associated with xPos


% Number of targets
Np = length(xPos);


% Preallocate output
xDetected = zeros(size(xPos));


% Available peaks
xPeak_temp = xPeak;


% Peak association
for i = 1:Np

    % Find closest detected peak
    [~, idx] = min(abs(xPeak_temp - xPos(i)));

    % Store associated peak
    xDetected(i) = xPeak_temp(idx);

    % Remove assigned peak
    xPeak_temp(idx) = [];

end

end
