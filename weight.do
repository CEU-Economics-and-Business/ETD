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
