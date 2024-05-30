log using $stata/disd03_descriptives.log, replace
use $/disability_disaster/data/2021_NHS_general_data_disd02.dta

//  github:		disability_disaster_response

//  author:		Annie Yaeger 

***--------------------------***
// PROGRAM SETUP
***--------------------------***

version 18 
set linesize 80
clear all
set more off

***--------------------------***
// DESCRIPTIVE STATISTICS
***--------------------------***
//Confidence, preparedness stage, and info by disability status
dtable i.confidence_prep i.preparedness_stage mean_info 	///
	male /// 
	c.income_redi i.insurance_ownership mean_cbo  ///
	new_disaster_experience i.education i.race_ethnicity i.age i.simple_employment, by(disability) ///
	export("$results/disd03_dtable_disability.docx", as(docx) replace)

//Information margins plot
svy: reg mean_info disability male  ///  
	mean_cbo new_disaster_experience i.insurance_ownership  /// 
	c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment

capture egen disabilitymean = mean(disability), by(mean_info)
capture egen dispercent = mean (100 * disability), by(mean_info)
twoway connected dispercent mean_info, ytitle(Percent Disability) sort

clear all
frame create disability_info_percents
frame change disability_info_percents
use $data/2021_NHS_general_data_cd43.dta

tab mean_info disability, matcell(x)
gen r = 1
collapse (count) r, by(mean_info disability)
list
egen r_tot = total(r), by(disability)
gen r_pct = r/r_tot
list

twoway connected  r_pct mean_info, by(disability)

twoway ///
	(connected r_pct mean_info if disability==1, color("0 63 92")) ///
	(connected r_pct mean_info if disability==0, color("188 80 144")), ///
	xtitle("Mean level of information", color("147 149 152")) ///
	ytitle("Proportion of respondents", color("147 149 152")) ///
	ylabel(, gmax tlwidth(medium) glcolor(white) glwidth(medium)) yscale(lcolor("147 149 152")) /// 
	legend(on order (1 "Disability" 2 "No Disability")) //
	
graph save "Graph" "$results/disd03_mean_info_by_disability_line.gph", replace
graph export $results/disd03_mean_info_by_disability_line.pdf, replace
	
frame change default
frame drop disability_info_percents

//Prep by disability histogram
graph hbar (percent) not_prepared intend_prep_year intend_prep_6months prepared_year prepared_overyear, ///
	over(disability, label(angle(50) labsize(small))) vertical percentage ///
	legend(on order(1 "Not prepared, do not intend to prep in the next year" ///
	2 "Not prepared, intend to prepare in the next year" ///
	3 "Not prepared, intend to prepare in the next six months" ///
	4 "Been prepared for the past year" ///
	5 "Been prepared for more than a year, continues preparing") stack rows(5) ///
	size(vsmall) color(black) margin(small) ///
	nobox region(fcolor(white) lcolor(white))) ///
	bar(1, fcolor("0 63 92") fintensity(inten100) lcolor("0 63 92") lwidth(small)) ///
	bar(2, fcolor("188 80 144") fintensity(inten100) lcolor("188 80 144") lwidth(small)) ///
	bar(3, fcolor("255 99 97") fintensity(inten100) lcolor("255 99 97") lwidth(small)) ///
	bar(4, fcolor("255 166 0") fintensity(inten100) lcolor("255 166 0") lwidth(small)) ///
	bar(5, fcolor("88 80 141") fintensity(inten100) lcolor("88 80 141") lwidth(small)) ///
	ytitle("Percentage of Respondents", size(medium))

graph save "Graph" "$results/disd03_prepstage_by_disability_histogram.gph", replace
graph export $results/disd03_prepstage_by_disability_histogram.pdf, replace

//Confidence by disability histogram
	graph hbar (percent) extremely_conf moderate_conf somewhat_conf slightly_conf not_conf, ///
	over(disability, label(angle(50) labsize(small))) vertical percentage ///
	legend(on order(1 "Extremely confident" ///
	2 "Moderately confident" ///
	3 "Somewhat confident" ///
	4 "Slightly confident" ///
	5 "Not at all confident") stack rows(5) ///
	size(vsmall) color(black) margin(small) ///
	nobox region(fcolor(white) lcolor(white))) ///
	bar(1, fcolor("0 63 92") fintensity(inten100) lcolor("0 63 92") lwidth(small)) ///
	bar(2, fcolor("188 80 144") fintensity(inten100) lcolor("188 80 144") lwidth(small)) ///
	bar(3, fcolor("255 99 97") fintensity(inten100) lcolor("255 99 97") lwidth(small)) ///
	bar(4, fcolor("255 166 0") fintensity(inten100) lcolor("255 166 0") lwidth(small)) ///
	bar(5, fcolor("88 80 141") fintensity(inten100) lcolor("88 80 141") lwidth(small)) ///
	ytitle("Percentage of Respondents", size(medium))
	
graph save "Graph" "$results/disd03_conf_by_disability_histogram.gph", replace
graph export $results/disd03_conf_by_disability_histogram.pdf, replace


***--------------------------***
log close 

exit
