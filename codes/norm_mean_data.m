%The spherical K-means algorithm
%Usage: Normalize the data set to have mean zero and unit norm
% a is matrix with each data in column , 
%row = number of data samples
%columns= number of features for each data
% b = output = data nomalised with zero mean with same dimensions as that
% of a
function b=norm_mean_data(a)
[n dim]=size(a);
for i=1:n
    b(i,:)=(a(i,:)-mean(a(i,:)))/norm(a(i,:)-mean(a(i,:)),2);
end