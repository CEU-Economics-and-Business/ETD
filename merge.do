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
import delimited "output/thesis_gaurav.csv", varnames(1) clear
replace folder_name = strrtrim(folder_name)
tempfile gaurav
save `gaurav'
restore

preserve
import delimited "output/thesis_mirko.csv", varnames(1) clear
replace folder_name = strrtrim(folder_name)
tempfile mirko
save `mirko'
restore

preserve
import delimited "output/sample.csv", clear
gen slash = strrpos(pdf_link,"/")
gen folder_name = strrtrim(substr(pdf_link,(slash+1),.))
drop slash pdf_link
tempfile sample
save `sample'
restore

merge 1:1 folder_name using `gaurav', gen(merge_gaurav)
merge 1:1 folder_name using `mirko', gen(merge_mirko)
merge 1:1 folder_name using `sample', gen(merge_pilot) keep(1 3)
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

tab merge_gaurav merge_mirko
tab merge_pilot

tab ra_analysis_exist
tab ra_analysis_subject
tab ra_analysis_type

save "output/analysis_sample", replace
