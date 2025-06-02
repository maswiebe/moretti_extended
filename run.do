* set path: uncomment the following line and set the filepath for the folder containing this run.do file
*global root "[location of replication archive]"
global root "/home/michael/Dropbox/replications/moretti_extended"
global main "$root/data/AER_UPLOADED"
global tables "$root/output/tables"
global figures "$root/output/figures"

* Stata version control
version 16

* configure library environment
do "$root/code/_config.do"

* clean the data
do "$root/code/create_COMETS_Patent_ExtractForEnrico_mw.do"
* main dataset
do "$root/code/data_3_mw.do"
* impute missing observations
do "$root/code/data_3_impute.do"
* recalculate cluster size after imputing
do "$root/code/data_3_impute_size.do"
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

* heterogeneity by time and field
do "$root/code/het_time_field.do"