function MFCC = mfcc_calculator(input_signal)
% Calculates mel-frequency cepstral coefficients from audio signal

fs = 11025;

% read in wav-file

y = input_signal;
y = y(:);

% Hamming Windowing

winlen = round(0.020*fs/2)*2; % 20 ms Window
win = hamming( winlen); % Symmetric Hamming Window
winstep = round(0.01*fs); % step 10 ms between frames

% Filterbank

numchannels = 26; % number of filters in filterbank
numceps = 12; % number of cepstral coefficients
L = 22; % liftering coefficient
fftlen = 2048; % total length of fft
fs2mel = 2595*log10( 1+(fs/2)/700); % fs/2 on mel scale
lifter = 1+L/2*sin( pi*(0:numceps).'/L); % lifter coefficients
f = (0:fftlen/2)/(fftlen)*fs; % frequencies in half of fft
fmel = 2595*log10( 1 + f/700); % f on mel scale
for c=1:numchannels,
    % construct triangular filters on mel-scale for each channel
    % channel midfrequency is c*fs2mel/(numchannels+1)
    cdelta = 1*fs2mel/(numchannels+1); % half of width of one filter channel
    cmid = c*fs2mel/(numchannels+1);
    fbc = 1 - abs(fmel-cmid)/cdelta;
    fbc = max( fbc, 0);
    FBC( c,:)= fbc;    
end

% Calculate MFCC's

n = 1;
frameind = 1;
% go through signal in frames and calculate MFCC's
while ( n + winlen <= length( y)),
    ywin = y( n+(0:winlen-1)).*win; % window
    YW = fft( ywin, fftlen);        % fft
    YW = YW(1:fftlen/2+1);          % we need only half
    % calculate log magnitude for each channel
    for c = 1:numchannels,
        mag( c) = 9 + log( sum( abs(YW).*FBC(c,:).')); % magic 9 from HTK       
    end
    cc = dct( mag); % take dct of magnitude vector
    c0 = sqrt(2)*cc( 1); % scale and remember c0
    cc = cc(1:numceps+1).'.*lifter;     % lifter
    cc(1) = []; % discard c0, keep only numceps
    MFCC( :, frameind) = [cc; c0];  % shuffle into same order as HTK
        
    n = n + winstep;
    frameind = frameind+1;
end



