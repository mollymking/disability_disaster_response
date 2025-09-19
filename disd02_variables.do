log using $stata/disd02_variables.log, replace

***--------------------------***
// PROGRAM SETUP
***--------------------------***

version 18 
set linesize 80
clear all
set more off

***--------------------------***
// DEMOGRAPHIC VARIABLES
***--------------------------***
use $data/2021_NHS_general_data.dta

//DISABILITY
gen disability = .
replace disability = 1 if D4ADoyouhaveadisabilityor == "Disability"
replace disability = 0 if D4ADoyouhaveadisabilityor == "No Disability"
tab D4ADoyouhaveadisabilityor disability, m

label define Disability_label 1 Disability 0 "No Disability"
label values disability Disability_label
tab disability, m

//EDUCATION
tab Educationascapturedinrawsur, m
gen education = .
replace education = 0 if Educationascapturedinrawsur == "Less than high school diploma"
replace education = 1 if Educationascapturedinrawsur == "High school degree or diploma"
replace education = 2 if Educationascapturedinrawsur == "Some college, no degree"
replace education = 3 if Educationascapturedinrawsur == "Associate's degree"
replace education = 4 if Educationascapturedinrawsur == "Bachelor's degree"
replace education = 5 if Educationascapturedinrawsur == "Post graduate work/degree or professional degree"
replace education = . if Educationascapturedinrawsur == "Don't know"
replace education = . if Educationascapturedinrawsur == "Prefer not to answer"
tab Educationascapturedinrawsur education, m

label define Education_label ///
	0 "Less than high school diploma" ///
	1 "High school degree or diploma" ///
	2 "Some college, no degree" ///
	3 "Associate's degree" ///
	4 "Bachelor's degree" ///
	5 "Post graduate work/degree or professional degree" 
label values education Education_label
tab education, m


//MALE
gen male = .
replace male = 0 if ///
	Genderascapturedinrawsurvey == "Female" | ///
	Genderascapturedinrawsurvey == "Non-binary / third gender" | ///
	Genderascapturedinrawsurvey == "I use another term (specify): " 
replace male = 1 if Genderascapturedinrawsurvey == "Male"
replace male = . if ///
	Genderascapturedinrawsurvey == "Don't know" | ///
	Genderascapturedinrawsurvey == "Prefer not to answer"
tab Genderascapturedinrawsurvey male, m

label define Male_label 0 "Not male" 1 Male
label values male Male_label
tab male, m

//NEW_DISASTER_EXPERIENCE
gen new_disaster_experience = .
replace new_disaster_experience = 0 if GENEXP1Haveyouoryourfamily == "No"
replace new_disaster_experience = 1 if GENEXP1Haveyouoryourfamily == "Yes"
replace new_disaster_experience = . if GENEXP1Haveyouoryourfamily == "Don't know"
replace new_disaster_experience = . if GENEXP1Haveyouoryourfamily == "Prefer not to answer"
tab GENEXP1Haveyouoryourfamily new_disaster_experience, m

label define new_disaster_experience_label 0 No 1 Yes 
label values new_disaster_experience new_disaster_experience_label
tab new_disaster_experience, m

//AGE
gen age = .
replace age = 0 if QNS6WhatisyourageAGE == "18-29"
replace age = 1 if QNS6WhatisyourageAGE == "30-39"
replace age = 2 if QNS6WhatisyourageAGE == "40-49"
replace age = 3 if QNS6WhatisyourageAGE == "50-59"
replace age = 4 if QNS6WhatisyourageAGE == "60-69"
replace age = 5 if QNS6WhatisyourageAGE == "70-79"
replace age = 6 if QNS6WhatisyourageAGE == "Over 80"

label define Age_label 0 "18-29" 1 "30-39" 2 "40-49" 3 "50-59" 4 "60-69" 5 "70-79" 6 "Over 80"
label values age Age_label
tab QNS6WhatisyourageAGE age, m

//INSURANCE_OWNERSHIP
//insurance recode
gen insurance = .
replace insurance = 0 if FP1Doyouhavehomeownersorr == "No"
replace insurance = 1 if FP1Doyouhavehomeownersorr == "Yes"
replace insurance = . if FP1Doyouhavehomeownersorr == "Prefer not to answer"
replace insurance = . if FP1Doyouhavehomeownersorr == "Don't know"

label define Insurance_label 0 No 1 Yes
label values insurance Insurance_label
tab FP1Doyouhavehomeownersorr insurance, m

//home ownership recode
gen home_ownership = .
replace home_ownership = 1 if D8Doyourentorownyourhome == "Own"
replace home_ownership = 0 if D8Doyourentorownyourhome == "Rent"

label define Home_ownership_label 1 Own 0 Rent
label values home_ownership Home_ownership_label
tab D8Doyourentorownyourhome home_ownership, m

//insurance_ownership recode
gen insurance_ownership = .
replace insurance_ownership = 1 if insurance == 1 & home_ownership == 0
replace insurance_ownership = 2 if insurance == 0 & home_ownership == 0
replace insurance_ownership = 3 if insurance == 1 & home_ownership == 1
replace insurance_ownership = 4 if insurance == 0 & home_ownership == 1

label define Insurance_own_label ///
	1 "Renter with insurance" ///
	2 "Renter without insurance" ///
	3 "Owner with insurance" ///
	4 "Owner without insurance"
label values insurance_ownership Insurance_own_label
tab insurance_ownership insurance, m
tab insurance_ownership home_ownership, m

//MEAN_CBO
//animal welfare
tab CBO1Howoftendoyouuseorre

gen animal_welfare = .
replace animal_welfare = 0 if CBO1Howoftendoyouuseorre == "Never"
replace animal_welfare = 1 if CBO1Howoftendoyouuseorre == "Rarely"
replace animal_welfare = 2 if CBO1Howoftendoyouuseorre == "Occasionally"
replace animal_welfare = 3 if CBO1Howoftendoyouuseorre == "A Moderate Amount"
replace animal_welfare = 4 if CBO1Howoftendoyouuseorre == "A Great Deal"

label define Animal_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values animal_welfare Animal_label
tab animal_welfare  CBO1Howoftendoyouuseorre, m

//childcare
tab CBO1_b

gen childcare = .
replace childcare = 0 if CBO1_b == "Never"
replace childcare = 1 if CBO1_b == "Rarely"
replace childcare = 2 if CBO1_b == "Occasionally"
replace childcare = 3 if CBO1_b == "A Moderate Amount"
replace childcare = 4 if CBO1_b == "A Great Deal"

label define Childcare_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values childcare Childcare_label
tab childcare

//emergency_services
tab CBO1_d

gen emergency_services = .
replace emergency_services = 0 if CBO1_d == "Never"
replace emergency_services = 1 if CBO1_d == "Rarely"
replace emergency_services = 2 if CBO1_d == "Occasionally"
replace emergency_services = 3 if CBO1_d == "A Moderate Amount"
replace emergency_services = 4 if CBO1_d == "A Great Deal"

label define Emergency_services_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values emergency_services Emergency_services_label
tab emergency_services

//faith_services
tab CBO1_e

gen faith_services = .
replace faith_services = 0 if CBO1_e == "Never"
replace faith_services = 1 if CBO1_e == "Rarely"
replace faith_services = 2 if CBO1_e == "Occasionally"
replace faith_services = 3 if CBO1_e == "A Moderate Amount"
replace faith_services = 4 if CBO1_e == "A Great Deal"

label define faith_services_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values faith_services faith_services_label
tab faith_services

//financial_support
tab CBO1_f

gen financial_support = .
replace financial_support = 0 if CBO1_f == "Never"
replace financial_support = 1 if CBO1_f == "Rarely"
replace financial_support = 2 if CBO1_f == "Occasionally"
replace financial_support = 3 if CBO1_f == "A Moderate Amount"
replace financial_support = 4 if CBO1_f == "A Great Deal"

label define financial_support_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values financial_support financial_support_label
tab financial_support

//food_pantry
tab CBO1_g

gen food_pantry = .
replace food_pantry = 0 if CBO1_g == "Never"
replace food_pantry = 1 if CBO1_g == "Rarely"
replace food_pantry = 2 if CBO1_g == "Occasionally"
replace food_pantry = 3 if CBO1_g == "A Moderate Amount"
replace food_pantry = 4 if CBO1_g == "A Great Deal"

label define food_pantry_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values food_pantry food_pantry_label
tab food_pantry

//general_services
tab CBO1_h

gen general_services = .
replace general_services = 0 if CBO1_h == "Never"
replace general_services = 1 if CBO1_h == "Rarely"
replace general_services = 2 if CBO1_h == "Occasionally"
replace general_services = 3 if CBO1_h == "A Moderate Amount"
replace general_services = 4 if CBO1_h == "A Great Deal"

label define general_services_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values general_services general_services_label
tab general_services

//housing_support
tab CBO1_j

gen housing_support = .
replace housing_support = 0 if CBO1_j == "Never"
replace housing_support = 1 if CBO1_j == "Rarely"
replace housing_support = 2 if CBO1_j == "Occasionally"
replace housing_support = 3 if CBO1_j == "A Moderate Amount"
replace housing_support = 4 if CBO1_j == "A Great Deal"

label define housing_support_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values housing_support housing_support_label
tab housing_support

//immigrant_support
tab CBO1_k

gen immigrant_support = .
replace immigrant_support = 0 if CBO1_k == "Never"
replace immigrant_support = 1 if CBO1_k == "Rarely"
replace immigrant_support = 2 if CBO1_k == "Occasionally"
replace immigrant_support = 3 if CBO1_k == "A Moderate Amount"
replace immigrant_support = 4 if CBO1_k == "A Great Deal"

label define immigrant_support_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values immigrant_support immigrant_support_label
tab immigrant_support

//legal_aid
tab CBO1_l

gen legal_aid = .
replace legal_aid = 0 if CBO1_l == "Never"
replace legal_aid = 1 if CBO1_l == "Rarely"
replace legal_aid = 2 if CBO1_l == "Occasionally"
replace legal_aid = 3 if CBO1_l == "A Moderate Amount"
replace legal_aid = 4 if CBO1_l == "A Great Deal"

label define legal_aid_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values legal_aid legal_aid_label
tab legal_aid

//small_business
tab CBO1_m

gen small_business = .
replace small_business = 0 if CBO1_m == "Never"
replace small_business = 1 if CBO1_m == "Rarely"
replace small_business = 2 if CBO1_m == "Occasionally"
replace small_business = 3 if CBO1_m == "A Moderate Amount"
replace small_business = 4 if CBO1_m == "A Great Deal"

label define small_business_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values small_business small_business_label
tab small_business

//senior_support
tab CBO1_n

gen senior_support = .
replace senior_support = 0 if CBO1_n == "Never"
replace senior_support = 1 if CBO1_n == "Rarely"
replace senior_support = 2 if CBO1_n == "Occasionally"
replace senior_support = 3 if CBO1_n == "A Moderate Amount"
replace senior_support = 4 if CBO1_n == "A Great Deal"

label define senior_support_label 0 Never 1 Rarely 2 Occasionally 3 "A Moderate Amount" 4 "A Great Deal"
label values senior_support senior_support_label
tab senior_support

//mean
gen mean_cbo = (animal_welfare + childcare + emergency_services + faith_services + financial_support + food_pantry + general_services + housing_support + immigrant_support + legal_aid + small_business + senior_support)/12
sum mean_cbo, det

//SIMPLE_EMPLOYMENT
gen simple_employment = .
replace simple_employment = 0 if ///
	Employmentascapturedinrawsu == "No, I have been unemployed for less than 1 month" | ///
	Employmentascapturedinrawsu == "No, I have been unemployed for 1-2 months" | ///
	Employmentascapturedinrawsu == "No, I have been unemployed for 2-6 months" | ///
	Employmentascapturedinrawsu == "No, I have been unemployed for 6 months - 1 year" | ///
	Employmentascapturedinrawsu == "No, I have been unemployed for more than 1 year" | ///
	Employmentascapturedinrawsu == "Not in the labor force, and not retired (e.g. student, stay-at-home spouse)" 
replace simple_employment = 1 if Employmentascapturedinrawsu == "No, I am retired"
replace simple_employment = 2 if ///
	Employmentascapturedinrawsu == "Yes" | ///
	Employmentascapturedinrawsu == "In Armed Forces"

label define Simple_employment_label 0 "Unemployed" 1 "Retired" 2 "Employed"
label values simple_employment Simple_employment_label
tab Employmentascapturedinrawsu simple_employment, m

//RACE/ETHNICITY
// Ethnicity
tab Ethnicityafterdatacleaningpr, m nolabel
tab Ethnicityafterdatacleaningpr, m

// Race
tab D4Whichofthefollowingdescr, m nolabel
tab D4Whichofthefollowingdescr, m 

tab D4Whichofthefollowingdescr Ethnicityafterdatacleaningp, m

** Modified version of the combined race specification: insufficient sample size of Native Hawaiian / Pacific Islander and  American Indian/Alaska Native, so added to "Other", otherwise follow:
*"combined race (a more detailed scheme that also separated out Pacific Island-origin and multiple race respondents)"
* "pentagon race (which includes five categories distinguishing American Indian, Asian, Black, Hispanic, and White respondents)"
*Combined Race based on Howell & Emerson 2017: https://journals.sagepub.com/doi/10.1177/2332649216648465

gen race_ethnicity = .
replace race_ethnicity = 0 if D4Whichofthefollowingdescr == "White" &  ///
	D4Whichofthefollowingdescr != "Black or African American" & ///
	D4Whichofthefollowingdescr != "Asian" & ///
	Ethnicityafterdatacleaningpr != "Hispanic/Latino" & ///
	D4Whichofthefollowingdescr != "Native Hawaiian or Pacific Islander" & ///
	D4Whichofthefollowingdescr != "American Indian or Alaska Native" & ///
	D4Whichofthefollowingdescr != "Other"
	
replace race_ethnicity = 1 if D4Whichofthefollowingdescr == "Black or African American" & ///
	D4Whichofthefollowingdescr != "White" & ///
	D4Whichofthefollowingdescr != "Asian" & ///
	Ethnicityafterdatacleaningpr != "Hispanic/Latino" & ///
	D4Whichofthefollowingdescr != "Native Hawaiian or Pacific Islander" & ///
	D4Whichofthefollowingdescr != "American Indian or Alaska Native" & ///
	D4Whichofthefollowingdescr != "Other"
	
replace race_ethnicity = 2 if D4Whichofthefollowingdescr == "Asian" & ///
	D4Whichofthefollowingdescr != "Black or African American" & ///
	D4Whichofthefollowingdescr != "White" & ///
	Ethnicityafterdatacleaningpr != "Hispanic/Latino" & ///
	D4Whichofthefollowingdescr != "Native Hawaiian or Pacific Islander" & ///
	D4Whichofthefollowingdescr != "American Indian or Alaska Native" & ///
	D4Whichofthefollowingdescr != "Other"
	
*"Hispanic origin responses efectively override race responses (as in combined race and pentagon)" (Guluma and Saperstein 2022)
replace race_ethnicity = 3 if Ethnicityafterdatacleaningpr == "Hispanic/Latino" 

replace race_ethnicity = 4 if ///
	D4Whichofthefollowingdescr == "Other" | ///
	D4Whichofthefollowingdescr == "Native Hawaiian or Pacific Islander" | ///
	D4Whichofthefollowingdescr == "American Indian or Alaska Native" & ///
	D4Whichofthefollowingdescr != "Black or African American" & ///
	D4Whichofthefollowingdescr != "Asian" & ///
	D4Whichofthefollowingdescr != "White" & ///
	D4Whichofthefollowingdescr != "Native Hawaiian or Pacific Islander" & ///
	D4Whichofthefollowingdescr != "American Indian or Alaska Native" & ///
	D4Whichofthefollowingdescr != "White" 

*Two or more
replace race_ethnicity = 5 if D4Whichofthefollowingdescr == "Two or More Races" 

label define race_ethnicity_label ///
	0 "White (non-Hispanic)" ///
	1 "Black or African American" ///
	2 "Asian" ///
	3 "Hispanic/Latino" ///
	4 "Other" ///
	5 "Multiple"
label values  race_ethnicity race_ethnicity_label
tab race_ethnicity, m
tab race_ethnicity, m nolabel
tab race race_ethnicity, m

replace race_ethnicity = 4 if race_ethnicity == .
label values  race_ethnicity race_ethnicity_label
tab race race_ethnicity, m
tab D4Whichofthefollowingdescr race_ethnicity, m
tab Ethnicityafterdatacleaningpr race_ethnicity, m

***--------------------------***
// VARIABLES OF INTEREST
***--------------------------***
//CONFIDENCE_PREP
gen confidence_prep = . 
replace confidence_prep = 0 if C2Howconfidentareyouthaty == "Not at all confident"
replace confidence_prep = 1 if C2Howconfidentareyouthaty == "Slightly confident"
replace confidence_prep = 2 if C2Howconfidentareyouthaty == "Somewhat confident"
replace confidence_prep = 3 if C2Howconfidentareyouthaty == "Moderately confident"
replace confidence_prep = 4 if C2Howconfidentareyouthaty == "Extremely confident"
replace confidence_prep = . if C2Howconfidentareyouthaty ==  "Don't know" | ///
							   C2Howconfidentareyouthaty == "Prefer not to answer"

label define confidence_rev_label 4 "Extremely confident" 3 "Moderately confident" 2 "Somewhat confident" 1 "Slighly confident" 0 "Not at all confident"
label values confidence_prep confidence_rev_label
tab confidence_prep, m


//Confidence recode for histograms
tab confidence_prep, m
tab confidence_prep, m nolab

gen extremely_conf = .
replace extremely_conf = 1 if confidence_prep == 4
label define Extremely_conf 1 "Extremely confident"
label values extremely_conf Extremely_conf
tab extremely_conf

gen moderate_conf = .
replace moderate_conf = 1 if confidence_prep == 3
label define Moderate_conf 1 "Moderately confident"
label values moderate_conf Moderate_conf
tab moderate_conf

gen somewhat_conf = .
replace somewhat_conf = 1 if confidence_prep == 2
label define Somewhat_conf 1 "Somewhat confident"
label values somewhat_conf Somewhat_conf
tab somewhat_conf

gen slightly_conf = .
replace slightly_conf = 1 if confidence_prep == 1
label define Slightly_conf 1 "Slightly confident"
label values slightly_conf Slightly_conf
tab slightly_conf

gen not_conf = .
replace not_conf = 1 if confidence_prep == 0
label define Not_conf 1 "Not at all confident"
label values not_conf Not_conf
tab not_conf


//MEAN_INFO
//alerts and warnings
tab A3Inthepastyearwhatinfor, m

gen info_alerts_warnings = .
replace info_alerts_warnings = 0 
replace info_alerts_warnings = 1 if A3Inthepastyearwhatinfor == "Sign up for Alerts and Warnings"

label define Info_alerts_warnings 0 No 1 "Sign up for Alerts and Warnings"
label values info_alerts_warnings Info_alerts_warnings
tab info_alerts_warnings A3Inthepastyearwhatinfor, m

//make a plan
tab A3_B, m

gen info_plan = .
replace info_plan = 0 
replace info_plan = 1 if A3_B == "Make a Plan"

label define Info_plan 0 No 1 "Make a Plan"
label values info_plan Info_plan
tab info_plan A3_B, m

//save for rainy day
tab A3_C, m

gen info_save = .
replace info_save = 0 
replace info_save = 1 if A3_C == "Save for a Rainy Day"

label define Info_save 0 No 1 "Save for a Rainy Day"
label values info_save Info_save
tab info_save A3_C, m

//emergency Drills
tab A3_D, m

gen info_emergency_drills = .
replace info_emergency_drills = 0 
replace info_emergency_drills = 1 if A3_D == "Practice Emergency Drills or Habits"

label define info_emergency_drills 0 No 1 "Practice Emergency Drills or Habits"
label values info_emergency_drills info_emergency_drills
tab info_emergency_drills A3_D, m

//family Communication
tab A3_E, m

gen info_communication = .
replace info_communication = 0 
replace info_communication = 1 if A3_E == "Test Family Communication Plan"

label define info_communication 0 No 1 "Test Family Communication Plan"
label values info_communication info_communication
tab info_communication  A3_E, m

//safeguard Documents
tab A3_F, m

gen info_documents = .
replace info_documents = 0 
replace info_documents = 1 if A3_F == "Safeguard Documents"

label define info_documents 0 No 1 "Safeguard Documents"
label values info_documents info_documents
tab info_documents A3_F, m

//plan with neighbors
tab A3_G, m

gen info_neighbors = .
replace info_neighbors = 0 
replace info_neighbors = 1 if A3_G == "Plan with Neighbors"

label define info_neighbors 0 No 1 "Plan with Neighbors"
label values info_neighbors info_neighbors
tab info_neighbors  A3_G, m

//assemble/Update Supplies
tab A3_H, m 

gen info_supplies = .
replace info_supplies = 0 
replace info_supplies = 1 if A3_H == "Assemble or Update Supplies"

label define info_supplies 0 No 1 "Assemble or Update Supplies"
label values info_supplies info_supplies
tab info_supplies A3_H, m

//involved in Community
tab A3_I, m

gen info_involved = .
replace info_involved = 0 
replace info_involved = 1 if A3_I == "Get Involved in Your Community"

label define info_involved 0 No 1 "Get Involved in Your Community"
label values info_involved info_involved
tab info_involved A3_I, m

//make home safer
tab A3_J, m

gen info_home_safer = .
replace info_home_safer = 0 
replace info_home_safer = 1 if A3_J == "Make Your Home Safer"

label define info_home_safer 0 No 1 "Make Your Home Safer"
label values info_home_safer info_home_safer
tab info_home_safer A3_J, m

//know evacuation routes
tab A3_K, m

gen info_evacuation = .
replace info_evacuation = 0 
replace info_evacuation = 1 if A3_K == "Know Evacuation Routes"

label define info_evacuation 0 No 1 "Know Evacuation Routes"
label values info_evacuation info_evacuation
tab info_evacuation A3_K, m

//document and insure property
tab A3_L, m

gen info_insure_property = .
replace info_insure_property = 0 
replace info_insure_property = 1 if A3_L == "Document and Insure Property"

label define info_insure_property 0 No 1 "Document and Insure Property"
label values info_insure_property info_insure_property
tab info_insure_property A3_L, m

//mean info
gen mean_info = (info_alerts_warnings + info_plan + info_save + info_emergency_drills + info_communication + info_documents + info_neighbors + info_supplies + info_involved + info_home_safer + info_evacuation + info_insure_property)/12
label var mean_info "Mean info: alerts + plan + saving + drills + comm + docs + neighbors + supplies + involved + home + evac"
sum mean_info, det


//PREPAREDNESS_STAGE
tab ST_STG1Thinkingaboutpreparing, m
gen preparedness_stage = .
replace preparedness_stage = 0 if ST_STG1Thinkingaboutpreparing == "I am NOT prepared, and I do not intend to prepare in the next year"
replace preparedness_stage = 1 if ST_STG1Thinkingaboutpreparing == "I am NOT prepared, but I intend to start preparing in the next year"
replace preparedness_stage = 2 if ST_STG1Thinkingaboutpreparing == "I am NOT prepared, but I intend to get prepared in the next six months"
replace preparedness_stage = 3 if ST_STG1Thinkingaboutpreparing == "I have been prepared for the last year"
replace preparedness_stage = 4 if ST_STG1Thinkingaboutpreparing == "I have been prepared for MORE than a year and I continue preparing"
replace preparedness_stage = . if ST_STG1Thinkingaboutpreparing == "Don't know"
replace preparedness_stage = . if ST_STG1Thinkingaboutpreparing == "Prefer not to answer"
tab ST_STG1Thinkingaboutpreparing preparedness_stage, m

label define Preparedness_stage_label ///
	0 "I am NOT prepared, and I do not intend to prepare in the next year" ///
	1 "I am NOT prepared, but I intend to start preparing in the next year" ///
	2 "I am NOT prepared, but I intend to get prepared in the next six months" ///
	3 "I have been prepared for the last year" ///
	4 "I have been prepared for MORE than a year and I continue preparing"
label values preparedness_stage Preparedness_stage_label
tab preparedness_stage, m

//Preparedness stage recode for histograms
tab preparedness_stage
tab preparedness_stage, nolab

gen not_prepared = .
replace not_prepared = 1 if preparedness_stage == 0
label define Not_prepared_label 1 "I am NOT prepared, and I do not intend to prepare in the next year"
label values not_prepared Not_prepared_label
tab not_prepared

gen intend_prep_year = .
replace intend_prep_year = 1 if preparedness_stage == 1
label define Intend_prep_year 1 "I am NOT prepared, but I intend to start preparing in the next year"
label values intend_prep_year Intend_prep_year
tab intend_prep_year

gen intend_prep_6months = .
replace intend_prep_6months = 1 if preparedness_stage == 2
label define Intend_prep_6months 1 "I am NOT prepared, but I intend to get prepared in the next six months"
label values intend_prep_6months Intend_prep_6months
tab intend_prep_6months

gen prepared_year = .
replace prepared_year = 1 if preparedness_stage == 3
label define Prepared_year 1 "I have been prepared for the last year"
label values prepared_year Prepared_year
tab prepared_year

gen prepared_overyear= .
replace prepared_overyear = 1 if preparedness_stage == 4
label define Prepared_overyear 1 "I have been prepared for MORE than a year and I continue preparing"
label values prepared_overyear Prepared_overyear
tab prepared_overyear

save $data/2021_NHS_general_data_disd02.dta, replace

***--------------------------***
log close 
exit
