capture log close
log using $stata/disd01_import.log, replace

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
// IMPORT SURVEY DATA
***--------------------------***

import excel $data/survey_data_merged_cells.xlsx, sheet("2021 NHS General Data") firstrow

save $data/2021_NHS_general_data.dta, replace

***--------------------------***
log close 

exit
