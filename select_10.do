foreach file in "PHD_30" "Business_10" "MA_100" {
	import delimited "output/`file'.csv", encoding(UTF-8) clear
	foreach var in year subject {
		cap tostring(`var'), replace
		}
	tempfile `file'
	save ``file''
}

use `PHD_30', clear
*use `Business_10', clear
append using `Business_10'
append using `MA_100'

count

clonevar program_sampling = program
foreach val in "MESPOM" "MSc" {
	replace program_sampling = "MA" if program == "`val'"
}

tab program_sampling

*save "output/all", replace
export delimited using "/home/zavecz/etd/ETD/output/all.csv", replace

set seed 123
sample 7, by(program_sampling)
tab program_sampling 

*save "output/sample", replace
export delimited using "/home/zavecz/etd/ETD/output/sample.csv", replace
