* aggregate to inventor-city-field-year
* more disaggregated data; original data is aggregated to inventor-year level
    * ie, allow inventor observations in multiple clusters in the same year, instead of taking the mode


***********************************************
***********************************************
* CLEAN THE DATA
***********************************************
***********************************************
u $main/data/COMETS_Patent_ExtractForEnrico.dta, clear
compress

keep if year >1970 & year <=2007
gegen inventor_id = group(inventor)
drop if inventor_id ==.
drop if class ==.

drop if bea =="NOCOUNTRY"
drop if bea =="OTHER_USA"
drop if bea =="UNITED STATES"
destring bea, replace
drop if bea ==.
drop if bea ==0

* ZD is the broad technology class
* Here I create a ZD2 which is the numeric version 
gegen zd2 = group(zd)
tab zd zd2
drop if zd2 ==.

** MW: keep inventors with more than 3 cities in the same year

* count inventors before assigning to modal city/field
* NUMBER OF INVENTORS
***************************
gsort inventor_id year bea zd 
by inventor_id year bea zd: g d1 = 1 if _n ==1
gegen count = count(d1), by(bea zd year)
gegen total = count(d1), by(zd year)
g density14 = (count-1)/(total-1)
compress
/* save $main/data2/data_3_count_disagg, replace */
drop count total d1

* I SAVE DENSITY MEASURES IN DATA FILES 
* TO BE USED LATER
***********************************************
compress
save $main/data2/data_patent_level_3_disagg, replace

gsort bea zd2 year
gcollapse density14, by(bea zd2 year)
compress
save $main/data2/density14_3_disagg, replace

*------------------------------------------------------
* collapse to inventor-city-field-year level
    * ie, inventor-cluster-year
* do not collapse to inventor-year level
* note: patent-level has ~no variation in depvar, since each patent is one observation
    * only have variation from fraction of patent attributed
* what are we aggregating?
    * sum patents per cluster-year
    * inventor can be in different firms, classes, category
    * eg, inventor is in different firms in the same cluster-year

u $main/data2/data_patent_level_3_disagg, clear
compress

gegen tmp7 = count(inventor_id), by(patent_id) 
g number = 1/tmp7
replace citations = citations / tmp7
drop tmp7

gegen team  = count(inventor_id), by(patent_id)
summ team, detail
* indicator for solo inventor
g    team2 = (team ==1)

* take modal class and firm, by inventor-cluster-year
egen main_class      = mode(class),   maxmode by(inventor_id bea_code zd2 year)
egen main_org        = mode(org_id),  maxmode by(inventor_id bea_code zd2 year)

gsort inventor_id year
compress
gcollapse team team2 (sum) number citat, by(inventor_id bea_code zd2 year main_class main_org)
* note: main_* variables are constant within by(), so just including them in the aggregated data
* reduces from 4.2M to 3.1M

rename main_org org_id
rename main_class class

* MERGE MAIN DATA WITH 
* MEASURES OF CLUSTER DENSITY
gsort bea zd year
merge m:1 bea zd2 year using $main/data2/density14_3_disagg
drop _merge

* SAVE
g Den_bea_zd = density14 

drop density* 
drop if inventor_id ==.

compress
save $main/data2/data_3_disagg, replace
