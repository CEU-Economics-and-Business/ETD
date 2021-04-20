import delimited "report/results_pilot.csv", clear

replace etdlinkofthedissertationpdf = "http://www.etd.ceu.edu/2012/sphulr01.pdf" if timestamp == "2021/03/15 9:26:34 pm CET" // apparent miscoding

gen slash = strrpos(etdlinkofthedissertationpdf,"/")
gen folder_name = substr(etdlinkofthedissertationpdf,(slash+1),.)
drop slash pleaselistanysuggestionsyouthink etdlinkofthedissertationpdf

* duplications as coded by both - should think about it later
* should report on intercoder reliability
*duplicates drop folder_name, force
bys folder_name (timestamp): gen drop = _n
keep if drop == 1
drop drop

tempfile pilot
save `pilot'

import delimited "report/results_second.csv", varnames(1) clear
rename filenameofthethesisdissertationf folder_name

append using `pilot'

preserve
import delimited "output/all.csv", clear
gen slash = strrpos(pdf_link,"/")
gen folder_name = strrtrim(substr(pdf_link,(slash+1),.))
drop slash pdf_link
tempfile all
save `all'
restore

merge 1:1 folder_name using `all', gen(merge_all) keep(1 3)
sort folder_name

rename wasthereanyanalysisintheprojectb ra_analysis_exist
rename whatwerethesubjectsoftheresearch ra_analysis_subject
rename didtheresearchinvolveoriginaldat ra_analysis_type
rename weretherepotentialbenefitsandhaz ra_risk_subject
rename didtheresearchinvolveanyrisksorp ra_risk_researcher
rename wereproceduresensuringthatconsen ra_consent
rename wererisksofcoercionconsidered ra_coercion_risk
rename didtheresearchinvolveincompetent ra_incompetent
rename didtheresearchinvolvedeception ra_deception
rename didtheresearchinvolveoriginalexp ra_experiment
rename didtheresearchinvolvethecollecti ra_sensitive
rename didtheresearchinvolvetrackingoro ra_tracking
rename waspersonalanonymitysecured ra_anonymity
rename weredataprotectionandstoragerequ ra_protection
rename werethereanyplansforfutureuseoft ra_future
rename pleaselistanycommentsyouhaveabou ra_comment

tab merge_all

tab ra_analysis_exist
tab ra_analysis_subject
tab ra_analysis_type

tab ra_coercion_risk

label define values 0 "No" 1 "Yes" 2 "Can not be decided" 3 "NA" 
foreach var of varlist ra_analysis_exist ra_risk_subject - ra_future {
	*egen `var'__num = group(`var')
	gen `var'_num = ""
	replace `var'_num = "0" if `var' == "No"
	replace `var'_num = "1" if `var' == "Yes"
	replace `var'_num = "2" if `var' == "Can not be decided"
	replace `var'_num = "3" if `var' == "NA"
	destring `var'_num, replace
	label values `var'_num values
	drop `var'
}

tab ra_coercion_risk_num

foreach var in department program {
	egen `var'_num = group(`var')
	labmask `var'_num, val(`var')
}

preserve
import delimited "/home/zavecz/etd/ETD/output/final.csv", encoding(UTF-8) clear
contract program
rename _freq freq_final
tempfile weight_final
save `weight_final'
restore

preserve
import delimited "/home/zavecz/etd/ETD/output/all.csv", encoding(UTF-8) clear
contract program
rename _freq freq_all
tempfile weight_all
save `weight_all'
restore

preserve
use `weight_final', clear
merge 1:1 program using `weight_all', nogen
egen sum_final = sum(freq_final)
egen sum_all = sum(freq_all)
gen weight = (freq_final * sum_all) / (freq_all * sum_final)
tempfile weight_both
save `weight_both'
restore

merge m:1 program using `weight_both', keep (1 3) nogen keepusing(weight)

save "output/analysis_sample", replace
