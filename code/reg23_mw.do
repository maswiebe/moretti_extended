* event study
* MW: my changes are tagged with comments starting with "** MW"

********************************************************************
********************************************************************
********************************************************************
* MOVERS - LEADS AND LAGS
********************************************************************
********************************************************************
********************************************************************

********************************************************************
********************************************************************
********************************************************************
* READ DATA
********************************************************************
********************************************************************
********************************************************************
clear
u $main/data2/data_3
drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

* INCLUDE THE FOLLOWING 6 LINES IF YOU DON'T WANT INTERPOLATED DATA
** MW: I skipped interpolation
/* replace bea    =. if inter_bea   ==1
replace zd     =. if inter_zd    ==1
replace class  =. if inter_class ==1
replace bea    =. if inter_bea2  ==1
replace zd     =. if inter_zd2   ==1
replace class  =. if inter_class2==1 */


* CLUSTER SIZE
g y = log(number)
g x   = log(Den_bea_zd    )
gegen cluster1               = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

** MW: not used
/* gsort inventor year
by inventor : g  x_m1 = x[_n-1]
by inventor : g  x_m2 = x[_n-2]
by inventor : g  x_m3 = x[_n-3]
by inventor : g  x_m4 = x[_n-4]
by inventor : g  x_m5 = x[_n-5]
by inventor : g  x_p1 = x[_n+1]
by inventor : g  x_p2 = x[_n+2]
by inventor : g  x_p3 = x[_n+3]
by inventor : g  x_p4 = x[_n+4]
by inventor : g  x_p5 = x[_n+5] */


gegen org_new2 = group(org_id) if org_id ~= ""



********************************************************************
********************************************************************
********************************************************************
********************************************************************
********************************************************************
********************************************************************

* NUMBER OF PATENTS IN A YEAR
/* g y = log(number) */

* CITATIONS
* To avoid dropping the 0's, I add 0.00001
/* g y2 = log(citations+0.00001)
g y3 = log( (citations+0.00001) / number) */

* SPECIALIZATION
*g y4 = 1-general

* NUMBER OF FIRMS
/* g x3  = log(Den_bea_zdB) */


***********************
***********************
* DEFINE STAR INVENTORS
***********************
***********************
/* keep if total  >=3.25 */



********************************************************************
********************************************************************
********************************************************************
* NEW VARIABLES
********************************************************************
********************************************************************
********************************************************************

**MW: not used
/* gegen cluster1               = group(bea zd) */
/* gegen cluster0               = group(bea zd year) */
/* gegen cluster2               = group(bea ) */
gegen cluster_bea_year       = group(bea year)
/* gegen cluster_bea_zd_year    = group(bea zd year) */
/* gegen cluster_bea_class_year = group(bea class year) */
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)
/* gegen cluster_org_year       = group(org_new year)
gegen org_size               = count(inventor), by(org_new year)
gegen lab_size              = count(inventor), by(org_new year bea) */



********************************************************************
********************************************************************
********************************************************************
* REGRESSIONS
********************************************************************
********************************************************************
********************************************************************
/* keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=. */
/* summ y y2 y3  x
summ number, detail
summ x Den_bea_zd , detail
tab zd */


************************************************************************
************************************************************************

*preserve

* Mover dummy
rename bea_code bea
gsort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
g       move = 0
replace move = 1 if bea ~= bea_m1 & bea ~=. & bea_m1 ~=.



* Indicator for cases where an inventor is in a different city  relative
* to last year she was observed, and last year observed is more than 1 year ago
* In these case, the exact time of the move in unknown
g dyear = year - year_m1
g large_gap = 1 if move ==1 & dyear >1
* Assign this dummy to all years when an inventor is observed
gegen gapp = max(large_gap), by(inventor)
drop large_gap dyear

g move_year = year if move ==1
* Total number of moves by inventor
gegen nn1 = total(move), by(inventor)


* move_year1 is year of first observed move
* It is defined only for those who move once
gegen move_year1 = min(move_year),  by(inventor)
*drop move_year
replace move_year1 = . if nn>1
* Time since move
g tt = year - move_year1

* Keep only movers, when time of the move is exactly identified
* For coding simplicity, I keep those who move once
keep if nn1 ==1 
drop if gapp ==1


* Mean x in the 5 years before the move and the five years after the move
gegen tmp_mm = mean(x) if tt >= -5 & tt <=-1, by(inventor)
gegen tmp_pp = mean(x) if tt >= 1  & tt <= 5, by(inventor)

* tmp_mm and tmp_pp are constants, but they are defined only in the 5 years 
* before the move and the 5 years after the move, repsctively. To run the regression, 
* I assign tmp_mm and tmp_pp to an entire inventor life so that they are not missing
gegen tmp_m = max(tmp_mm),  by(inventor)
gegen tmp_p = max(tmp_pp),  by(inventor)
drop tmp_pp tmp_mm


* Now I interact the average x in the years before and after the move with
* indicators for numbeer of years since the move 
g m1 = (tt==-1)
g m2 = (tt==-2)
g m3 = (tt==-3)
g m4 = (tt==-4)
g m5 = (tt==-5)

g p1 = (tt==1)
g p2 = (tt==2)
g p3 = (tt==3)
g p4 = (tt==4)
g p5 = (tt==5)

/* drop x_p* x_m* */
g  x_m1 = tmp_m*m1
g  x_m2 = tmp_m*m2
g  x_m3 = tmp_m*m3
g  x_m4 = tmp_m*m4
g  x_m5 = tmp_m*m5
g  x_p1 = tmp_p*p1
g  x_p2 = tmp_p*p2
g  x_p3 = tmp_p*p3
g  x_p4 = tmp_p*p4
g  x_p5 = tmp_p*p5

*** MW:
* t=0 indicator
g p0 = (tt==0)
g x_p0 = tmp_p*p0

set scheme plotplainblind

* Stata error on linux: only first subscript renders correctly
* https://www.statalist.org/forums/forum/general-stata-discussion/general/1568841-how-to-fix-subscripts-in-stata-graphs
*lab var x_m5 "{&beta}{subscript:-5}"
* AER changed from unicode to latex, see his code below

lab var x_m5 "{&beta}(-5)"
lab var x_m4 "{&beta}(-4)"
lab var x_m3 "{&beta}(-3)"
lab var x_m2 "{&beta}(-2)"
lab var x_m1 "{&beta}(-1)"
lab var x_p0 "{&beta}(0)"
lab var x_p1 "{&beta}(1)"
lab var x_p2 "{&beta}(2)"
lab var x_p3 "{&beta}(3)"
lab var x_p4 "{&beta}(4)"
lab var x_p5 "{&beta}(5)"
lab var x "{&beta}(0)"

* original regression
reghdfe y x_p5 x_p4 x_p3 x_p2 x_p1 x x_m1 x_m2 x_m3 x_m4 x_m5 ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
est sto m1
file open myfile using "$tables/N_es_orig.txt", write replace
file write myfile (e(N))
file close myfile

*coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5)
gen x_orig = x
gen esample_orig = e(sample)
distinct inventor if esample_orig
* 3k inventors in the event study

* fixed regression
replace x = x_p0
* need to use same variable to plot side-by-side
reghdfe y x_p5 x_p4 x_p3 x_p2 x_p1 x x_m1 x_m2 x_m3 x_m4 x_m5 ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
est sto m2
file open myfile using "$tables/N_es_fix.txt", write replace
file write myfile (e(N))
file close myfile
*coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5)

* combined
coefplot (m1, label(Original)) (m2, label(Corrected)), drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5) legend(pos(6) rows(1))
graph export "$figures/es.pdf", replace
graph export "$figures/es.png", replace

*** 
gegen esample_count = count(inventor_id) if esample_orig, by(inventor_id)
su esample_count
* estimation sample includes inventors with 2-24 observations

*bro inventor year x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5 tt move_year esample_count if esample_orig
* no restriction on time gap between observations

* do any inventors contribute to the regression but have 0s for all time indicators?
egen xcount_temp = rowtotal(x_m5 x_m4 x_m3 x_m2 x_m1 x_p1 x_p2 x_p3 x_p4 x_p5)
gegen xcount = total(xcount_temp), by(inventor)
su xcount if esample_orig ,d
* no

*-------------------------------------------------------
* above, tmp_p is defined excluding year 0
    * ie. average size post-move does not include the first year in the new city
* redo including tt=0 in the post period
replace x = x_orig
gegen tmp_pp0 = mean(x) if tt >= 0  & tt <= 5, by(inventor)
gegen tmp_p0 = max(tmp_pp0),  by(inventor)
drop tmp_pp0

su tmp_p*
* a lot of inventors don't have observations in [1,5], so tmp_pp and tmp_p are undefined
    * but they do have observations at tt=0, by construction, so these get filled in for tmp_p0
    * note: this leads to a drop in observations when using tmp_p*p0, since tmp_p is undefined
        * using tmp_p0 adds them back in
        * the original regression using x does not have any missing obs

g  x_p10 = tmp_p0*p1
g  x_p20 = tmp_p0*p2
g  x_p30 = tmp_p0*p3
g  x_p40 = tmp_p0*p4
g  x_p50 = tmp_p0*p5
g  x_p00 = tmp_p0*p0
lab var x_p00 "{&beta}(0)"
lab var x_p10 "{&beta}(1)"
lab var x_p20 "{&beta}(2)"
lab var x_p30 "{&beta}(3)"
lab var x_p40 "{&beta}(4)"
lab var x_p50 "{&beta}(5)"

* using time-varying x for b0
replace x = x_orig
reghdfe y x_p50 x_p40 x_p30 x_p20 x_p10 x x_m1 x_m2 x_m3 x_m4 x_m5 ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
est sto m3
file open myfile using "$tables/N_es_orig_incl0.txt", write replace
file write myfile (e(N))
file close myfile
*coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p10 x_p20 x_p30 x_p40 x_p50)

* fixed regression: using x=tmp_p0*t0
replace x = x_p00
reghdfe y x_p50 x_p40 x_p30 x_p20 x_p10 x x_m1 x_m2 x_m3 x_m4 x_m5 ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
est sto m4
file open myfile using "$tables/N_es_fix_incl0.txt", write replace
file write myfile (e(N))
file close myfile
*coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p10 x_p20 x_p30 x_p40 x_p50)

* combined
coefplot (m3, label(Original)) (m4, label(Corrected)), drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p10 x_p20 x_p30 x_p40 x_p50) legend(pos(6) rows(1))
graph export "$figures/es_incl0.pdf", replace
graph export "$figures/es_incl0.png", replace


*-----------------------------------------------
* the original event study is nonstandard
* instead of a constant treatment variable, it interacts average cluster size over the preperiod (tmp_m) with the preperiod years, and average cluster size over the post-period (tmp_p) with the post-period years
    * here I use a constant treatment variable: difference in average cluster size, post - pre.
* it includes observations from outside of [-5,5] in event time
    * I restrict to observations within [-5,5]
* it does not omit t=-1 as the reference year
    * I omit t=-1

gen size_diff = tmp_p0 - tmp_m

su size_diff x_orig,d
* variation in cluster size from moving

g sd_p0 = size_diff*p0
g sd_p1 = size_diff*p1
g sd_p2 = size_diff*p2
g sd_p3 = size_diff*p3
g sd_p4 = size_diff*p4
g sd_p5 = size_diff*p5
g sd_m1 = size_diff*m1
g sd_m2 = size_diff*m2
g sd_m3 = size_diff*m3
g sd_m4 = size_diff*m4
g sd_m5 = size_diff*m5

lab var sd_p0 "{&beta}(0)"
lab var sd_p1 "{&beta}(1)"
lab var sd_p2 "{&beta}(2)"
lab var sd_p3 "{&beta}(3)"
lab var sd_p4 "{&beta}(4)"
lab var sd_p5 "{&beta}(5)"
lab var sd_m1 "{&beta}(-1)"
lab var sd_m2 "{&beta}(-2)"
lab var sd_m3 "{&beta}(-3)"
lab var sd_m4 "{&beta}(-4)"
lab var sd_m5 "{&beta}(-5)"

reghdfe y sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo m5
* include sd_m1 last, so reghdfe omits it
file open myfile using "$tables/N_es_fixed.txt", write replace
file write myfile (e(N))
file close myfile
coefplot m5, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted
graph export "$figures/es_fixed.pdf", replace
graph export "$figures/es_fixed.png", replace

* what causes jump in CIs at t=0? 
reghdfe y sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
coefplot, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted
* using constant treatment variable but not restricting to [-5,5], does not happen

* don't get CI jump in any previous regressions when restricting to [-5,5]
replace x = x_orig 
reghdfe y x_p5 x_p4 x_p3 x_p2 x_p1 x x_m1 x_m2 x_m3 x_m4 x_m5 if inrange(tt,-5,5) ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5)

replace x = x_p0
reghdfe y x_p5 x_p4 x_p3 x_p2 x_p1 x x_m1 x_m2 x_m3 x_m4 x_m5 if inrange(tt,-5,5) ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p1 x_p2 x_p3 x_p4 x_p5)

replace x = x_p00
reghdfe y x_p50 x_p40 x_p30 x_p20 x_p10 x x_m1 x_m2 x_m3 x_m4 x_m5 if inrange(tt,-5,5) ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  
coefplot, drop(_cons) vert order(x_m5 x_m4 x_m3 x_m2 x_m1 x x_p10 x_p20 x_p30 x_p40 x_p50)

* so must be combination of using constant treatment variable and using full set of interactions
    * using separate tmp_m and tmp_p0 allows an extra 'degree of freedom'

*** use constant treatment variable, but don't interact with t0, don't restrict sample, and don't omit t-1
    * doesn't work, since size_diff is not time-varying, collinear with inventor FE
    * Moretti's code (no interaction for t0) works because x is time-varying

*** 
* binary diff in diff (instead of continuous)
* shouldn't think of treated=move_up, and control = move_down
    * move_down is really a negative treatment, not the lack of treatment
    * with stayers, do reg y move_up move_down; ie, include both
    * or is this Move X Move_up, triple diff

gen move_up = (size_diff > 0)

g b_p0 = move_up*p0
g b_p1 = move_up*p1
g b_p2 = move_up*p2
g b_p3 = move_up*p3
g b_p4 = move_up*p4
g b_p5 = move_up*p5
g b_m1 = move_up*m1
g b_m2 = move_up*m2
g b_m3 = move_up*m3
g b_m4 = move_up*m4
g b_m5 = move_up*m5

lab var b_p0 "{&beta}(0)"
lab var b_p1 "{&beta}(1)"
lab var b_p2 "{&beta}(2)"
lab var b_p3 "{&beta}(3)"
lab var b_p4 "{&beta}(4)"
lab var b_p5 "{&beta}(5)"
lab var b_m1 "{&beta}(-1)"
lab var b_m2 "{&beta}(-2)"
lab var b_m3 "{&beta}(-3)"
lab var b_m4 "{&beta}(-4)"
lab var b_m5 "{&beta}(-5)"

reghdfe y b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo m6
* include b_m1 last, so reghdfe omits it
    * need to include it for the plot to show the omitted year
file open myfile using "$tables/N_es_binary.txt", write replace
file write myfile (e(N))
file close myfile
coefplot m6, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted
graph export "$figures/es_binary.pdf", replace
graph export "$figures/es_binary.png", replace
* slight positive effect, but looks like a trend


***
* binary event study with Sun and Abraham estimator
* didn't work

/* ssc install eventstudyinteract, replace
ssc install event_plot, replace

summ tt
local relmin = abs(r(min))
local relmax = abs(r(max))

* leads (before treatment)
cap drop F_*
forval x = 2/`relmin' {  
    * drop the first lead
    gen F_`x' = tt == -`x'
}

* lags (after treatment)
cap drop L_*
forval x = 0/`relmax' {
    gen L_`x' = tt ==  `x'
}

* last-treated cohort
    * can also use never-treated cohort
sum move_year1
gen last_cohort = move_year1==r(max) */
/* 
eventstudyinteract y L_* F_* if inrange(tt,-5,5), vce(cluster cluster1) absorb(cluster1 year) cohort(move_year1) control_cohort(last_cohort)
* takes >30min

eventstudyinteract y L_* F_*, vce(cluster cluster1) absorb(cluster1 year) cohort(move_year1) control_cohort(last_cohort)
* takes >10min

event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Periods since the event") ytitle("Average effect") xlabel(-10(1)10) title("eventstudyinteract")) stub_lag(L_#) stub_lead(F_#) trimlag(10) trimlead(10) together

* allows other FEs beyond two-way?
eventstudyinteract y L_* F_*, vce(cluster cluster1) absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) cohort(move_year1) control_cohort(last_cohort) */


*------------------------------------------
*** include stayers
* triple diff: Move X Move_up X Post
set scheme plotplainblind

u $main/data2/data_3, clear
drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

g y = log(number)
g x   = log(Den_bea_zd    )
gegen cluster1               = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

gegen org_new2 = group(org_id) if org_id ~= ""
gegen cluster_bea_year       = group(bea year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

rename bea_code bea
gsort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
g       move = 0
replace move = 1 if bea ~= bea_m1 & bea ~=. & bea_m1 ~=.

g dyear = year - year_m1
g large_gap = 1 if move ==1 & dyear >1
gegen gapp = max(large_gap), by(inventor)
drop large_gap dyear

g move_year = year if move ==1
gegen nn1 = total(move), by(inventor)

gegen move_year1 = min(move_year),  by(inventor)
replace move_year1 = . if nn>1
g tt = year - move_year1

* keep move-once and stayers
keep if inrange(nn1,0,1)
* keep movers where move occurs in consecutive observations (timing of move is known)
drop if gapp ==1

gegen tmp_pp0 = mean(x) if tt >= 0  & tt <= 5, by(inventor)
gegen tmp_p0 = max(tmp_pp0),  by(inventor)
gegen tmp_mm = mean(x) if tt >= -5 & tt <=-1, by(inventor)
gegen tmp_m = max(tmp_mm),  by(inventor)
drop tmp_pp0 tmp_mm
gen size_diff = tmp_p0 - tmp_m
* assign size_diff=0 for stayers
replace size_diff = 0 if nn1==0

gen move_up = (size_diff > 0)

forval i = 1/5 {
    gen m`i' = (tt == -`i')
    * this assigns 0 if tt is missing
}
forval i = 0/5 {
    gen p`i' = (tt == `i')
}

*bro inventor_id year nn1 tt x tmp_m tmp_p0 size_diff
* just need treatment variables to be 0 for control group

g b_p0 = move_up*p0
g b_p1 = move_up*p1
g b_p2 = move_up*p2
g b_p3 = move_up*p3
g b_p4 = move_up*p4
g b_p5 = move_up*p5
g b_m1 = move_up*m1
g b_m2 = move_up*m2
g b_m3 = move_up*m3
g b_m4 = move_up*m4
g b_m5 = move_up*m5

lab var b_p0 "{&beta}(0)"
lab var b_p1 "{&beta}(1)"
lab var b_p2 "{&beta}(2)"
lab var b_p3 "{&beta}(3)"
lab var b_p4 "{&beta}(4)"
lab var b_p5 "{&beta}(5)"
lab var b_m1 "{&beta}(-1)"
lab var b_m2 "{&beta}(-2)"
lab var b_m3 "{&beta}(-3)"
lab var b_m4 "{&beta}(-4)"
lab var b_m5 "{&beta}(-5)"

gegen mover = total(move), by(inventor)
gen post = (year >= move_year1)

gen moverXpost = mover*post
* post is only defined for movers, so moverXpost = post
    * so post is not collinear with year FE, since always 0 for stayers
gen move_upXpost = move_up*post

*** binary DDD
reghdfe y post move_upXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* effect for movers (compared to stayers), and differential effect for move_up
* not statsig

*reghdfe y mover##post##move_up if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* move_up is a subset of mover
    * mover*move_up = move_up
* all collinear except post and post#move_up
    * post is not collinear with year FE, since post is always 0 for stayers

* binary DDD event study
    * need coefficients for Post and Moveup*Post
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* this is event study for B7 term: move_up*post
file open myfile using "$tables/N_es_binary_ddd.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted keep(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5)
graph export "$figures/es_binary_ddd.pdf", replace
graph export "$figures/es_binary_ddd.png", replace
* positive effect in -2, otherwise nothing

*** cts DDD
gen size_diffXpost = size_diff*post

reghdfe y moverXpost size_diffXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)

* continuous
g sd_p0 = size_diff*p0
g sd_p1 = size_diff*p1
g sd_p2 = size_diff*p2
g sd_p3 = size_diff*p3
g sd_p4 = size_diff*p4
g sd_p5 = size_diff*p5
g sd_m1 = size_diff*m1
g sd_m2 = size_diff*m2
g sd_m3 = size_diff*m3
g sd_m4 = size_diff*m4
g sd_m5 = size_diff*m5

lab var sd_p0 "{&beta}(0)"
lab var sd_p1 "{&beta}(1)"
lab var sd_p2 "{&beta}(2)"
lab var sd_p3 "{&beta}(3)"
lab var sd_p4 "{&beta}(4)"
lab var sd_p5 "{&beta}(5)"
lab var sd_m1 "{&beta}(-1)"
lab var sd_m2 "{&beta}(-2)"
lab var sd_m3 "{&beta}(-3)"
lab var sd_m4 "{&beta}(-4)"
lab var sd_m5 "{&beta}(-5)"

* cts DDD event study
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
file open myfile using "$tables/N_es_cts_ddd.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted keep(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5)
graph export "$figures/es_cts_ddd.pdf", replace
graph export "$figures/es_cts_ddd.png", replace


*--------------------------------------
*** origin imputation
set scheme plotplainblind

use "$main/data2/data_3_origin", clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

g y = log(number+1)
replace y=0 if missing(y)
* need to use log(y+1), since now have number=0 with imputed observations
    * filled-in obs have number=.
g x   = log(Den_bea_zd    )
gegen cluster1               = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

gegen org_new2 = group(org_id) if org_id ~= ""
gegen cluster_bea_year       = group(bea year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

rename bea_code bea
gsort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
g       move = 0
replace move = 1 if bea ~= bea_m1 & bea ~=. & bea_m1 ~=.

*g dyear = year - year_m1
** MW: with imputed data, no year gaps
*g large_gap = 1 if move ==1 & dyear >1
g large_gap = 1 if move ==1 & (_fillin==1 | _fillin[_n-1]==1)
* don't count moves defined using imputed data, since timing of move is unidentified
gegen gapp = max(large_gap), by(inventor)
drop large_gap

g move_year = year if move ==1
gegen nn1 = total(move), by(inventor)

gegen move_year1 = min(move_year),  by(inventor)
replace move_year1 = . if nn>1
g tt = year - move_year1

* keep move-once and stayers
keep if inrange(nn1,0,1)
* keep movers where move occurs in consecutive observations (timing of move is known)
drop if gapp ==1

gegen tmp_pp0 = mean(x) if tt >= 0  & tt <= 5, by(inventor)
gegen tmp_p0 = max(tmp_pp0),  by(inventor)
gegen tmp_mm = mean(x) if tt >= -5 & tt <=-1, by(inventor)
gegen tmp_m = max(tmp_mm),  by(inventor)
drop tmp_pp0 tmp_mm
gen size_diff = tmp_p0 - tmp_m
* assign size_diff=0 for stayers
replace size_diff = 0 if nn1==0

gen move_up = (size_diff > 0)

forval i = 1/5 {
    gen m`i' = (tt == -`i')
    * this assigns 0 if tt is missing
}
forval i = 0/5 {
    gen p`i' = (tt == `i')
}

g b_p0 = move_up*p0
g b_p1 = move_up*p1
g b_p2 = move_up*p2
g b_p3 = move_up*p3
g b_p4 = move_up*p4
g b_p5 = move_up*p5
g b_m1 = move_up*m1
g b_m2 = move_up*m2
g b_m3 = move_up*m3
g b_m4 = move_up*m4
g b_m5 = move_up*m5

lab var b_p0 "{&beta}(0)"
lab var b_p1 "{&beta}(1)"
lab var b_p2 "{&beta}(2)"
lab var b_p3 "{&beta}(3)"
lab var b_p4 "{&beta}(4)"
lab var b_p5 "{&beta}(5)"
lab var b_m1 "{&beta}(-1)"
lab var b_m2 "{&beta}(-2)"
lab var b_m3 "{&beta}(-3)"
lab var b_m4 "{&beta}(-4)"
lab var b_m5 "{&beta}(-5)"

gegen mover = total(move), by(inventor)
gen post = (year >= move_year1)

gen moverXpost = mover*post
gen move_upXpost = move_up*post

* continuous DD
g sd_p0 = size_diff*p0
g sd_p1 = size_diff*p1
g sd_p2 = size_diff*p2
g sd_p3 = size_diff*p3
g sd_p4 = size_diff*p4
g sd_p5 = size_diff*p5
g sd_m1 = size_diff*m1
g sd_m2 = size_diff*m2
g sd_m3 = size_diff*m3
g sd_m4 = size_diff*m4
g sd_m5 = size_diff*m5

lab var sd_p0 "{&beta}(0)"
lab var sd_p1 "{&beta}(1)"
lab var sd_p2 "{&beta}(2)"
lab var sd_p3 "{&beta}(3)"
lab var sd_p4 "{&beta}(4)"
lab var sd_p5 "{&beta}(5)"
lab var sd_m1 "{&beta}(-1)"
lab var sd_m2 "{&beta}(-2)"
lab var sd_m3 "{&beta}(-3)"
lab var sd_m4 "{&beta}(-4)"
lab var sd_m5 "{&beta}(-5)"

*** binary DD
reghdfe y b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* exclude stayers
eststo mo1
file open myfile using "$tables/N_es_binary_origin.txt", write replace
file write myfile (e(N))
file close myfile
coefplot mo1, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted
graph export "$figures/es_binary_origin.pdf", replace
graph export "$figures/es_binary_origin.png", replace

*** continuous DD
reghdfe y sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* exclude stayers
eststo mo2
file open myfile using "$tables/N_es_cts_origin.txt", write replace
file write myfile (e(N))
file close myfile
coefplot mo2, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted
graph export "$figures/es_cts_origin.pdf", replace
graph export "$figures/es_cts_origin.png", replace

*** binary DDD
reghdfe y moverXpost move_upXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)

* DDD event study
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo mo3
file open myfile using "$tables/N_es_binary_ddd_origin.txt", write replace
file write myfile (e(N))
file close myfile
coefplot mo3, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted keep(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5)
* 
graph export "$figures/es_binary_ddd_origin.pdf", replace
graph export "$figures/es_binary_ddd_origin.png", replace

*** cts DDD
gen size_diffXpost = size_diff*post

reghdfe y moverXpost size_diffXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)

* cts DDD event study
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo mo4
file open myfile using "$tables/N_es_cts_ddd_origin.txt", write replace
file write myfile (e(N))
file close myfile
coefplot mo4, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted keep(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5)
graph export "$figures/es_cts_ddd_origin.pdf", replace
graph export "$figures/es_cts_ddd_origin.png", replace

*--------------------------------------
*** destination imputation
set scheme plotplainblind

use "$main/data2/data_3_destination", clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

g y = log(number+1)
replace y=0 if missing(y)
* need to use log(y+1), since now have number=0 with imputed observations
    * filled-in obs have number=.
g x   = log(Den_bea_zd    )
gegen cluster1               = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

gegen org_new2 = group(org_id) if org_id ~= ""
gegen cluster_bea_year       = group(bea year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

rename bea_code bea
gsort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
g       move = 0
replace move = 1 if bea ~= bea_m1 & bea ~=. & bea_m1 ~=.

*g dyear = year - year_m1
    ** MW: with imputed data, no year gaps
*g large_gap = 1 if move ==1 & dyear >1
g large_gap = 1 if move ==1 & (_fillin==1 | _fillin[_n-1]==1)
* don't count moves defined using imputed data, since timing of move is unidentified
    * eg. t=0, in city A; t=10, in city B; missing observations from t=1:9.
    * imputation will say the move occurred in t=1 (destination) or t=10 (origin)
gegen gapp = max(large_gap), by(inventor)
drop large_gap 

g move_year = year if move ==1
gegen nn1 = total(move), by(inventor)

gegen move_year1 = min(move_year),  by(inventor)
replace move_year1 = . if nn>1
g tt = year - move_year1

* keep move-once and stayers
keep if inrange(nn1,0,1)
* keep movers where move occurs in consecutive observations (timing of move is known/identified)
drop if gapp ==1

gegen tmp_pp0 = mean(x) if tt >= 0  & tt <= 5, by(inventor)
gegen tmp_p0 = max(tmp_pp0),  by(inventor)
gegen tmp_mm = mean(x) if tt >= -5 & tt <=-1, by(inventor)
gegen tmp_m = max(tmp_mm),  by(inventor)
drop tmp_pp0 tmp_mm
gen size_diff = tmp_p0 - tmp_m
* assign size_diff=0 for stayers
replace size_diff = 0 if nn1==0

gen move_up = (size_diff > 0)

forval i = 1/5 {
    gen m`i' = (tt == -`i')
    * this assigns 0 if tt is missing
}
forval i = 0/5 {
    gen p`i' = (tt == `i')
}

*bro inventor_id year nn1 tt x tmp_m tmp_p0 size_diff

g b_p0 = move_up*p0
g b_p1 = move_up*p1
g b_p2 = move_up*p2
g b_p3 = move_up*p3
g b_p4 = move_up*p4
g b_p5 = move_up*p5
g b_m1 = move_up*m1
g b_m2 = move_up*m2
g b_m3 = move_up*m3
g b_m4 = move_up*m4
g b_m5 = move_up*m5

lab var b_p0 "{&beta}(0)"
lab var b_p1 "{&beta}(1)"
lab var b_p2 "{&beta}(2)"
lab var b_p3 "{&beta}(3)"
lab var b_p4 "{&beta}(4)"
lab var b_p5 "{&beta}(5)"
lab var b_m1 "{&beta}(-1)"
lab var b_m2 "{&beta}(-2)"
lab var b_m3 "{&beta}(-3)"
lab var b_m4 "{&beta}(-4)"
lab var b_m5 "{&beta}(-5)"

gegen mover = total(move), by(inventor)
gen post = (year >= move_year1)

gen moverXpost = mover*post
gen move_upXpost = move_up*post

* continuous DD
g sd_p0 = size_diff*p0
g sd_p1 = size_diff*p1
g sd_p2 = size_diff*p2
g sd_p3 = size_diff*p3
g sd_p4 = size_diff*p4
g sd_p5 = size_diff*p5
g sd_m1 = size_diff*m1
g sd_m2 = size_diff*m2
g sd_m3 = size_diff*m3
g sd_m4 = size_diff*m4
g sd_m5 = size_diff*m5

lab var sd_p0 "{&beta}(0)"
lab var sd_p1 "{&beta}(1)"
lab var sd_p2 "{&beta}(2)"
lab var sd_p3 "{&beta}(3)"
lab var sd_p4 "{&beta}(4)"
lab var sd_p5 "{&beta}(5)"
lab var sd_m1 "{&beta}(-1)"
lab var sd_m2 "{&beta}(-2)"
lab var sd_m3 "{&beta}(-3)"
lab var sd_m4 "{&beta}(-4)"
lab var sd_m5 "{&beta}(-5)"

*** binary DD
reghdfe y b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* exclude stayers
eststo
file open myfile using "$tables/N_es_binary_dest.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted
graph export "$figures/es_binary_dest.pdf", replace
graph export "$figures/es_binary_dest.png", replace

*** continuous DD
reghdfe y sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5), absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* exclude stayers
eststo
file open myfile using "$tables/N_es_cts_dest.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted
graph export "$figures/es_cts_dest.pdf", replace
graph export "$figures/es_cts_dest.png", replace

*** binary DDD
reghdfe y moverXpost move_upXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
* -0.04 for move_down, -0.04+0.04 = 0 for move_up

* DDD event study
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 b_m5 b_m4 b_m3 b_m2 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5 b_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo
file open myfile using "$tables/N_es_binary_ddd_dest.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5) omitted keep(b_m5 b_m4 b_m3 b_m2 b_m1 b_p0 b_p1 b_p2 b_p3 b_p4 b_p5)
* 
graph export "$figures/es_binary_ddd_dest.pdf", replace
graph export "$figures/es_binary_ddd_dest.png", replace

*** cts DDD
gen size_diffXpost = size_diff*post

reghdfe y moverXpost size_diffXpost if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)

* cts DDD event study
reghdfe y m5 m4 m3 m2 p0 p1 p2 p3 p4 p5 sd_m5 sd_m4 sd_m3 sd_m2 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5 sd_m1 if inrange(tt,-5,5)|missing(tt)==1, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)
eststo
file open myfile using "$tables/N_es_cts_ddd_dest.txt", write replace
file write myfile (e(N))
file close myfile
coefplot, drop(_cons) vert order(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5) omitted keep(sd_m5 sd_m4 sd_m3 sd_m2 sd_m1 sd_p0 sd_p1 sd_p2 sd_p3 sd_p4 sd_p5)
graph export "$figures/es_cts_ddd_dest.pdf", replace
graph export "$figures/es_cts_ddd_dest.png", replace

