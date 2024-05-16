
Libname users "/Users/vassi/Desktop/brownproject/2.data/1.rawdata"; /*Project Library*/
Libname asp "/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp"; /*asp datasets Library*/
Libname dat "/Users/vassi/Desktop/brownproject/2.data/2.cleandata"; /*clean datasets Library*/


/**************************************************/
/**************************************************/

/* Macro for loading data */
%Macro loadat (input, output);

proc import datafile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&input"
out = &output
dbms = csv
replace;

run;

%mend loadat;

%loadat(workdatb.csv, workdatb);
%loadat(workdatd.csv, workdatd);
%loadat(workdate.csv, workdate);


/******************************************************/
/* The ANOVA Tests to thy differences in Pre-Post ASP */
/******************************************************/

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova1.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatb;
class asptreat;
model antibio15rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova2.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatb;
class asptreat;
model antibio30rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova3.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatb;
class asptreat;
model visit15rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova4.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatb;
class asptreat;
model visit30rate = asptreat;
run;

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova5.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatb;
class asptreat;
model age = asptreat;
run;

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova6.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdate;
class asptreat;
model antprescprs = asptreat;
run;


/***********************************************************************************************************************************************/
/***********************************************************************************************************************************************/


/**************************************************/
/* The Data Step  */
/**************************************************/

data workdatb; set workdatb;

  zantibio15 = antibio15rate;
  zantusepr = antusepr;
  zvisit15 = visit15rate;
  zvisit30 = visit30rate;

run;
 
* Standardization of data for analysis *;

proc standard data = workdatb mean = 0 std = 1 out = workdatb;

  var zvisit15 zvisit30 zantibio15 zantusepr;

run;
 
%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (workdatb, workdatb);

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIIA.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";

proc sort data=workdate; by  asptreat; run;
proc means data = workdate; 
	by asptreat;
	var age antibio15rate visit15rate visit30rate antprescprs;

run;


%Macro vprean (input1, input2);

options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableVA.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";

*Produce descriptive statistics;
proc means data = &input1 n nmiss mean std stderr median min max qrange maxdec = 4;
class asptreat;
var &input2;
run;
 
*Test for normality and produce confidence intervals on the median;
proc univariate data = &input1 normal cipctldf;
class asptreat;
var &input2;
histogram &input2 /normal;
qqplot /normal (mu = est sigma = est);
run;
 
*Produce boxplots;
proc sgplot data = &input1;
title 'Boxplot number of &input2 by treatment';
vbox &input2 /category = asptreat;
run;
 
*Perform the Mann-Whitney U Test;
proc npar1way data = &input1 wilcoxon;
class asptreat;
var &input2;
run;

%mend vprean;

%vprean(workdatb, age);
%vprean(workdatb, antibio15rate);
%vprean(workdate, antprescprs);
%vprean(workdatb, visit15rate);
%vprean(workdatb, visit30rate);


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIA.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = workdatc plots(unpack) = summary;
 class asptreat;
 var zantibio15;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIB.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = workdatc plots(unpack) = summary;
 class asptreat;
 var zantusepr;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIC.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = workdatc plots(unpack) = summary;
 class asptreat;
 var zvisit15;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableID.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = workdatc plots(unpack) = summary;
 class asptreat;
 var zvisit30;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIED.csv" style = Vasstables;
title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = workdatc plots(unpack) = summary;
 class asptreat;
 var zage;
run;

data workdate; set workdate; antprescprs = (antibiorate*1000)/1774; run; 

%retcsv (workdate, workdate);

%loadat(workdate.csv, workdate);


/********************************************************************************************/
/* The Data Step Provider types D-I-D: PROC PSMATCH FOR PROPENSITY SCORES with weighting    */
/*******************************************************************************************/

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabpsmch.csv" style=Vasstables;
title1 "ITS Without trend";
title "Provider types D-I-D: PROC PSMATCH FOR PROPENSITY SCORES";

ods graphics on;
proc psmatch data = workdate region = cs;
 	class providgr female;

 	psmodel providgr(treated = '1') = age ethhispanic ethnothispanic female male raceblack racewhite otherrace hospother hospnobrth hospbrth 
		insurpersonalpay insurcomerc insurgrpolicy insurhmo insurmedicaid insurmedicare insursuplmtpolicy insurother otheredu atleast9gredu 
		atleast12gredu more2yrcoledu tobother tobcurrtlyevday tobcurrtlysomday tobformly tobnever icdB373 icdR060 icdN390 icdJ069 icdJ019 
		icdJ189 icdJ029 icdJ209 icdL029 icdL039;

	assess ps lps var = (age ethhispanic ethnothispanic female male raceblack racewhite otherrace hospother hospnobrth hospbrth 
		insurpersonalpay insurcomerc insurgrpolicy insurhmo insurmedicaid insurmedicare insursuplmtpolicy insurother otheredu atleast9gredu 
		atleast12gredu more2yrcoledu tobother tobcurrtlyevday tobcurrtlysomday tobformly tobnever icdB373 icdR060 icdN390 icdJ069 icdJ019 
		icdJ189 icdJ029 icdJ209 icdL029 icdL039) / varinfo nlargestwgt = 6 
	plots( NODETAILS) = (cdfplot boxplot(display = (ps age)) 
	stddiff(ref = 0.10) ) weight = atewgt(stabilize = no) ; 

	output out(obs = all) = ps_out lps = lps ps = ps atewgt(stabilize = no) = ate_wt; 

run;

%retcsv (ps_out, ps_out);
%retcsv (OutEx4, OutEx4);

%loadat(ps_out.csv, ps_out);


/* The ATT weights can be calculated from the PROC PSMATCH output with the code: */
data diddataps;
set ps_out;
att_wt = ps /(1-ps);
run;

data diditsdataps; set diddataps; if 0.34504 <= ps <= 0.97713; run;  /*  1670 observations and 79 variables */

%retcsv (ps_out, ps_out);
%retcsv (diddataps, diddataps);
%retcsv (diditsdataps, diditsdataps);


/********************************************************************************************/
/* The Data Step Provider types D-I-D: PROC PSMATCH FOR PROPENSITY SCORES with Matching     */
/*******************************************************************************************/

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabpsgrdymch.csv" style=Vasstables;
title1 "ITS Without trend";
title "Provider types D-I-D: PROC PSMATCH FOR PROPENSITY SCORES";

ods graphics on;
proc psmatch data = workdate region = treated(extend(stat = ps mult = one) = 0.025);
 	class providgr female;

 	psmodel providgr(treated = '1') = age ethhispanic ethnothispanic female male raceblack racewhite otherrace hospother hospnobrth hospbrth 
		insurpersonalpay insurcomerc insurgrpolicy insurhmo insurmedicaid insurmedicare insursuplmtpolicy insurother otheredu atleast9gredu 
		atleast12gredu more2yrcoledu tobother tobcurrtlyevday tobcurrtlysomday tobformly tobnever icdB373 icdR060 icdN390 icdJ069 icdJ019 
		icdJ189 icdJ029 icdJ209 icdL029 icdL039;

	match method = greedy(k = 1) exact = female caliper = 0.6;

	assess ps lps var = (age ethhispanic ethnothispanic female male raceblack racewhite otherrace hospother hospnobrth hospbrth 
		insurpersonalpay insurcomerc insurgrpolicy insurhmo insurmedicaid insurmedicare insursuplmtpolicy insurother otheredu atleast9gredu 
		atleast12gredu more2yrcoledu tobother tobcurrtlyevday tobcurrtlysomday tobformly tobnever icdB373 icdR060 icdN390 icdJ069 icdJ019 
		icdJ189 icdJ029 icdJ209 icdL029 icdL039) / varinfo plots = all weight = none;

	output out(obs = match) = OutEx4 matchid = _MatchID;

run;


%loadat(diddataps.csv, diddataps);
%loadat(diditsdatapv.csv, diditsdatapv);
%loadat(diditsdatamch.csv, diditsdatamch);

/* The ATT weights can be calculated from the PROC PSMATCH output with the code: */
data diditsdatamch;
set diditsdatamch;
att_wt = ps /(1-ps);
run;


proc ttest data = weeklytimeseries plots(unpack) = summary;
 class asptreat;
 var antibio15;
run;


/***********************************************************************************************************************************************/
/***********************************************************************************************************************************************/
/**********************************************/
/* The Data Step for execution of a Weekly ITS */
/**********************************************/

Data WIndiASPy;
Set diddataps (keep = ClinicalEncounterDate antibio15rate antprescprs visit15rate visit30rate ps lps ate_wt att_wt);
format ClinicalEncounterDate date9.;
Trend =sum (
		intck ("weeks", '1nov2019'd, ClinicalEncounterDate, "c"),
        NStudMoPreIntervention
        );

asptreat =max (0, Trend > NStudMoPreasptreat );
TrendPre =max (0, Trend *(Not (asptreat)));
TrendPst =max (0, Trend * asptreat);
run;


proc summary data = WIndiASPy (where = (- 76 <= Trend <= 76)) nway;

	var antibio15rate antprescprs visit15rate visit30rate ps lps ate_wt att_wt;
	class Trend;
	Id asptreat TrendPre TrendPst;
	Output out = weeklytimsery
			(rename = (_freq_ = nsvisit15rate _freq_ = nsvisit30rate _freq_ = nsantibio15rate _freq_ = nsantprescprs ) drop = _type_) 
		
		mean(antibio15rate) = antibio15 std(antibio15rate) = std_antibio15
		mean(antprescprs) = antprescprsmn std(antprescprs) = std_antprescprs

		mean(visit15rate) = visit15 std(visit15rate) = std_visit15
		mean(visit30rate) = visit30 std(visit30rate) = std_visit30

		mean(ps) = psmn 
		mean(lps) = lpsmn 
		mean(ate_wt) = ate_wtmn 
		mean(att_wt) = att_wtmn ;

run;

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv(weeklytimsery, weeklytimsery);
%retcsv(weeklytimsers, weeklytimsers);
%retcsv(weeklytimeseries, weeklytimeseries);
%retcsv(weeklytimeseriesv, weeklytimeseriesv);

%loadat(weeklytimsery.csv, weeklytimsery);
%loadat(weeklytimsers.csv, weeklytimsers);
%loadat(weeklytimeseries.csv, weeklytimeseries);
%loadat(weeklytimeseriesv.csv, weeklytimeseriesv);


/******************************************************************************************/
/* ITS Without and with trend, controlling for covid19, seasonality, and winter vs summer */
/******************************************************************************************/

/**********************************************/
/* Interrupted-Time-Series Approach 1 */
/**********************************************/

%Macro itsmod1 (wtstring =,modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabitsm1.csv" style = Vasstables;
title1 "DiD No Control";

proc mixed data = weeklytimsery method = ml 
	plots(maxpoints = 60000)=(residualpanel(unpack) vcirypanel(unpack)); 
	class asptreat;
	model &outcomevar. = pretime asptreat postime asptreat*postime covid19 covid19*postime covid19*asptreat*postime seasonality / s ;
 	&wtstring;

	estimate 'pre-ASP slope' pretime 1 / cl e;
 	estimate 'post-ASP slope' postime 1 postime*asptreat 1 / cl e;
 	estimate 'pre/post ASP' pretime 1 asptreat 1 postime*asptreat 10 / cl e;

	TITLE1 " pre/post asp interventions &outcomevar. controlling for covid19 and seasonality ";
	TITLE2 "&modeltype";

run;

%mend itsmod1;

%itsmod1(wtstring =, modeltype = UNADJUSTED, outcomevar = antibio15);
%itsmod1(wtstring = WEIGHT ATE_WT, modeltype = ATE_WT, outcomevar = antibio15);
%itsmod1(wtstring = WEIGHT ATT_WT, modeltype = ATT_WT, outcomevar = antibio15);

%itsmod1(wtstring =, modeltype = UNADJUSTED, outcomevar = antprescprs);
%itsmod1(wtstring = WEIGHT ATE_WT, modeltype = ATE_WT, outcomevar = antprescprs);
%itsmod1(wtstring = WEIGHT ATT_WT, modeltype = ATT_WT, outcomevar = antprescprs);

%itsmod1(wtstring =, modeltype = UNADJUSTED, outcomevar = visit15);
%itsmod1(wtstring = WEIGHT ATE_WT, modeltype = ATE_WT, outcomevar = visit15);
%itsmod1(wtstring = WEIGHT ATT_WT, modeltype = ATT_WT, outcomevar = visit15);

%itsmod(wtstring =, modeltype = UNADJUSTED, outcomevar = visit30);
%itsmod1(wtstring = WEIGHT ATE_WT, modeltype = ATE_WT, outcomevar = visit30);
%itsmod(wtstring = WEIGHT ATT_WT, modeltype = ATT_WT, outcomevar = visit30);


/******************************************************************************************/
/* Autocorrelation testing */
/******************************************************************************************/

title 'Autocorrelated Time Series';
proc sgplot data = weeklytimsery noautolegend;
by asptreat;
series x = time y = antibio15 / markers;
reg x = time y = antibio15 / lineattrs = (color = black);
run;


%Macro autoc (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabauto.csv" style=Vasstables;
title1 " Autocorrelation ";

proc autoreg data = &input1;
model &input2 = time / dw = 4 dwprob nlag = 2 method = ml;
output out = p p = yhat pm = ytrend
lcl = lcl ucl = ucl;
run;

title 'Forecasting Autocorrelated Time Series';
proc sgplot data = &input1;
band x = time upper = ucl lower = lcl;
scatter x = time y = &input2;
series x = time y = yhat;
series x = time y = ytrend / lineattrs = (color = black);
run;

%mend autoc;

%autoc(weeklytimsery, antibio15); * No AR *;

%autoc(weeklytimsery, antprescprs); *AR 1 and 2 *;

%autoc(weeklytimsery, visit15); * AR 1 and 2 *;

%autoc(weeklytimsery, visit30); * AR 1 and 2 *;

/***********************************************************************************************************************************************/
/***********************************************************************************************************************************************/

/********************************************************************************************/
/* These are the TRUE models to consider in this study: Interrupted-Time-Series Approach 2 */
/*******************************************************************************************/

%Macro itsmod2 (modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabitsm2.csv" style=Vasstables;
title1 "ITS Without trend";

proc autoreg data = weeklytimsery;
	Model &outcomevar. = time asptreat time*asptreat covid19 covid19*asptreat*time / dw = 4 nlag = 2 dwprob method = ml loglikl
	plots (UNPACKpanel only) = (standardresidual residualHistogram fitplot cooksd pacfplot);

	TITLE1 " pre/post asp interventions &outcomevar. controlling for covid19 ";
	TITLE2 "&modeltype";

run;

%mend itsmod2;

%itsmod2(modeltype = Only COVID19 controlled, outcomevar = antibio15);

%itsmod2(modeltype = Only COVID19 controlled, outcomevar = antprescprs);

%itsmod2(modeltype = Only COVID19 controlled, outcomevar = visit15);

%itsmod2(modeltype = Only COVID19 controlled, outcomevar = visit30);


/**********************************************/
/* Interrupted-Time-Series Approach 3 */
/**********************************************/

%Macro itsmod3 (modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabitsm3.csv" style=Vasstables;
title1 "ITS Without trend";

proc autoreg data = weeklytimsery;
	Model &outcomevar. = pretime asptreat postime covid19 covid19*asptreat*postime seasonality ps / dw = 4 nlag = 2 dwprob method = ml loglikl
	plots (UNPACKpanel only) = (standardresidual residualHistogram fitplot cooksd pacfplot);

	TITLE1 " pre/post asp interventions &outcomevar. controlling for covid19 and seasonality ";
	TITLE2 "&modeltype";

run;

%mend itsmod3;

%itsmod3(modeltype = Unadjusted, outcomevar = antibio15);

%itsmod3(modeltype = Unadjusted, outcomevar = antprescprs);

%itsmod3(modeltype = Unadjusted, outcomevar = visit15);

%itsmod3(modeltype = Unadjusted, outcomevar = visit30);


/**********************************************/
/* Interrupted-Time-Series Approach 4 */
/**********************************************/

%Macro itsmod4 (modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabitsm4.csv" style=Vasstables;
title1 "ITS Without trend";

proc autoreg data = weeklytimsery;
	Model &outcomevar. = pretime asptreat postime covid19 covid19*asptreat*postime seasonality ate_wt / dw=4 nlag = 2 dwprob method = ml loglikl
	plots (UNPACKpanel only) = (standardresidual residualHistogram fitplot cooksd pacfplot);

	TITLE1 " pre/post asp interventions &outcomevar. controlling for covid19 and seasonality ";
	TITLE2 "&modeltype";

run;

%mend itsmod4;

%itsmod4(modeltype = Adjusted for ATE_WT, outcomevar = antibio15);

%itsmod4(modeltype = Adjusted for ATE_WT, outcomevar = antprescprs);

%itsmod4(modeltype = Adjusted for ATE_WT, outcomevar = visit15);

%itsmod4(modeltype = Adjusted for ATE_WT, outcomevar = visit30);


/**********************************************/
/* Interrupted-Time-Series Approach 5 */
/**********************************************/

%Macro itsmod4 (modeltype =, outcomevar = );

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabitsm5.csv" style=Vasstables;
title1 "ITS Without trend";

proc autoreg data = weeklytimsery;
	Model &outcomevar. = pretime asptreat postime covid19 covid19*asptreat*postime seasonality att_wt / dw=4 nlag = 2 dwprob method = ml loglikl
	plots (UNPACKpanel only) = (standardresidual residualHistogram fitplot cooksd pacfplot);

	TITLE1 " pre/post asp interventions &outcomevar. controlling for covid19 and seasonality ";
	TITLE2 "&modeltype";

run;

%mend itsmod4;

%itsmod4(modeltype = Adjusted for ATT_WT, outcomevar = antibio15);

%itsmod4(modeltype = Adjusted for ATT_WT, outcomevar = antprescprs);

%itsmod4(modeltype = Adjusted for ATT_WT, outcomevar = visit15);

%itsmod4(modeltype = Adjusted for ATT_WT, outcomevar = visit30);
