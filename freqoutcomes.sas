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

%loadat(overallprepost.csv, overallprepost);
%loadat(hospitaliz.csv, hospitaliz);
%loadat(antibioprepost.csv, antibioprepost);
%loadat(antibio15prepost.csv, antibio15prepost);
%loadat(antibio30prepost.csv, antibio30prepost);
%loadat(visit15prepost.csv, visit15prepost);
%loadat(visit30prepost.csv, visit30prepost);
%loadat(aspnet.csv, aspnet);
%loadat(weeklyoverall.csv, weeklyoverall);
%loadat(aspnetunique.csv, aspnetunique);




/* create weekly column and formating */
data aspnetunique;
  set aspnetunique;
  format clweekyr yyyyWww;
  format ordweekyr yyyyWww;
run;


/* Macro for data formating */
%Macro conv (input, output);

data &output;
  set &input;

  format mthyr1 monyy7.;
  format mthyr2 monyy7.;
  format mthyr3 monyy7.;

  format clweekyr YYYYWEEKU.;
  format ordweekyr YYYYWEEKU.;
  
run;

%mend conv;

%conv(overallprepost, overallprepost);
%conv(hospitaliz, hospitaliz);
%conv(antibioprepost, antibioprepost);
%conv(antibio15prepost, antibio15prepost);
%conv(antibio30prepost, antibio30prepost);
%conv(visit15prepost, visit15prepost);
%conv(visit30prepost, visit30prepost);


/* Macro for data formating */
%Macro con (input, output);

data &output;
  set &input;

  format clweekyr  YYYYWEEKU8.;
  format ordweekyr YYYYWEEKU8.;
  
run;

%mend con;

%con(aspnet, aspnet);
%con(weeklyoverall, weeklyoverall);
%con(aspnetunique, aspnetunique);


/* Macro for exporting data */
%Macro retcsv (input, output);

proc export data = &input dbms=csv
outfile = "C:/Users/vassi/Desktop/brownproject/2.data/1.rawdata/asp/&output"
replace;
run;

%mend retcsv;

%retcsv(overallprepost, overallprepost);
%retcsv(hospitaliz, hospitaliz);
%retcsv(antibioprepost, antibioprepost);
%retcsv(antibio15prepost, antibio15prepost);
%retcsv(antibio30prepost, antibio30prepost);
%retcsv(visit15prepost, visit15prepost);
%retcsv(visit30prepost, visit30prepost);
%retcsv(weeklyoverall, weeklyoverall);

