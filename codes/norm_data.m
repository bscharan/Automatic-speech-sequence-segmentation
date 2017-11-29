%The spherical K-means algorithm data normalisation
%Usage: Normalize the data set to have unit norm
% a is matrix with each data in column , 
%row = number of data samples
%columns= number of features for each data
% b = output = data nomalised with zero mean with same dimensions as that
% of a

function b=norm_data(a)
[n dim]=size(a);
for i=1:n
   b(i,:)=a(i,:)/norm(a(i,:));
end