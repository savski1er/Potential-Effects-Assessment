/***************************************************************************************/

Libname users "/Users/vassi/Desktop/brownproject/2.data/1.rawdata"; /*Project Library*/
Libname asp "/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp"; /*asp datasets Library*/
Libname dat "/Users/vassi/Desktop/brownproject/2.data/2.cleandata"; /*clean datasets Library*/

/***************************************************************************************/

/*******************/
/****** Step 1 ******/
/*******************/

/* Loading the data sets pre and post asp */

%Macro loadat (input, output);

proc import datafile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&input"
out = &output
dbms = csv
replace;

run;

%mend loadat;

/* Loading pre_asp data sets 2017 to 2019 */
%loadat (preasp1.csv, preaspa); /* clinic order date 11-1-2017 to 12-31-2017; preaspa has 10319 observations and 16 variables. */
%loadat (preasp2.csv, preaspb); /* clinic order date 1-1-2018 to 12-31-2018; preaspb has 69717 observations and 16 variables. */
%loadat (preasp3.csv, preaspc); /* clinic order date 1-1-2019 to 10-31-2019; preaspc has 50708 observations and 16 variables. */

/* Loading post_asp data sets 2019 to 2021 */
%loadat (postasp1.csv, postaspa); /* clinic order date 11-1-2019 to 12-31-2019;  has 10047 observations and 16 variables. */
%loadat (postasp2.csv, postaspb); /* clinic order date 1-1-2020 to 12-31-2020;  has 14365 observations and 16 variables. */
%loadat (postasp3.csv, postaspc); /* clinic order date 1-1-2021 to 6-22-2021; has 2408 observations and 16 variables. */
%loadat (sameicd10.csv, sameicd10);
%loadat (v15visitdat.csv, v15visitdat);
%loadat (v30visitdat.csv, v30visitdat);
%loadat (workdatav.csv, workdatav);
%loadat (workdatb.csv, workdatb);
%loadat (workdatbdmy.csv, workdatbdmy);
%loadat (aspcleanvs.csv, aspcleanvs);


/* Dr. Brown shared Antibiotic drugs list 

AMINOSALICYLIC, AMPICILLIN, ANAGRELIDE, ANIDULAFUNGIN, CEFACLOR, CEFADROXIL, CEFAZOLIN, CEFEPIME, CEFIXIME, CEFOTETAN, CEFOXITIN, 
CEFPODOXIME, CEFPROZIL, CEFTAZIDIME, CEFTRIAXONE, CEFUROXIME, CHLORAMPHENICOL, CIPROFLOXACIN, CLARITHROMYCIN, CLINDAMYCIN, DAPSONE, 
DELAFLOXACIN, DEMECLOCYCLINE, ERYTHROMYCIN, ETHAMBUTOL, ETHIONAMIDE, FIDAXOMICIN, GENTAMICIN, ISONIAZID, LEVOFLOXACIN, LINEZOLID,
MAFENIDE, MEROPENEM, MINOCYCLINE, MOXIFLOXACIN, MUPIROCIN, NITROFURANTOIN, NORFLOXACIN, OFLOXACIN, OXACILLIN, PENICILLIN, PENICILLIN,
PIPERACILLIN, POLYMYXIN, POTASSIUM SORBATE, PREDNISOLONE, PYRAZINAMIDE, RETAPAMULIN, RIFABUTIN, RIFAMPIN, RIFAPENTINE, RIFAXIMIN, 
SILVER SULFADIAZINE, STREPTOMYCIN, SULDAMETHOXAZOLE, SULFACETAMIDE, SULFACETAMIDE, SULFAMETHOXAZOLE, TETRACYCLINE, TIGECYCLINE,
TOBRAMYCIN, VALACYCLOVIR, VANCOMYCIN 

*/

/* Dr. Okere shared Antibiotic drugs list 

Amoxicillin, Amoxicillin / Potassium Clavulanate, Ampicillin Sodium, Ampicillin Sodium / Sulbactam Sodium,Azithromycin, Cedpodoxime,
Cefazolin, Cefdinir, Cefepime, Cefotetan, Cefoxitin, Ceftaroline, Ceftazidime, Ceftolozane, Ceftriaxone, Cefuroxime, Cephalexin,
Ciprofloxacin, Clindamycin, Dicloxacillin, Doxycycline, Erythromycin, Levofloxacin, Linezolid, Metronidazole, Moxifloxacin, Nitrofurantoin, 
Penicillin, Suldamethoxazole, Cefaclor, Cefadroxil, Cefepime, Cefixime, Cefotetan, Cefoxitin, Cefpodoxime, Cefprozil, Ceftriaxone,
Cefuroxime, Chloramphenicol, Ciprofloxacin, Clarithromycin, Clindamycin, Dapsone, Delafloxacin, Demeclocycline, Doxycycline, Erythromycin, 
Fidaxomicin, Levofloxacin, Minocycline, Tetracycline

*/ 

/* project variables list 

ClinicalEncounterDate, UPID, Age,	Ethnicity, Race, Gender, ICD10Diagnosis, ClinicalOrder_ID, ClinicalOrderDate, 
OrderNameMedications, Provider_Type, Hospitalizations, All_Insurances, Insurance_Type, Education, Tobacco_Use.

*/


/*******************/
/****** Step 2 ******/
/*******************/

/* Macro for the production of the project predictors*/

%Macro bvar (input,output);

data &output; set &input; 

*categorize Age*;
	if 0 <= Age <= 18 then agegr = 1;
	else if 19 <= Age <= 44 then agegr = 2;
	else if 45 <= Age <= 64 then agegr = 3;
	else if 65 <= Age <= 74 then agegr = 4;
	else if 75 <= Age then agegr = 5;
	else agegr = 0;
	*drop Age;

*categorize Ethnicity*;
	Ethnicity = put(Ethnicity, 45.);
	if Ethnicity = 'Hispanic or Latino/Spanish' or 'Latin American/Latin, Latino' then ethnicgr = 1;
	else if Ethnicity = 'Not Hispanic or Latino' then ethnicgr = 2;
	else if Ethnicity = 'Patient Declined' then ethnicgr = 3;
	else if Ethnicity = 'Puerto Rican' then ethnicgr = 4;
	else if Ethnicity = 'Mrxican' then ethnicgr = 5;
	else ethnicgr = 0;
	*drop Ethnicity;
	
*categorize Gender*;
	Gender = put(Gender, 45.);
	if Gender = 'Female' or 'F' then sex = 1;
	else if Gender = 'Male' or 'M' then sex = 2;
	else if Gender = 'Choose not to disclose' then sex = 3;
	else sex = 0;
	*drop Gender;

*categorize Race*;
	Race = put(Race, 45.);
	if Race = 'Asian' then racegr = 1; 
	else if Race = 'Black' or 'Black or African American' then racegr = 2; 
	else if Race = 'White' then racegr = 3; 
	else if Race = 'Middle Eastern or North African' then racegr = 4; 
	else if Race = 'Native Hawaiian or Othe Pacific Islander' or 'Othe Pacific Islander' then racegr = 5; 
	else if Race = 'Other Race' then racegr = 6; 
	else if Race = 'Patient Declined' then racegr = 7; 
	else racegr = 0;
	*drop Race;
	
*categorize Provider_Type*;
	Provider_Type = put(Provider_Type, 45.);
	if Provider_Type = 'Doctor of Podiatric Medicine' or 'DOCTOR OF PODIATRIC MEDICINE' then providgr = 1; 
	else if Provider_Type = 'MD' then providgr = 2; 
	else if Provider_Type = 'Nurse Practitioner, Supervising(NP,S)' or 'NURSE PRACTITIONER, SUPERVISING(NP,S)' then providgr = 3; 
	else providgr = 0;
	*drop Provider_Type;

*categorize Hospitalizations, Hospitalizations Other Than Birth*;
	Hospitalizations = put(Hospitalizations, 3.);
	if Hospitalizations = 'Yes' or 'Y' then hospnobthgr = 1; 
	else if Hospitalizations = 'No' or 'N' then hospnobthgr = 2; 
	else hospnobthgr = 0;
	*drop Hospitalizations;

*categorize Insurance_Type*;
	Insurance_Type = put(Insurance_Type, 45.);
	if Insurance_Type = 'Personal Payment (Cash - No Insurance)' then insurangr = 1;
	else if Insurance_Type = 'Commercial' then insurangr = 2;
	else if Insurance_Type = 'Group Policy' then insurangr = 3;
	else if Insurance_Type = 'Health Maintenance Organization (HMO)' then insurangr = 4;
	else if Insurance_Type = 'Medicaid' then insurangr = 5;
	else if Insurance_Type = 'Medicare Part B' then insurangr = 6;
	else if Insurance_Type = 'Supplemental Policy' then insurangr = 7;
	else if Insurance_Type = 'Other' then insurangr = 8;
	else insurangr = 0;
	*drop Insurance_Type;
	drop All_Insurances;
	
*categorize Education*;
	Education = put(Education, 20.);
	if Education = 'Less than 8th Grade' then educatgr = 1; 
	else if Education = '8' or 8 or '8th Grade' then educatgr = 2; 
	else if Education = '9' or 9 or '9th Grade' then educatgr = 3;  
	else if Education = '10' or 10 or '10th Grade' then educatgr = 4;  
	else if Education = '11' or 11 or '11th Grade' then educatgr = 5;  
	else if Education = '12' or 12 or '12th Grade' then educatgr = 6;  
	else if Education = '2 Year College' then educatgr = 7;  
	else if Education = '4 Year College' then educatgr = 8;  
	else if Education = 'Post Graduate' then educatgr = 9;  
	else educatgr = 0;
	*drop Education;

*categorize Tobacco_Use*;
	Tobacco_Use = put(Tobacco_Use, 20.);
	if Tobacco_Use = 'CurrentlyEveryDay' then tobacgr = 1; 
	else if Tobacco_Use = 'CurrentlySomeDays' then tobacgr = 2; 
	else if Tobacco_Use = 'Formerly' then tobacgr = 3;  
	else if Tobacco_Use = 'Never' then tobacgr = 4;  
	else if Tobacco_Use = 'UnknownIfEver' then tobacgr = 5;  
	else tobacgr = 0;
	*drop Tobacco_Use;
run;

%mend bvar;

/* Pre ASP*/
%bvar (preaspa, prea); * has 10319 observations and 16 variables. *;
%bvar (preaspb, preb); * has 69717 observations and 16 variables. *;
%bvar (preaspc, prec); * has 50708 observations and 16 variables. *;
/* Post ASP*/
%bvar (postaspa, posta); * has 10047 observations and 16 variables. *;
%bvar (postaspb, postb); * has 14365 observations and 16 variables. *;
%bvar (postaspc, postc); * has 2408 observations and 16 variables. *;


/* export the created data sets, for verification. */

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (prea, prea);
%retcsv (preb, preb);
%retcsv (prec, prec);

%retcsv (posta, posta);
%retcsv (postb, postb);
%retcsv (postc, postc);


/* import the verified data sets. */

%Macro impcsv (input, output);
proc import datafile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&input"
out = &output
dbms = csv
replace;

run;

%mend impcsv;

%impcsv (prea.csv, prea);
%impcsv (preb.csv, preb);
%impcsv (prec.csv, prec);

%impcsv (posta.csv, posta);
%impcsv (postb.csv, postb);
%impcsv (postc.csv, postc);

/* Macro for Concatenating data sets for each pre and post asp. of the project outcomes*/

%Macro concat (inputa,inputb,inputc, output);

data &output;
   set &inputa &inputb &inputc;
run;

%mend concat;

*pre asp combined dat set;
%concat (prea,preb,prec, predat); * Obs count for predat: 112373 = 10319+69717+32337 *;
*post asp combined dat set;
%concat (posta,postb,postc, postdat); * Obs count for predat:  26820 = 10047+14365+2408 *;


* Macro for pre and post asp combined dat set;

%Macro conc (input1,input2, output);

data &output;
   set &input1 &input2;
run;

%mend conc;

*pre and post asp combined dat set;
%conc (predat,postdat, aspdat); * Obs count for predat: 139193 = 112373+26820 *;


/* Saving data sets. */

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (predat, predat);
%retcsv (postdat, postdat);
%retcsv (aspdat, aspdat);

%loadat (clindexdt.csv, clindexdt);
%loadat (medndexdt.csv, medndexdt);
%loadat (indexicd.csv, indexicd);



/*******************/
/****** Step 3 ******/
/*******************/

/* Project Objectives. */

* Objective: Understand the impact of an antibiotic stewardship program in a primary care center. *;
* ASP influence on prescriptions pattern by providers’ level. *;

* 1- Measure antibiotics prescription rate., Stratify the measure based on the type of provider (MD vs NP). *;
* 2- Measure the frequency of change in antibiotics within 15 days. Measured by the number of times an antibiotic prescription was changed (use order date).*; 
* 3- Measure the frequency of clinic visit within 15 & 30 days for any infectious disease. *;
* 4- Measure the frequency of clinic visit for the same infectious disease (use ICD 10). *;
* 5- Assess the differences in hospitalization rates (if available), or clinic visits. *;

/* Building the project outcomes variables. */

/* Selecting first clinic encounter and first clinic order. */

/*Creating index date and unique ambpatients, edppatients, inpatients*/

/* Macro Selecting first clinic encounter and creating index dates */
%Macro retindex (input,output1,output2);

data &output1; set &input; run;
proc sort data = &output1;
  by UPID ClinicalEncounterDate;
run;

data &output2 (keep = clindex_dt UPID);
  set &output1 (rename = (ClinicalEncounterDate = clindex_dt));
  by UPID clindex_dt;
  if first.UPID then output;
run;

%mend retindex;

%retindex (aspdat,iw,clindexdt); /* obs 1942 */

/* Macro Selecting first clinic order and creating index dates */
%Macro medindex (input,output1,output2);

data &output1; set &input; run;
proc sort data = &output1;
  by ClinicalOrder_ID ClinicalOrderDate;
run;

data &output2 (keep = medndex_dt ClinicalOrder_ID);
  set &output1 (rename = (ClinicalOrderDate = medndex_dt));
  by ClinicalOrder_ID medndex_dt;
  if first.ClinicalOrder_ID then output;
run;

%mend medindex;

%medindex (aspdat,iz,medndexdt); /* obs 65872 */


/* Joining data set with index dates */

/*Join clindx_dt*/
proc sql;
create table aspdata as select a.*,b.* 
from clindexdt a left join aspnet b
on a. UPID = b. UPID;
quit;

/*Join medndx_dt*/
proc sql;
create table aspdata as select a.*,b.* 
from medndexdt a left join aspdata b
on a. ClinicalOrder_ID = b. ClinicalOrder_ID;
quit;


/* measuring clinic visit within 15 & 30 days for any infectious disease. */
/* Creating visit15, visit30, order5, order10, and order15 */

%macro vist (input, output);
data &output; set &input; 
  
visit15 = clindex_dt + 15;
visit30 = clindex_dt + 30;
order15 = ClinicalOrderDate + 15;
order30 = ClinicalOrderDate + 30;
      format visit15 mmddyy10.;
      format visit30 mmddyy10.;
      format order15 mmddyy10.;
	  format order30 mmddyy10.;

run;

%mend vist;

%vist (aspdata, aspdata); /* obs 139193 */ 


/* creating visitXX and orderXX variables */

%Macro visor (input,output);

data &output; set &input; 
if ClinicalEncounterDate <= visit15 then visit_15 = 1; else visit_15 = 0;
if ClinicalEncounterDate <= visit30 then visit_30 = 1; else visit_30 = 0;
if ClinicalOrderDate <= order15 then order_15 = 1; else order_15 = 0;
if ClinicalOrderDate <= order30 then order_30 = 1; else order_30 = 0;
run;

%mend visor;

%visor (aspdata, aspdata);

/* Saving data set*/
%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv (aspdata, aspdata);
%retcsv (clindexdt, clindexdt);
%retcsv (medndexdt, medndexdt);

%impcsv (aspdata.csv, aspdata);


/* Measuring clinic visit for the same infectious disease (use ICD 10). */
/* Macro Selecting first clinic encounter and first ICD10 Diagnosis, to creating index in ICD10 Diagnosis */
%Macro retindxicd (input,output1,output2);

data &output1; set &input; run;
proc sort data = &output1;
  by UPID ClinicalEncounterDate;
run;

data &output2 (keep = ClinicalEncounterDate idc10index UPID);
  set &output1 (rename = (ICD10Diagnosis = idc10index));
  by UPID ClinicalEncounterDate;
  if first.UPID then output;
run;

%mend retindxicd;

%retindxicd (aspdata,ix,indexicd); /* obs 1941 */
data indexicd; set indexicd (keep = idc10index UPID); run;

/*Join idc10index*/
proc sql;
create table aspdata as select a.*,b.* 
from indexicd a left join aspdata b
on a. UPID = b. UPID;
quit;

/* measuring change in the ICD10 code. */
data aspicd; set aspdata; 
	if UPID = UPID and ICD10Diagnosis = idc10index then icdsame = 1; 
	else icdsame = 0; 
run;

/* clean data set at this stage. */
data aspclean; set aspdata (drop = medndex_dt clindex_dt order5 order10); run;

/* saving data sets */
%retcsv (aspicd, aspicd);
%retcsv (aspclean, aspclean);


/* Measure the frequency of change in antibiotics within 15 days. 
Measured by the number of times an antibiotic prescription was changed (use order date).*/

/* finding the selected antibiotics in OrderNameMedications column. */

/* AMOXICILLIN, AMOXICILLIN / POTASSIUM CLAVULANATE, AMPICILLIN SODIUM, AMPICILLIN SODIUM / SULBACTAM SODIUM,AZITHROMYCIN, CEDPODOXIME,
CEFAZOLIN, CEFDINIR, CEFEPIME, CEFOTETAN, CEFOXITIN, CEFTAROLINE, CEFTAZIDIME, CEFTOLOZANE, CEFTRIAXONE, CEFUROXIME, CEPHALEXIN,
CIPROFLOXACIN, CLINDAMYCIN, DICLOXACILLIN, DOXYCYCLINE, ERYTHROMYCIN, LEVOFLOXACIN, LINEZOLID, METRONIDAZOLE, MOXIFLOXACIN, NITROFURANTOIN, 
PENICILLIN, SULDAMETHOXAZOLE, CEFACLOR, CEFADROXIL, CEFEPIME, CEFIXIME, CEFOTETAN, CEFOXITIN, CEFPODOXIME, CEFPROZIL, CEFTRIAXONE,
CEFUROXIME, CHLORAMPHENICOL, CIPROFLOXACIN, CLARITHROMYCIN, CLINDAMYCIN, DAPSONE, DELAFLOXACIN, DEMECLOCYCLINE, DOXYCYCLINE, ERYTHROMYCIN, 
FIDAXOMICIN, LEVOFLOXACIN, MINOCYCLINE, TETRACYCLINE */

/* UPDATE LIST:
AUGMENTIN, FLAGYL, AMOXIL, CIPRO, KEFLEX, BACTRIM, LEVAQUIN, ZITHROMAX, AVELOX, CLEOCIN, SULFAMETHOXAZOLE, NITROFURANTOIN, MACROBID.
 */


data aspcleanvs; set aspcleanvs;

   a1_Yes = find(catx(',',OrderNameMedications),'AMOXICILLIN','i') > 0; * find in*;
   a2_Yes = find(catx(',',OrderNameMedications),'AMOXICILLIN / POTASSIUM CLAVULANATE','i') > 0;
   a3_Yes = find(catx(',',OrderNameMedications),'AMPICILLIN','i') > 0;
   a4_Yes = find(catx(',',OrderNameMedications),'AMPICILLIN SODIUM / SULBACTAM SODIUM','i') > 0;
   a5_Yes = find(catx(',',OrderNameMedications),'AZITHROMYCIN','i') > 0; * find in*;
   a6_Yes = find(catx(',',OrderNameMedications),'CEDPODOXIME','i') > 0;
   a7_Yes = find(catx(',',OrderNameMedications),'CEFAZOLIN','i') > 0;
   a8_Yes = find(catx(',',OrderNameMedications),'CEFDINIR','i') > 0; * find in*;
   a9_Yes = find(catx(',',OrderNameMedications),'CEFEPIME','i') > 0;
   a10_Yes = find(catx(',',OrderNameMedications),'CEFOTETAN','i') > 0;
   a11_Yes = find(catx(',',OrderNameMedications),'CEFOXITIN','i') > 0;
   a12_Yes = find(catx(',',OrderNameMedications),'CEFTAROLINE','i') > 0;
   a13_Yes = find(catx(',',OrderNameMedications),'CEFTAZIDIME','i') > 0;
   a14_Yes = find(catx(',',OrderNameMedications),'CEFTOLOZANE','i') > 0;
   a15_Yes = find(catx(',',OrderNameMedications),'CEFTRIAXONE','i') > 0; * find in*;
   a16_Yes = find(catx(',',OrderNameMedications),'CEFUROXIME','i') > 0;
   a17_Yes = find(catx(',',OrderNameMedications),'CEPHALEXIN','i') > 0; * find in*;
   a18_Yes = find(catx(',',OrderNameMedications),'CIPROFLOXACIN','i') > 0; * find in*;
   a19_Yes = find(catx(',',OrderNameMedications),'CLINDAMYCIN','i') > 0; * find in*;
   a20_Yes = find(catx(',',OrderNameMedications),'DICLOXACILLIN','i') > 0;
   a21_Yes = find(catx(',',OrderNameMedications),'DOXYCYCLINE','i') > 0; * find in*;
   a22_Yes = find(catx(',',OrderNameMedications),'ERYTHROMYCIN','i') > 0; * find in*;
   a23_Yes = find(catx(',',OrderNameMedications),'LEVOFLOXACIN','i') > 0; * find in*;
   a24_Yes = find(catx(',',OrderNameMedications),'LINEZOLID','i') > 0;
   a25_Yes = find(catx(',',OrderNameMedications),'METRONIDAZOLE','i') > 0; * find in*;
   a26_Yes = find(catx(',',OrderNameMedications),'MOXIFLOXACIN','i') > 0;
   a27_Yes = find(catx(',',OrderNameMedications),'NITROFURANTOIN','i') > 0; * find in*;
   a28_Yes = find(catx(',',OrderNameMedications),'PENICILLIN','i') > 0; * find in*;
   a29_Yes = find(catx(',',OrderNameMedications),'SULDAMETHOXAZOLE','i') > 0;
   a30_Yes = find(catx(',',OrderNameMedications),'CEFACLOR','i') > 0;
   a31_Yes = find(catx(',',OrderNameMedications),'CEFADROXIL','i') > 0;
   a32_Yes = find(catx(',',OrderNameMedications),'CEFEPIME','i') > 0;
   a33_Yes = find(catx(',',OrderNameMedications),'CEFIXIME','i') > 0; * find in*;
   a34_Yes = find(catx(',',OrderNameMedications),'CEFOTETAN','i') > 0;
   a35_Yes = find(catx(',',OrderNameMedications),'CEFOXITIN','i') > 0;
   a36_Yes = find(catx(',',OrderNameMedications),'CEFPODOXIME','i') > 0;
   a37_Yes = find(catx(',',OrderNameMedications),'CEFPROZIL','i') > 0;
   a38_Yes = find(catx(',',OrderNameMedications),'CEFTRIAXONE','i') > 0; * find in*;
   a39_Yes = find(catx(',',OrderNameMedications),'CEFUROXIME','i') > 0;
   a40_Yes = find(catx(',',OrderNameMedications),'CHLORAMPHENICOL','i') > 0;
   a41_Yes = find(catx(',',OrderNameMedications),'CIPROFLOXACIN','i') > 0; * find in*;
   a42_Yes = find(catx(',',OrderNameMedications),'CLARITHROMYCIN','i') > 0; * find in*;
   a43_Yes = find(catx(',',OrderNameMedications),'CLARITHROMYCIN','i') > 0; * find in*;
   a44_Yes = find(catx(',',OrderNameMedications),'CLINDAMYCIN','i') > 0; * find in*;
   a45_Yes = find(catx(',',OrderNameMedications),'DAPSONE','i') > 0; * find in*;
   a46_Yes = find(catx(',',OrderNameMedications),'DELAFLOXACIN','i') > 0;
   a47_Yes = find(catx(',',OrderNameMedications),'DEMECLOCYCLINE','i') > 0;
   a48_Yes = find(catx(',',OrderNameMedications),'DOXYCYCLINE','i') > 0; * find in*;
   a49_Yes = find(catx(',',OrderNameMedications),'ERYTHROMYCIN','i') > 0; * find in*;
   a50_Yes = find(catx(',',OrderNameMedications),'FIDAXOMICIN','i') > 0;
   a51_Yes = find(catx(',',OrderNameMedications),'LEVOFLOXACIN','i') > 0; * find in*;
   a52_Yes = find(catx(',',OrderNameMedications),'MINOCYCLINE','i') > 0; * find in*;
   a53_Yes = find(catx(',',OrderNameMedications),'TETRACYCLINE','i') > 0; * find in*;

   a54_Yes = find(catx(',',OrderNameMedications),'AUGMENTIN','i') > 0;
   a55_Yes = find(catx(',',OrderNameMedications),'FLAGYL','i') > 0; * find in*;
   a56_Yes = find(catx(',',OrderNameMedications),'AMOXIL','i') > 0; * find in*;
   a57_Yes = find(catx(',',OrderNameMedications),'CIPRO','i') > 0; * find in*;
   a58_Yes = find(catx(',',OrderNameMedications),'KEFLEX','i') > 0; * find in*;
   a59_Yes = find(catx(',',OrderNameMedications),'BACTRIM','i') > 0; * find in*;
   a60_Yes = find(catx(',',OrderNameMedications),'LEVAQUIN','i') > 0; * find in*;
   a61_Yes = find(catx(',',OrderNameMedications),'ZITHROMAX','i') > 0; * find in*;
   a62_Yes = find(catx(',',OrderNameMedications),'AVELOX','i') > 0; * find in*;
   a63_Yes = find(catx(',',OrderNameMedications),'CLEOCIN','i') > 0; * find in*;
   a64_Yes = find(catx(',',OrderNameMedications),'SULFAMETHOXAZOLE','i') > 0;
   a65_Yes = find(catx(',',OrderNameMedications),'NITROFURANTOIN','i') > 0; * find in*;
   a66_Yes = find(catx(',',OrderNameMedications),'MACROBID','i') > 0; * find in*;

   gel = find(catx(',',OrderNameMedications),'GEL','i') > 0; 
   cream = find(catx(',',OrderNameMedications),'CREAM','i') > 0; 
   ointment = find(catx(',',OrderNameMedications),'OINTMENT','i') > 0; 



run;

%retcsv (meddata, meddata);
%retcsv (aspdata, aspdata);

/* create the antiibio variable. */
data aspcleanvs; set aspcleanvs;

   if ((a1_Yes = 1 or a2_Yes = 1 or a3_Yes = 1 or a4_Yes = 1 or a5_Yes = 1 or a6_Yes = 1 or  a7_Yes = 1 or a8_Yes = 1 
or a9_Yes = 1 or a10_Yes = 1 or a11_Yes = 1 or a12_Yes = 1 or a13_Yes = 1 or a14_Yes = 1 or a15_Yes = 1 or a16_Yes = 1
or a17_Yes = 1 or a18_Yes = 1 or a19_Yes = 1 or a20_Yes = 1 or a21_Yes = 1 or a22_Yes = 1 or a23_Yes = 1 or a24_Yes = 1
or a25_Yes = 1 or a26_Yes = 1 or a27_Yes = 1 or a28_Yes = 1 or a29_Yes = 1 or a30_Yes = 1 or a31_Yes = 1 or a32_Yes = 1 
or a33_Yes = 1 or a34_Yes = 1 or a35_Yes = 1 or a36_Yes = 1 or a37_Yes = 1 or a38_Yes = 1 or a39_Yes = 1 or a40_Yes = 1 
or a41_Yes = 1 or a42_Yes = 1 or a43_Yes = 1 or a44_Yes = 1 or a45_Yes = 1 or a46_Yes = 1 or a47_Yes = 1 or a48_Yes = 1
or a49_Yes = 1 or a50_Yes = 1 or a51_Yes = 1 or a52_Yes = 1 or a53_Yes = 1 or a54_Yes = 1 or a55_Yes = 1 or a56_Yes = 1 
or a57_Yes = 1 or a58_Yes = 1 or a59_Yes = 1 or a60_Yes = 1 or a61_Yes = 1 or a62_Yes = 1 or a63_Yes = 1 or a64_Yes = 1 
or a65_Yes = 1 or a66_Yes = 1) & (gel = 0 & cream = 0 & ointment = 0)) then antibio = 1; else antibio = 0;

run;


%loadat (workdatb.csv, workdatb);
%loadat (antibious.csv, antibious);


data aspvass; set aspcleanvs;
proc sort data = aspvass;
	by UPID;
run;

data aspfree; set aspvass;

	if (drugs = 1) & (visit_15 = 1) & (antibio = 1) then antibio_15 = 1; 
	else antibio_15 = 0;

	if (drugs = 1) & (visit_30 = 1) & (antibio = 1) then antibio_30 = 1; 
	else antibio_30 = 0;
	
run;

%retcsv (aspcleanvs, aspcleanvs);


/*Join hospitrate*/
proc sql;
create table workdatb as select a.*,b.* 
from workdatb a left join antibious b
on a. UPID = b. UPID;
quit;

data workdatb ; set workdatb ; if antibiouse = ' ' then antibiouse = 0; run;


/* working data set for analytics */
data aspclean; set aspclean (drop = order_5 order_10 order_15); run;

%retcsv (aspclean, aspclean);
%retcsv (aspcleanv, aspcleanv);
%retcsv (aspcleanvs, aspcleanvs);
%retcsv (aspfree, aspfree);
%retcsv (workdatan, workdatan);
%retcsv (workdatbv, workdatbv);


*************************************
/* data preprocessing ended here */
************************************;

%loadat (aspworka.csv, aspworka); 

data workdatbv; set workdatbv;

if (sameicd10 = 1) & (ICD10Diagnosis = 'B373') then icdB373 = 1; else icdB373 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'R060') then icdR060 = 1; else icdR060 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'N390') then icdN390 = 1; else icdN390 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'J069') then icdJ069 = 1; else icdJ069 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'J019') then icdJ019 = 1; else icdJ019 = 0;

run;


data workdatb; set workdatb;

if (sameicd10 = 1) & (ICD10Diagnosis = 'J189') then icdJ189 = 1; else icdJ189 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'J029') then icdJ029 = 1; else icdJ029 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'J209') then icdJ209 = 1; else icdJ209 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'L029') then icdL029 = 1; else icdL029 = 0;
if (sameicd10 = 1) & (ICD10Diagnosis = 'L039') then icdL039 = 1; else icdL039 = 0;

run;

%retcsv (aspworka, aspworka);




data workdatan; set workdatan;

if (visit_15 = 1) & (icdsame = 1) then _15_visit = 1; else _15_visit = 0;
if (visit_30 = 1) & (icdsame = 1) then _30_visit = 1; else _30_visit = 0;

run;


/*Join dummies*/
proc sql;
create table workdatbv as select a.*,b.* 
from workdatb a left join workdatbdmy b
on a. UPID = b. UPID;
quit;

%retcsv (workdatav, workdatav);
%retcsv (workdatb, workdatbv);


data workdatb; set workdatb; antusepr = (antibiouse*1000)/1781; run;
