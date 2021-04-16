output/graphs_original.png: output/analysis_sample.dta
	stata -b do analysis.do
output/analysis_sample.dta: output/all.csv report/results_pilot.csv report/results_second.csv
	stata -b do merge.do
output/all.csv: output/PHD_30.csv output/Business_10.csv output/MA_100.csv
	stata -b do append.do

