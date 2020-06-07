function [reject] = zValue(threshold,dat)

for i = 1:size(dat,1)
    zc(i,:) = (dat(i,:)-mean(dat(i,:)))./std(dat(i,:));
end

zsum = sum(zc./sqrt(size(dat,1)));

if any(abs(zsum) > threshold)
    reject = 2;
else
    reject = 0;
end

end

