*------------------------------------------------------------------------
*** Fig 5 sample

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

gegen total = sum(number), by(inventor)

keep if total  >=3.25

g x   = log(Den_bea_zd    )

sort inventor year
by inventor : g  x_m1 = x[_n-1]
by inventor : g  x_m2 = x[_n-2]
by inventor : g  x_m3 = x[_n-3]
by inventor : g  x_m4 = x[_n-4]
by inventor : g  x_m5 = x[_n-5]
by inventor : g  x_p1 = x[_n+1]
by inventor : g  x_p2 = x[_n+2]
by inventor : g  x_p3 = x[_n+3]
by inventor : g  x_p4 = x[_n+4]
by inventor : g  x_p5 = x[_n+5]

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

reghdfe y x_p5 x_p4 x_p3 x_p2 x_p1 x x_m1 x_m2 x_m3 x_m4 x_m5 ,absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new  ) vce(cluster cluster1)  

su total if e(sample),d
* average: 23.5
su total,d
* average: 10.1

*------------------------------------------------------------------------
*** main results for top 10%

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

gegen total = sum(number), by(inventor)

keep if total  >=3.25

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_replicate.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*------------------------------------------------------------------------
*** main results for bottom 90%

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)

* use bottom 90% inventors
keep if total  <3.25
*keep if total  >=3.25

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") 
esttab m* using "$tables/t3_b90.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") 


*------------------------------------------------------------------------
*** full sample, interact with top10 indicator

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)

*keep if total  >=3.25

g x   = log(Den_bea_zd    )
gen top10 = (total >= 3.25)
gen sizeXtop10 = x*top10

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"
lab var top10 "Top 10\%"
lab var sizeXtop10 "Log size $\times$ Top 10\%"

eststo clear
qui reghdfe y x sizeXtop10 top10, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x sizeXtop10 top10, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x sizeXtop10 top10, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x sizeXtop10 top10, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x sizeXtop10 top10, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x sizeXtop10, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x sizeXtop10, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x sizeXtop10, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") order(x sizeXtop10 top10)
esttab m* using "$tables/t3_highlow.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") order(x sizeXtop10 top10)


*------------------------------------------------------------------------
*** movers and stayers

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)
keep if total  >=3.25

rename zd2 zd
rename bea_code bea

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

sort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
by inventor : g  zd_m1 = zd[_n-1]

gegen spell = count(y), by(inventor_id)
* 606 with spell=1; dropped in regression (by inventor FEs)
*tab spell
* 1-35, mode=6, mean=9
drop if spell==1

* move in year t
    * across field or city
    * this is broader than field-only or city-only
g       move = 0
replace move = 1 if (bea ~= bea_m1 & bea ~=. & bea_m1 ~=.) | (zd_m1 ~= zd & zd ~=. & zd_m1 ~=.)
gegen evermove = max(move), by(inventor_id)

* move field-only
g move_field = 0
replace move_field = 1 if (zd_m1 ~= zd & zd ~=. & zd_m1 ~=.)
gegen evermove_field = max(move_field), by(inventor_id)

* move city-only
g move_city = 0
replace move_city = 1 if (bea ~= bea_m1 & bea ~=. & bea_m1 ~=.)
gegen evermove_city = max(move_city), by(inventor_id)

gen evermove_field_only = evermove_field
replace evermove_field_only = 0 if evermove_city==1

gen evermove_city_only = evermove_city
replace evermove_city_only = 0 if evermove_field==1

preserve
collapse evermove evermove_field evermove_city evermove_field_only evermove_city_only, by(inventor)
su
* movers are 67% of inventors, stayers are 33%
restore

tab evermove
* 72% of obs change clusters, 28% stay
    * so movers have more patents than stayers

*--------------------
*** does missingness of firm data vary by mover?
tab evermove
count if missing(org_id) & evermove==1
* 70797 / 674003 = 10%
count if missing(org_id) & evermove==0
* 37764 / 258113 = 15%

*--------------------
*** do movers move to large clusters?
* need to generate spells by inventor-cluster, since could be >2 clusters per inventor

tsset inventor_id year
gegen group_inventor_cluster = group(inventor_id cluster1)
tsspell group_inventor_cluster, fcond((group_inventor_cluster != group_inventor_cluster[_n-1]) | (_n == 1))
* allow gaps in year

* cluster size by inventor-cluster and spell
gegen size_inv_cl_sp = mean(Den_bea_zd), by(group_inventor_cluster _spell)
by inventor_id : g  size_after = size_inv_cl_sp if move==1
by inventor_id: g  size_before = size_inv_cl_sp[_n-1] if move==1
* note that this generates one value per inventor-spell
    * don't need to collapse to inventor-spell level to calculate average across inventors

bro year inventor_id cluster1 group_inventor_cluster _spell move size_inv_cl_sp size_before size_after
* eg. inventor_id==212
    * city: 137 -> 173 -> 138 -> 173 -> 137 -> 138 -> 137 -> 173
    * could be an artifact of breaking ties, when selecting modal cluster

ttest size_before == size_after 
* t = 0.71, p = 0.48

gen size_diff = size_after - size_before
su size_diff
* no change in cluster size

*--------------------
*** how does cluster size change during a spell for stayers?

gen size_sp_start_temp = Den_bea_zd if _seq==1
gegen size_sp_start = max(size_sp_start_temp), by(group_inventor_cluster _spell)
gen size_sp_end_temp = Den_bea_zd if _end==1
gegen size_sp_end = max(size_sp_end_temp), by(group_inventor_cluster _spell)
gen size_sp_diff = size_sp_end - size_sp_start

bro year inventor_id cluster1 group_inventor_cluster _spell move size_sp_start size_sp_end size_sp_diff _end

su size_sp_diff if evermove==0 & _end
* -0.0015
su size_sp_diff if evermove==0 
* different, because assigning more weight to longer spells

su Den_bea_zd
* 0.0459
* so for stayers, on average, cluster size decreases by 0.0015/0.0459 = 3% of the average cluster size

* using city size
gen size_bea_sp_start_temp = Den_bea if _seq==1
gegen size_bea_sp_start = max(size_bea_sp_start_temp), by(group_inventor_cluster _spell)
gen size_bea_sp_end_temp = Den_bea if _end==1
gegen size_bea_sp_end = max(size_bea_sp_end_temp), by(group_inventor_cluster _spell)
gen size_bea_sp_diff = size_bea_sp_end - size_bea_sp_start
su size_bea_sp_diff if evermove==1 & _end
* 0.0000
su size_bea_sp_diff if evermove==0 & _end
* -0.0015
    * so almost all of the decrease for stayers is from decreasing city size

*---------------------
*** heterogeneous TEs by movers and stayers

gen evermoveXsize = evermove*x

lab var x "Log size"
lab var evermove "Mover"
lab var evermoveXsize "Log size $\times$ Mover"

eststo clear
qui reghdfe y x evermoveXsize evermove, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x evermoveXsize evermove, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x evermoveXsize evermove, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x evermoveXsize evermove, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x evermoveXsize evermove, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x evermoveXsize, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x evermoveXsize, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x evermoveXsize, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") order(x evermoveXsize evermove)
esttab m* using "$tables/t3_het_mover.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm") order(x evermoveXsize evermove)

*------------------------------------------------------------
*** alternate measures of cluster size

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)
keep if total  >=3.25

g num_zd_bea = log(number_zd_bea)
g num_zd_other_bea = log(number_zd_other_bea)
* could make these densities, by normalizing by national field size; but equivalent with field-year FEs
g num_zd_bea_org = log(number_zd_bea_org)
g num_zd_bea_other_org = log(number_zd_bea_other_org)

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var num_zd_bea "Log size (city-field)"
lab var num_zd_other_bea "Log size (other-city, field)"
lab var num_zd_bea_org "Log size (own-firm)"
lab var num_zd_bea_other_org "Log size (other-firm)"

*** horse race: own-city vs other-city (within-field)
eststo clear
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y num_zd_bea num_zd_other_bea, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")
esttab m* using "$tables/t3_own_other_city.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")

*** horse race: own-firm vs other-firm (within city-field)
eststo clear
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y num_zd_bea_org num_zd_bea_other_org, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")
esttab m* using "$tables/t3_own_other_org.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")

su number_*,d
* median number of inventors by city-field: 843
* median number of inventors by other-city, field: 29990
* median number of inventors by own-firm: 15
* median number of inventors by other-firm: 764

*-------------------------------------------------------------------
*** imputation summary stats
u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)
keep if total  >=3.25

rename zd2 zd
rename bea_code bea

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

sort inventor year
by inventor : g  bea_m1 = bea[_n-1]
by inventor : g  year_m1 = year[_n-1]
by inventor : g  zd_m1 = zd[_n-1]

gegen spell = count(y), by(inventor_id)
drop if spell==1

g       move = 0
replace move = 1 if (bea ~= bea_m1 & bea ~=. & bea_m1 ~=.) | (zd_m1 ~= zd & zd ~=. & zd_m1 ~=.)
gegen evermove = max(move), by(inventor_id)

tsset inventor_id year
gegen group_inventor_cluster = group(inventor_id cluster1)
tsspell group_inventor_cluster, fcond((group_inventor_cluster != group_inventor_cluster[_n-1]) | (_n == 1))

g dyear = year - year_m1
* missing if no previous year

gen dgap = 0
replace dgap = 1 if dyear>1 & missing(dyear)==0

* how many inventor-cluster spells have gaps?
preserve
gcollapse dgap, by(group_inventor_cluster _spell)
su dgap
* 37% of spells have gaps
restore

*bro year inventor_id cluster1 group_inventor_cluster _spell _seq _end dyear dgap

* average length of gap
su dyear
* 2.2 years
    * but this includes gap=1, ie, balanced panel
su dyear if dyear>1
* 3.83 years
* max gap is 34 years

su dyear if dyear>1 & evermove==1
* 3.89
su dyear if dyear>1 & evermove==0
* 3.65
* so movers have larger gaps

su inventor_id if dyear==34
* patents in 1971, 2005, 2006

preserve
replace dyear = dyear-1
* gap of 2 will only get 1 obs filled
    * gap of 1 is consecutive years
    * gap of n gets n-1 obs filled
gcollapse (sum) dyear, by(evermove)
table evermove, c(mean dyear)
* movers: 696906
* stayers: 228808
    * so 75% of imputed observations are from evermovers
gcollapse (sum) dyear

su dyear
* 925714
di 925714/932116
* would increase sample size by 99% by filling in all gaps
restore

*----------------------------------------------------
*** origin imputation
u $main/data2/data_3_origin, clear

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_orig.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*----------------------------------------------------
*** origin imputation: recalculating cluster size
u $main/data2/data_3_origin_agg, clear

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_orig_agg.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*----------------------------------------------------
*** origin imputation: recalculating cluster size
* full sample 

u $main/data2/data_3_origin_agg, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
/* keep if total  >=3.25 */

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_orig_agg_fullsample.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*** poisson

cap program drop t3_reg_fes
program define t3_reg_fes, rclass
    args y x output pkg 

    eststo clear
    qui `pkg' `y' `x', absorb(year bea zd class) vce(cluster bea_code#zd2)
    eststo m1
    estadd local year "Yes"
    estadd local city "Yes"
    estadd local field "Yes"
    estadd local class "Yes"
    qui `pkg' `y' `x', absorb(year class bea_code#zd2) vce(cluster bea_code#zd2)
    eststo m2
    estadd local year "Yes"
    estadd local class "Yes"
    estadd local cityfield "Yes"
    qui `pkg' `y' `x', absorb(year bea_code#zd2 bea_code#class) vce(cluster bea_code#zd2)
    eststo m3
    estadd local year "Yes"
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year) vce(cluster bea_code#zd2)
    eststo m4
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year class#year) vce(cluster bea_code#zd2)
    eststo m5
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    estadd local classyear "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year class#year inventor_id) vce(cluster bea_code#zd2)
    eststo m6
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    estadd local classyear "Yes"
    estadd local inventor "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year class#year inventor_id bea_code#year) vce(cluster bea_code#zd2)
    eststo m7
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    estadd local classyear "Yes"
    estadd local inventor "Yes"
    estadd local cityyear "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year class#year inventor_id bea_code#year org_new) vce(cluster bea_code#zd2)
    eststo m8
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    estadd local classyear "Yes"
    estadd local inventor "Yes"
    estadd local cityyear "Yes"
    estadd local firm "Yes"
    qui `pkg' `y' `x', absorb(bea_code#zd2 bea_code#class zd2#year class#year inventor_id bea_code#year org_new#year) vce(cluster bea_code#zd2)
    eststo m9
    estadd local cityfield "Yes"
    estadd local cityclass "Yes"
    estadd local fieldyear "Yes"
    estadd local classyear "Yes"
    estadd local inventor "Yes"
    estadd local cityyear "Yes"
    estadd local firmyear "Yes"

    esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
    esttab m* using "$tables/`output'.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
end

*** origin imputation: recalculating cluster size, full sample, poisson
replace citations=0 if missing(citations)==1 & _fillin==1
replace import=0 if missing(import) & _fillin==1
keep citations import x inventor_id year bea_code zd2 class org_new

* citations
t3_reg_fes citations x "t3_impute_orig_agg_full_pois" ppmlhdfe

* patent importance
t3_reg_fes import x "t3_impute_orig_agg_full_pois_imp" ppmlhdfe

*----------------------------------------------------
*** destination imputation
u $main/data2/data_3_destination, clear

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
gen esample = e(sample)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_dest.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

* average cluster size including 'inactive' inventors
su Den_bea_zd if esample
* 0.0432
* max 0.2986

*----------------------------------------------------
*** destination imputation: recalculating cluster size
u $main/data2/data_3_destination_agg, clear

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
gen esample= e(sample)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_dest_agg.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

* average cluster size including 'inactive' inventors
su Den_bea_zd if esample
* 0.0425
* max 0.2663

*----------------------------------------------------
*** destination imputation: recalculating cluster size
* full sample

u $main/data2/data_3_destination_agg, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
/* keep if total  >=3.25 */

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

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_impute_dest_agg_fullsample.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")


* destination imputation: recalculating cluster size, full sample, poisson, citations
replace citations=0 if missing(citations)==1 & _fillin==1
replace import=0 if missing(import)==1 & _fillin==1
keep citations import x inventor_id year bea_code zd2 class org_new

t3_reg_fes citations x "t3_impute_dest_agg_full_pois" ppmlhdfe

* patent importance
t3_reg_fes import x "t3_impute_dest_agg_full_pois_imp" ppmlhdfe


*-----------------------------------------------------------------------
*** aggregation bias

u $main/data2/data_3_disagg, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

g y = log(number)
g x   = log(Den_bea_zd)
gegen cluster1 = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

gegen org_new2 = group(org_id) if org_id ~= ""
gegen cluster_bea_year       = group(bea year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_disagg.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*-------------------------------------------------------------------------------
*** time units

eststo clear

foreach i in "1m" "2m" "3m" "6m" "1y" "2y" "3y" {

local data = "$main/data2/data_4_" + "`i'" + "_resize"
u "`data'", clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

gegen total = sum(number), by(inventor)
keep if total  >=3.25

g y = log(number)
g x   = log(Den_bea_zd)
gegen cluster1 = group(bea zd)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & cluster1 ~=. & bea ~=.

gegen cluster_bea_year       = group(bea year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
rename org_new org_id
gegen org_new                = group(org_id)

lab var x "Log size"

qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
local model = "m" + "`i'"
eststo `model'

}

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("1-Month" "2-Month" "3-Month" "6-Month" "1-Year" "2-Year" "3-Year")
esttab m* using "$tables/ta7_resize.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("1-Month" "2-Month" "3-Month" "6-Month" "1-Year" "2-Year" "3-Year")

*------------------------------------------------------------------------
*** main results using cluster size calculated from inventor-year data

u $main/data2/data_3_agg, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)

keep if total  >=3.25

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
gen esample = e(sample)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_invyear_size.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

* average cluster size including 'inactive' inventors
su Den_bea_zd if esample
* 0.0460
* max 0.2927

*------------------------------------------------------------------------
*** main results using cluster size calculated from inventor-year data
* on full sample

u $main/data2/data_3_agg, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

egen total = sum(number), by(inventor)

/* keep if total  >=3.25 */

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_invyear_size_fullsample.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*** poisson 
* depvar: total (fractional) citations
    * citation-weighted patents, adjusting for patent quality
* full sample

t3_reg_fes citations x "t3_invyear_size_fullsample_pois" ppmlhdfe

*------------------------------------------------------------------------
*** main results for full sample

u $main/data2/data_3, clear

drop if year  ==.
drop if zd ==.
drop if bea ==.

g y = log(number)
keep if y~=. & zd ~=. & class ~=. & year ~=. & inventor ~=. & bea ~=.

gegen total = sum(number), by(inventor)

/* keep if total  >=3.25 */

g x   = log(Den_bea_zd    )

gegen cluster1               = group(bea zd)
gegen cluster_bea_year       = group(bea year)
gegen cluster_bea_class_year = group(bea class year)
gegen cluster_zd_year        = group(zd year)
gegen cluster_bea_class      = group(bea class)
gegen cluster_class_year     = group(class year)
gegen org_new                = group(org_id)

lab var x "Log size"

eststo clear
qui reghdfe y x , absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
eststo m6
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
eststo m7
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
eststo m8
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
qui reghdfe y x , absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new org_new#year) vce(cluster cluster1)
eststo m9
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
estadd local inventor "Yes"
estadd local cityyear "Yes"
estadd local firm "Yes"
estadd local firmyear "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")
esttab m* using "$tables/t3_fullsample.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm" "firmyear Firm $\times$ Year")

*** poisson
* depvar: total (fractional) citations
    * citation-weighted patents, adjusting for patent quality

t3_reg_fes citations x "t3_fullsample_poisson" ppmlhdfe


*----------------------------------------------------------------
*** heterogeneity by cluster size
* poisson, citations, full sample, imputing

*** origin imputation: recalculating cluster size
* full sample

u "$main/data2/data_3_origin_agg", clear

gegen total = sum(number), by(inventor)
g x = log(Den_bea_zd)
* set depvar = 0 for interpolated observations
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

* global quartiles 
gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

est clear 
ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
* separation check is not finishing, drop `ir` check
    * problematic if separation is from continuous covariates x_q
    * https://www.statalist.org/forums/forum/general-stata-discussion/general/1548421-ppmlhdfe-regression-not-starting
eststo m1

* use city-field and city-year FEs
    * take simple average across fields
        * could do weighted average, weighting by field size
        * https://chatgpt.com/share/681d0497-c5c4-8004-900f-fee587a55f5e
    * specify year==2000

preserve
keep if year==2000 & e(sample)
* FEs are constant within city-field and city-year
* so simple average is a weighted average by group; accounting for group size

* how to interpret FE<0? answer: below-average

gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)

save "$main/data2/het_pois_cit_full_orig_fes", replace
restore

* in sending_metros:
    * merge in
    * save exp(F) for each destination-origin city pair
    * new columns: orig_fe, dest_fe
* in spreadsheet: city output is S^(a+1) * exp(F)
    * effect: scaling up output in both cities



*** destination imputation: recalculating cluster size
* full sample

u "$main/data2/data_3_destination_agg", clear

gegen total = sum(number), by(inventor)
g x = log(Den_bea_zd)
* set depvar = 0 for interpolated observations
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

* global quartiles 
gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m2

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)

save "$main/data2/het_pois_cit_full_dest_fes", replace
restore

lab var x_q1 "Log size $\times$ Q1"
lab var x_q2 "Log size $\times$ Q2"
lab var x_q3 "Log size $\times$ Q3"
lab var x_q4 "Log size $\times$ Q4"

esttab m1 m2, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3)
esttab m1 m2 using "$tables/t8_sizehet_full_impute.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)


*-------------
* top10
*** origin imputation: recalculating cluster size

u "$main/data2/data_3_origin_agg", clear
gegen total = sum(number), by(inventor)
keep if total>=3.25
g x = log(Den_bea_zd)
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

est clear 
ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m1

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)
save "$main/data2/het_pois_cit_full_orig_top10_fes", replace
restore

*** destination imputation: recalculating cluster size

u "$main/data2/data_3_destination_agg", clear

gegen total = sum(number), by(inventor)
keep if total>=3.25
g x = log(Den_bea_zd)
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m2

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)
save "$main/data2/het_pois_cit_full_dest_top10_fes", replace
restore

lab var x_q1 "Log size $\times$ Q1"
lab var x_q2 "Log size $\times$ Q2"
lab var x_q3 "Log size $\times$ Q3"
lab var x_q4 "Log size $\times$ Q4"

esttab m1 m2, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)
esttab m1 m2 using "$tables/t8_sizehet_top10_impute.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)

*-------------
* bot90
*** origin imputation: recalculating cluster size

u "$main/data2/data_3_origin_agg", clear
gegen total = sum(number), by(inventor)
keep if total<3.25
g x = log(Den_bea_zd)
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

est clear 
ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m1

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)
save "$main/data2/het_pois_cit_full_orig_bot90_fes", replace
restore

*** destination imputation: recalculating cluster size

u "$main/data2/data_3_destination_agg", clear

gegen total = sum(number), by(inventor)
keep if total<3.25
g x = log(Den_bea_zd)
replace citations=0 if missing(citations)==1 & _fillin==1
gegen org_new = group(org_id)

gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

ppmlhdfe citations x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m2

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)
save "$main/data2/het_pois_cit_full_dest_bot90_fes", replace
restore

lab var x_q1 "Log size $\times$ Q1"
lab var x_q2 "Log size $\times$ Q2"
lab var x_q3 "Log size $\times$ Q3"
lab var x_q4 "Log size $\times$ Q4"

esttab m1 m2, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)
esttab m1 m2 using "$tables/t8_sizehet_bot90_impute.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)


*----------------------------------------
*** quality-adjusted patents, using Kelly et al. (2021) patent importance
* importance = fsim10 / bsim5 = 10-year forward similarity / 5-year backward similarity
    * note: KPST use log ratio; here, using level
* quality-adjusted patent = importance
* y_it = sum_p imp_p * 1/team_p
    * multiply importance by fractional patent, then aggregate to inventor-year level
* imputing missing zeros, so use Poisson regression

*** heterogeneity by cluster size
* poisson, full sample, imputing

*** origin imputation: recalculating cluster size
u "$main/data2/data_3_origin_agg", clear
gegen total = sum(number), by(inventor)
g x = log(Den_bea_zd)
replace import=0 if missing(import)==1 & _fillin==1
gegen org_new = group(org_id)

* global quartiles 
gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class import x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

est clear 
ppmlhdfe import x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m1

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)

save "$main/data2/het_pois_kpst_full_orig_fes", replace
restore

*** destination imputation: recalculating cluster size
u "$main/data2/data_3_destination_agg", clear
gegen total = sum(number), by(inventor)
g x = log(Den_bea_zd)
replace import=0 if missing(import)==1 & _fillin==1
gegen org_new = group(org_id)

* global quartiles 
gegen pctile25 = pctile(x), p(25)
gegen pctile50 = pctile(x), p(50)
gegen pctile75 = pctile(x), p(75)
g q1 = (x <= pctile25) if missing(x)==0
g q2 = (x > pctile25 & x <= pctile50) if missing(x)==0
g q3 = (x > pctile50 & x <= pctile75) if missing(x)==0
g q4 = (x > pctile75) if missing(x)==0
g x_q1 = x*q1
g x_q2 = x*q2
g x_q3 = x*q3
g x_q4 = x*q4

keep inventor_id year org_new bea_code zd2 class import x_q1 x_q2 x_q3 x_q4 q1 q2 q3 

ppmlhdfe import x_q1 x_q2 x_q3 x_q4 q1 q2 q3, absorb(fe_cityfield=bea_code#zd2 bea_code#class zd2#year class#year inventor fe_cityyear=bea_code#year org_new#year) vce(cluster bea_code#zd2) verbose(1) sep(fe simplex)
eststo m2

preserve
keep if year==2000 & e(sample)
gcollapse fe_cityfield fe_cityyear, by(bea_code)
gen fe = exp(fe_cityfield + fe_cityyear)
save "$main/data2/het_pois_kpst_full_dest_fes", replace
restore

lab var x_q1 "Log size $\times$ Q1"
lab var x_q2 "Log size $\times$ Q2"
lab var x_q3 "Log size $\times$ Q3"
lab var x_q4 "Log size $\times$ Q4"

esttab m1 m2, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3)
esttab m1 m2 using "$tables/t8_sizehet_full_kpst_impute.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nocons b(%9.4f) mtitle("Origin" "Destination") drop(q1 q2 q3 _cons)

