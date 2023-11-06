*** resize the data to a new time unit

*****************************************************
* 1, 2, 3, and 6 MONTHS
* 1, 2, and 3 YEARS
******************************************************

* collapse to inventor-year level

foreach i in "1m" "2m" "3m" "6m" "1y" "2y" "3y" {

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
    drop if zd2 ==.


    * MERGE WITH NBER PATENT DATA
    gsort patent
    merge m:m patent using  $main/data/apat63_99
    drop _merge
    drop if inventor_id ==.

    *****************************************************************
    * counting if in different cities/fields in the same year
        * dropping inventors if more than 3 cities in the same year

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


    ***********************************************
    * MEASURES OF CLUSTERS DENSITY
    ***********************************************

    if "`i'" == "1m" {
        g month_str =  substr(app_date,6,2)
        gen date = string(year) + "m" + month_str
        drop year
        gegen year = group(date)
        drop month_str
    }

    if "`i'" == "2m" {
        g month_str =  substr(app_date,6,2)
        g tmp = 1 if month_str=="01"  | month_str=="02"  
        replace tmp = 2 if month_str=="03"  | month_str=="04"  
        replace tmp = 3 if month_str=="05"  | month_str=="06"  
        replace tmp = 4 if month_str=="07" | month_str=="08" 
        replace tmp = 5 if month_str=="09" | month_str=="10"
        replace tmp = 6 if month_str=="11" | month_str=="12"
        gen date = string(year) + "m" + string(tmp)
        drop year
        gegen year = group(date)
        drop tmp month_str
    }

    if "`i'" == "3m" {
        g month_str =  substr(app_date,6,2)
        g tmp = 1 if month_str=="01"  | month_str=="02"  | month_str=="03" 
        replace tmp = 2 if month_str=="04"  | month_str=="05"  | month_str=="06"
        replace tmp = 3 if month_str=="07"  | month_str=="08"  | month_str=="09"
        replace tmp = 4 if month_str=="10" | month_str=="11" | month_str=="12"
        gen date = string(year) + "m" + string(tmp)
        drop year
        gegen year = group(date)
        drop tmp month_str
    }

    if "`i'" == "6m" {
        g month_str =  substr(app_date,6,2)
        g tmp = 1 if month_str=="01"  | month_str=="02"
        replace tmp = 1 if month_str=="03"  | month_str=="04"
        replace tmp = 1 if month_str=="05"  | month_str=="06"
        replace tmp = 2 if month_str=="07"  | month_str=="08"
        replace tmp = 2 if month_str=="09"  | month_str=="10"
        replace tmp = 2 if month_str=="11" | month_str=="12"
        gen date = string(year) + "m" + string(tmp)
        drop year
        gegen year = group(date)
        drop tmp month_str

    }

    if "`i'" == "1y" | "`i'" == "2y"  | "`i'" == "3y" {
        local j = substr("`i'",1,1)
        g new_year = int(year/`j') * `j'
        drop year
        rename new_year year
    }

    * ex. convert to 3-year time units

    *g new_year = int(year/`i') * `i'
    * floor division * 3
        * 1993 -> 1992
        * round down to nearest multiple of 3
            * data: 1971, 74, 77, 80, 83, 86, 89, 92, 95, 98, 01, 04, 07
            * original data is 1971-2007

    gsort inventor_id year bea_code zd2 
    by inventor_id year bea_code zd2: g d1 = 1 if _n ==1
    * this counts the first observation of an inventor-city-field-year spell; avoids overcounting inventors
    gegen count = count(d1), by(bea_code zd2 year)
    gegen total = count(d1), by(zd2 year)
    * have some obs with total=1: singleton field-time obs
        * then denom below is 0, get density14==.
    g density14 = (count-1)/(total-1)
    * have some obs in singleton clusters; this assigns them a size of 0
        * log size drops them; would be dropped by inventor FEs too
    drop count total d1

    * recalculate cluster size
    preserve
    gsort bea_code zd2 year
    gcollapse density14, by(bea_code zd2 year)
    compress
    local size = "$main/data2/density14_3_" + "`i'" 
    save "`size'", replace
    restore

    * When a patent is joint, I split it among inventors
    gegen tmp7 = count(inventor_id), by(patent_id)
    g number = 1/tmp7
    replace citations = citations / tmp7
    drop tmp7

    * MODE
    egen main_bea        = mode(bea),     maxmode by(inventor_id year)
    egen main_zd         = mode(zd2),     maxmode by(inventor_id year)
    egen main_class      = mode(class),   maxmode by(inventor_id year)
    egen main_org        = mode(org_id),  maxmode by(inventor_id year)

    * COLLAPSE
    gsort inventor_id year
    * inventor-time level data
    gcollapse main_bea main_zd main_class general original (sum) number citat, by(inventor_id year main_org)

    rename main_bea bea_code
    rename main_zd zd2
    rename main_class class
    rename main_org org_new

    * MERGE
    gsort bea_code zd2 year
    merge m:1 bea_code zd2 year using "`size'"
    drop _merge

    * SAVE
    g Den_bea_zd = density14
    drop density* 
    drop if inventor ==.

    local data = "$main/data2/data_4_" + "`i'" + "_resize"
    save "`data'", replace

}
