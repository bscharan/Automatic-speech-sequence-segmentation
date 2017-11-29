
clearvars -except gd2 fs;
Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
%[data,fs] = audioread('merge.wav');
data=gd2;
clear gd2;
f_d = 0.025; f_size = floor(f_d*fs); n = length(data); n_f = floor(n/f_size);
temp = 0;
for i = 1 : n_f
 if(abs(max(data(temp+1: temp + f_size)))>0.05);
     gd(temp+1: temp + f_size)=data(temp+1: temp + f_size);
 else
     gd(temp+1: temp + f_size)=0;
 end
 temp = temp + f_size;
end
[ MFCCs, FBEs, frames ] = ...
                    mfcc( gd, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    slmean=mean(MFCCs(1:13,:).^2,1);
    h=1;
    
    
    slmean(isnan(slmean))=0;
    
    p=1;
    
for i=1:length(MFCCs)-2
    if(slmean(i)==0 && slmean(i+1)~=0)
        si(h)=i+1;%numbers starting
        h=h+1;
    end
    if(slmean(i)~=0 && slmean(i+1)==0)
        sp(p)=i;%zeros starting
        p=p+1;
    end
end
for i=1:length(sp)
    salmean(:,i)=mean(MFCCs(5:12,si(i):sp(i)),2);
end
idx=kmeans(salmean',2);
 
%gd is output after removing noise.

len = floor(length(gd)/length(MFCCs));
for i=1:length(sp)
 if (idx(i)==1)
    gd1(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
 if (idx(i)==2)
    gd2(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
  if (idx(i)==3)
    gd3(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==4)
    gd4(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==5)
    gd5(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==6)
    gd6(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
 
 
end
