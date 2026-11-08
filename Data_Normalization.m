function [D] = Data_Normalization(B,MIN,MAX)
n=size(B,2);
R=B;

% for i=1:n
%     temp=B(:,i);
%     A(:,i)=(temp-min(temp))/(max(temp)-min(temp));
% end

for i=1:n
   
    R(:,i)=(B(:,i)-MIN(i))/(MAX(i)-MIN(i));
end
D=R;

end