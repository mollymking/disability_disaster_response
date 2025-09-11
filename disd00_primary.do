
***--------------------------***
// DATA NOTES
***--------------------------***
/*
To run this as a replication package, the analyst will need two datasets installed in a subfolder "data":

1) The FEMA 2021 National Household Survey, available here: 
https://www.fema.gov/about/openfema/data-sets/national-household-survey
(Direct download link: https://www.fema.gov/sites/default/files/documents/fema_national_household_survey_data_and_codebook_2021.zip)
The tab "2021 NHS General Data" is used for this analysis.
The cells in the top two rows must be merged to create variable names.
Give the data filename "survey_data_merged_cells.xlsx".

2) A Current Population Survey ASEC 2021 reference dataset available for download from IPUMS
cps.ipums.org
and including the variables YEAR, ASECWTH, HHINCOME, and PERNUM
Put the stata file from IPUMS in the "stata" subfolder and
change the name of the below global to whatever your cps dataset and stata filenames are.
	For example, if the files you download are cps_00016.do and cps_00016.dat, 
	change the below global to cps_00016:
*/
global cps_dataset_filename "cps_00016"

***--------------------------***
// PROGRAM SETUP
***--------------------------***

version 18 // keeps program consistent for future replications
set linesize 80
clear all
set more off

***--------------------------***
// CHANGE DIRECTORIES to local files to run replication code:
***--------------------------***

global stata "~/Desktop/disability_disaster_response/stata"
global data "~/Desktop/disability_disaster_response/data"
global results "~/Desktop/disability_disaster_response/results"

***--------------------------***

do $stata/disd01_import.do 			// import and add survey weights
do $stata/disd02_variables.do 		// recode variables
do $stata/disd02b_redi_income.do 	// convert categorical to continuous income
do $stata/disd03_descriptives.do 	// descriptive statistics
do $stata/disd04_regress.do 		// regressions
