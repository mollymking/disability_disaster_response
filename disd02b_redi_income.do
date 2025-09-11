log using $stata/disd02b_redi_income.log, name(redi_income) replace

//  github:		disability_disaster_response

//  author:		Molly King

***--------------------------***
// PROGRAM SETUP
***--------------------------***

version 18 
set linesize 80
clear all
set more off

***--------------------------***
// NOTES
***--------------------------***
/*
This .do file uses the REDI user-written program to convert categorical to continuous income
for use in the final regression analyses.
For more on this program, please see the Stata help file for "redi" or the publication:

King, Molly M. 2022. "REDI for binned data: 
A Random Empirical Distribution Imputation method for estimating continuous incomes." 
Sociological Methodology  52(2): 220-253. https://doi.org/10.1177/00811750221108086
*/
***--------------------------***
// CREATE CATEGORICAL INCOME VARIABLE
***--------------------------***

use $data/2021_NHS_general_data_disd02.dta, clear

gen income = .
replace income = 0 if Incomeascapturedinrawsurvey == "Less than $10,000"
replace income = 1 if Incomeascapturedinrawsurvey == "$10,000 to $19,999"
replace income = 2 if Incomeascapturedinrawsurvey == "$20,000 to $29,999"
replace income = 3 if Incomeascapturedinrawsurvey == "$30,000 to $39,999"
replace income = 4 if Incomeascapturedinrawsurvey == "$40,000 to $49,999"
replace income = 5 if Incomeascapturedinrawsurvey == "$50,000 to $59,999"
replace income = 6 if Incomeascapturedinrawsurvey == "$60,000 to $69,999"
replace income = 7 if Incomeascapturedinrawsurvey == "$70,000 to $79,999"
replace income = 8 if Incomeascapturedinrawsurvey == "$80,000 to $89,999"
replace income = 9 if Incomeascapturedinrawsurvey == "$90,000 to $99,999"
replace income = 10 if Incomeascapturedinrawsurvey == "$100,000 to $149,999"
replace income = 11 if Incomeascapturedinrawsurvey == "$150,000 to $250,000"
replace income = 12 if Incomeascapturedinrawsurvey == "More than $250,000"
replace income = . if Incomeascapturedinrawsurvey == "Don't know"
replace income = . if Incomeascapturedinrawsurvey == "Prefer not to answer"
tab Incomeascapturedinrawsurvey income, m

label define Income_label ///
	0 "Less than $10,000" ///
	1 "$10,000 to $19,999" ///
	2 "$20,000 to $29,999" ///
	3 "$30,000 to $39,999" ///
	4 "$40,000 to $49,999" ///
	5 "$50,000 to $59,999" ///
	6 "$60,000 to $69,999" ///
	7 "$70,000 to $79,999" ///
	8 "$80,000 to $89,999" ///
	9 "$90,000 to $99,999" ///
	10 "$100,000 to $149,999" ///
	11 "$150,000 to $250,000" ///
	12 "$250,000 or more" 
label values income Income_label
tab income, m

save $data/2021_NHS_general_data_disd02.dta, replace

***--------------------------***
// IMPORT CPS DATA
***--------------------------***

do $stata/$cps_dataset_filename.do
keep if year == 2021
save $data/cps_reference.dta, replace

***--------------------------***
// REDI conversions from categorical to continuous income
***--------------------------***

use $data/2021_NHS_general_data_disd02.dta, clear

*year of conversion factor
gen year = 2021
local year "year"

set seed 34858540

ssc install redi
redi income year, generate(income_redi) cpstype(household)

order income income_redi
sort income
drop year month cpsid asecflag asecwth statefip county pernum asecwt ///
	income_ub income_lb


gen inc_ln_redi = ln(income_redi)
replace inc_ln_redi = 0 if income_redi <= 0

gen inc_1k = income_redi/1000
	
save $data/2021_NHS_general_data_disd02b.dta, replace

***--------------------------***
log close redi_income

exit
