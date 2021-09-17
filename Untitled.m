cd(fileparts(which('Debug_Test_Scripts')));
load('pacing_time_test.mat')
scatter([data{:,1}],[data{:,2}]);
at = [data{:,2}];
wt = [data{:,1}];
scatter(wt,at);
coefs = polyfit(wt, at, 1);
y = coefs(2)+(coefs(1)*wt);
hold on
plot(wt,y);title(num2str(coefs(1)));

actual = input('actual: ');
(actual - coefs(2))/coefs(1)