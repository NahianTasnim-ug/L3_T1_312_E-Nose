function [Mean mod med stdval diff skew kurt prcntl Rms] = feature_extraction(matrix)

Mean = mean(matrix);
mod = mode(matrix);
med = median(matrix);
stdval = std(matrix);
diff = abs(max(matrix)-min(matrix));
skew = skewness(matrix);
kurt = kurtosis(matrix);
p=[25 50 75 85 40];
prcntl=prctile(matrix,p);
prcntl=reshape(prcntl,1,[]);
Rms = rms(matrix);
%gmean=geomean(matrix);

end