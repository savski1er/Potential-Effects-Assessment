
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

%loadat(aspnet.csv, aspnet);


/* The Data Step for execution of ITS*/

Data IndivDa;
Set aspnet (keep = ClinicalEncounterDate antibio antibio_15 antibio_30 visit_15 visit_30 hospnobthgr 
);
format ClinicalEncounterDate date9.;
Trend =sum (
		intck ("months", '1nov2019'd, ClinicalEncounterDate, "c"),
        NStudMoPreIntervention
        );

Intervention =max (0, Trend > NStudMoPreIntervention );
TrendPre =max (0, Trend *(Not (Intervention)));
TrendPst =max (0, Trend * Intervention);
run;

data IndivDa; set IndivDa; if hospnobthgr = 1 then hospnobthgr = 1; else hospnobthgr = 0;

/* The Summary Step for execution of ITS*/

proc summary data = IndivDa (where = (-18<= Trend <= 18)) nway;
var antibio ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_antibio
		(rename = (_freq_ = nsantibio) drop = _type_) 
mean(antibio) = antibio std(antibio) = std_antibio;  
run;


proc summary data = IndivDa (where = (-17<= Trend <= 17)) nway;
var antibio_15 ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_antibio15
		(rename = (_freq_ = nsantibio15) drop = _type_) 
mean(antibio_15) = antibio15 std(antibio_15) = std_antibio15;  
run;


proc summary data = IndivDa (where = (-17<= Trend <= 17)) nway;
var antibio_30 ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_antibio30
		(rename = (_freq_ = nsantibio30) drop = _type_) 
mean(antibio_30) = antibio30 std(antibio_30) = std_antibio30;  
run;

proc summary data = IndivDa (where = (-19<= Trend <= 19)) nway;
var visit_15 ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_visit15
		(rename = (_freq_ = nsvisit15) drop = _type_) 
mean(visit_15) = visit15 std(visit_15) = std_visit15;  
run;

proc summary data = IndivDa (where = (-19<= Trend <= 19)) nway;
var visit_30 ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_visit30
		(rename = (_freq_ = nsvisit30) drop = _type_) 
mean(visit_30) = visit30 std(visit_30) = std_visit30;  
run;


proc summary data = IndivDa (where = (-19<= Trend <= 19)) nway;
var hospnobthgr ;
class Trend;
Id Intervention TrendPre TrendPst;
Output out = monthlytimeseriesdata_hospit
		(rename = (_freq_ = nshospnobthgr) drop = _type_) 
mean(hospnobthgr) = hospnobthgr std(hospnobthgr) = std_hospnobthgr;  
run;

%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv(monthlytimeseriesdata_antibio, monthlytimeseriesdata_antibio);
%retcsv(monthlytimeseriesdata_antibio15, monthlytimeseriesdata_antibio15);
%retcsv(monthlytimeseriesdata_antibio30, monthlytimeseriesdata_antibio30);
%retcsv(monthlytimeseriesdata_visit15, monthlytimeseriesdata_visit15);
%retcsv(monthlytimeseriesdata_visit30, monthlytimeseriesdata_visit30);
%retcsv(monthlytimeseriesdata_hospit, monthlytimeseriesdata_hospit);


/* ITS Without trend*/
%Macro itsnwt (input1, input2);

Proc AUTOREG data = &input1;
Model &input2 = Intervention
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsnwt;

%itsnwt(monthlytimeseriesdata_antibio, antibio);
%itsnwt(monthlytimeseriesdata_antibio15, antibio15);
%itsnwt(monthlytimeseriesdata_antibio30, antibio30);
%itsnwt(monthlytimeseriesdata_visit15, visit15);
%itsnwt(monthlytimeseriesdata_visit30, visit30);
%itsnwt(monthlytimeseriesdata_hospit, hospnobthgr);


/* ITS With trend: Trend */

%Macro itsywt (input1, input2);

Proc AUTOREG data = &input1;
Model &input2 = Intervention Trend
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywt;

%itsywt(monthlytimeseriesdata_antibio, antibio);
%itsywt(monthlytimeseriesdata_antibio15, antibio15);
%itsywt(monthlytimeseriesdata_antibio30, antibio30);
%itsywt(monthlytimeseriesdata_visit15, visit15);
%itsywt(monthlytimeseriesdata_visit30, visit30);
%itsywt(monthlytimeseriesdata_hospit, hospnobthgr);


/* ITS Without trend: TrendPre and TrendPst */

%Macro itsywtt (input1, input2);

Proc AUTOREG data = &input1;
Model &input2 = Intervention TrendPre TrendPst
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywtt;

%itsywtt(monthlytimeseriesdata_antibio, antibio);
%itsywtt(monthlytimeseriesdata_antibio15, antibio15);
%itsywtt(monthlytimeseriesdata_antibio30, antibio30);
%itsywtt(monthlytimeseriesdata_visit15, visit15);
%itsywtt(monthlytimeseriesdata_visit30, visit30);
%itsywtt(monthlytimeseriesdata_hospit, hospnobthgr);



Data IndiASP;
Set aspnet (keep = ClinicalEncounterDate racegr sex ethnicgr insurangr agegr providgr educatgr hospnobthgr tobacgr 
icdsame visit_15 visit_30 antibio antibio_15 antibio_30 
);
format ClinicalEncounterDate date9.;
Trend =sum (
		intck ("months", '1nov2019'd, ClinicalEncounterDate, "c"),
        NStudMoPreIntervention
        );

Intervention =max (0, Trend > NStudMoPreIntervention );
TrendPre =max (0, Trend *(Not (Intervention)));
TrendPst =max (0, Trend * Intervention);
run;

data IndiASP; set IndiASP; if hospnobthgr = 1 then hospnobthgr = 1; else hospnobthgr = 0;


proc summary data = IndiASP (where = (-19<= Trend <= 19)) nway;

	var racegr sex ethnicgr insurangr agegr providgr educatgr hospnobthgr tobacgr icdsame visit_15 visit_30 antibio antibio_15 antibio_30;
	class Trend;
	Id Intervention TrendPre TrendPst;
	Output out = monthlytimeseriesdata
			(rename = (_freq_ = nsvisit15 _freq_ = nsvisit30 _freq_ = nsantibio _freq_ = nsantibio15 _freq_ = nsantibio30
						_freq_ = nshospnobthgr _freq_ = nsoverall) drop = _type_) 
		mean(racegr) = racegr 
		mean(sex) = sex 
		mean(ethnicgr) = ethnicgr 
		mean(agegr) = agegr 
		mean(insurangr) = insurangr 
		mean(providgr) = providgr 
		mean(providgr) = providgr
		mean(educatgr) = educatgr 
		mean(tobacgr) = tobacgr
		mean(icdsame) = icdsame
		mean(visit_15) = visit15 std(visit_15) = std_visit15
		mean(visit_30) = visit30 std(visit_30) = std_visit30
		mean(antibio) = antibio std(antibio) = std_antibio
		mean(antibio_15) = antibio15 std(antibio_15) = std_antibio15
		mean(antibio_30) = antibio30 std(antibio_30) = std_antibio30  
		mean(hospnobthgr) = hospnobthgr std(hospnobthgr) = std_hospnobthgr;  

run;


%retcsv(monthlytimeseriesdata, monthlytimeseriesdata);

%loadat(monthlytimeseriesdata.csv, monthlytimeseriesdata);
%loadat(monthlytimeseriesdatb.csv, monthlytimeseriesdatb);


/******************************************************************************************/
/* ITS Without and with trend, controlling for covid19, seasonality, and winter vs summer */
/******************************************************************************************/

/* ITS Without trend, controlling for covid19, seasonality, and winter vs summer */

/* ITS Without trend */
%Macro itsnwt (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits1.csv" style=Vasstables;
title1 "ITS Without trend";

Proc AUTOREG data = &input1;
Model &input2 = Intervention 
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsnwt;

%itsnwt(monthlytimeseriesdata, antibio);
%itsnwt(monthlytimeseriesdata, antibio15);
%itsnwt(monthlytimeseriesdata, antibio30);
%itsnwt(monthlytimeseriesdata, visit15);
%itsnwt(monthlytimeseriesdata, visit30);
%itsnwt(monthlytimeseriesdata, hospnobthgr);


/* ITS Without trend, controlling for covid19 only */
%Macro itsnwts (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits2.csv" style=Vasstables;
title1 "ITS Without trend and controlling for covid19";

Proc AUTOREG data = &input1;
Model &input2 = Intervention covid19
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsnwts;

%itsnwts(monthlytimeseriesdata, antibio);
%itsnwts(monthlytimeseriesdata, antibio15);
%itsnwts(monthlytimeseriesdata, antibio30);
%itsnwts(monthlytimeseriesdata, visit15);
%itsnwts(monthlytimeseriesdata, visit30);
%itsnwts(monthlytimeseriesdata, hospnobthgr);


/* ITS Without trend, controlling for covid19, seasonality, and wntr_vs_smr with */
%Macro itsnwtc (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits3.csv" style=Vasstables;
title1 "ITS Without trend and controlling for covariates";

Proc AUTOREG data = &input1;
Model &input2 = Intervention covid19 seasonality wntr_vs_smr
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsnwtc;

%itsnwtc(monthlytimeseriesdata, antibio);
%itsnwtc(monthlytimeseriesdata, antibio15);
%itsnwtc(monthlytimeseriesdata, antibio30);
%itsnwtc(monthlytimeseriesdata, visit15);
%itsnwtc(monthlytimeseriesdata, visit30);
%itsnwtc(monthlytimeseriesdata, hospnobthgr);



/* ITS With trend: Trend, controlling for covid19, seasonality, and winter vs summer */

/* ITS With trend: Trend Only */
%Macro itsywt (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits4.csv" style=Vasstables;
title1 "ITS With trend: Trend";

Proc AUTOREG data = &input1;
Model &input2 = Intervention Trend
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywt;

%itsywt(monthlytimeseriesdata, antibio);
%itsywt(monthlytimeseriesdata, antibio15);
%itsywt(monthlytimeseriesdata, antibio30);
%itsywt(monthlytimeseriesdata, visit15);
%itsywt(monthlytimeseriesdata, visit30);
%itsywt(monthlytimeseriesdata, hospnobthgr);


/* ITS With trend: Trend, controlling for covid19 only */
%Macro itsywts (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits5.csv" style=Vasstables;
title1 "ITS With trend: Trend";

Proc AUTOREG data = &input1;
Model &input2 = Intervention Trend covid19
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywts;

%itsywts(monthlytimeseriesdata, antibio);
%itsywts(monthlytimeseriesdata, antibio15);
%itsywts(monthlytimeseriesdata, antibio30);
%itsywts(monthlytimeseriesdata, visit15);
%itsywts(monthlytimeseriesdata, visit30);
%itsywts(monthlytimeseriesdata, hospnobthgr);


/* ITS With trend: Trend, controlling for covid19, seasonality, and wntr_vs_smr */
%Macro itsywtc (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits6.csv" style=Vasstables;
title1 "ITS With trend: Trend and controlling for covariates";

Proc AUTOREG data = &input1;
Model &input2 = Intervention Trend covid19 seasonality wntr_vs_smr
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywtc;

%itsywtc(monthlytimeseriesdata, antibio);
%itsywtc(monthlytimeseriesdata, antibio15);
%itsywtc(monthlytimeseriesdata, antibio30);
%itsywtc(monthlytimeseriesdata, visit15);
%itsywtc(monthlytimeseriesdata, visit30);
%itsywtc(monthlytimeseriesdata, hospnobthgr);



/* ITS With trend: TrendPre and TrendPst, controlling for covid19, seasonality, and winter vs summer */

/* ITS With trend: TrendPre and TrendPst Only */
%Macro itsywtt (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits7.csv" style=Vasstables;
title1 "ITS Without trend: TrendPre and TrendPst";

Proc AUTOREG data = &input1;
Model &input2 = Intervention TrendPre TrendPst 
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywtt;

%itsywtt(monthlytimeseriesdata, antibio);
%itsywtt(monthlytimeseriesdata, antibio15);
%itsywtt(monthlytimeseriesdata, antibio30);
%itsywtt(monthlytimeseriesdata, visit15);
%itsywtt(monthlytimeseriesdata, visit30);
%itsywtt(monthlytimeseriesdata, hospnobthgr);


/* ITS With trend: TrendPre and TrendPst, contolling for covid19 only */
%Macro itsywtts (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits8.csv" style=Vasstables;
title1 "ITS Without trend: TrendPre and TrendPst";

Proc AUTOREG data = &input1;
Model &input2 = Intervention TrendPre TrendPst covid19
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywtts;

%itsywtts(monthlytimeseriesdata, antibio);
%itsywtts(monthlytimeseriesdata, antibio15);
%itsywtts(monthlytimeseriesdata, antibio30);
%itsywtts(monthlytimeseriesdata, visit15);
%itsywtts(monthlytimeseriesdata, visit30);
%itsywtts(monthlytimeseriesdata, hospnobthgr);


/* ITS With trend: TrendPre and TrendPst, controlling for covid19, seasonality, and wntr_vs_smr */
%Macro itsywttc (input1, input2);

options orientation=landscape;
ods csv file= "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/tabits9.csv" style=Vasstables;
title1 "ITS Without trend: TrendPre and TrendPst controlling for all covariates";

Proc AUTOREG data = &input1;
Model &input2 = Intervention TrendPre TrendPst covid19 seasonality wntr_vs_smr
/ DW = 12 dwprob
Method = ml loglikl
plots (UNPACKpanel only) = (standardresidual fitplot);

run;

%mend itsywttc;

%itsywttc(monthlytimeseriesdata, antibio);
%itsywttc(monthlytimeseriesdata, antibio15);
%itsywttc(monthlytimeseriesdata, antibio30);
%itsywttc(monthlytimeseriesdata, visit15);
%itsywttc(monthlytimeseriesdata, visit30);
%itsywttc(monthlytimeseriesdata, hospnobthgr);
