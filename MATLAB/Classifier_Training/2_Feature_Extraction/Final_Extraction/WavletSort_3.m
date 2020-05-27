clear all

mat = dir(strcat('**/', 'C:\Users\Emanuel\OneDrive\NEVR_Thesis\Shared\Wavelet_WaveDecomposition','/*.mat'));

load('C:\Users\Emanuel\OneDrive\NEVR_Thesis\Shared\Wavelet_WaveDecomposition\Features_Wdb4.mat')

alphasamp = 15.625;
betasamp  = 32.5;
thetasamp = 7.8125;
deltasamp = 7.8125;
epoch    = [-0.720 -1.100];
%epoch    = [-0.450 -0.890];


for q = 1:length(mat)


AlphaLoom = [];
AlphaLoomAvg = [];
AlphaLoomVar = [];

BetaLoom  = [];
BetaLoomAvg = [];
BetaLoomVar = [];

DeltaLoom = [];
DeltaLoomAvg  = [];
DeltaLoomVar = [];

ThetaLoom = [];
ThetaLoomAvg = [];
ThetaLoomVar = [];

AlphaNonLoom = [];
AlphaNonLoomAvg = [];
AlphaNonLoomVar = [];

BetaNonLoom  = [];
BetaNonLoomAvg = [];
BetaNonLoomVar = [];

DeltaNonLoom = [];
DeltaNonLoomAvg  = [];
DeltaNonLoomVar = [];

ThetaNonLoom = [];
ThetaNonLoomAvg = [];
ThetaNonLoomVar = [];

AlphaRandom = [];
AlphaRandomAvg = [];
AlphaRandomVar = [];

BetaRandom  = [];
BetaRandomAvg = [];
BetaRandomVar = [];

DeltaRandom = [];
DeltaRandomAvg  = [];
DeltaRandomVar = [];

ThetaRandom = [];
ThetaRandomAvg = [];
ThetaRandomVar = [];

%(alphasamp*600)/500

AlphaDataStim = AlphaData(:,round((alphasamp*600)/500 + (epoch./alphasamp)));
BetaGammaDataStim = BetaGammaData(:,round((betasamp*600)/500 + (epoch./betasamp)));
ThetaDataStim = ThetaData(:,round((thetasamp*600)/500 + (epoch./thetasamp)));
DeltaDataStim = DeltaData(:,round((deltasamp*600)/500 + (epoch./deltasamp)));

AlphaDataRef = AlphaData(:,1:3);
BetaGammaDataRef = BetaGammaData(:,1:3);
ThetaDataRef = ThetaData(:,1:3);
DeltaDataRef = DeltaData(:,1:3);

for i = 1:length(LDAIndex) 
    if LDAIndex(i) == 1
       AlphaLoom = [AlphaLoom; AlphaData(i,:)];
       AlphaLoomVar = [AlphaLoomVar; std(AlphaData(i,:))];
       AlphaLoomAvg = [AlphaLoomAvg; mean(AlphaDataRef(i,:))-mean(AlphaDataStim(i,:))];
       BetaLoom  = [BetaLoom; BetaGammaData(i,:)];
       BetaLoomVar = [BetaLoomVar; std(BetaGammaData(i,:))];
       BetaLoomAvg = [BetaLoomAvg; mean(BetaGammaDataRef(i,:))-mean(BetaGammaDataStim(i,:))];
       DeltaLoom = [DeltaLoom; DeltaData(i,:)];
       DeltaLoomVar = [DeltaLoomVar; std(DeltaData(i,:))];
       DeltaLoomAvg = [DeltaLoomAvg; mean(DeltaDataRef(i,:))-mean(DeltaDataStim(i,:))];
       ThetaLoom = [ThetaLoom; ThetaData(i,:)];
       ThetaLoomVar = [ThetaLoomVar; std(ThetaData(i,:))];
       ThetaLoomAvg = [ThetaLoomAvg; mean(ThetaDataRef(i,:))-mean(ThetaDataStim(i,:))];
       
    elseif LDAIndex(i) == 2
       AlphaNonLoom = [AlphaNonLoom; AlphaData(i,:)];
       AlphaNonLoomVar = [AlphaNonLoomVar; std(AlphaData(i,:))];
       AlphaNonLoomAvg = [AlphaNonLoomAvg; mean(AlphaDataRef(i,:))-mean(AlphaDataStim(i,:))];
       BetaNonLoom  = [BetaNonLoom; BetaGammaData(i,:)];
       BetaNonLoomVar = [BetaNonLoomVar; std(BetaGammaData(i,:))];
       BetaNonLoomAvg = [BetaNonLoomAvg; mean(BetaGammaDataRef(i,:))-mean(BetaGammaDataStim(i,:))];
       DeltaNonLoom = [DeltaNonLoom; DeltaData(i,:)];
       DeltaNonLoomVar = [DeltaNonLoomVar; std(DeltaData(i,:))];
       DeltaNonLoomAvg = [DeltaNonLoomAvg; mean(DeltaDataRef(i,:))-mean(DeltaDataStim(i,:))];
       ThetaNonLoom = [ThetaNonLoom; ThetaData(i,:)];
       ThetaNonLoomVar = [ThetaNonLoomVar; std(ThetaData(i,:))];
       ThetaNonLoomAvg = [ThetaNonLoomAvg; mean(ThetaDataRef(i,:))-mean(ThetaDataStim(i,:))];
       
    elseif LDAIndex(i) == 3
       AlphaRandom = [AlphaRandom; AlphaData(i,:)];
       AlphaRandomVar = [AlphaRandomVar; std(AlphaData(i,:))];
       AlphaRandomAvg = [AlphaRandomAvg; mean(AlphaDataRef(i,:))-mean(AlphaDataStim(i,:))];
       BetaRandom  = [BetaRandom; BetaGammaData(i,:)];
       BetaRandomVar = [BetaRandomVar; std(BetaGammaData(i,:))];
       BetaRandomAvg = [BetaRandomAvg; mean(BetaGammaDataRef(i,:))-mean(BetaGammaDataStim(i,:))];
       DeltaRandom = [DeltaRandom; DeltaData(i,:)];
       DeltaRandomVar = [DeltaRandomVar; std(DeltaData(i,:))];
       DeltaRandomAvg = [DeltaRandomAvg; mean(DeltaDataRef(i,:))-mean(DeltaDataStim(i,:))];
       ThetaRandom = [ThetaRandom; ThetaData(i,:)];
       ThetaRandomVar = [ThetaRandomVar; std(ThetaData(i,:))];
       ThetaRandomAvg = [ThetaRandomAvg; mean(ThetaDataRef(i,:))-mean(ThetaDataStim(i,:))];
    end
    
end

end
