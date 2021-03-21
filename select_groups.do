preserve
import delimited using "output/sample.csv", clear
tempfile sample
save `sample'
restore

import delimited using "output/all.csv", clear
count

merge 1:1 thesis_link using `sample', keep(1 3) nogen
count
