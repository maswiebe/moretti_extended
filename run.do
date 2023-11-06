* set path
global root "[location of replication archive]"
global main "$root/data/AER_UPLOADED"
global tables "$root/output/tables"
global figures "$root/output/figures"


* install: gtools, reghdfe, ivreg2, ranktest, ivreghdfe, carryforward
foreach prg in gtools reghdfe ivreg2 ranktest ivreghdfe carryforward {
	* install using ssc, but avoid re-installing if already present
		capture which `prg'
		if _rc == 111 {                 
		   dis "Installing `prg'"
		   ssc install `prg', replace
		   }
	}

* clean the data
clear
do "$root/data/AER_UPLOADED/data/create_COMETS_Patent_ExtractForEnrico.do"
* this sets version = 13.1
clear
do "$main/data/read_apat.do"
* main dataset
do "$root/code/data_3.do"
* impute missing observations
do "$root/code/data_3_impute.do"
* aggregate to inventor-cluster-year level
do "$root/code/data_3_disagg.do"
* construct the sample using different time units
do "$root/code/data_4_resize.do"


* event study
do "$root/code/reg23_mw.do"

* IV regressions
do "$root/code/iv_new_mw.do"
do "$root/code/reg11_mw.do"

* Table 3 replications, heterogeneity, mechanisms, imputation, time unit
do "$root/code/reg_mw.do"
