%% Taking Input  and Record Near End    
% Assumption by some way we have 2 seperate signals where we can
% differentiate which is near signal and which far end signal

NearVoice = audiorecorder(8000,8,1);
NearVoice.StartFcn = 'disp(''Start speaking.'')';
NearVoice.StopFcn = 'disp(''End of recording.'')';
record(NearVoice,5);

%% Record Far End

FarVoice = audiorecorder(8000,8,1);
FarVoice.StartFcn = 'disp(''Start speaking Far.'')';
FarVoice.StopFcn = 'disp(''End of recording Far.'')';
record(FarVoice,5);

%% Geigel Alogrithm

Near_End_Signal = getaudiodata(NearVoice);
Far_End_Signal = getaudiodata(FarVoice);
MixedSignalG = Far_End_Signal + Near_End_Signal;
subplot(2,1,1);
plot(Near_End_Signal)
title('Near End Signal');
subplot(2,1,2);
plot(Far_End_Signal)
title('Far End Signal');
figure,plot(MixedSignalG);
title('Mixed Signal');

MixedSignalG = abs(MixedSignalG);
DecisionVector = zeros(1,length(MixedSignalG));
l = zeros(1,length(MixedSignalG));

for i=1:length(MixedSignalG)
    DecisionVector(i) = MixedSignalG(i)/max(abs(Far_End_Signal));
    if DecisionVector(i)>1000
        l(i) = 1;
    end
end

if sum(l) > 0
    disp('Double Talk Detected');
else
    disp('Double Talk Not Present');
end
figure,plot(l);
title('Time at which Double talk Detected');
%% DTD Proposed Alogrithm

Near_End_Signal = getaudiodata(NearVoice);
Far_End_Signal = getaudiodata(FarVoice);
% Far_End_Signal = zeros(40000,1);
MixedSignal = Far_End_Signal + Near_End_Signal;

subplot(2,1,1);
plot(Near_End_Signal)
title('Near End Signal');
subplot(2,1,2);
plot(Far_End_Signal)
title('Far End Signal');
figure,plot(MixedSignal);
title('Mixed Signal');

CrossCorrelate_FAR_MIXED = xcorr(Far_End_Signal,MixedSignal);
NewNear = Near_End_Signal.*Near_End_Signal;
NewFar = Far_End_Signal.*Far_End_Signal;
for i=1:length(CrossCorrelate_FAR_MIXED)
    CrossCorrelate_FAR_MIXED(i) = CrossCorrelate_FAR_MIXED(i)/sqrt(mean(NewNear)*mean(NewFar));
end

DecisionParameter = max(abs(CrossCorrelate_FAR_MIXED));

if DecisionParameter > 1000
    disp('Double Talk Detected');
else
    disp('Double Talk Not Present');
end

CrossCorrelate_FAR_MIXED = abs(CrossCorrelate_FAR_MIXED);
DTDSignal = zeros(1,length(Far_End_Signal));

for i=1:length(Far_End_Signal)
    if MixedSignal(i)-Near_End_Signal(i)>0
        DTDSignal(i) = 1;
    end
end
figure,plot(DTDSignal);
title('Time at which Double talk Detected');