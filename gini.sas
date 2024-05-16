/*                        GINI CODE
                          =========

   This SAS code was written by Philip N. Cohen. It is meant to be adaptable to
   various units of analysis and measures of interest. The Gini coefficient can
   be calculated for lots of different distributions, although it is most often
   used for income.

   The formula used here is from _The methods and materials of demography_,
   by Henry S. Shryock, Jacob S. Siegel, and associates. Orlanda, FL:
   Academic Press, 1976 (p. 98).

   (The author of the code can take no responsibility for its reliability
    or accuracy, or for the results obtained with its use; but he would be
    glad to take partial credit for it successful use or adaptation.)
*/


/* The variable I use is CAPINC and the weight is CAPWGT.
   Substitute these for your own measure and population weight.
   Those are the only variable names you have to change to suit
   your data.
 */

/* This creates a table with one line for each level of income,
   the number of (weighted) people with that income, and the
   percent with that income. */

title 'Income distribution';
proc freq data=temp;
tables capinc / noprint out = table;
format capinc 7.0;
weight capwgt;
run;

/* this data step creates cumulative income and population
   columns */

data table;
set table;

retain suminc perpop;

suminc + (capinc * count);
perpop + percent;

/* suminc is the cumulative income at each point in the distribution.
   perpop is the cumulative population at each point in the distribution.
   Note that PERCENT and COUNT are variables created by PROC FREQ.
 */

run;

/* This sort and data step takes the last value of suminc,
   which is the total income, and adds it onto every
   record in the table as totalinc. Then it divides suminc
   by totalinc for each line to create the percent of
   income below that point in the distribution */

proc sort data=table;
by descending suminc ;
run;

data table;
set table;
by descending suminc;

if _n_=1 then do;
totalinc=suminc;
end;

retain totalinc;

perinc = (suminc/totalinc) * 100;

run;

/* this sort just puts it back in order
   from low to high */

proc sort data=table;
by perpop;
run;

/* To calculate Gini:
   sum[Xsub(i) * Ysub(i+1)] - sum[Xsub(i+1) * Ysub(i)]
   where X is the proportion of population column and
   Y is the proportion of income column.
 */

data ginidat;
set table;

xlag = lag(perpop);
xlag = xlag / 100;

ylag = lag(perinc);
ylag = ylag / 100;

columna = (perinc/100) * xlag;
columnb = (perpop/100) * ylag;

retain suma sumb;

suma + columna;
sumb + columnb;

gini = suma - sumb;

run;

title2 'Gini coefficient';
proc print data=ginidat;
var gini;
where perinc = 100;
run;
title2;

/* Optional graph portion:

   For graphing a Lorenz curve, these steps output 
   table data in truncated form, and read it back in,
   taking only the last occurrence of each whole percentage
   of the population. That just cuts it down to 101
   records (0-100), instead of however many thousands.

   Note that this creates a file called 'temp.dat' in your C:
   directory: adjust to suit.
*/

data table; set table;
file 'C:\temp.dat';
put perinc 4.2 perpop 4.0;
run;

data table;
filename in 'C:\temp.dat';
infile in;
input perinc perpop;
run;

proc sort data=table; by perpop; run;

data table; set table;
by perpop;
if last.perpop;
run;

proc print data=table;

/* creates a simple Lorenz curve graph */

symbol1 interpol=join width=2 value=none height=1 color=black;
proc gplot data=table;
plot perinc*perpop=1;
run;

