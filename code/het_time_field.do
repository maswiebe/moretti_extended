
u $main/data2/data_3, clear

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

* 37 year span: 1971-2007
    * split 13,12,12
gen t1 = inrange(year,1971,1983)
gen t2 = inrange(year,1984,1995)
gen t3 = inrange(year,1996,2007)

gen x_t2 = x*t2
gen x_t3 = x*t3

lab var x_t2 "Log size $\times$ 1984-1995"
lab var x_t3 "Log size $\times$ 1996-2007"

* heterogeneity by field
gen bio = zd2==1
gen com = zd2==2
gen oen = zd2==3
gen osc = zd2==4
gen sem = zd2==5

gen x_com = x*com
gen x_oen = x*oen
gen x_osc = x*osc
gen x_sem = x*sem

lab var x_com "Log size $\times$ Comp"
lab var x_oen "Log size $\times$ Other Eng"
lab var x_osc "Log size $\times$ Other Sci"
lab var x_sem "Log size $\times$ Semicon"

foreach t of varlist t1 t2 t3 {
    preserve
    keep if `t'

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

    esttab m* using "$tables/het_`t'.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")

    restore
}


eststo clear
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
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
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year) vce(cluster cluster1)
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
qui reghdfe y x x_t2 x_t3, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor cluster_bea_year org_new) vce(cluster cluster1)
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

esttab m* using "$tables/het_time_interaction.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "cityyear City $\times$ year" "firm Firm")


*** heterogeneity by field
eststo clear
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class) vce(cluster cluster1)
eststo m1
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1) vce(cluster cluster1)
eststo m2
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1 cluster_bea_class) vce(cluster cluster1)
eststo m3
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year) vce(cluster cluster1)
eststo m4
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year) vce(cluster cluster1)
eststo m5
estadd local year "Yes"
estadd local city "Yes"
estadd local field "Yes"
estadd local class "Yes"
estadd local cityfield "Yes"
estadd local cityclass "Yes"
estadd local fieldyear "Yes"
estadd local classyear "Yes"
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor) vce(cluster cluster1)
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
qui reghdfe y x x_com x_oen x_osc x_sem, absorb(year bea zd class cluster1 cluster_bea_class cluster_zd_year cluster_class_year inventor org_new) vce(cluster cluster1)
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
estadd local firm "Yes"

esttab m*, se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "firm Firm")

esttab m* using "$tables/het_field_interaction.tex", se ar2 label compress replace star(* 0.10 ** 0.05 *** 0.01) nomtitle nocons b(%9.4f) scalars(N "year Year" "city City" "field Field" "class Class" "cityfield City $\times$ field" "cityclass City $\times$ class" "fieldyear Field $\times$ year" "classyear Class $\times$ year" "inventor Inventor" "firm Firm")
