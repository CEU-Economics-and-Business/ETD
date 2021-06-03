objects = output/reg_analysis.pdf output/graphs_original.pdf output/analysis_sample.dta output/all.csv
all: $(objects)

output/reg_analysis.pdf: output/analysis_sample.dta comparison.do
	stata -b do comparison.do
output/graphs_original.pdf: output/analysis_sample.dta analysis.do
	stata -b do analysis.do
output/analysis_sample.dta: output/all.csv report/results_pilot.csv report/results_second.csv merge.do
	stata -b do merge.do
output/all.csv: output/PHD_30.csv output/Business_10.csv output/MA_100.csv append.do
	stata -b do append.do

