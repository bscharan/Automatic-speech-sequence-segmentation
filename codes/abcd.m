clear all; close all;

n_spe=4;%number of speakers to be clustered

[data,fs] = audioread('merge.wav');
data=data(:,1);%audioread ,fs= number of samples persec.
f_d = 0.025;  %size of block under consideration = f_d
f_size = floor(f_d*fs);%no of samples in f_d is f_size
n = length(data);
n_f = floor(n/f_size);% n_f is total number of blocks in given data
temp = 0;


%/// code to remove noise using amplitude thresholding
for i = 1 : n_f
 if(abs(max(data(temp+1: temp + f_size)))>0.05);
     gd(temp+1: temp + f_size)=data(temp+1: temp + f_size);
 else
     gd(temp+1: temp + f_size)=0;
 end
 temp = temp + f_size;
end

%/////////ZCR
zz=0;
for i = 1 : n_f
 if(zcr(data(zz+1: zz + f_size))<0.10);
     zc(zz+1: zz + f_size)=data(zz+1: zz + f_size);
 else
     zc(zz+1: zz + f_size)=0;
 end
 zz = zz + f_size;
end

%inputs for MFCC
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
    
    % //////////////////MFCC Function call

[ MFCCs, FBEs, frames ] = ...
                    mfcc( gd, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

 %////////////////    dfd=delta mfcc
fdf=MFCCs(2:13,:);
mfcclen = length(MFCCs)-1;
 for r=1:mfcclen-1
    if(r==1)
    dfd(:,1)=fdf(:,r);
    end
    if(r==mfcclen)
    dfd(:,mfcclen)=fdf(:,r);
    end
    if(r~=1 && r~=mfcclen)
    dfd(:,r)=(fdf(:,r+1)-fdf(:,r-1))/2;
    end
 end
 
 %///////////////  ddfd=double delta mfcc
 fdf=dfd;
 lendfd=length(dfd)-1;
 for r=1:lendfd
    if(r==1)
    ddfd(:,1)=fdf(:,r);
    end
    if(r==lendfd)
    ddfd(:,length(MFCCs))=fdf(:,r);
    end
    if(r~=1 && r~=lendfd)
    ddfd(:,r)=(fdf(:,r+1)-fdf(:,r-1))/2;
    end
 end
 

                
%finding silences i.e starting of silence and starting of speech                
slmean=mean(MFCCs(1:13,:).^2,1);
    h=1;
    slmean(isnan(slmean))=0; % replacing All NaN to 0
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

%dividing sample into blocks between silences and calculating mean;
for i=1:length(sp)-1
    salmean(:,i)=mean(MFCCs(1:13,si(i):sp(i)),2);
end

%Kmeans clustering

[idx,c]=kmeans(salmean',n_spe); 
%gd is output after removing noise.
len = floor(length(gd)/length(MFCCs));
for i=1:length(sp)-1
 if (idx(i)==1)
    gd1k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
 if (idx(i)==2)
    gd2k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
  if (idx(i)==3)
    gd3k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==4)
    gd4k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==5)
    gd5k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx(i)==6)
    gd6k(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
end

%///////////////sphereical kmeans

%code and classification
skmean_data2 = norm_data(salmean); %function for normalising data 
skmean_data=skmean_data2';
[x,f,mem]=SPKmeans(skmean_data,n_spe,15);
%x is best centroid for Spherical kmeans clustering
%mem is a numbered row vector with number representing each classification  

idx2= mem';%idk2 is a numbered vector with number representing each classification  

%classification of labelled data
len = floor(length(gd)/length(MFCCs));

for i=1:length(sp)-1
 if (idx2(i)==1)
    gd1(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
 if (idx2(i)==2)
    gd2(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
  if (idx2(i)==3)
    gd3(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx2(i)==4)
    gd4(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx2(i)==5)
    gd5(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (idx2(i)==6)
    gd6(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  
end

%plots
plot(idx);ylim([0 5]);title('kmeans'); figure; plot(idx2);ylim([0 5]); title( 'Spkmeans');
figure;plot(gd1k);hold on;plot(gd2k);hold on;plot(gd3k);hold on;plot(gd4k);title('kmeans2');
figure;plot(gd1);hold on;plot(gd2);hold on;plot(gd3);hold on;plot(gd4);title('Spkmeans2');





