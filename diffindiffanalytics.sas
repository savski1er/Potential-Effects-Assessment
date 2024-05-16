
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

%loadat(aspworka.csv, aspworka);



/************************************************/
/* The Data Step for execution of a Monthly ITS */
/************************************************/

/***********************************************************************************************************************************************/
/***********************************************************************************************************************************************/


/**********************************************/
/* The Data Step for execution of a Weekly ITS */
/**********************************************/


Data WIndiASPDif;

Set aspworka (keep = ClinicalEncounterDate age racegr sex ethnicgr insurangr agegr providgr educatgr hospnobthgr tobacgr 
				covid19 icdsame icdB373 icdR060 icdN390 icdJ069 icdJ019 visit_15 visit_30 antibio_15 antibio_30);
format ClinicalEncounterDate date9.;
Trend =sum ( intck ("weeks", '1nov2019'd, ClinicalEncounterDate, "c"),NStudMoPreIntervention );

Intervention =max (0, Trend > NStudMoPreIntervention );
TrendPre =max (0, Trend *(Not (Intervention)));
TrendPst =max (0, Trend * Intervention);

run;


proc summary data = WIndiASPDif (where = (- 76 <= Trend <= 76)) nway;

var age racegr sex ethnicgr insurangr agegr providgr educatgr hospnobthgr tobacgr covid19 icdsame icdB373 icdR060 icdN390 icdJ069 icdJ019
	visit_15 visit_30 antibio_15 antibio_30;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = weeklydiffindiff
(rename = (_freq_ = nsvisit15 _freq_ = nsvisit30 _freq_ = nsantibio15 _freq_ = nsantibio30 _freq_ = nsoverall) drop = _type_)

mean(age) = age 
mean(racegr) = racegr 
mean(sex) = sex 
mean(ethnicgr) = ethnicgr 
mean(agegr) = agegr 
mean(insurangr) = insurangr 
mean(providgr) = providgr
mean(educatgr) = educatgr 
mean(tobacgr) = tobacgr
mean(icdsame) = icdsame
mean(icdB373) = icdB373 
mean(icdR060) = icdR060
mean(icdN390) = icdN390 
mean(icdJ069) = icdJ069
mean(icdJ019) = icdJ019
mean(covid19) = icdJ019

mean(visit_15) = visit15
mean(visit_30) = visit30
mean(antibio_15) = antibio15 
mean(antibio_30) = antibio30 
mean(hospnobthgr) = hospnobthgr;  

run;

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv(weeklydiffindiff, weeklydiffindiff);
%loadat(weeklydiffindiff.csv, weeklydiffindiff);


DATA weeklydiffindiff2;
  SET weeklydiffindiff;

  zage = age; 
  zracegr = racegr;
  zsex = sex;
  zethnicgr = ethnicgr;
  zinsurangr = insurangr;
  zagegr = agegr;
  zprovidgr = providgr;
  zeducatgr = educatgr;
  zhospnobthgr = hospnobthgr;
  ztobacgr = tobacgr;
  zicdsame = icdsame;
  zicdB373 = icdB373;
  zicdR060 = icdR060;
  zicdN390 = icdN390;
  zicdJ069 = icdJ069;
  zicdJ019 = icdJ019;
  zvisit15 = visit15;
  zvisit30 = visit30;
  zantibio15 = antibio15;
  zantibio30 = antibio30;

RUN;
 
PROC STANDARD DATA = weeklydiffindiff2 MEAN=0 STD=1 OUT = weeklydiffindiff2;

  VAR   zage zracegr zsex zethnicgr zinsurangr zagegr zprovidgr zeducatgr zhospnobthgr ztobacgr zicdsame 
        zicdB373 zicdR060 zicdN390 zicdJ069 zicdJ019 zvisit15 zvisit30 zantibio15 zantibio30;

RUN;
 
PROC MEANS DATA = weeklydiffindiff2;
RUN;


* Test analysis on age Variables*;
* Creating table 2;
options orientation=portrait;

ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIA.csv" style=Vasstables;

title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data=weeklydiffindiff2 plots(unpack)=summary;
 class intervention;
 var zantibio15;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation=portrait;

ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIB.csv" style=Vasstables;

title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data=weeklydiffindiff2 plots(unpack)=summary;
 class intervention;
 var zantibio30;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation=portrait;

ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableIC.csv" style=Vasstables;

title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data=weeklydiffindiff2 plots(unpack)=summary;
 class intervention;
 var zvisit15;
run;


* Test analysis on age Variables*;
* Creating table 2;
options orientation=portrait;

ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tableID.csv" style=Vasstables;

title1 "Chisquare Test for Demographic and Socioeconomic Characteristic of Patients";

proc ttest data = weeklydiffindiff2 plots(unpack) = summary;
 class intervention;
 var zvisit30;
run;


/******************************************************************************************/
/*    Difference - in - Difference / with ASP as the treatment and COVID19 as exposure    */
/******************************************************************************************/

/* ITS Without trend, controlling for covid19, seasonality, and winter vs summer */

/* DiD controlling COVID19 */
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv1.csv" style=Vasstables;
title1 "DiD controlling covid19";

proc genmod data = &input1 descending;

class covid19 (order=formatted ref='1') / param=ref;
model &input2 = intervention|covid19 / dist = tweedie link = log type3;

estimate 'RR:covid19' covid19 1 /exp;
estimate 'RR:intervention' intervention 1 /exp;
estimate 'RRR:intervention*covid19' intervention*covid19 1 /exp;

run;

%mend didv;

%didv(weeklydiffindiff2, zantibio15);
%didv(weeklydiffindiff2, zantibio30);
%didv(weeklydiffindiff2, zvisit15);
%didv(weeklydiffindiff2, zvisit30);



/* DiD controlling COVID19 and other covariates*/
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv2.csv" style=Vasstables;
title1 "DiD controlling all covariates";

proc genmod data = &input1 descending;

class covid19 (order = formatted ref = '1') / param = ref;
model &input2 = intervention covid19 zracegr zsex zethnicgr zinsurangr zage zprovidgr zeducatgr 
				ztobacgr zicdsame / dist = tweedie link = log type3;

estimate 'RR:covid19' covid19 1 /exp;
estimate 'RR:intervention' intervention 1 /exp;

run;

%mend didv;

%didv(weeklydiffindiff2, zantibio15);
%didv(weeklydiffindiff2, zantibio30);
%didv(weeklydiffindiff2, zvisit15);
%didv(weeklydiffindiff2, zvisit30);


/* DiD controlling COVID19 and other covariates*/
%Macro didv (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabdifv3.csv" style=Vasstables;
title1 "DiD controlling all covariates";

proc genmod data = &input1 descending;

class covid19 (order=formatted ref='1') / param=ref;
model &input2 = intervention covid19 zracegr zsex zethnicgr zinsurangr zage zprovidgr zeducatgr 
				ztobacgr zicdB373 zicdR060 zicdN390 zicdJ069 zicdJ019 / dist = tweedie link = log type3;

estimate 'RR:covid19' covid19 1 /exp;
estimate 'RR:intervention' intervention 1 /exp;

run;

%mend didv;

%didv(weeklydiffindiff2, zantibio15);
%didv(weeklydiffindiff2, zantibio30);
%didv(weeklydiffindiff2, zvisit15);
%didv(weeklydiffindiff2, zvisit30);
