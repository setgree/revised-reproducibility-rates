* Encoding: UTF-8.
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Manipulation Check Syntax 

*Manipulation Check: Nationality

DO IF  (targetnationality = 0).
RECODE MC1nationality (1=1) (2=0) (3=0) (4=0) INTO MC1nationalitycorrect.
END IF.
VARIABLE LABELS  MC1nationalitycorrect '0=wrong, 1=correct'.
EXECUTE.

DO IF  (targetnationality = 1).
RECODE MC1nationality (1=0) (2=0) (3=0) (4=1) INTO MC1nationalitycorrect.
END IF.
VARIABLE LABELS  MC1nationalitycorrect '0=wrong, 1=correct'.
EXECUTE.

DO IF  (targetnationality = 2).
RECODE MC1nationality (1=0) (2=1) (3=0) (4=0) INTO MC1nationalitycorrect.
END IF.
VARIABLE LABELS  MC1nationalitycorrect '0=wrong, 1=correct'.
EXECUTE.

DO IF  (targetnationality = 3).
RECODE MC1nationality (1=0) (2=1) (3=0) (4=0) INTO MC1nationalitycorrect.
END IF.
VARIABLE LABELS  MC1nationalitycorrect '0=wrong, 1=correct'.
EXECUTE.

*Manipulation Check: Income

DO IF  (targetincome=0).
RECODE MC2income (1=1) (2=0) (3=0) INTO MC2incomecorrect.
END IF.
VARIABLE LABELS  MC2incomecorrect '0=wrong, 1=correct'.
EXECUTE.

DO IF  (targetincome=1).
RECODE MC2income (1=0) (2=0) (3=1) INTO MC2incomecorrect.
END IF.
VARIABLE LABELS  MC2incomecorrect '0=wrong, 1=correct'.
EXECUTE.

*Manipulation Check: Hobbies

DO IF  (targetformidability=0).
RECODE MC3hobbies (1=1) (2=0) (3=0) INTO MC3hobbiescorrect.
END IF.
VARIABLE LABELS  MC3hobbiescorrect '0=wrong, 1=correct'.
EXECUTE.

DO IF  (targetformidability=1).
RECODE MC3hobbies (1=0) (2=1) (3=0) INTO MC3hobbiescorrect.
END IF.
VARIABLE LABELS  MC3hobbiescorrect '0=wrong, 1=correct'.
EXECUTE.

*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Filter for keep/drop. This section has screened for completed survey, duplicateID, turkprime gender, demographic exclusion criteria,
 careless respondnig, and the attention check. 

*Filter for conception risk This section combines results from conception risk exclusion. Thus, individuals who have never menstruated, stopped menstruating
for reasons other than pregnancy, are taking HRT, have taken hormonal contraceptive in the last 3 months, are pregnant, have had a child in the last year, have 
have an average cycle less than 24 days, greater than 36 days, or have impossible data are excluded from analyses.

*Filter for manipulation check.

USE ALL.
COMPUTE filter_$=(keepdrop = 0 and conriskkeepdrop = 0 and MC1nationalitycorrect = 1 and 
    MC2incomecorrect = 1 and MC3hobbiescorrect = 1).
VARIABLE LABELS filter_$ 'keepdrop = 0 and conriskkeepdrop = 0 and MC1nationalitycorrect = 1 and '+
    'MC2incomecorrect = 1 and MC3hobbiescorrect = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*Vulnerbility to sexual coercion

RECODE BehVig8 BehVig26 BehVig27 BehVig28 BehVig29 BehVig30 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) INTO 
    BehVig8r BehVig26r BehVig27r BehVig28r BehVig29r BehVig30r.
EXECUTE.

COMPUTE vsc=MEAN(BehVIG1, BehVIG2, BehVIG3, BehVIG4, BehVIG5, BehVIG6, BehVIG7, BehVIG8r, BehVIG9, BehVIG10, BehVIG11, BehVIG12, BehVIG13, BehVIG14, BehVIG15, BehVIG16, BehVIG17, BehVIG18,
BehVIG19, BehVIG20, BehVIG21, BehVIG22, BehVIG23, BehVIG24, BehVIG25, BehVIG26r, BehVIG27r, BehVIG28r, BehVIG29r, BehVIG30r).
EXECUTE.

RELIABILITY
 /VARIABLES =  BehVIG1, BehVIG2, BehVIG3, BehVIG4, BehVIG5, BehVIG6, BehVIG7, BehVIG8r, BehVIG9, BehVIG10, BehVIG11, BehVIG12, BehVIG13, BehVIG14, BehVIG15, BehVIG16, BehVIG17, BehVIG18,
BehVIG19, BehVIG20, BehVIG21, BehVIG22, BehVIG23, BehVIG24, BehVIG25, BehVIG26r, BehVIG27r, BehVIG28r, BehVIG29r, BehVIG30r
 /FORMAT=NOLABELS
 /SCALE (ALPHA)=ALL/MODEL =ALPHA
 /STATISTICS =DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR . 

FREQUENCIES
 VARIABLES= vsc
 /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN MODE SKEWNESS SESKEW KURTOSIS SEKURT
 /HISTOGRAM NORMAL
 /ORDER= ANALYSIS.

EXAMINE 
 VARIABLES=vsc
 /PLOT BOXPLOT STEMLEAF
 /COMPARE GROUP
 /STATISTICS DESCRIPTIVE EXTREME
 /CINTERVAL 95
 /MISSING LISTWISE
 /NOTOTAL.

*---------------------------------------------------------------------------------------------------------------------------------------------------------------
*mate value scale

COMPUTE matevalue= MEAN (matevalue1, matevalue2, matevalue3, matevalue4, matevalue5).
EXECUTE.

RELIABILITY
 /VARIABLES = matevalue1, matevalue2, matevalue3, matevalue4, matevalue5
 /FORMAT=NOLABELS
 /SCALE(ALPHA)=ALL/MODEL=ALPHA
 /STATISTICS=DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR.

FREQUENCIES
 VARIABLES=matevalue
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN MODE SKEWNESS SESKEW KURTOSIS SEKURT
  /HISTOGRAM  NORMAL
  /ORDER=  ANALYSIS .

EXAMINE
  VARIABLES=matevalue
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUP
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL. 

*---------------------------------------------------------------------------------------------------------------------------------------------------------
*Factor analysis to determine whether short-term and long-term interest items load on separate factors

FACTOR
  /VARIABLES RomInterest_1 RomInterest_2 RomInterest_3 RomInterest_4 RomInterest_5 RomInterest_6 
    RomInterest_7 RomInterest_8
  /MISSING LISTWISE 
  /ANALYSIS RomInterest_1 RomInterest_2 RomInterest_3 RomInterest_4 RomInterest_5 RomInterest_6 
    RomInterest_7 RomInterest_8
  /PRINT INITIAL EXTRACTION ROTATION
  /PLOT EIGEN
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /METHOD=CORRELATION.

*romantic interest scale

COMPUTE rominterest= MEAN (RomInterest_1, RomInterest_2, RomInterest_3, RomInterest_4, RomInterest_5, RomInterest_6, RomInterest_7, RomInterest_8).
EXECUTE.

RELIABILITY
 /VARIABLES = RomInterest_1, RomInterest_2, RomInterest_3, RomInterest_4, RomInterest_5, RomInterest_6, RomInterest_7, RomInterest_8
 /FORMAT=NOLABELS
 /SCALE(ALPHA)=ALL/MODEL=ALPHA
 /STATISTICS=DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR.

FREQUENCIES
 VARIABLES=rominterest
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN MODE SKEWNESS SESKEW KURTOSIS SEKURT
  /HISTOGRAM  NORMAL
  /ORDER=  ANALYSIS .

EXAMINE
  VARIABLES=rominterest
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUP
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL. 




**----------------------------------Analyses for Paper--------------------------------------------------------------*

*Descriptive stats*

DESCRIPTIVES VARIABLES=age annualincome
  /STATISTICS=MEAN STDDEV MIN MAX.

CORRELATIONS
  /VARIABLES=conceptionrisk vsc rominterest
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

DESCRIPTIVES VARIABLES=conceptionrisk vsc rominterest
  /STATISTICS=MEAN STDDEV MIN MAX.

RELIABILITY
 /VARIABLES =  BehVIG1, BehVIG2, BehVIG3, BehVIG4, BehVIG5, BehVIG6, BehVIG7, BehVIG8r, BehVIG9, BehVIG10, BehVIG11, BehVIG12, BehVIG13, BehVIG14, BehVIG15, BehVIG16, BehVIG17, BehVIG18,
BehVIG19, BehVIG20, BehVIG21, BehVIG22, BehVIG23, BehVIG24, BehVIG25, BehVIG26r, BehVIG27r, BehVIG28r, BehVIG29r, BehVIG30r
 /FORMAT=NOLABELS
 /SCALE (ALPHA)=ALL/MODEL =ALPHA
 /STATISTICS =DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR . 

RELIABILITY
 /VARIABLES = RomInterest_1, RomInterest_2, RomInterest_3, RomInterest_4, RomInterest_5, RomInterest_6, RomInterest_7, RomInterest_8
 /FORMAT=NOLABELS
 /SCALE(ALPHA)=ALL/MODEL=ALPHA
 /STATISTICS=DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR.

RELIABILITY
  /VARIABLES=matevalue1 matevalue2 matevalue3 matevalue4 matevalue5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.


*T-tests*

T-TEST GROUPS=targetformidability(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=rominterest
  /CRITERIA=CI(.95).

T-TEST GROUPS=targetincome(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=rominterest
  /CRITERIA=CI(.95).

T-TEST GROUPS=targetgroupstatus(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=rominterest
  /CRITERIA=CI(.95).

*Regression Analyses*

*Create centered continuous variables*

DESCRIPTIVES VARIABLES=conceptionrisk vsc
  /STATISTICS=MEAN STDDEV MIN MAX.

COMPUTE Cconceptionrisk=conceptionrisk-.043023255813953505.
EXECUTE.

COMPUTE Cvsc=vsc-4.400620155038761.
EXECUTE.

*Create centered interaction terms*

*TWO-WAY*

COMPUTE groupXincome=targetgroupstatus * targetincome.
EXECUTE.
COMPUTE groupXformid=targetgroupstatus * targetformidability.
EXECUTE.
COMPUTE groupXcrisk=targetgroupstatus * Cconceptionrisk.
EXECUTE.
COMPUTE groupXvsc=targetgroupstatus * Cvsc.
EXECUTE.
COMPUTE incomeXformid=targetincome * targetformidability.
EXECUTE.
COMPUTE incomeXcrisk=targetincome * Cconceptionrisk.
EXECUTE.
COMPUTE incomeXvsc=targetincome * Cvsc.
EXECUTE.
COMPUTE formidXcrisk=targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE formidXvsc=targetformidability * Cvsc.
EXECUTE.
COMPUTE criskXvsc=Cconceptionrisk * Cvsc.
EXECUTE.

*THREE-WAY*

COMPUTE groupXincomeXformid=targetgroupstatus * targetincome * targetformidability.
EXECUTE.
COMPUTE groupXincomeXcrisk=targetgroupstatus * targetincome * Cconceptionrisk.
EXECUTE.
COMPUTE groupXincomeXvsc=targetgroupstatus * targetincome * Cvsc.
EXECUTE.
COMPUTE groupXformidXcrisk=targetgroupstatus * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE groupXformidXvsc=targetgroupstatus * targetformidability * Cvsc.
EXECUTE.
COMPUTE groupXcriskXvsc=targetgroupstatus * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE incomeXformidXcrisk=targetincome * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE incomeXformidXvsc=targetincome * targetformidability * Cvsc.
EXECUTE.
COMPUTE incomeXcriskXvsc=targetincome * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE formidXcriskXvsc=targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.

*FOUR-WAY*

COMPUTE groupXincomeXformidXcrisk=targetgroupstatus * targetincome * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE groupXincomeXformidXvsc=targetgroupstatus * targetincome * targetformidability * Cvsc.
EXECUTE.
COMPUTE groupXincomeXcriskXvsc=targetgroupstatus * targetincome * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE groupXformidXcriskXvsc=targetgroupstatus * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE incomeXformidXcriskXvsc=targetincome * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.

*FIVE-WAY*

COMPUTE groupXincomeXformidXcriskXvsc=targetgroupstatus * targetincome * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.


**Centered Regression Analysis**
*Full Regression Model with all predictors - 4 and 5-way interactions are all n.s. so they are subsequently dropped from the model 

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rominterest
  /METHOD=ENTER targetgroupstatus targetincome targetformidability Cconceptionrisk Cvsc
  /METHOD=ENTER groupXincome groupXformid groupXcrisk groupXvsc incomeXformid incomeXcrisk 
    incomeXvsc formidXcrisk formidXvsc criskXvsc
  /METHOD=ENTER groupXincomeXformid groupXincomeXcrisk groupXincomeXvsc groupXformidXcrisk 
    groupXformidXvsc groupXcriskXvsc incomeXformidXcrisk incomeXformidXvsc incomeXcriskXvsc 
    formidXcriskXvsc
  /METHOD=ENTER groupXincomeXformidXcrisk groupXincomeXcriskXvsc groupXformidXcriskXvsc 
    incomeXformidXcriskXvsc groupXincomeXformidXvsc
  /METHOD=ENTER groupXincomeXformidXcriskXvsc.

*Model above without the 4 and 5-way interactions

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN  
  /DEPENDENT rominterest
  /METHOD=ENTER targetgroupstatus targetincome targetformidability Cconceptionrisk Cvsc
  /METHOD=ENTER groupXincome groupXformid groupXcrisk groupXvsc incomeXformid incomeXcrisk 
    incomeXvsc formidXcrisk formidXvsc criskXvsc
  /METHOD=ENTER groupXincomeXformid groupXincomeXcrisk groupXincomeXvsc groupXformidXcrisk 
    groupXformidXvsc groupXcriskXvsc incomeXformidXcrisk incomeXformidXvsc incomeXcriskXvsc 
    formidXcriskXvsc.
