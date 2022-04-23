net install PS813_EX2, from(https://weimer.polisci.wisc.edu) 

PS813_EX2 0102

summarize cost_per_household hholds density wage snowdays
di 6.28 * 10000 * 2.5 * 3.53 
* total costing $554210 more than average of 30 municipalities

regress cost_per_household hholds density wage snowdays

**Plot residuals
predict p_cost_per_household

generate resid = cost_per_household - p_cost_per_household

plot resid hholds 
**maybe there is a quadratic pattern? 

plot resid density
plot resid wage
plot resid snowdays

**Include squared term of hholds
gen hholds2 = hholds^2

regress cost_per_household hholds hholds2 density wage snowdays 

**Variance-Covariance model for b
* s^2*(X'X)^-1
* but can easily calculate with.. 
matrix V = get(VCE)
matrix list V, nohalf

matrix x0 = 6.28 \ 6.28^2 \ 620 \ 19.50 \ 5 \ 1

matrix x0tVx0 = (x0')*V*x0
matrix list x0tVx0

**Estimator of the variance of e (s^2)
* we can calculate this using RSS 
* s^2 = RSS / df =  645.855448 / 24
di 645.855448 / 24 
* = 26.910644


**Variance of y_hat 
* var(y0_hat) = s^2 + x0tVx0
di 26.910644 + 2.7406849
* = 29.651329


**Y0_hat
* y0_hat =  -9.821759 * 6.28 +  -.0038076 * 620 +  2.051062 * 19.50 + .9323627 * 5 + .9315048 * 6.28^2
di -9.821759 * 6.28 +  -.0038076 * 620 +  2.051062 * 19.50 + .9323627 * 5 + .9315048 * 6.28^2 + 20.1717
* = 37.524923

**Confidence interval 
* y0_hat +/- tvalue*var(y0_hat)^1/2
di 37.524923 - 2.064 * sqrt(29.651329) 
di 37.524923 + 2.064 * sqrt(29.651329) 
* from 26.285817 to 48.764029

