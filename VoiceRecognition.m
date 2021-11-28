function VoiceRecognition
% Records a small library and test word recognition

clc
warning off;

fs = 11025;
%fs =8000;
% RECORD LIBRARY SAMPLES

disp('Record Library Samples')

disp(' [1] Press Return to record first password');
k = waitforbuttonpress;
disp(' > Recording Started...')
obj1 = audiorecorder(8000,16,1,-1);
recordblocking(obj1,1);
LIBWORD_user1 = getaudiodata(obj1)*1000;
disp(' | Recording Ended');
subplot(211); 
plot(LIBWORD_user1);
title('Library Password 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_user1,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal');ylabel('Frequency (Hz)');xlabel('Time (Seconds)');
LIBWORD_user1 = EndPointingVAD(LIBWORD_user1); 
MFCCVectors_LIBWORD_user1 = mfcc_calculator(LIBWORD_user1);

disp(' [2] Press Return to record second password');
k = waitforbuttonpress;
disp(' > Recording Started...');
obj2 = audiorecorder(8000,16,1,-1);
recordblocking(obj2,1);
LIBWORD_user2 = getaudiodata(obj2)*1000;
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_user2); title('Library Password 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_user2,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_user2 = EndPointingVAD(LIBWORD_user2); 
MFCCVectors_LIBWORD_user2 = mfcc_calculator(LIBWORD_user2);

disp(' [3] Press Return to record third password');
k = waitforbuttonpress;
disp(' > Recording Started...');
obj3 = audiorecorder(8000,16,1,-1);
recordblocking(obj3,1);
LIBWORD_user3 = getaudiodata(obj3)*1000;
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_user3); title('Library Password 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_user3,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_user3 = EndPointingVAD(LIBWORD_user3);
MFCCVectors_LIBWORD_user3 = mfcc_calculator(LIBWORD_user3);

disp(' [4] Press Return to record fourth password');
k = waitforbuttonpress;
disp(' > Recording Started...');
obj4 = audiorecorder(8000,16,1,-1);
recordblocking(obj4,1);
LIBWORD_user4 = getaudiodata(obj4)*1000;
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_user4); title('Library Password 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_user4,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_user4 = EndPointingVAD(LIBWORD_user4);
MFCCVectors_LIBWORD_user4 = mfcc_calculator(LIBWORD_user4);


disp('Library ok');
subplot(4,1,1); plot(LIBWORD_user1); title('Library Password 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(4,1,2); plot(LIBWORD_user2); title('Library Password 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(4,1,3); plot(LIBWORD_user3); title('Library Password 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(4,1,4); plot(LIBWORD_user4); title('Library Password 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
play(obj1);
play(obj2);
play(obj3);
play(obj4);
% RECORD SAMPLE

disp('--------------');
disp('Press Return and say a sample from library');
k = waitforbuttonpress;
disp(' > Recording Started...');
obj5 = audiorecorder(8000,16,1,-1);
recordblocking(obj5,1);
TEST_SAMPLE = getaudiodata(obj5)*1000;
disp(' | Recording Ended');
TEST_SAMPLE =  EndPointingVAD(TEST_SAMPLE); 
play(obj5)
MFCCVectors_TEST_SAMPLE = mfcc_calculator(TEST_SAMPLE);

% COMPARE

[F , TS]=size(MFCCVectors_TEST_SAMPLE);
[F , LW1]=size(MFCCVectors_LIBWORD_user1);
[F , LW2]=size(MFCCVectors_LIBWORD_user2);
[F , LW3]=size(MFCCVectors_LIBWORD_user3);
[F , LW4]=size(MFCCVectors_LIBWORD_user4);
M = [TS,LW1,LW2,LW3,LW4];
[M,I] = max(M);

NMFCCVectors_TEST_SAMPLE = zeros(F,M);
NMFCCVectors_LIBWORD_user1 = zeros(F,M);
NMFCCVectors_LIBWORD_user2 = zeros(F,M);
NMFCCVectors_LIBWORD_user4 = zeros(F,M);
NMFCCVectors_LIBWORD_user3 = zeros(F,M);

NMFCCVectors_TEST_SAMPLE(1:F,1:TS)=MFCCVectors_TEST_SAMPLE;
NMFCCVectors_LIBWORD_user1(1:F,1:LW1)=MFCCVectors_LIBWORD_user1;
NMFCCVectors_LIBWORD_user2(1:F,1:LW2)=MFCCVectors_LIBWORD_user2;
NMFCCVectors_LIBWORD_user4(1:F,1:LW4)=MFCCVectors_LIBWORD_user4;
NMFCCVectors_LIBWORD_user3(1:F,1:LW3)=MFCCVectors_LIBWORD_user3;

DISTANCE_LW1 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_user1);
DISTANCE_LW2 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_user2);
DISTANCE_LW3 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_user3);
DISTANCE_LW4 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_user4);
M = [DISTANCE_LW1,DISTANCE_LW2,DISTANCE_LW3,DISTANCE_LW4];
[A,I] = min(M);

if(I==1) 
    disp('Sample Matched LIBWORD_user1');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_user1); title('Matched Library Password 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    play(obj1) % LIBWORD_1
end
if(I==2)
    disp('Sample Matched LIBWORD_user2');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_user2); title('Matched Library Password 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    play(obj2) % LIBWORD_2
end
if(I==3)
    disp('Sample Matched LIBWORD_user3');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_user3); title('Matched Library Password 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
	play(obj3) % LIBWORD_3
end
if(I==4)
    disp('Sample Matched LIBWORD_user4');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_user4); title('Matched Library Password 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    play(obj4) % LIBWORD_4
end
end