

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
%loadat(workdatcv.csv, workdatc);



/******************************************************/
/* The ANOVA Tests to thy differences in Pre-Post ASP */
/******************************************************/

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova1.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatc;
class asptreat;
model antibio15rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova2.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatc;
class asptreat;
model antibio30rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova3.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatc;
class asptreat;
model visit15rate = asptreat;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova4.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatc;
class asptreat;
model visit30rate = asptreat;
run;

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;
ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tablanova5.csv" style = Vasstables;
title1 "Statistics of the ASP Patients Data";
proc anova data = workdatc;
class asptreat;
model age = asptreat;
run;


/***********************************************************************************************************************************************/
/***********************************************************************************************************************************************/


/**************************************************/
/* The Data Step for execution of a Diff-in-Diff */
/**************************************************/

data workdatc; set workdatc;

  zage = age; 
  zvisit15 = visit15rate;
  zvisit30 = visit30rate;
  zantibio = antibiorate;
  zantibio15 = antibio15rate;
  zantibio30 = antibio30rate;

run;
 
* Standardization of data for analysis *;

proc standard data = workdatc mean = 0 std = 1 out = workdatc;

  var zage zvisit15 zvisit30 zantibio zantibio15 zantibio30;

run;
 
%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (workdatc, workdatc);

* Test analysis on age Variables*;
* Creating table 2;
options orientation = portrait;

ods csv file = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIIA.csv" style = Vasstables;

title1 "Statistics of the ASP Patients Data";

proc sort data=workdatc; by  asptreat; run;
proc means data = workdatc; 
	by asptreat;
	var age antibio15rate antibio30rate visit15rate visit30rate zage zvisit15
       zvisit30 zantibio15 zantibio30;

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

%vprean(workdatc, age);
%vprean(workdatc, antibio15rate);
%vprean(workdatc, antibio30rate);
%vprean(workdatc, visit15rate);
%vprean(workdatc, visit30rate);




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
 var zantibio30;
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

proc npar1way data = workdatc  wilcoxon plots();
 class asptreat;
 var zage;
run;


/******************************************************************************************/
/*    Difference - in - Difference / with ASP as the treatment and COVID19 as exposure    */
/******************************************************************************************/

/* ITS Without trend, controlling for covid19, seasonality, and winter vs summer */

/* DiD No Control */
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv1.csv" style = Vasstables;
title1 "DiD No Control";

proc genmod data = &input1 descending;

class antibio (order=formatted ref='1') / param=ref;
model &input2 = asptreat|antibio / dist = tweedie type3;

estimate 'RR:antibio' antibio 1 /exp;
estimate 'RR:asptreat' asptreat 1 /exp;
estimate 'RRR:asptreat*antibio' asptreat*antibio 1 /exp;

run;

%mend didv;

%didv(workdatc, zantibio15);
%didv(workdatc, zantibio30);
%didv(workdatc, zvisit15);
%didv(workdatc, zvisit30);


/* DiD controlling COVID19 and other covariates*/
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv2.csv" style=Vasstables;
title1 "DiD controlling COVID19 and other covariates";

proc genmod data = &input1 descending;

class antibio (order=formatted ref='1') / param=ref;
model &input2 = asptreat|antibio covid19 b18to44age b45to64age more65age ethhispanic 
	ethnothispanic female male raceblack racewhite otherrace providmd providnps hospother
 	hospnobrth hospbrth insurpersonalpay insurcomerc insurgrpolicy insurhmo insurmedicaid
	insurmedicare insursuplmtpolicy insurother otheredu atleast9gredu atleast12gredu 
	more2yrcoledu tobother tobcurrtlyevday tobcurrtlysomday tobformly tobnever icdB373
	icdR060 icdN390 icdJ069 icdJ019 icdJ189 icdJ029 icdJ209 icdL029 icdL039 / dist = tweedie type3;

estimate 'RR:antibio' antibio 1 /exp;
estimate 'RR:asptreat' asptreat 1 /exp;
estimate 'RRR:asptreat*antibio' asptreat*antibio 1 /exp;

run;

%mend didv;

%didv(workdatc, zantibio15);
%didv(workdatc, zantibio30);
%didv(workdatc, zvisit15);
%didv(workdatc, zvisit30);



/* DiD controlling COVID19 and other covariates*/
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv3.csv" style=Vasstables;
title1 "DiD controlling COVID19 and other covariates";

proc genmod data = &input1 descending;

class antibio (order=formatted ref='1') / param=ref;
model &input2 = asptreat|antibio covid19 b18to44age b45to64age ethhispanic 
	ethnothispanic female male raceblack racewhite providmd providnps hospother
 	hospnobrth insurpersonalpay insurcomerc insurhmo insurmedicaid
	insurmedicare otheredu atleast9gredu atleast12gredu 
	tobother tobcurrtlyevday tobcurrtlysomday tobformly icdB373
	icdR060 icdN390 icdJ069 icdJ019 icdJ189 icdJ029 icdJ209 icdL029 icdL039 / dist = tweedie type3;

estimate 'RR:antibio' antibio 1 /exp;
estimate 'RR:asptreat' asptreat 1 /exp;
estimate 'RRR:asptreat*antibio' asptreat*antibio 1 /exp;

run;

%mend didv;

%didv(workdatc, zantibio15);
%didv(workdatc, zantibio30);
%didv(workdatc, zvisit15);
%didv(workdatc, zvisit30);


/* DiD controlling COVID19 and other covariates*/;
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv4.csv" style=Vasstables;
title1 "DiD controlling COVID19 and other covariates";

proc genmod data = &input1 descending;

class antibio (order=formatted ref='1') / param=ref;
model &input2 = asptreat|antibio covid19 b18to44age b45to64age ethhispanic ethnothispanic female male raceblack racewhite 
	providmd providnps insurpersonalpay insurcomerc insurhmo insurmedicaid insurmedicare otheredu atleast9gredu atleast12gredu 
	tobother tobcurrtlyevday tobcurrtlysomday tobformly icdB373 icdR060 icdN390 icdJ069 icdJ019 icdJ189 icdJ029 icdJ209 icdL029 
	icdL039 / dist = tweedie type3;

estimate 'RR:antibio' antibio 1 /exp;
estimate 'RR:asptreat' asptreat 1 /exp;
estimate 'RRR:asptreat*antibio' asptreat*antibio 1 /exp;

run;

%mend didv;

%didv(workdatc, zantibio15);
%didv(workdatc, zantibio30);
%didv(workdatc, zvisit15);
%didv(workdatc, zvisit30);


***********************************************************************************************************************
***********************************************************************************************************************


/* DiD controlling COVID19 and other covariates*/;
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv4.csv" style=Vasstables;
title1 "DiD controlling COVID19 and other covariates";

proc genmod data = &input1 descending;

class antibio (order=formatted ref='1') / param=ref;
model &input2 = asptreat|antibio covid19 b18to44age b45to64age ethhispanic ethnothispanic female male raceblack racewhite 
	providmd providnps insurpersonalpay insurcomerc insurhmo insurmedicaid insurmedicare otheredu atleast9gredu atleast12gredu 
	tobother tobcurrtlyevday tobcurrtlysomday tobformly icdB373 icdR060 icdN390 icdJ069 icdJ019 icdJ189 icdJ029 icdJ209 icdL029 
	icdL039 / dist = tweedie type3;

estimate 'RR:antibio' antibio 1 /exp;
estimate 'RR:asptreat' asptreat 1 /exp;
estimate 'RRR:asptreat*antibio' asptreat*antibio 1 /exp;

run;

%mend didv;

%didv(workdatc, zantibio15);
%didv(workdatc, zantibio30);
%didv(workdatc, zvisit15);
%didv(workdatc, zvisit30);

