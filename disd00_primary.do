

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

global stata "/Users/annieyaeger/Desktop/disability_disaster_response/stata"
global data "/Users/annieyaeger/Desktop/disability_disaster_response/data"
global results "/Users/annieyaeger/Desktop/disability_disaster_response/results"

***--------------------------***
cd $stata

do disd01_import.do 		// import and add survey weights
do disd02_variables.do 		// recode variables
do disd03_descriptives.do	// descriptive statistics
do disd04_regress.do		// regressions
