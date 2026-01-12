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
    MC3hobbiescorrect = 1).
VARIABLE LABELS filter_$ 'keepdrop = 0 and conriskkeepdrop = 0 and MC1nationalitycorrect = 1 and '+
    'MC3hobbiescorrect = 1 (FILTER)'.
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
*romantic interest factor analysis

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
 /VARIABLES = matevalue1, matevalue2, matevalue3, matevalue4, matevalue5
 /FORMAT=NOLABELS
 /SCALE(ALPHA)=ALL/MODEL=ALPHA
 /STATISTICS=DESCRIPTIVE CORRELATIONS
 /SUMMARY=TOTAL MEANS CORR.


T-TEST GROUPS=targetphysattract(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=MC2attractiveness
  /CRITERIA=CI(.95).


*T-tests*

T-TEST GROUPS=targetformidability(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=rominterest
  /CRITERIA=CI(.95).

T-TEST GROUPS=targetphysattract(0 1)
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

COMPUTE Cconceptionrisk=conceptionrisk-0.04397938144329899.
EXECUTE.

COMPUTE Cvsc=vsc-4.293951890034367.
EXECUTE.

*Create centered interaction terms*

*TWO-WAY*

COMPUTE groupXattract=targetgroupstatus * targetphysattract.
EXECUTE.
COMPUTE groupXformid=targetgroupstatus * targetformidability.
EXECUTE.
COMPUTE groupXcrisk=targetgroupstatus * Cconceptionrisk.
EXECUTE.
COMPUTE groupXvsc=targetgroupstatus * Cvsc.
EXECUTE.
COMPUTE attractXformid=targetphysattract * targetformidability.
EXECUTE.
COMPUTE attractXcrisk=targetphysattract * Cconceptionrisk.
EXECUTE.
COMPUTE attractXvsc=targetphysattract * Cvsc.
EXECUTE.
COMPUTE formidXcrisk=targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE formidXvsc=targetformidability * Cvsc.
EXECUTE.
COMPUTE criskXvsc=Cconceptionrisk * Cvsc.
EXECUTE.

*THREE-WAY*

COMPUTE groupXattractXformid=targetgroupstatus * targetphysattract * targetformidability.
EXECUTE.
COMPUTE groupXattractXcrisk=targetgroupstatus * targetphysattract * Cconceptionrisk.
EXECUTE.
COMPUTE groupXattractXvsc=targetgroupstatus * targetphysattract * Cvsc.
EXECUTE.
COMPUTE groupXformidXcrisk=targetgroupstatus * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE groupXformidXvsc=targetgroupstatus * targetformidability * Cvsc.
EXECUTE.
COMPUTE groupXcriskXvsc=targetgroupstatus * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE attractXformidXcrisk=targetphysattract * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE attractXformidXvsc=targetphysattract * targetformidability * Cvsc.
EXECUTE.
COMPUTE attractXcriskXvsc=targetphysattract * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE formidXcriskXvsc=targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.

*FOUR-WAY*

COMPUTE groupXattractXformidXcrisk=targetgroupstatus * targetphysattract * targetformidability * Cconceptionrisk.
EXECUTE.
COMPUTE groupXattractXformidXvsc=targetgroupstatus * targetphysattract * targetformidability * Cvsc.
EXECUTE.
COMPUTE groupXattractXcriskXvsc=targetgroupstatus * targetphysattract * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE groupXformidXcriskXvsc=targetgroupstatus * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.
COMPUTE attractXformidXcriskXvsc=targetphysattract * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.

*FIVE-WAY*

COMPUTE groupXattractXformidXcriskXvsc=targetgroupstatus * targetphysattract * targetformidability * Cconceptionrisk * Cvsc.
EXECUTE.


**Centered Regression Analysis**
*Full Regression Model with all predictors - 4 and 5-way interactions are all n.s. so they are subsequently dropped from the model 

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rominterest
  /METHOD=ENTER targetgroupstatus targetphysattract targetformidability Cconceptionrisk Cvsc
  /METHOD=ENTER groupXattract groupXformid groupXcrisk groupXvsc attractXformid attractXcrisk 
    attractXvsc formidXcrisk formidXvsc criskXvsc
  /METHOD=ENTER groupXattractXformid groupXattractXcrisk groupXattractXvsc groupXformidXcrisk 
    groupXformidXvsc groupXcriskXvsc attractXformidXcrisk attractXformidXvsc attractXcriskXvsc 
    formidXcriskXvsc
  /METHOD=ENTER groupXattractXformidXcrisk groupXattractXcriskXvsc groupXformidXcriskXvsc 
    attractXformidXcriskXvsc groupXattractXformidXvsc
  /METHOD=ENTER groupXattractXformidXcriskXvsc.


*Removing target physical attractiveness since the manipulation failed

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rominterest
  /METHOD=ENTER targetgroupstatus targetformidability Cconceptionrisk Cvsc
  /METHOD=ENTER groupXformid groupXcrisk groupXvsc formidXcrisk formidXvsc criskXvsc
  /METHOD=ENTER groupXformidXcrisk groupXformidXvsc groupXcriskXvsc formidXcriskXvsc
  /METHOD=ENTER groupXformidXcriskXvsc.
   
*Model above without the 4 way interaction

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rominterest
  /METHOD=ENTER targetgroupstatus targetformidability Cconceptionrisk Cvsc
  /METHOD=ENTER groupXformid groupXcrisk groupXvsc formidXcrisk formidXvsc criskXvsc
  /METHOD=ENTER groupXformidXcrisk groupXformidXvsc groupXcriskXvsc formidXcriskXvsc.





