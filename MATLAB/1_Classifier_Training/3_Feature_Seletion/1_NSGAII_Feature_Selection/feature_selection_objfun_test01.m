function [y, cons] = feature_selection_objfun_test01(x,test)
% disp('------------------------------')
% disp(x)
%disp('------------------------------')
cons = [];
% disp(' -------------------------------')
if (sum(x)>0)
    %Two objective
    y(1) = test.meas_accuracy(x);
    y(1) = 1 - y(1); 
    y(2) = sum(x);
%     if (y(2)>50)
%         y(2) = 580;
%     end
else
y(1) = 1;
y(2) = 581;
end

%disp('*********************************************')
%disp(y)
%disp('*********************************************')

