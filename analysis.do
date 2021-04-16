cap ssc install splitvallabels
cap ssc install catplot
cap ssc install labutil

use "output/analysis_sample", clear

tab ra_coercion_risk_num

*splitvallabels ra_coercion_risk_num
*graph hbar, over(ra_coercion_risk_num, label(labsize(small)) relabel(`r(relabel)')) ytitle("Percent of Respondents")
*graph hbar, over(ra_coercion_risk_num) ytitle("Percent of Respondents")
*catplot ra_coercion_risk_num, ytitle("Percent of Respondents")

local i = 0

foreach var of varlist ra_analysis_exist_num-ra_future_num {
	local i = `i' + 1
	local name = substr("`var'",1,2)
	*di `name'_`i'
	rename `var' `name'_`i'
	gen text_`i' = "`var'"
}

reshape long ra_ text_, i(folder_name) j(question)
tab ra_ if text_ == "ra_coercion_risk_num"

gen question_text = ""
replace question_text = "Was there any analysis in the project?" if text_ == "ra_analysis_exist_num"
replace question_text = "Was personal anonymity secured?" if text_ == "ra_anonymity_num"
replace question_text = "Were risks of coercion considered?" if text_ == "ra_coercion_risk_num"
replace question_text = "Were procedures ensuring that consent was informed followed?" if text_ == "ra_consent_num"
replace question_text = "Did the research involve deception?" if text_ == "ra_deception_num"
replace question_text = "Did the research involve original experiments involving humans?" if text_ == "ra_experiment_num"
replace question_text = "Were there any plans for future use of the data?" if text_ == "ra_future_num"
replace question_text = "Did the research involve incompetent adults?" if text_ == "ra_incompetent_num"
replace question_text = "Were data protection and storage requirements followed?" if text_ == "ra_protection_num"
replace question_text = "Did the research involve any risks to the researcher?" if text_ == "ra_risk_researcher_num"
replace question_text = "Were there potential benefits and hazards for the subjects?" if text_ == "ra_risk_subject_num"
replace question_text = "Did the research involve the collection of sensitive personal data?" if text_ == "ra_sensitive_num"
replace question_text = "Did the research involve tracking or observation of participants?" if text_ == "ra_tracking_num"

labmask question, val(question_text)

*splitvallabels question, recode
*catplot ra_ question, ytitle("Percent of Respondents") asyvars stack var2opts(sort(1) descending)
*graph export "output/graphs_both.png", replace

splitvallabels question if text_ == "ra_coercion_risk_num" | text_ == "ra_consent_num" | text_ == "ra_deception_num" | text_ == "ra_experiment_num" | text_ == "ra_incompetent_num" | text_ == "ra_risk_researcher_num" | text_ == "ra_risk_subject_num", recode
catplot ra_ question if text_ == "ra_coercion_risk_num" | text_ == "ra_consent_num" | text_ == "ra_deception_num" | text_ == "ra_experiment_num" | text_ == "ra_incompetent_num" | text_ == "ra_risk_researcher_num" | text_ == "ra_risk_subject_num", fraction(question) var2opts(sort(2) descending label(labsize(small)) gap(*0.5) relabel(`r(relabel)')) ytitle("Fraction of Respondents" "N = 51", size(small)) asyvars stack graphregion(color(white)) legend(size(small)) xsize(2.5) note("Note: Only asked from those who did some original analysis." "Option NA was added after pilot coding." "Questions are truncated in some cases." "Questions are sorted by the fraction of the yes answers.", size(vsmall))
graph export "output/graphs_original.png", replace
*restore

splitvallabels question if text_ == "ra_anonymity_num" | text_ == "ra_future_num" | text_ == "ra_protection_num" | text_ == "ra_sensitive_num" | text_ == "ra_tracking_num", recode
catplot ra_ question if text_ == "ra_anonymity_num" | text_ == "ra_future_num" | text_ == "ra_protection_num" | text_ == "ra_sensitive_num" | text_ == "ra_tracking_num", fraction(question) var2opts(sort(2) descending label(labsize(small)) gap(*0.5) relabel(`r(relabel)')) ytitle("Fraction of Respondents" "N = 80", size(small)) asyvars stack graphregion(color(white)) legend(size(small)) xsize(2.5) note("Note: Only asked from those who did some analysis (original, secondary, both)." "Option NA was added after pilot coding." "Questions are truncated in some cases." "Questions are sorted by the fraction of the yes answers.", size(vsmall))
graph export "output/graphs_all.png", replace
*restore
