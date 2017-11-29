
Count_k=0;%initialise the variable count_k to zero.It is a controlling variable for the loop
whi_count=0;
id=6 %number of estimated speakers+1
k=id; %id gets updated after every loop.so store the variable in a new variable
while id>1
[IDX, CentM] = kmeans(salmean',id);%extract the clusters and the centroids for clusters
CentM=CentM';%convert the row vector CentM to coloumn vector CentM
adkt=1;   
%run a loop to calculate if a cluster is closer to the above or below
%cluster so that the 3 clusters initially obtained could be modified to 2
for na=id:-1:3  
         Abc_dist(adkt)=pdist2(CentM(na,:),CentM(na-1,:))/(pdist2(CentM(na,:),CentM(na-1,:)+pdist2(CentM(na-1,:),CentM(na-2,:))));
         if(Abc_dist(adkt)<0.4 || Abc_dist(adkt) > 0.6)
            Count_k=Count_k+1 ; %increase the count so that the number of clusters gets decreased by one in every iteration if the distance rule is satisfied
         end
        adkt=adkt+1;
   end
if (Count_k>0)
id=id-1; %decrase the number of clusters by 1 if the distance rule isd satisfied
Count_k=0;
end
abcdefg=1;
whi_count=whi_count+1;
if (whi_count>k)
    break;
end
end
%the loop iterates continuously until the 3 clusters satisfying the
%distance rule can be merged and finally we get the effective number of
%clusters.

[IDX, CentM] = kmeans(salmean',2);




len = floor(length(gd)/length(MFCCs));
for i=1:length(sp)
 if (IDX(i)==1)
    gd1(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
 if (IDX(i)==2)
    gd2(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
 end
  if (IDX(i)==3)
    gd3(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (IDX(i)==4)
    gd4(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (IDX(i)==5)
    gd5(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
  if (IDX(i)==6)
    gd6(si(i)*len:sp(i)*len)=gd(si(i)*len:sp(i)*len);
  end
 
 
end

