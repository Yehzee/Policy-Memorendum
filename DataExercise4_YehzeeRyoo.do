
net install PS813_EX4, from(https://weimer.polisci.wisc.edu)

PS813_EX4 0102

*logit Regression 
logit Probat Report Convict Take Night 

global xlist Report Convict Take Night
global ylist Probat

summarize $ylist $xlist

*coefficients
logit $ylist $xlist

*odds ratio
logistic $ylist $xlist


*Coefficient and Covariances from the Regression
matrix define b = e(b)
matrix define V = e(V)

matrix list b 
matrix list V


*Calculate the logit bounds 
**capture program drop = preventing premanent changes in live editing 
capture program drop Logit_bounds 

program define Logit_bounds  
drop _all 

drawnorm c_report c_convict c_take c_night c_cons, means(b) cov(V) cstorage(full) n(1000)

generate z=`1'*c_report+`2'*c_convict+`3'*c_take+`4'*c_night+c_cons
generate p = 1/(1+exp(-z))
sum p, d
end 

**** Logit_bounds Report Convict Take Night *****
* mean_Take = 5120.95
* mean_Convict = 1.746429

*when Report is 0 and Night is 0 and others are mean values
Logit_bounds 0 1.746429 5120.95 0 
*when Report is 1 and others are the same with the previous setting
Logit_bounds 1 1.746429 5120.95 0 

*Convict 0 to 5
Logit_bounds 0 0 5120.95 0 
Logit_bounds 0 1 5120.95 0 
Logit_bounds 0 2 5120.95 0 
Logit_bounds 0 3 5120.95 0 
Logit_bounds 0 4 5120.95 0 
Logit_bounds 0 5 5120.95 0 


Logit_bounds 1 0 5120.95 0 
Logit_bounds 1 1 5120.95 0 
Logit_bounds 1 2 5120.95 0 
Logit_bounds 1 3 5120.95 0 
Logit_bounds 1 4 5120.95 0 
Logit_bounds 1 5 5120.95 0 


graph twoway (scatter yhat Convict if Report==0) (scatter yhat Convict if Report==1), ///
 legend(label(1 No report) label(2 Report)) 



*sensitivity test
net install PS813_EX4, from(https://weimer.polisci.wisc.edu)
PS813_EX4 0102

logit Probat Report Convict Take Night 
predict yhat
scatter yhat Report
scatter yhat Convict

margins, dydx(*)
marginsplot

lstat 
*(lstat = same with the 'estat classification' function)
** what I am reporting = 86.43% (correctly classified); 

lroc, title("ROC curve") xtitle(False Positive Rate) ytitle(True Positive Rate)

