//	project:	Disability and Disaster Information, Confidence, and Preparation

//  task:		Primary file
//				This will run all files in folder: me_search

//  github:		disability_disaster

//  author:		Annie Yaeger 

display "$S_DATE  $S_TIME"

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

global stata "~/disability_disaster/stata"
global data "~/disability_disaster/data"
global results "~/disability_disaster/results"

***--------------------------***
cd $stata

do disd01_import.do 		// import and add survey weights
do disd02_variables.do 		// recode variables
do disd03_descriptives.do	// descriptive statistics
do disd04_regress.do		// regressions

