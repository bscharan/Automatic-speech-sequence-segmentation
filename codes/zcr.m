function y = ZCR(x)
y = sum(abs(diff(x>0)))/length(x);
end
