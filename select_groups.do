preserve
import delimited using "output/sample.csv", clear
tempfile sample
save `sample'
restore

import delimited using "output/all.csv", clear
count

merge 1:1 thesis_link using `sample', keep(1) nogen
count

gen flag = (!regexm(pdf_link,"etd") | regexm(pdf_link,"atta") | regexm(pdf_link,"bakr"))
count if flag
drop if flag
drop flag

splitsample, gen(coder) nsplit(2) balance(program_sampling) rround rseed(123)
tab program_sampling coder

gen slash = strrpos(pdf_link,"/")
gen folder_name = substr(pdf_link,(slash+1),.)
drop slash
sort folder_name

export delimited using "output/thesis_mirko.csv" if coder == 1, replace
export delimited using "output/thesis_gaurav.csv" if coder == 2, replace

*double-check whether there is overlap
preserve
import delimited using "output/thesis_mirko.csv", clear
tempfile mirko
save `mirko'
restore

import delimited using "output/thesis_gaurav.csv", clear
merge 1:1 thesis_link using `mirko'
