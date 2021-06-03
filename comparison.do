capture ssc install coefplot
use "output/analysis_sample", clear

foreach var of varlist ra_analysis_exist_num-ra_future_num{
	reg `var' i.department_num i.program_num [pweight = weight], robust
}

reg ra_analysis_exist_num i.department_num i.program_num [pweight = weight] if ra_analysis_exist_num != 2, robust coeflegend

coefplot, levels(90) xline(0, lcolor(black)) graphregion(color(white)) drop(_cons) title("Dependent variable: analysis exists", col(black)) ytitle("Independent variables") note("Notes: Points represent coefficient estimates." "Lines represent 90% confidence intervals." "Weighted results." "Robust standard errors.", size(vsmall)) omitted baselevels headings(1.department_num = "{bf: Department}" 1.program_num = "{bf: Program}")
graph export "output/reg_analysis.pdf", replace
