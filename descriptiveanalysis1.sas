

Libname users "/Users/vassi/Desktop/brownproject/2.data/1.rawdata"; /*Project Library*/
Libname asp "/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp"; /*asp datasets Library*/
Libname dat "/Users/vassi/Desktop/brownproject/2.data/2.cleandata"; /*clean datasets Library*/


/**************************************************/
/**************************************************/

/* Project Objectives. */

* Objective: Understand the impact of an antibiotic stewardship program in a primary care center. *;
* ASP influence on prescriptions pattern by providers’ level. *;

* 1- Measure antibiotics prescription rate., Stratify the measure based on the type of provider (MD vs NP). *;
* 2- Measure the frequency of change in antibiotics within 15 days. Measured by the number of times an antibiotic prescription was changed (use order date).*; 
* 3- Measure the frequency of clinic visit within 15 & 30 days for any infectious disease. *;
* 4- Measure the frequency of clinic visit for the same infectious disease (use ICD 10). *;
* 5- Assess the differences in hospitalization rates (if available), or clinic visits. *;


/*****************/
/** First Step **/
/****************/

%Macro loadat (input, output);

proc import datafile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&input"
out = &output
dbms = csv
replace;

run;

%mend loadat;

%loadat(aspclean.csv, aspclean)

/* 1- Measure antibiotics prescription rate., Stratify the measure based on the type of provider (MD vs NP). */
/* 2- Measure the frequency of change in antibiotics within 15 days. */

/* calculating the antibiotic prescription rate and the total antibiotic prescription rate, for any days, 15 days, and 30 days. */
data aspclean; set aspclean; overall = 1; run; 
data ex; set aspclean; run;


/* The Global data set of ASP program */
/**************************************************/
data antibio; set ex; where antibio = 1; run; * 3512 observations *;
data test; set antibio; keep UPID; run;
proc sort data=test nodupkey; by UPID; run; *  900 observations *;
/*
obs 3512
obs 900 unique observations had at least one antibiotic prescription record.
*/

data antibio15; set ex; where antibio_15 = 1; run; * 1857 observations *;
data test1; set antibio15; keep UPID; run;
proc sort data=test1 nodupkey; by UPID; run; * 886 observations *;
/*
obs 1857
obs 886 unique observations had at least one antibiotic prescription record within 15 days.
*/

data antibio30; set ex; where antibio_30 = 1; run; * 1971 observations *;
data test2; set antibio30; keep UPID; run;
proc sort data=test2 nodupkey; by UPID; run; * 886 observations *;
/*
obs 1971
obs 886 unique observations had at least one antibiotic prescription record within 30 days.
*/

/* The data set of Pre ASP program */
/**************************************************/
data antibio; set ex; where antibio = 1 and treat = 0; run; * 2778 observations *;
data test; set antibio; keep UPID; run;
proc sort data=test nodupkey; by UPID; run; *  703 observations *;
/*
obs 2778
obs 703 unique observations had at least one antibiotic prescription record.
*/

data antibio15; set ex; where antibio_15 = 1 and treat = 0; run; * 1546 observations *;
data test1; set antibio15; keep UPID; run;
proc sort data=test1 nodupkey; by UPID; run; * 699 observations *;
/*
obs 1546
obs 699 unique observations had at least one antibiotic prescription record within 15 days.
*/

data antibio30; set ex; where antibio_30 = 1 and treat = 0; run; * 1639 observations *;
data test2; set antibio30; keep UPID; run;
proc sort data=test2 nodupkey; by UPID; run; * 699 observations *;
/*
obs 1639
obs 699 unique observations had at least one antibiotic prescription record within 30 days.
*/

/* The data set of Post ASP program */
/**************************************************/
data antibio; set ex; where antibio = 1 and treat = 1; run; * 734 observations *;
data test; set antibio; keep UPID; run;
proc sort data=test nodupkey; by UPID; run; *  295 observations *;
/*
obs 734
obs 295 unique observations had at least one antibiotic prescription record.
*/

data antibio15; set ex; where antibio_15 = 1 and treat = 1; run; * 311 observations *;
data test1; set antibio15; keep UPID; run;
proc sort data=test1 nodupkey; by UPID; run; * 187 observations *;
/*
obs 311
obs 187 unique observations had at least one antibiotic prescription record within 15 days.
*/

data antibio30; set ex; where antibio_30 = 1 and treat = 1; run; * 332 observations *;
data test2; set antibio30; keep UPID; run;
proc sort data=test2 nodupkey; by UPID; run; * 189 observations *;
/*
obs 332
obs 189 unique observations had at least one antibiotic prescription record within 30 days.
*/


/* 3- Measure the frequency of clinic visit within 15 & 30 days for any infectious disease. */

/* The Global data set of ASP program */
data visit15; set ex; where visit_15 = 1; run; * 70321 observations *;
data test3; set visit15; keep UPID; run;
proc sort data=test3 nodupkey; by UPID; run; * 1941 observations *;
/*
obs 70321
obs 1941 unique observations had at least one clinical visit record within 15 days.
*/

data visit30; set ex; where visit_30 = 1; run; * 73609 observations *;
data test4; set visit30; keep UPID; run;
proc sort data=test4 nodupkey; by UPID; run; * 1941 observations *;
/*
obs 73609
obs 1941 unique observations had at least one clinical visit record within 30 days.
*/

/* The data set of Pre ASP program */
data visit15; set ex; where visit_15 = 1 and treat = 0; run; * 62055 observations *;
data test3; set visit15; keep UPID; run;
proc sort data=test3 nodupkey; by UPID; run; * 1466 observations *;
/*
obs 62055
obs 1466 unique observations had at least one clinical visit record within 15 days.
*/

data visit30; set ex; where visit_30 = 1 and treat = 0; run; * 65086 observations *;
data test4; set visit30; keep UPID; run;
proc sort data=test4 nodupkey; by UPID; run; * 1466 observations *;
/*
obs 65086
obs 1466 unique observations had at least one clinical visit record within 30 days.
*/

/* The data set of Prost ASP program */
data visit15; set ex; where visit_15 = 1 and treat = 1; run; * 8266 observations *;
data test3; set visit15; keep UPID; run;
proc sort data=test3 nodupkey; by UPID; run; * 475 observations *;
/*
obs 8266
obs 475 unique observations had at least one clinical visit record within 15 days.
*/

data visit30; set ex; where visit_30 = 1 and treat = 1; run; * 8523 observations *;
data test4; set visit30; keep UPID; run;
proc sort data=test4 nodupkey; by UPID; run; * 477 observations *;
/*
obs 8523
obs 477 unique observations had at least one clinical visit record within 30 days.
*/


/* 4- Measure the frequency of clinic visit for the same infectious disease (use ICD 10). */

/* The Global data set of ASP program */
data icdsame; set ex; where icdsame = 1; run; * 112078 observations *;
data test5; set icdsame; keep UPID; run;
proc sort data=test5 nodupkey; by UPID; run; * 1941 observations *;
/*
obs 112078
obs 1941 unique observations had at least one same icd10 record within per visit.
*/

/* The data set of Pre ASP program */
data icdsame; set ex; where icdsame = 1 and treat = 0; run; * 92564 observations *;
data test5; set icdsame; keep UPID; run;
proc sort data=test5 nodupkey; by UPID; run; * 1466 observations *;
/*
obs 92564
obs 1466 unique observations had at least one same icd10 record per visit.
*/

/* The data set of Post ASP program */
data icdsame; set ex; where icdsame = 1 and treat = 1; run; * 19514 observations *;
data test5; set icdsame; keep UPID; run;
proc sort data=test5 nodupkey; by UPID; run; * 653 observations *;
/*
obs 19514
obs 653 unique observations had at least one same icd10 record per visit.
*/


/**************************************************/

/* The Global data set of ASP program */
/*Creating the antibiotic prescription rate*/

/*antibio*/
data antibio_rate; set ex; proc sort; by UPID; run;
data antibio_rate; set antibio_rate; by UPID;
    retain antibio_rate;
      if first.UPID then antibio_rate = antibio;
      else antibio_rate= antibio + antibio_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ex left join antibio_rate
on ex. UPID = antibio_rate. UPID;
quit; 

/*antibio_15*/
data antibio_rate15; set ex; proc sort; by UPID; run;
data antibio_rate15; set antibio_rate15; by UPID;
    retain antibio_rate_15;
      if first.UPID then antibio_rate_15 = antibio_15;
      else antibio_rate_15 = antibio_15 + antibio_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate15
on ey. UPID = antibio_rate15. UPID;
quit; 

/*antibio_30*/
data antibio_rate30; set ex; proc sort; by UPID; run;
data antibio_rate30; set antibio_rate30; by UPID;
    retain antibio_rate_30;
      if first.UPID then antibio_rate_30 = antibio_30;
      else antibio_rate_30= antibio_30+ antibio_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate30
on ey. UPID = antibio_rate30. UPID;
quit; 

/*visit_15*/
data visit_rate15; set ex; proc sort; by UPID; run;
data visit_rate15; set visit_rate15; by UPID;
    retain visit_rate_15;
      if first.UPID then visit_rate_15 = visit_15;
      else visit_rate_15 = visit_15 + visit_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate15
on ey. UPID = visit_rate15. UPID;
quit; 

/*visit_30*/
data visit_rate30; set ex; proc sort; by UPID; run;
data visit_rate30; set visit_rate30; by UPID;
    retain visit_rate_30;
      if first.UPID then visit_rate_30 = visit_30;
      else visit_rate_30= visit_30+ visit_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate30
on ey. UPID = visit_rate30. UPID;
quit; 

/*icdsame*/
data icdsamerate; set ex; proc sort; by UPID; run;
data icdsamerate; set icdsamerate; by UPID;
    retain icdsame_rate;
      if first.UPID then icdsame_rate = icdsame;
      else icdsame_rate = icdsame + icdsame_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join icdsamerate
on ey. UPID = icdsamerate. UPID;
quit; 


/* Complete data set before futher analyses*/;
data aspclean; set ey; run; * 139193 observations *;

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (aspclean, aspclean);


/* The data set of Pre ASP program */
/*Creating the antibiotic prescription rate*/
/*antibio*/
data ez; set ex; where treat = 0; run;
data antibio_rate; set ez; proc sort; by UPID; run;
data antibio_rate; set antibio_rate; by UPID;
    retain antibio_rate;
      if first.UPID then antibio_rate = antibio;
      else antibio_rate= antibio + antibio_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ez left join antibio_rate
on ez. UPID = antibio_rate. UPID;
quit; 

/*antibio_15*/
data antibio_rate15; set ez; proc sort; by UPID; run;
data antibio_rate15; set antibio_rate15; by UPID;
    retain antibio_rate_15;
      if first.UPID then antibio_rate_15 = antibio_15;
      else antibio_rate_15 = antibio_15 + antibio_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate15
on ey. UPID = antibio_rate15. UPID;
quit; 

/*antibio_30*/
data antibio_rate30; set ez; proc sort; by UPID; run;
data antibio_rate30; set antibio_rate30; by UPID;
    retain antibio_rate_30;
      if first.UPID then antibio_rate_30 = antibio_30;
      else antibio_rate_30= antibio_30+ antibio_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate30
on ey. UPID = antibio_rate30. UPID;
quit; 


/*visit_15*/
data visit_rate15; set ez; proc sort; by UPID; run;
data visit_rate15; set visit_rate15; by UPID;
    retain visit_rate_15;
      if first.UPID then visit_rate_15 = visit_15;
      else visit_rate_15 = visit_15 + visit_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate15
on ey. UPID = visit_rate15. UPID;
quit; 

/*visit_30*/
data visit_rate30; set ez; proc sort; by UPID; run;
data visit_rate30; set visit_rate30; by UPID;
    retain visit_rate_30;
      if first.UPID then visit_rate_30 = visit_30;
      else visit_rate_30= visit_30+ visit_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate30
on ey. UPID = visit_rate30. UPID;
quit; 

/*icdsame*/
data icdsamerate; set ez; proc sort; by UPID; run;
data icdsamerate; set icdsamerate; by UPID;
    retain icdsame_rate;
      if first.UPID then icdsame_rate = icdsame;
      else icdsame_rate= icdsame + icdsame_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ez left join icdsamerate
on ez. UPID = icdsamerate. UPID;
quit; 

/* Complete data set of pre asp, before futher analyses*/;
data preaspclean; set ey; run; * 139193 observations *;

%retcsv (preaspclean, preaspclean);


/* The data set of post ASP program */
/*Creating the antibiotic prescription rate*/
/*antibio*/
data ez; set ex; where treat = 1; run;
data antibio_rate; set ez; proc sort; by UPID; run;
data antibio_rate; set antibio_rate; by UPID;
    retain antibio_rate;
      if first.UPID then antibio_rate = antibio;
      else antibio_rate= antibio + antibio_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ez left join antibio_rate
on ez. UPID = antibio_rate. UPID;
quit; 

/*antibio_15*/
data antibio_rate15; set ez; proc sort; by UPID; run;
data antibio_rate15; set antibio_rate15; by UPID;
    retain antibio_rate_15;
      if first.UPID then antibio_rate_15 = antibio_15;
      else antibio_rate_15 = antibio_15 + antibio_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate15
on ey. UPID = antibio_rate15. UPID;
quit; 

/*antibio_30*/
data antibio_rate30; set ez; proc sort; by UPID; run;
data antibio_rate30; set antibio_rate30; by UPID;
    retain antibio_rate_30;
      if first.UPID then antibio_rate_30 = antibio_30;
      else antibio_rate_30= antibio_30+ antibio_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join antibio_rate30
on ey. UPID = antibio_rate30. UPID;
quit; 


/*visit_15*/
data visit_rate15; set ez; proc sort; by UPID; run;
data visit_rate15; set visit_rate15; by UPID;
    retain visit_rate_15;
      if first.UPID then visit_rate_15 = visit_15;
      else visit_rate_15 = visit_15 + visit_rate_15;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate15
on ey. UPID = visit_rate15. UPID;
quit; 

/*visit_30*/
data visit_rate30; set ez; proc sort; by UPID; run;
data visit_rate30; set visit_rate30; by UPID;
    retain visit_rate_30;
      if first.UPID then visit_rate_30 = visit_30;
      else visit_rate_30= visit_30+ visit_rate_30;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join visit_rate30
on ey. UPID = visit_rate30. UPID;
quit; 

/*icdsame*/
data icdsamerate; set ez; proc sort; by UPID; run;
data icdsamerate; set icdsamerate; by UPID;
    retain icdsame_rate;
      if first.UPID then icdsame_rate = icdsame;
      else icdsame_rate= icdsame + icdsame_rate;
      if last.UPID;
run;

proc sql;
create table ey as
select*
from ey left join icdsamerate
on ey. UPID = icdsamerate. UPID;
quit; 


/* Complete data set of post asp, before futher analyses*/;
data posaspclean; set ey; run; * 139193 observations *;

%retcsv (posaspclean, posaspclean);


/**************************************************/
/** The Global data set of ASP Program **/
/**************************************************/
data ey; set aspclean; run;
data h; set ey; run; /* observations 139193 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where antibio = 1; run;
proc freq data=y; table antibio; run;
data y1; set h; where antibio_rate > 0; run;
proc freq data=y1; table antibio_rate; run;
/*
164 unique observations had one antibiotic prescription record, thus
the antibiotic prescription rate is 164/139193 = 0.12%

900 unique observations had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 900/139193 = 0.65% 
*/

data x; set h; where antibio_15 = 1; run;
proc freq data=x; table antibio_15; run;
data x; set h; where antibio_rate_15 > 0; run;
proc freq data=x; table antibio_rate_15; run;
/*
148 unique observations had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 148/139193 = 0.11%

886 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 886/139193 = 0.64% 
*/

data z; set h; where antibio_30 = 1; run;
proc freq data=z; table antibio_30; run;
data z; set h; where antibio_rate_30 > 0; run;
proc freq data=z; table antibio_rate_30; run;
/*
150 unique observations had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 150/139193 = 0.11%

886 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 886/139193 = 0.64% 
*/

data x; set h; where visit_15 = 1; run;
proc freq data=x; table visit_15; run;
data x; set h; where visit_rate_15 > 0; run;
proc freq data=x; table viasit_rate_15; run;
/*
1624 unique observations had one clinical visit record within 15 days, thus
the clinical visit rate is 1624/139193 = 1.17%

0 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 0/139193 = 0.0% 
*/

data z; set h; where visit_30 = 1; run;
proc freq data=z; table visit_30; run;
data z; set h; where visit_rate_30 > 0; run;
proc freq data=z; table visit_rate_30; run;
/*
1651 unique observations had one clinical visit record within 30 days, thus
the clinical visit rate is 1651/139193 = 1.19%

1941 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 1941/139193 = 1.39% 
*/

data z; set h; where icdsame = 1; run;
proc freq data=z; table icdsame; run;
data z; set h; where icdsame_rate > 0; run;
proc freq data=z; table icdsame_rate; run;
/*
1941 1815 unique observations had one same icd10 record per visit, thus
the same icd10 rate is 1815/139193 = 1.30%

1941 unique observations had at least one same icd10 record per visit, thus
the same icd10 rate is 1815/139193 = 1.39%
*/

/**************************************************/
/** The data set of Pre ASP Program **/
/**************************************************/
data ey; set preaspclean; run;
data h; set ey; run; /* observations 112373 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where antibio = 1; run;
proc freq data=y; table antibio; run;
data y1; set h; where antibio_rate > 0; run;
proc freq data=y1; table antibio_rate; run;
/*
130 unique observations had one antibiotic prescription record, thus
the antibiotic prescription rate is 130/112373 = 0.12%

703 unique observations had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 900/112373 = 0.63% 
*/

data x; set h; where antibio_15 = 1; run;
proc freq data=x; table antibio_15; run;
data x; set h; where antibio_rate_15 > 0; run;
proc freq data=x; table antibio_rate_15; run;
/*
123 unique observations had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 123/112373 = 0.11%

699 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 699/112373 = 0.62% 
*/

data z; set h; where antibio_30 = 1; run;
proc freq data=z; table antibio_30; run;
data z; set h; where antibio_rate_30 > 0; run;
proc freq data=z; table antibio_rate_30; run;
/*
123 unique observations had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 123/112373 = 0.11%

699 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 699/112373 = 0.62% 
*/

data x; set h; where visit_15 = 1; run;
proc freq data=x; table visit_15; run;
data x; set h; where visit_rate_15 > 0; run;
proc freq data=x; table viasit_rate_15; run;
/*
1254 unique observations had one clinical visit record within 15 days, thus
the clinical visit rate is 1254/112373 = 1.12%

0 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 0/112373 = 0.00% 
*/

data z; set h; where visit_30 = 1; run;
proc freq data=z; table visit_30; run;
data z; set h; where visit_rate_30 > 0; run;
proc freq data=z; table visit_rate_30; run;
/*
1275 unique observations had one clinical visit record within 30 days, thus
the clinical visit rate is 1275/112373 = 1.13%

1466 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 1466/112373 = 1.30% 
*/

data z; set h; where icdsame = 1 and treat = 0; run;
proc freq data=z; table icdsame; run;
data z; set h; where icdsame_rate > 0; run;
proc freq data=z; table icdsame_rate; run;
/*
1310 unique observations had one same icd10 record per visit, thus
the same icd10 rate is 1310/112373 = 1.17%

1941 unique observations had at least one same icd10 record per visit, thus
the same icd10 rate is 1941/112373 = 1.73%
*/

/**************************************************/
/** The data set of Post ASP Program **/
/**************************************************/
data ey; set posaspclean; run;
data h; set ey; run; /* observations 26820 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where antibio = 1; run;
proc freq data=y; table antibio; run;
data y1; set h; where antibio_rate > 0; run;
proc freq data=y1; table antibio_rate; run;
/*
70 unique observations had one antibiotic prescription record, thus
the antibiotic prescription rate is 70/26820 = 0.26%

295 unique observations had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 295/26820 = 1.10% 
*/

data x; set h; where antibio_15 = 1; run;
proc freq data=x; table antibio_15; run;
data x; set h; where antibio_rate_15 > 0; run;
proc freq data=x; table antibio_rate_15; run;
/*
53 unique observations had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 53/26820 = 0.20%

187 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 187/26820 = 0.70% 
*/

data z; set h; where antibio_30 = 1; run;
proc freq data=z; table antibio_30; run;
data z; set h; where antibio_rate_30 > 0; run;
proc freq data=z; table antibio_rate_30; run;
/*
119 unique observations had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 119/26820 = 0.44%

189 unique observations had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 189/26820 = 0.70% 
*/

data x; set h; where visit_15 = 1; run;
proc freq data=x; table visit_15; run;
data x; set h; where visit_rate_15 > 0; run;
proc freq data=x; table viasit_rate_15; run;
/*
437 unique observations had one clinical visit record within 15 days, thus
the clinical visit rate is 437/26820 = 1.63%

0 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 0/26820 = 0.00% 
*/

data z; set h; where visit_30 = 1; run;
proc freq data=z; table visit_30; run;
data z; set h; where visit_rate_30 > 0; run;
proc freq data=z; table visit_rate_30; run;
/*
442 unique observations had one clinical visit record within 30 days, thus
the clinical visit rate is 442/26820 = 1.65%

477 unique observations had at least one clinical visit record within 30 days, thus
the clinical visit rate is 477/26820 = 1.78% 
*/

data z; set h; where icdsame = 1 and treat = 1; run;
proc freq data=z; table icdsame; run;
data z; set h; where icdsame_rate > 0; run;
proc freq data=z; table icdsame_rate; run;
/*
505 unique observations had one same icd10 record per visit, thus
the same icd10 rate is 505/26820 = 1.88%

1941 unique observations had at least one same icd10 record per visit, thus
the same icd10 rate is 1941/26820 = 7.24%
*/


/* 1- Measure antibiotics prescription rate., Stratify the measure based on the type of provider (MD vs NP). */
/* Stratified antibiotic prescription Analysis */

/**************************************************/
/** The Global data set of ASP Program **/
/**************************************************/
data ex; set aspclean; run;

proc freq data= ex; tables providgr; run; 

/* providgr = 2 or provider is MD */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 139193 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 2; run; /* obs 22859 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 2; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
38 unique observations where providgr = 2 had one antibiotic prescription record, thus
the antibiotic prescription rate is 38/139193 = 0.03%

180 unique observations where providgr = 2 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 180/139193 = 0.13% 
*/

data x; set h; where providgr = 2; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 2; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
35 unique observations where stratum=1 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 35/139193 = 0.03%

178 unique observations where stratum=1 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 178/139193 = 0.13% 
*/

data z; set h; where providgr = 2; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 2; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
36 unique observations where stratum=1 had one antibiotic prescription record within 30 days, thus
the readmission rate is 36/139193 = 0.03%

178 unique observations where stratum=1 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 178/139193 = 0.13% 
*/
;

/* providgr = 3 or provider is Nurse Practitioner, Supervising (NP, S) */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 139193 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 3; run; /* obs 116250 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 3; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
122 unique observations where providgr = 2 had one antibiotic prescription record, thus
the antibiotic prescription rate is 122/139193 = 0.09%

713 unique observations where providgr = 2 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 713/139193 = 0.51% 
*/

data x; set h; where providgr = 3; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 3; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
109 unique observations where stratum=1 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 109/139193 = 0.08%

701 unique observations where stratum=1 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 701/139193 = 0.50% 
*/

data z; set h; where providgr = 3; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 3; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
110 unique observations where stratum=1 had one antibiotic prescription record within 30 days, thus
the readmission rate is 110/139193 = 0.08%

701 unique observations where stratum=1 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 701/139193 = 0.50% 
*/

/**************************************************/
/** The data set of Pre ASP Program **/
/**************************************************/
data ex; set preaspclean; run;

proc freq data= ex; tables providgr; run; 

/* providgr = 2 or provider is MD */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 112373 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 2; run; /* obs 17329 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 2; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
24 unique observations where providgr = 2 had one antibiotic prescription record, thus
the antibiotic prescription rate is 24/112373 = 0.02%

124 unique observations where providgr = 2 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 124/112373 = 0.11% 
*/

data x; set h; where providgr = 2; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 2; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
22 unique observations where providgr = 2 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 22/112373 = 0.02%

124 unique observations where providgr = 2 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 124/112373 = 0.11% 
*/

data z; set h; where providgr = 2; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 2; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
22 unique observations where providgr = 2 had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 22/112373 = 0.02%

124 unique observations where providgr = 2 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 124/112373 = 0.11% 
*/
;

/* providgr = 3 or provider is Nurse Practitioner, Supervising (NP, S) */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 112373 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 3; run; /* obs 95044 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 3; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
106 unique observations where providgr = 3 had one antibiotic prescription record, thus
the antibiotic prescription rate is 106/112373 = 0.09%

579 unique observations where providgr = 3 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 579/112373 = 0.51% 
*/

data x; set h; where providgr = 3; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 3; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
101 unique observations where providgr = 3 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 101/112373 = 0.09%

575 unique observations where providgr = 3 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 575/112373 = 0.51% 
*/

data z; set h; where providgr = 3; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 3; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
101 unique observations where providgr = 3 had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 101/112373 = 0.09%

575 unique observations where providgr = 3 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 575/112373 = 0.51% 
*/

/**************************************************/
/** The data set of Post ASP Program **/
/**************************************************/
data ex; set posaspclean; run;

proc freq data= ex; tables providgr; run; 

/* providgr = 2 or provider is MD */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 26820 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 2; run; /* obs 5530 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 2; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
20 unique observations where providgr = 2 had one antibiotic prescription record, thus
the antibiotic prescription rate is 20/26820 = 0.07%

70 unique observations where providgr = 2 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 70/26820 = 0.26% 
*/

data x; set h; where providgr = 2; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 2; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
17 unique observations where providgr = 2 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 17/26820 = 0.06%

49 unique observations where providgr = 2 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 49/26820 = 0.18% 
*/

data z; set h; where providgr = 2; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 2; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
18 unique observations where providgr = 2 had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 18/26820 = 0.07%

50 unique observations where providgr = 2 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 50/26820 = 0.19% 
*/
;

/* providgr = 3 or provider is Nurse Practitioner, Supervising (NP, S) */
/*calculating the antibiotic prescription rate AND the total antibiotic prescription rate */
data h; set ex; run; /* observations 26820 */;
proc sort data=h nodupkey; by UPID; run;

data y; set h; where providgr = 3; run; /* obs 21206 */
data y1; set y;  where antibio = 1; run;
proc freq data=y1; table antibio; run;
data y2; set h; where providgr = 3; run;
data y2; set y2; where antibio_rate > 0; run;
proc freq data=y2; table antibio_rate; run;
/*
47 unique observations where providgr = 3 had one antibiotic prescription record, thus
the antibiotic prescription rate is 47/26820 = 0.18%

219 unique observations where providgr = 3 had at least one antibiotic prescription record, thus
the antibiotic prescription rate is 219/26820 = 0.82% 
*/

data x; set h; where providgr = 3; run;
data x1; set x; where antibio_15 = 1; run;
proc freq data=x1; table antibio_15; run;
data x2; set h; where providgr = 3; run;
data x3; set x2; where antibio_rate_15 > 0; run;
proc freq data=x3; table antibio_rate_15; run;
/*
33 unique observations where providgr = 3 had one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 33/26820 = 0.12%

132 unique observations where providgr = 3 had at least one antibiotic prescription record within 15 days, thus
the antibiotic prescription rate is 132/26820 = 0.49% 
*/

data z; set h; where providgr = 3; run;
data z1; set z; where antibio_30 = 1; run;
proc freq data=z1; table antibio_30; run;
data z2; set h; where providgr = 3; run;
data z3; set z2; where antibio_rate_30 > 0; run;
proc freq data=z3; table antibio_rate_30; run;
/*
35 unique observations where providgr = 3 had one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 35/26820 = 0.13%

133 unique observations where providgr = 3 had at least one antibiotic prescription record within 30 days, thus
the antibiotic prescription rate is 133/26820 = 0.50% 
*/

%loadat(bworkdata.csv, bworkdata)
%loadat(antibiorate.csv, antibiorate)
%loadat(antibio15rate.csv, antibio15rate)
%loadat(antibio30rate.csv, antibio30rate)
%loadat(visit15rate.csv, visit15rate)
%loadat(visit30rate.csv, visit30rate)
%loadat(icdsamerate.csv, icdsamerate)


proc sql;
create table bworkdata as
select*
from bworkdata left join antibiorate
on bworkdata. UPID = antibiorate. UPID;
quit; 

proc sql;
create table bworkdata as
select*
from bworkdata left join antibio15rate
on bworkdata. UPID = antibio15rate. UPID;
quit; 

proc sql;
create table bworkdata as
select*
from bworkdata left join antibio30rate
on bworkdata. UPID = antibio30rate. UPID;
quit; 


proc sql;
create table bworkdata as
select*
from bworkdata left join visit15rate
on bworkdata. UPID = visit15rate. UPID;
quit; 

proc sql;
create table bworkdata as
select*
from bworkdata left join visit30rate
on bworkdata. UPID = visit30rate. UPID;
quit;

proc sql;
create table bworkdata as
select*
from bworkdata left join icdsamerate
on bworkdata. UPID = icdsamerate. UPID;
quit;


data bworkdata; set bworkdata; 
if antibiorate = ' ' then antibiorate = 0; 
if antibio15rate = ' ' then antibio15rate = 0; 
if antibio30rate = ' ' then antibio30rate = 0; 
if visit15rate = ' ' then visit15rate = 0; 
if visit30rate = ' ' then visit30rate = 0; 
if icdsamerate = ' ' then icdsamerate = 0; 
run;


data bworkdata; set bworkdata; 
if icdB373 = ' ' then icdB373 = 0; 
if icdR060 = ' ' then icdR060 = 0; 
if icdN390 = ' ' then icdN390 = 0; 
if icdJ069 = ' ' then icdJ069 = 0; 
if icdJ019 = ' ' then icdJ019 = 0; 
run;


data aworkdata; set aworkdata; 
if visit_15 = 1 & icdsame = 1 then visit15v = 1; else visit15v = 0; 
if visit_30 = 1 & icdsame = 1 then visit30v = 1; else visit30v = 0; 
run;



%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (bworkdata, bworkdata);
%retcsv (aworkdata, aworkdata);

data antibio15 ; set workdatb; if antibio15rate > = 1; run;

data visit15 ; set workdatb; if visit15rate > = 1; run;

%retcsv (antibio15, antibio15);
%retcsv (visit15, visit15);
%retcsv (workdatb, workdatb);
