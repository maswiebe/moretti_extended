** MW: impute all missing zeros, using origin and destination methods

u $main/data2/data_patent_level_3, clear
compress

* In cases where there are multiple cities, zd or classes within 1 year, pick mode
* I use  maxmode to deal with ties. Minmode does not  make a difference
egen main_bea        = mode(bea),     maxmode by(inventor_id year)
egen main_zd         = mode(zd2),     maxmode by(inventor_id year)
egen main_class      = mode(class),   maxmode by(inventor_id year)
egen main_org        = mode(org_id),  maxmode by(inventor_id year)
* gtools doesn't have mode

* fractional attribution
gegen tmp7 = count(inventor_id), by(patent_id) 
g number = 1/tmp7
g raw_number = 1
gen raw_citations = citations
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
gcollapse main_bea main_zd main_class team team2 avg_frac_cite=citations (sum) number citations raw_number raw_citations, by(inventor_id year main_org)

rename main_bea bea_code
rename main_zd zd2
rename main_class class
rename main_org org_id

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

sort bea zd year
merge m:1 bea zd year using $main/data2/density14_3
tab _merge
drop _merge

*************************************
*************************************
* SAVE
************************************
**************************************
g Den_bea_zd = density14 

drop density* 
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

gsort bea zd year
merge m:1 bea zd year using $main/data2/density14_3
tab _merge
drop _merge

*************************************
*************************************
* SAVE
************************************
**************************************
g Den_bea_zd = density14 

drop density*
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_destination, replace
summ

restore