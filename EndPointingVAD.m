function   output_signal = EndPointingVAD(input_signal)
% Detect Human Voice (VAD) & Remove spikes at the beggining of recording

% Break file into frames for further analysis
% the duration of each frame, it should differ depending on the size of the
% audio file and the size of the speech segments.

fs = 11025;
totalFileTimeInMSec = (length(input_signal) / fs)*100;

frameLengthInMSec = 1;
% calculate the number of frames
numberOfFrames = totalFileTimeInMSec / frameLengthInMSec;
numberOfFrames = floor(numberOfFrames);
% calculate the size of each frame in the data array.
frameSize = floor(fs * frameLengthInMSec / 100);
% initialize the frames.
frames = zeros(numberOfFrames,frameSize);
% copy the data from the audio signal to the frames.
startIndex = 1;
endIndex = frameSize;
for frameM = 1:1:numberOfFrames
	frame = input_signal(startIndex:endIndex,1);
	startIndex = startIndex + frameSize;
	endIndex = endIndex +frameSize;
	frames(frameM,:) = frame.';
end

% Calculates the threshold of Voice Activity & remove silence from recording
 
%calculate P (mean^2)
framesSqr = frames.^2;
P = mean(framesSqr,2);
%calculate Z (avg difference)
Z = mean(abs(diff(abs(frames),1,2))./2,2);
%calculate W combination of P and Z, 1000 is just a scaling factor.
W = P.*(1-Z).*1000;
% calculate the VAD threshold.
meanW = mean(W);
stdDevW = std(W);
gamma  = 0.2*stdDevW^-0.8;
threshold = meanW + gamma*stdDevW;
thresholdedW = zeros(1,length(W));
%threshold the W.
for i = 1:1:length(W)
    
    if W(i)> threshold
        thresholdedW(i) = 1;
    end
end
%smooth the thresholded W to join nearby segments. default smoothing window = 5
smoothVAD = smooth(thresholdedW,10);
%threshold the VAD again
for i = 1:1:length(smoothVAD)
    
    if smoothVAD(i)> 0
        smoothVAD(i) = 1;
    end
end
C= 0;

%step-1 break the signal into frames of 0.01 sec
for i=1:numberOfFrames
    
    %extract frame from signal
    frame = input_signal((i-1)*frameSize+1 : frameSize*i).* smoothVAD(i);

    %identify speech by fiding frames with max amplitude more than 0.03
    S = sum(frame);    
    if(S ~= 0)
        C = C+1;
        %create a new signal with no silence
        output_signal((C-1)*frameSize+1 : frameSize*C) = frame;
    end
end
end
