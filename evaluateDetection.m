function [Ndet,xDetected,Nfa] = evaluateDetection(xPos,xPeak,tolerance)
%EVALUATEDETECTION Evaluate target detection performance.
%
%   [Ndet,xDetected,Nfa] = evaluateDetection(xPos,xPeak,tolerance)
%
%   A detected peak is considered a valid detection if its distance from
%   a true target position is smaller than the specified tolerance.
%   Each detected peak can be assigned to only one target.
%
%   Inputs:
%       xPos       - True target positions
%       xPeak      - Detected peak positions
%       tolerance  - Maximum localization error
%
%   Outputs:
%       Ndet       - Number of correctly detected targets
%       xDetected  - Positions of correctly detected peaks
%       Nfa        - Number of false alarms


%% Ensure column vectors

xPos = xPos(:);
xPeak = xPeak(:);


%% Initialize

Ndet = 0;

xDetected = [];


% Available peaks for association
xPeak_temp = xPeak;



%% Target-to-peak association

for i = 1:length(xPos)

    % No remaining peaks
    if isempty(xPeak_temp)
        break
    end


    % Find closest detected peak
    [distance,idx] = min(abs(xPeak_temp - xPos(i)));


    % Check detection condition
    if distance <= tolerance

        % Valid detection
        Ndet = Ndet + 1;

        xDetected(end+1,1) = xPeak_temp(idx);


        % Remove assigned peak
        xPeak_temp(idx) = [];

    end

end



%% False alarms

% Peaks not associated with any target
Nfa = length(xPeak_temp);


end
