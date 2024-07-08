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
// REGRESSIONS
***--------------------------***
use $data/2021_NHS_general_data_disd02.dta

//Information regression
svy: reg mean_info disability male  ///  
	mean_cbo new_disaster_experience i.insurance_ownership  /// 
	c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment
estimates store info_model_regress
	
etable, showstars ///
	estimates(info_model_regress) ///
	mstat(N) mstat(r2) ///
	export("$results/disd04_info_regression.docx", as(docx) replace)

//Confidence regression
*Disability
quietly: svy: ologit confidence_prep disability, ///
	  or
estimates store conf_model_dis

*Adding gender
quietly: svy: ologit confidence_prep disability male, ///
	or
estimates store conf_model_male

*Adding controls
svy: ologit confidence_prep disability male  ///  
	 mean_cbo new_disaster_experience i.insurance_ownership ///
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment, ///
	  or
estimates store conf_model_controls

* Put in table
etable, showstars ///
	estimates(conf_model_dis conf_model_male  conf_model_controls) /// conf_model_interact
	mstat(N) mstat(r2_a) ///
	export("$results/disd04_conf_nested_model.docx", as(docx) replace)


//Preparedness stage regression
*Disability
quietly: svy: ologit preparedness_stage disability, ///
	  or
estimates store prep_model_dis

*Adding gender
quietly: svy: ologit preparedness_stage disability male, ///
	or
estimates store prep_model_male

*Adding controls
svy: ologit preparedness_stage disability male  ///  
	 mean_cbo  new_disaster_experience i.insurance_ownership  /// 
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment, ///
	  or  
estimates store prep_model_controls

* Put in table
etable, showstars ///
	estimates(prep_model_dis prep_model_male prep_model_controls) ///
	mstat(N) mstat(r2_a) ///
	export("$results/disd04_prep_nested_model.docx", as(docx) replace)

//Preparedness stage nested model
*Disability
quietly: svy: ologit preparedness_stage disability, ///
	  or
estimates store prep_model_dis

*Adding gender
quietly: svy: ologit preparedness_stage disability male, ///
	or
estimates store prep_model_male

*Adding controls
svy: ologit preparedness_stage disability male  ///  
	 mean_cbo  new_disaster_experience i.insurance_ownership  /// 
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment, ///
	  or  
estimates store prep_model_controls

* Put in table
etable, showstars ///
	estimates(prep_model_dis prep_model_male prep_model_controls) ///
	mstat(N) mstat(r2_a) ///
	export("$results/disd04_prep_nested_model.docx", as(docx) replace)
	
***--------------------------***
// VISUALIZATIONS
***--------------------------***
//Predicted information by disability status 
svy: reg mean_info i.disability male  ///  
	mean_cbo new_disaster_experience i.insurance_ownership  /// 
	c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment

margins disability, atmeans
marginsplot, xtitle("Disability Status") ytitle("Linear Prediction") ///
	title("Predicted Information By Disability Status") graphregion(margin(r+10))
graph export $results/disd04_info_margins_plot.pdf, replace

//Conditional marginal effects of disability on confidence level
svy: ologit confidence_prep i.disability male  ///  
	 mean_cbo new_disaster_experience i.insurance_ownership ///
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment //

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

//Conditional marginal effects of disability on preparedness level
svy: ologit preparedness_stage i.disability male  ///  
	 mean_cbo new_disaster_experience i.insurance_ownership  /// 
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment

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

//Conditional marginal effects of disability on preparedness level, controlling for information and confidence
svy: ologit preparedness_stage i.disability mean_info confidence_prep male  ///  
	 mean_cbo new_disaster_experience i.insurance_ownership  /// 
	 c.income_redi i.education i.race_ethnicity i.age ib3.simple_employment

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
