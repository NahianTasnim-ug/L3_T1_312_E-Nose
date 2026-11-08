function [x y] = splitter(A,p,a)
y=a*ones(p,1);

[m n]=size(A);
part_sizes=ceil(m/p)*ones(1,p-1);
part_sizes(end+1)=m-sum(part_sizes);
C=mat2cell(A,part_sizes,n);

for i=1:p
    matrix= cell2mat(C(i,1,:));
    [Mean, mod, med, stdval, diff, skew, kurt, prcntl,Rms] = feature_extraction(matrix);
    x(i,:)=[Mean mod med stdval diff skew prcntl Rms];
end
end