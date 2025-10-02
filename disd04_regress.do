capture log close 
log using $stata/disd04_regress.log, replace

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
// DATA
***--------------------------***
use $data/2021_NHS_general_data_disd02b.dta
svyset _n, weight(GeneralSampleWeightWeight)
svydescribe

***--------------------------***
// OUTCOME: INFORMATION
***--------------------------***

*Base model: Disability only
svy: reg mean_info disability 
estimates store info_model_dis

*Adding controls
svy: reg mean_info disability   ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment 
estimates store info_model_controls
	
etable, showstars ///
	estimates(info_model_dis info_model_controls) ///
	mstat(N) mstat(r2) ///
	export("$results/disd04_info_regression.docx", as(docx) replace)

// VISUALIZE: Predicted information by disability status 
quietly: ///
svy: reg mean_info i.disability woman_nb  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment 

margins disability, atmeans
marginsplot, xtitle("Disability Status") ytitle("Linear Prediction") ///
	title("Predicted Information By Disability Status") graphregion(margin(r+10))
graph export $results/disd04_info_margins_plot.pdf, replace

***--------------------------***
// OUTCOME: CONFIDENCE
***--------------------------***

*Base model: Disability only
svy: ologit confidence_prep disability, ///
	  or
estimates store conf_model_dis

*Adding gender
quietly: svy: ologit confidence_prep disability woman_nb, ///
	or
estimates store conf_model_gender

*Adding controls
svy: ologit confidence_prep disability  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment, ///
	or
estimates store conf_model_controls

* Put in table
etable, showstars ///
	estimates(conf_model_dis  conf_model_controls) /// 
	mstat(N) mstat(r2_a) ///
	export("$results/disd04_conf_nested_model.docx", as(docx) replace)
	

// VISUALIZE: Conditional marginal effects of disability on confidence level (naive model)
quietly: ///
svy: ologit confidence_prep i.disability

margins r.disability, atmeans
marginsplot

margins, dydx(disability) atmeans
marginsplot, yline(0) ///
	title("Conditional Marginal Effects of Disability") ///
	xtitle("Confidence") ytitle("Effects on probability") ///
	xlabel(0 `""Not at all" "confident""' ///
	1 "Slightly confident" ///
	2 "Somewhat confident" ///
	3 "Moderately confident" ///
	4 "Extremely confident",  ///
	labsize(vsmall)) graphregion(margin(r+10))
graph export $results/disd04_confidence_marginaleffects_naivemodel_plot.jpg, replace
	
// VISUALIZE: Conditional marginal effects of disability on confidence level with controls
quietly: ///
svy: ologit confidence_prep i.disability ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment 

margins r.disability, atmeans
marginsplot

margins, dydx(disability) atmeans
marginsplot, yline(0) ///
	title("Conditional Marginal Effects of Disability") ///
	xtitle("Confidence") ytitle("Effects on probability") ///
	xlabel(0 `""Not at all" "confident""' ///
	1 "Slightly confident" ///
	2 "Somewhat confident" ///
	3 "Moderately confident" ///
	4 "Extremely confident",  ///
	labsize(vsmall)) graphregion(margin(r+10))
graph export $results/disd04_confidence_marginaleffects_plot.jpg, replace
	
***--------------------------***
// OUTCOME: PREPAREDNESS
***--------------------------***

*Base model: Disability only
svy: ologit preparedness_stage disability, ///
	or
estimates store prep_model_dis

*Adding gender
quietly: svy: ologit preparedness_stage disability woman_nb, ///
	or
estimates store prep_model_gender

*Adding controls
svy: ologit preparedness_stage disability  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment , ///
	or  
estimates store prep_model_controls

* Put in table
*etable, showstars ///
	estimates(prep_model_dis prep_model_controls) ///
	mstat(N) mstat(r2_a) ///
	export("$results/disd04_prep_nested_model.docx", as(docx) replace)

	
// VISUALIZE: Conditional marginal effects of disability on preparedness level
quietly: ///
svy: ologit preparedness_stage i.disability woman_nb  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment 

margins r.disability, atmeans
marginsplot

margins, dydx(disability) atmeans
marginsplot, yline(0) ///
	title("Conditional Marginal Effects of Disability") ///
	xtitle("Preparedness Stage") ytitle("Effects on probability") ///
	xlabel(0 `""Not prepared, do not intend" "to prep in the next year""' ///
	1 `""Not prepared, intend to" "prepare in the next year""' ///
	2 `""Not prepared, intend to" "prepare in the next six months""' ///
	3 `""Been prepared" "for the past year""' ///
	4 `""Been prepared for" "more than a year," "continues preparing""',  ///
	labsize(vsmall)) graphregion(margin(r+10))
graph export $results/disd04_prep_marginaleffects_plot.jpg, replace

	
***--------------------------***
// OUTCOME: PREPAREDNESS ~ CONFIDENCE & INFO
***--------------------------***	
	
*Base model: Disability only
svy: ologit preparedness_stage disability, ///
	  or
estimates store prep_model_dis

*Adding controls
svy: ologit preparedness_stage disability ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment, ///
	  or  
estimates store prepconf_model_controls

*Adding info
svy: ologit preparedness_stage disability c.mean_info   ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment, ///
	  or  
estimates store prepconf_model_info

*Adding confidence
svy: ologit preparedness_stage disability c.mean_info i.confidence_prep  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment, ///
	  or
estimates store prepconf_model

* Put in table
etable, showstars ///
	estimates(prep_model_dis  prepconf_model_controls prepconf_model_info  prepconf_model) ///
	mstat(N) mstat(r2_a) ///
export("$results/disd04_prepconf_nested_model.docx", as(docx) replace)

// VISUALIZE: Conditional marginal effects of disability on preparedness level, controlling for information and confidence
quietly: ///
svy: ologit preparedness_stage i.disability c.mean_info i.confidence_prep  ///  
	new_disaster_experience ib3.insurance_ownership mean_cbo  ///
	woman_nb i.race_ethnicity  i.age  i.education  c.income_redi  ib3.simple_employment
margins r.disability, atmeans
marginsplot

margins, dydx(disability) atmeans
marginsplot, yline(0) ///
	title("Conditional Marginal Effects of Disability") ///
	xtitle("Preparedness Stage") ytitle("Effects on probability") ///
	xlabel(0 `""Not prepared, do not intend" "to prep in the next year""' ///
	1 `""Not prepared, intend to" "prepare in the next year""' ///
	2 `""Not prepared, intend to" "prepare in the next six months""' ///
	3 `""Been prepared" "for the past year""' ///
	4 `""Been prepared for" "more than a year," "continues preparing""',  ///
	labsize(vsmall)) graphregion(margin(r+10))
graph export $results/disd04_prep_infoconfidence_marginaleffects_plot.jpg, replace


***--------------------------***
log close 

exit
