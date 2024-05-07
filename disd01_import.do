capture log close disd01_import
log using $stata/disd01_import.smcl, name(disd01_import) replace text

//	project:	Disability and Disaster Information, Confidence, and Preparation

//  task:		Import and Merge

//  github:		disability_disaster

//  author:		Annie Yaeger 

display "$S_DATE  $S_TIME"

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








***--------------------------***
log close disd01_import

exit
