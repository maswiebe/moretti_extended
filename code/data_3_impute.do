** MW: impute all missing zeros, using origin and destination methods

u $main/data2/data_patent_level_3, clear
compress

* In cases where there are multiple cities, zd or classes within 1 year, pick mode
* I use  maxmode to deal with ties. Minmode does not  make a difference
egen main_bea        = mode(bea),     maxmode by(inventor_id year)
egen main_zd         = mode(zd2),     maxmode by(inventor_id year)
egen main_class      = mode(class),   maxmode by(inventor_id year)
egen main_org        = mode(org_id),  maxmode by(inventor_id year)
egen main_cat        = mode(cat),     maxmode by(inventor_id year)
egen main_subcat     = mode(subcat),  maxmode by(inventor_id year)
egen main_org_type   = mode(org_typ), maxmode by(inventor_id year)
* gtools doesn't have mode

* fractional attribution
gegen tmp7 = count(inventor_id), by(patent_id) 
g number = 1/tmp7
replace citations = citations / tmp7
drop tmp7

* Team size: number of inventors on a patent
gegen team  = count(inventor_id), by(patent_id)
summ team, detail
* indicator for solo inventor
g    team2 = (team ==1)
summ year team*

* Collapse by inventor_id year. Note that main_org main_org_type are constant within a
* inventor_id year pair. I include them in by() so that they are in the 
* collapsed data
summ
sort inventor_id year
compress
gcollapse main_bea main_zd main_class main_cat main_subcat general original team team2 (sum) number citat, by(inventor_id year main_org main_org_type )

rename main_bea bea_code
rename main_zd zd2
rename main_class class
rename main_org org_id
rename main_org_type org_type
rename main_cat cat
rename main_subcat subcat

* fill in missings in balanced panel
fillin inventor_id year
summ
compress

* do origin first, then destination
preserve

* ssc install carryforward

*----------------------------------------------------------------------------------
*** impute origin cluster

gegen firstyear_temp = min(year) if missing(bea_code)==0, by(inventor_id)
gegen firstyear = max(firstyear_temp), by(inventor_id)
gegen lastyear_temp = max(year) if missing(bea_code)==0, by(inventor_id)
gegen lastyear = max(lastyear_temp), by(inventor_id)
keep if inrange(year, firstyear, lastyear)
drop firstyear* lastyear*
* keep only observations between first and last patent years

gsort inventor_id year
bysort inventor_id:  carryforward bea_code zd2 class org_id, replace

gsort inventor_id year

*******************************************
*****************************
* MERGE MAIN DATA WITH 
* MEASURES OF CLUSTER DENSITY
*****************************
********************************************
sort bea year
merge m:1 bea year using $main/data2/density13_3
tab _merge
drop _merge

sort bea zd year
merge m:1 bea zd year using $main/data2/density14_3
tab _merge
drop _merge

sort bea class year
merge m:1 bea class year using $main/data2/density15_3
tab _merge
drop _merge


sort bea cat year
merge m:1 bea cat year using $main/data2/density20_3
tab _merge
drop _merge


sort bea subcat year
merge m:1 bea subcat year using $main/data2/density21_3
tab _merge
drop _merge


*************************************
*************************************
* SAVE
************************************
**************************************
g Den_bea = density13 
g Den_bea_zd = density14 
g Den_bea_class = density15 
g Den_bea_cat    = density20
g Den_bea_subcat = density21

g Den_beaB = density13B
g Den_bea_zdB = density14B
g Den_bea_classB = density15B
g Den_bea_catB    = density20B
g Den_bea_subcatB = density21B

drop density* Den_bea_cat* Den_bea_subcatB* cat subcat
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_origin, replace
summ

restore

*----------------------------------------------------------------------------------
*** impute destination cluster

preserve

gegen firstyear_temp = min(year) if missing(bea_code)==0, by(inventor_id)
gegen firstyear = max(firstyear_temp), by(inventor_id)
gegen lastyear_temp = max(year) if missing(bea_code)==0, by(inventor_id)
gegen lastyear = max(lastyear_temp), by(inventor_id)
keep if inrange(year, firstyear, lastyear)
drop firstyear* lastyear*
* keep only observations between first and last patent years

* ssc install carryforward

gsort inventor_id -year
bysort inventor_id:  carryforward bea_code zd2 class org_id, replace

gsort inventor_id year

*******************************************
*****************************
* MERGE MAIN DATA WITH 
* MEASURES OF CLUSTER DENSITY
*****************************
********************************************
gsort bea year
merge m:1 bea year using $main/data2/density13_3
tab _merge
drop _merge

gsort bea zd year
merge m:1 bea zd year using $main/data2/density14_3
tab _merge
drop _merge

gsort bea class year
merge m:1 bea class year using $main/data2/density15_3
tab _merge
drop _merge


gsort bea cat year
merge m:1 bea cat year using $main/data2/density20_3
tab _merge
drop _merge


gsort bea subcat year
merge m:1 bea subcat year using $main/data2/density21_3
tab _merge
drop _merge


*************************************
*************************************
* SAVE
************************************
**************************************
g Den_bea = density13 
g Den_bea_zd = density14 
g Den_bea_class = density15 
g Den_bea_cat    = density20
g Den_bea_subcat = density21

g Den_beaB = density13B
g Den_bea_zdB = density14B
g Den_bea_classB = density15B
g Den_bea_catB    = density20B
g Den_bea_subcatB = density21B

drop density* Den_bea_cat* Den_bea_subcatB* cat subcat
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_destination, replace
summ

restore