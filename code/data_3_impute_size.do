*** generate data with imputed zeros, with cluster size calculated after imputing

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

g N = 1
gsort inventor year bea
by inventor year: replace N = N[_n-1] + 1 if bea ~= bea[_n-1] & _n >1
gegen NN = max(N), by(inventor)
drop if NN > 3 & NN ~=.
drop N NN

g N = 1
gsort inventor year zd2
by inventor year: replace N = N[_n-1] + 1 if zd2 ~= zd2[_n-1] & _n >1
gegen NN = max(N), by(inventor year)
drop if NN > 3 & NN ~=.
drop N NN


*--------------------------------------------------------------------
*** first aggregate to inventor-year level, then impute, then calculate cluster size

* In cases where there are multiple cities, zd or classes within 1 year, pick mode
* I use  maxmode to deal with ties. Minmode does not  make a difference
egen main_bea        = mode(bea),     maxmode by(inventor_id year)
egen main_zd         = mode(zd2),     maxmode by(inventor_id year)
egen main_class      = mode(class),   maxmode by(inventor_id year)
egen main_org        = mode(org_id),  maxmode by(inventor_id year)
* gtools doesn't have mode

**MW: how many multi-cluster inventors are there?
gen multicl = (main_bea!=bea_code | main_zd!=zd2) if missing(bea_code)==0 & missing(zd2)==0
su multicl
* 0.075 of all inventor-cluster-year obs
tab multicl
* 310k out of 4M
preserve
gcollapse (max) multicl, by(inventor_id year)
su multicl
* 0.078 of inventor-year obs
restore

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
gcollapse main_bea main_zd main_class team team2 (sum) number citat, by(inventor_id year main_org)
**MW: for multi-cluster inventors, this assigns all of an inventor's patents in one year to their modal cluster

rename main_bea bea_code
rename main_zd zd2
rename main_class class
rename main_org org_id

* fill in missings in balanced panel
fillin inventor_id year
summ
compress

*------------------------------------------------------------------
*** impute by origin
preserve

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


*** cluster size
gsort inventor_id year bea zd 
by inventor_id year bea zd: g d1 = 1 if _n ==1
gegen count = count(d1), by(bea zd year)
gegen total = count(d1), by(zd year)
g density_new = (count-1)/(total-1)
drop count total d1
compress

g Den_bea_zd = density_new

drop density* 
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_origin_agg, replace
summ

restore


*------------------------------------------------------------------
*** impute by destination
preserve

gegen firstyear_temp = min(year) if missing(bea_code)==0, by(inventor_id)
gegen firstyear = max(firstyear_temp), by(inventor_id)
gegen lastyear_temp = max(year) if missing(bea_code)==0, by(inventor_id)
gegen lastyear = max(lastyear_temp), by(inventor_id)
keep if inrange(year, firstyear, lastyear)
drop firstyear* lastyear*
* keep only observations between first and last patent years

gsort inventor_id -year
bysort inventor_id:  carryforward bea_code zd2 class org_id, replace

gsort inventor_id year


*** cluster size
gsort inventor_id year bea zd 
by inventor_id year bea zd: g d1 = 1 if _n ==1
gegen count = count(d1), by(bea zd year)
gegen total = count(d1), by(zd year)
g density_new = (count-1)/(total-1)
drop count total d1
compress

g Den_bea_zd = density_new

drop density* 
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_destination_agg, replace
summ

restore


*--------------------------------------------------------------------
*** first aggregate to inventor-year level, then calculate cluster size
* replicate Table 3 to check whether calculating cluster size at the inventor-year level affects the results

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

g N = 1
gsort inventor year bea
by inventor year: replace N = N[_n-1] + 1 if bea ~= bea[_n-1] & _n >1
gegen NN = max(N), by(inventor)
drop if NN > 3 & NN ~=.
drop N NN

g N = 1
gsort inventor year zd2
by inventor year: replace N = N[_n-1] + 1 if zd2 ~= zd2[_n-1] & _n >1
gegen NN = max(N), by(inventor year)
drop if NN > 3 & NN ~=.
drop N NN


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
gcollapse main_bea main_zd main_class team team2 (sum) number citat, by(inventor_id year main_org)
**MW: for multi-cluster inventors, this assigns all of an inventor's patents in one year to their modal cluster

rename main_bea bea_code
rename main_zd zd2
rename main_class class
rename main_org org_id

*** cluster size
gsort inventor_id year bea zd 
by inventor_id year bea zd: g d1 = 1 if _n ==1
gegen count = count(d1), by(bea zd year)
gegen total = count(d1), by(zd year)
g density_new = (count-1)/(total-1)
drop count total d1
compress

g Den_bea_zd = density_new

drop density* 
drop if inventor ==.

compress
sort inventor_id year
save $main/data2/data_3_agg, replace
summ
