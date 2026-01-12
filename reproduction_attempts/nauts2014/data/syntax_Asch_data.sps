***********************************************************************************************************************************
********************************************syntax Asch experiment***********************************************************
********************************************June/July 2013**********************************************************************
********************************************written by Sanne Nauts************************************************************
********************************************analayses checked by Inge Huijsmans******************************************
***********************************************************************************************************************************


***********************************************************************************************************************************
*********************DATA PREPARATION************************************************************************************
***********************************************************************************************************************************


************openended question & ranking (Asch.dat)******************
*first: clean up data:

DELETE VARIABLES build.
DELETE VARIABLES pretrialpause to blocktimeout.
DELETE VARIABLES correct to stimulusonset8.
EXECUTE.

SELECT IF blockcode ~= "INF".
SELECT IF blockcode ~= "ListA".
SELECT IF blockcode ~= "ListB".
SELECT IF blockcode ~= "ListC".
SELECT IF blockcode ~= "ListD".
SELECT IF blockcode ~= "ListE".
SELECT IF blockcode ~= "ListF".
SELECT IF blockcode ~= "ListG".
SELECT IF blockcode ~= "ListA_repeat".
SELECT IF blockcode ~= "ListB_repeat".
SELECT IF blockcode ~= "ListC_repeat".
SELECT IF blockcode ~= "ListD_repeat".
SELECT IF blockcode ~= "ListE_repeat".
SELECT IF blockcode ~= "ListF_repeat".
SELECT IF blockcode ~= "ListG_repeat".
SELECT IF blockcode ~= "end".
EXECUTE.

*delete practice run.

SELECT IF subject ~=3.
EXECUTE.

*we would like all data to be in the same columns, so here, I change the trialcode to make sure they are the same for all conditions.


RECODE trialcode ('trial1B'='trial1') ('trial2B'='trial2') ('trial3B'='trial3') ('trial4B'='trial4') ('trial5B'='trial5') ('trial6B'='trial6') ('trial7B'='trial7').
RECODE trialcode ('trial1C'='trial1') ('trial2C'='trial2') ('trial3C'='trial3') ('trial4C'='trial4') ('trial5C'='trial5') ('trial6C'='trial6') ('trial7C'='trial7').
RECODE trialcode ('trial1D'='trial1') ('trial2D'='trial2') ('trial3D'='trial3') ('trial4D'='trial4') ('trial5D'='trial5') ('trial6D'='trial6') ('trial7D'='trial7').
RECODE trialcode ('trial1E'='trial1') ('trial2E'='trial2') ('trial3E'='trial3') ('trial4E'='trial4') ('trial5E'='trial5') ('trial6E'='trial6') ('trial7E'='trial7').
RECODE trialcode ('trial1F'='trial1') ('trial2F'='trial2') ('trial3F'='trial3') ('trial4F'='trial4') ('trial5F'='trial5') ('trial6F'='trial6') ('trial7F'='trial7').
RECODE trialcode ('trial1G'='trial1') ('trial2G'='trial2') ('trial3G'='trial3') ('trial4G'='trial4') ('trial5G'='trial5') ('trial6G'='trial6') ('trial7G'='trial7').
EXECUTE.

*******restructure*****

CASESTOVARS					
 /ID = time subject
 /INDEX = trialcode
 /GROUPBY = VARIABLE.
EXECUTE.

DELETE VARIABLES blocknum.IMC to blockcode.trial7.
EXECUTE.

****determine condition**********

COMPUTE condition = 0.
IF ((mod ((subject),7)) = 1) condition = 1.
IF ((mod ((subject-1),7)) = 1) condition = 2.
IF ((mod ((subject-2),7)) = 1) condition = 3.
IF ((mod ((subject-3),7)) = 1) condition = 4.
IF ((mod ((subject-4),7)) = 1) condition = 5.
IF ((mod ((subject-5),7)) = 1) condition = 6.
IF ((mod ((subject-6),7)) = 1) condition = 7.
EXECUTE.


*label condition:

VALUE LABELS condition 1 'intelligent, skillful, industrious, warm, determined, practical, cautious' 2 'intelligent, skillful, industrious, cold, determined, practical, cautious' 
3 'obedient, weak, shallow, warm, unambitious, vain' 4 'vain, shrewd, unscrupulous, warm, shallow, envious'
5 'intelligent, skillful, sincere, cold, conscientious, helpful, modest' 6 'intelligent, skillful, industrious, polite, determined, practical, cautious' 
7  'intelligent, skillful, industrious, blunt, determined, practical, cautious'.
EXECUTE.


****recode variables*************

RENAME VARIABLES (response.trial1 to response.trial7 = ranking_1 ranking_2 ranking_3 ranking_4 ranking_5 ranking_6 ranking_7).
EXECUTE.

IF (ranking_1 = "blunt") rank_blunt = 1.
IF (ranking_2 = "blunt") rank_blunt = 2.
IF (ranking_3 = "blunt") rank_blunt = 3.
IF (ranking_4 = "blunt") rank_blunt = 4.
IF (ranking_5 = "blunt") rank_blunt = 5.
IF (ranking_6 = "blunt") rank_blunt = 6.
IF (ranking_7 = "blunt") rank_blunt = 7.
EXECUTE.

IF (ranking_1 = "cautious") rank_cautious = 1.
IF (ranking_2 = "cautious") rank_cautious = 2.
IF (ranking_3 = "cautious") rank_cautious = 3.
IF (ranking_4 = "cautious") rank_cautious = 4.
IF (ranking_5 = "cautious") rank_cautious = 5.
IF (ranking_6 = "cautious") rank_cautious = 6.
IF (ranking_7 = "cautious") rank_cautious = 7.
EXECUTE.

IF (ranking_1 = "cold") rank_cold = 1.
IF (ranking_2 = "cold") rank_cold = 2.
IF (ranking_3 = "cold") rank_cold = 3.
IF (ranking_4 = "cold") rank_cold = 4.
IF (ranking_5 = "cold") rank_cold = 5.
IF (ranking_6 = "cold") rank_cold = 6.
IF (ranking_7 = "cold") rank_cold = 7.
EXECUTE.
 
IF (ranking_1 = "conscientious") rank_conscientious = 1.
IF (ranking_2 = "conscientious") rank_conscientious = 2.
IF (ranking_3 = "conscientious") rank_conscientious = 3.
IF (ranking_4 = "conscientious") rank_conscientious = 4.
IF (ranking_5 = "conscientious") rank_conscientious = 5.
IF (ranking_6 = "conscientious") rank_conscientious = 6.
IF (ranking_7 = "conscientious") rank_conscientious = 7.
EXECUTE.

IF (ranking_1 = "determined") rank_determined = 1.
IF (ranking_2 = "determined") rank_determined = 2.
IF (ranking_3 = "determined") rank_determined = 3.
IF (ranking_4 = "determined") rank_determined = 4.
IF (ranking_5 = "determined") rank_determined = 5.
IF (ranking_6 = "determined") rank_determined = 6.
IF (ranking_7 = "determined") rank_determined = 7.
EXECUTE.

IF (ranking_1 = "envious") rank_envious = 1.
IF (ranking_2 = "envious") rank_envious = 2.
IF (ranking_3 = "envious") rank_envious = 3.
IF (ranking_4 = "envious") rank_envious = 4.
IF (ranking_5 = "envious") rank_envious = 5.
IF (ranking_6 = "envious") rank_envious = 6.
IF (ranking_7 = "envious") rank_envious = 7.
EXECUTE.

IF (ranking_1 = "helpful") rank_helpful = 1.
IF (ranking_2 = "helpful") rank_helpful = 2.
IF (ranking_3 = "helpful") rank_helpful = 3.
IF (ranking_4 = "helpful") rank_helpful = 4.
IF (ranking_5 = "helpful") rank_helpful = 5.
IF (ranking_6 = "helpful") rank_helpful = 6.
IF (ranking_7 = "helpful") rank_helpful = 7.
EXECUTE.

IF (ranking_1 = "industrious") rank_industrious = 1.
IF (ranking_2 = "industrious") rank_industrious = 2.
IF (ranking_3 = "industrious") rank_industrious = 3.
IF (ranking_4 = "industrious") rank_industrious = 4.
IF (ranking_5 = "industrious") rank_industrious = 5.
IF (ranking_6 = "industrious") rank_industrious = 6.
IF (ranking_7 = "industrious") rank_industrious = 7.
EXECUTE.

IF (ranking_1 = "modest") rank_modest = 1.
IF (ranking_2 = "modest") rank_modest = 2.
IF (ranking_3 = "modest") rank_modest = 3.
IF (ranking_4 = "modest") rank_modest = 4.
IF (ranking_5 = "modest") rank_modest = 5.
IF (ranking_6 = "modest") rank_modest = 6.
IF (ranking_7 = "modest") rank_modest = 7.
EXECUTE.

IF (ranking_1 = "obedient") rank_obedient = 1.
IF (ranking_2 = "obedient") rank_obedient = 2.
IF (ranking_3 = "obedient") rank_obedient = 3.
IF (ranking_4 = "obedient") rank_obedient = 4.
IF (ranking_5 = "obedient") rank_obedient = 5.
IF (ranking_6 = "obedient") rank_obedient = 6.
IF (ranking_7 = "obedient") rank_obedient = 7.
EXECUTE.

IF (ranking_1 = "polite") rank_polite = 1.
IF (ranking_2 = "polite") rank_polite = 2.
IF (ranking_3 = "polite") rank_polite = 3.
IF (ranking_4 = "polite") rank_polite = 4.
IF (ranking_5 = "polite") rank_polite = 5.
IF (ranking_6 = "polite") rank_polite = 6.
IF (ranking_7 = "polite") rank_polite = 7.
EXECUTE.

IF (ranking_1 = "practical") rank_practical = 1.
IF (ranking_2 = "practical") rank_practical = 2.
IF (ranking_3 = "practical") rank_practical = 3.
IF (ranking_4 = "practical") rank_practical = 4.
IF (ranking_5 = "practical") rank_practical = 5.
IF (ranking_6 = "practical") rank_practical = 6.
IF (ranking_7 = "practical") rank_practical = 7.
EXECUTE.

IF (ranking_1 = "shallowC") rank_shallow = 1.
IF (ranking_2 = "shallowC") rank_shallow = 2.
IF (ranking_3 = "shallowC") rank_shallow = 3.
IF (ranking_4 = "shallowC") rank_shallow = 4.
IF (ranking_5 = "shallowC") rank_shallow = 5.
IF (ranking_6 = "shallowC") rank_shallow = 6.
IF (ranking_7 = "shallowC") rank_shallow = 7.
EXECUTE.

IF (ranking_1 = "shallowD") rank_shallow = 1.
IF (ranking_2 = "shallowD") rank_shallow = 2.
IF (ranking_3 = "shallowD") rank_shallow = 3.
IF (ranking_4 = "shallowD") rank_shallow = 4.
IF (ranking_5 = "shallowD") rank_shallow = 5.
IF (ranking_6 = "shallowD") rank_shallow = 6.
IF (ranking_7 = "shallowD") rank_shallow = 7.
EXECUTE.


IF (ranking_1 = "intelligent") rank_intelligent = 1.
IF (ranking_2 = "intelligent") rank_intelligent = 2.
IF (ranking_3 = "intelligent") rank_intelligent = 3.
IF (ranking_4 = "intelligent") rank_intelligent = 4.
IF (ranking_5 = "intelligent") rank_intelligent = 5.
IF (ranking_6 = "intelligent") rank_intelligent = 6.
IF (ranking_7 = "intelligent") rank_intelligent = 7.
EXECUTE.

IF (ranking_1 = "skillful") rank_skillful = 1.
IF (ranking_2 = "skillful") rank_skillful = 2.
IF (ranking_3 = "skillful") rank_skillful = 3.
IF (ranking_4 = "skillful") rank_skillful = 4.
IF (ranking_5 = "skillful") rank_skillful = 5.
IF (ranking_6 = "skillful") rank_skillful = 6.
IF (ranking_7 = "skillful") rank_skillful = 7.
EXECUTE.

IF (ranking_1 = "shrewd") rank_shrewd = 1.
IF (ranking_2 = "shrewd") rank_shrewd = 2.
IF (ranking_3 = "shrewd") rank_shrewd = 3.
IF (ranking_4 = "shrewd") rank_shrewd = 4.
IF (ranking_5 = "shrewd") rank_shrewd = 5.
IF (ranking_6 = "shrewd") rank_shrewd = 6.
IF (ranking_7 = "shrewd") rank_shrewd = 7.
EXECUTE.

IF (ranking_1 = "sincere") rank_sincere = 1.
IF (ranking_2 = "sincere") rank_sincere = 2.
IF (ranking_3 = "sincere") rank_sincere = 3.
IF (ranking_4 = "sincere") rank_sincere = 4.
IF (ranking_5 = "sincere") rank_sincere = 5.
IF (ranking_6 = "sincere") rank_sincere = 6.
IF (ranking_7 = "sincere") rank_sincere = 7.
EXECUTE.

IF (ranking_1 = "unambitious") rank_unambitious = 1.
IF (ranking_2 = "unambitious") rank_unambitious = 2.
IF (ranking_3 = "unambitious") rank_unambitious = 3.
IF (ranking_4 = "unambitious") rank_unambitious = 4.
IF (ranking_5 = "unambitious") rank_unambitious = 5.
IF (ranking_6 = "unambitious") rank_unambitious = 6.
IF (ranking_7 = "unambitious") rank_unambitious = 7.
EXECUTE.

IF (ranking_1 = "unscrupulous") rank_unscrupulous = 1.
IF (ranking_2 = "unscrupulous") rank_unscrupulous = 2.
IF (ranking_3 = "unscrupulous") rank_unscrupulous = 3.
IF (ranking_4 = "unscrupulous") rank_unscrupulous = 4.
IF (ranking_5 = "unscrupulous") rank_unscrupulous = 5.
IF (ranking_6 = "unscrupulous") rank_unscrupulous = 6.
IF (ranking_7 = "unscrupulous") rank_unscrupulous = 7.
EXECUTE.

IF (ranking_1 = "vainC") rank_vain = 1.
IF (ranking_2 = "vainC") rank_vain = 2.
IF (ranking_3 = "vainC") rank_vain = 3.
IF (ranking_4 = "vainC") rank_vain = 4.
IF (ranking_5 = "vainC") rank_vain = 5.
IF (ranking_6 = "vainC") rank_vain = 6.
IF (ranking_7 = "vainC") rank_vain = 7.
EXECUTE.

IF (ranking_1 = "vainD") rank_vain = 1.
IF (ranking_2 = "vainD") rank_vain = 2.
IF (ranking_3 = "vainD") rank_vain = 3.
IF (ranking_4 = "vainD") rank_vain = 4.
IF (ranking_5 = "vainD") rank_vain = 5.
IF (ranking_6 = "vainD") rank_vain = 6.
IF (ranking_7 = "vainD") rank_vain = 7.
EXECUTE.


IF (ranking_1 = "warm") rank_warm = 1.
IF (ranking_2 = "warm") rank_warm = 2.
IF (ranking_3 = "warm") rank_warm = 3.
IF (ranking_4 = "warm") rank_warm = 4.
IF (ranking_5 = "warm") rank_warm = 5.
IF (ranking_6 = "warm") rank_warm = 6.
IF (ranking_7 = "warm") rank_warm = 7.
EXECUTE.

IF (ranking_1 = "weak") rank_weak = 1.
IF (ranking_2 = "weak") rank_weak = 2.
IF (ranking_3 = "weak") rank_weak = 3.
IF (ranking_4 = "weak") rank_weak = 4.
IF (ranking_5 = "weak") rank_weak = 5.
IF (ranking_6 = "weak") rank_weak = 6.
IF (ranking_7 = "weak") rank_weak = 7.
EXECUTE.


********************trait pair ratings**************************

DELETE VARIABLES build.
EXECUTE.

*keep latency to check for potential &*&$%$% who didn't complete the task seriously

RENAME VARIABLES (dishonest_latency = trait_pair_latency).
EXECUTE.

*delete practice run.

SELECT IF subject ~=3.
EXECUTE.


*now, delete the latencies:

DELETE VARIABLES generous_latency shrewd_latency unhappy_latency irritable_latency humorous_latency sociable_latency popular_latency unreliable_latency important_latency ruthless_latency 
goodlooking_latency persistent_latency frivolous_latency restrained_latency selfcentered_latency imaginative_latency strong_latency.
EXECUTE.

RENAME VARIABLES (generous_response shrewd_response unhappy_response irritable_response humorous_response sociable_response popular_response unreliable_response important_response ruthless_response 
goodlooking_response persistent_response frivolous_response restrained_response selfcentered_response imaginative_response strong_response dishonest_response
= TPchoice_generous TPchoice_shrewd TPchoice_unhappy TPchoice_irritable TPchoice_humorous TPchoice_sociable TPchoice_popular TPchoice_unreliable TPchoice_important TPchoice_ruthless 
TPchoice_goodlooking TPchoice_persistent TPchoice_frivolous TPchoice_restrained TPchoice_selfcentered TPchoice_imaginative TPchoice_strong TPchoice_dishonest).
EXECUTE.

VALUE LABELS TPchoice_generous 1 'generous'  0 ' ungenerous'.
VALUE LABELS TPchoice_shrewd 1 'shrewd '  0 'wise '.
VALUE LABELS TPchoice_unhappy 1 'unhappy '  0 'happy '.
VALUE LABELS TPchoice_irritable 1 'irritable '  0 'good-natured'.
VALUE LABELS TPchoice_humorous 1 'humorous '  0 'humorless '.
VALUE LABELS TPchoice_sociable 1 'sociable '  0 'unsociable '.
VALUE LABELS TPchoice_popular 1 'popular '  0 'unpopular'.
VALUE LABELS TPchoice_unreliable 1 'unreliable '  0 'reliable'.
VALUE LABELS TPchoice_important 1 'important '  0 'insignificant '.
VALUE LABELS TPchoice_ruthless 1 'ruthless '  0 'humane'.
VALUE LABELS TPchoice_goodlooking 1 'goodlooking '  0 'unattractive'.
VALUE LABELS TPchoice_persistent 1 'persistent '  0 'unstable'.
VALUE LABELS TPchoice_frivolous 1 'frivolous '  0 'serious'.
VALUE LABELS TPchoice_restrained 1 'restrained '  0 'talkative'.
VALUE LABELS TPchoice_selfcentered 1 'selfcentered '  0 'altruistic'.
VALUE LABELS TPchoice_imaginative 1 'imaginative '  0 'hard-headed '.
VALUE LABELS TPchoice_strong 1 'strong '  0 'weak'.
VALUE LABELS TPchoice_dishonest 1 'dishonest '  0 'honest'.
EXECUTE.


********************demographics**************************

*delete practice run.

SELECT IF subject ~=3.
EXECUTE.

DELETE VARIABLES build.
DELETE VARIABLES ID_latency.
DELETE VARIABLES sex_latency.
DELETE VARIABLES age_latency.
DELETE VARIABLES race_latency.
DELETE VARIABLES native_latency.
DELETE VARIABLES words_latency.
DELETE VARIABLES problems_latency.
DELETE VARIABLES targetsex_latency.
DELETE VARIABLES targetrace_latency.
DELETE VARIABLES best_latency.
DELETE VARIABLES remarks_latency.
DELETE VARIABLES participated_latency.
EXECUTE.

RENAME VARIABLES (ID_response to remarks_response = demo.MTurkID demo.sex demo.age demo.race demo.native demo.problems demo.words demo.best demo.participated demo.targetsex demo.targetrace demo.remarks).
EXECUTE.

VALUE LABELS demo.sex 1 'male' 2 'female'.
VALUE LABELS demo.race 1 'African American' 2 'European American'
3 'Asian American' 4 'Hispanic'  5 'Native American' 6 'mixed race' 7 'other'  8 'Id rather not say'.
VALUE LABELS demo.native 1 'before the age of five' 2 'after the age of five'.
VALUE LABELS demo.problems 1 'no' 2 'yes'.
VARIABLE LABELS demo.problems = 'Did you experience any problems during the experiment (e.g., computer malfunction)?'.  
VALUE LABELS demo.participated 1 'yes' 2 'maybe' 3 'no'. 
VARIABLE LABELS demo.participated 'Have you participated in a HIT from the same requester before?'. 
VALUE LABELS demo.targetrace 1 'African American' 2 'European American'
3 'Asian American' 4 'Hispanic'  5 'Native American' 6 'mixed race' 7 'other'  8 'I dont know'.
VALUE LABELS demo.targetsex 1 'male' 2 'female' 3 'I don t know'.
EXECUTE.

*calculate: do people think of someone of the same or the opposite gender?

IF (demo.sex = 1 & demo.targetsex = 1) demo.samesex = 1.
IF (demo.sex = 2 & demo.targetsex = 2) demo.samesex = 1.
IF (demo.sex = 1 & demo.targetsex = 2) demo.samesex = 0.
IF (demo.sex = 2 & demo.targetsex = 1) demo.samesex = 0.
EXECUTE.

VALUE LABELS demo.samesex 1 'thought of person of the same sex' 2 'thought of person of the opposite sex'.
EXECUTE.

******************check for double pp numbers before merging files*********************


FREQUENCIES VARIABLES=subject
  /ORDER=ANALYSIS.

*I delete all participants that have incomplete data (e.g., filled out just teh first question)-this happens with mTurk data, and most of the time, we just have their pp number and nothing else.
*SPSS has a very difficult time merging so many cases. once it encounters a case that is present in one dataset but not teh other, it will stop importing. SPSS is obviously limited when it comes to dealing with large datasets like this.
*to help it, I delete double cases by hand (57 in total)

SELECT IF subject ~= 323.
SELECT IF subject ~= 356.
SELECT IF subject ~= 420.
SELECT IF subject ~= 453.
SELECT IF subject ~= 512.
SELECT IF subject ~= 660.
SELECT IF subject ~= 885.
SELECT IF subject ~= 893.
SELECT IF subject ~= 1164.
SELECT IF subject ~= 1314.

SELECT IF subject ~= 1368.
SELECT IF subject ~= 1610.
SELECT IF subject ~= 1782.
SELECT IF subject ~= 2143.
SELECT IF subject ~= 2399.
SELECT IF subject ~= 2437.
SELECT IF subject ~= 2755.
SELECT IF subject ~= 19.
SELECT IF subject ~= 42.
SELECT IF subject ~= 44.

SELECT IF subject ~= 112.
SELECT IF subject ~= 265.
SELECT IF subject ~= 323.
SELECT IF subject ~= 346.
SELECT IF subject ~= 365.
SELECT IF subject ~= 370.
SELECT IF subject ~= 411.
SELECT IF subject ~= 421.
SELECT IF subject ~= 492.
SELECT IF subject ~= 502.

SELECT IF subject ~= 627.
SELECT IF subject ~= 678.
SELECT IF subject ~= 872.
SELECT IF subject ~= 892.
SELECT IF subject ~= 925.
SELECT IF subject ~= 1087.
SELECT IF subject ~= 1089.
SELECT IF subject ~= 1098.
SELECT IF subject ~= 1207.
SELECT IF subject ~= 1383.

SELECT IF subject ~= 1464.
SELECT IF subject ~= 1482.
SELECT IF subject ~= 1602.
SELECT IF subject ~= 1790.
SELECT IF subject ~= 1980.
SELECT IF subject ~= 2049.
SELECT IF subject ~= 2143.
SELECT IF subject ~= 2199.
SELECT IF subject ~= 2444.
SELECT IF subject ~= 2452.

SELECT IF subject ~= 2727.
SELECT IF subject ~= 2904.
SELECT IF subject ~= 2513.
SELECT IF subject ~= 2441.
SELECT IF subject ~= 2442.
SELECT IF subject ~= 2448.
SELECT IF subject ~= 2492.
EXECUTE.

***********************************************************************************************************************************
*********************PARTICIPANTS********************************************************************************************
***********************************************************************************************************************************


*check if participants answered the Instructional Manipulation Check correctly.
*get easy cases out automatically. Do rest by hand

IF (response.IMC = "I read the instructions.") IMC_correct = 1.
IF (response.IMC = "I read the instructions") IMC_correct = 1.
IF (response.IMC = "i read the instructions") IMC_correct = 1.
IF (response.IMC = "I read the instructions.") IMC_correct = 1.
IF (response.IMC = "I have read the instructions.") IMC_correct = 1.
IF (response.IMC = "I have read the instructions") IMC_correct = 1.
IF (response.IMC = "I've read the instructions") IMC_correct = 1.
IF (response.IMC = "read the instructions") IMC_correct = 1.
IF (response.IMC = "reading instructions") IMC_correct = 1.
EXECUTE.

*We determined a priori that we would not include anyone who failed the IMC or is not a native speaker, before looking at teh data. So let's do that:

SELECT IF IMC_correct = 1.
SELECT IF demo.native = 1.
EXECUTE.


*1132 people participated in total, 78 (6.9%) failed the IMC (so that's quite ok). Without these people, we have 1054 people.
*We also have 31 non native speakers (2.9%). We indicated in the proposal that we would remove those two groups before commencing analysis. 
*We wanted to have 1050 people and we have 1023, so that seems to be within the right range: 129 to 159 participants per condition.
*age: 18 to 75, mean 33
*474 males (46.3%), 549 females (53.7%)
*European American: 69.1%, African American: 6.8%, Asian 6/9, Hispanic 4.0, native 1.5, mixed 3.9, other 5.5, won't say 2.2%.


***********************************************************************************************************************************
*********************RANKING DATA*******************************************************************************************
***********************************************************************************************************************************



*do pp think of a male or female target?


CROSSTABS
  /TABLES=demo.targetsex BY condition
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.


CROSSTABS
  /TABLES=demo.targetrace BY condition
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.



************ranking*********


*start by looking at the descriptives: 

CROSSTABS
  /TABLES=rank_blunt rank_cautious rank_cold rank_conscientious rank_determined rank_envious 
    rank_helpful rank_industrious rank_modest rank_obedient rank_polite rank_practical rank_shallow 
    rank_intelligent rank_skillful rank_shrewd rank_sincere rank_unambitious 
    rank_unscrupulous rank_vain rank_warm rank_weak BY condition
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT COLUMN 
  /COUNT ROUND CELL.


********Chi square test**********************

*are distributions sign different from a flat distribution?

NPAR TESTS
  /CHISQUARE=rank_blunt rank_cautious rank_cold rank_conscientious rank_determined rank_envious 
    rank_helpful rank_industrious rank_modest rank_obedient rank_polite rank_practical rank_shallow 
    rank_intelligent rank_skillful rank_shrewd rank_sincere rank_unambitious rank_unscrupulous 
    rank_vain rank_warm rank_weak
  /EXPECTED=EQUAL
  /STATISTICS DESCRIPTIVES
  /MISSING ANALYSIS
  /METHOD=MC CIN(99) SAMPLES(10000).


********************Wilcoxon signed rank test**************************

*is there any trait with a significantly higher rank than warmth?

*******************condition 1*******************************************


USE ALL.
COMPUTE filter_$=(condition = 1).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*is intelligence the central trait in condition 1?

*compare: intelligence

NPAR TESTS
  /WILCOXON=rank_intelligent rank_intelligent rank_intelligent rank_intelligent rank_intelligent 
rank_intelligent WITH rank_skillful rank_industrious rank_warm rank_determined 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*yes, it is. It receives a higher rank than any of the other traits.


*compare: warmth

NPAR TESTS
  /WILCOXON=rank_warm rank_warm rank_warm rank_warm rank_warm 
WITH rank_skillful rank_industrious  rank_determined 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*skillful:

NPAR TESTS
  /WILCOXON=rank_skillful rank_skillful rank_skillful rank_skillful rank_skillful 
WITH rank_industrious  rank_determined 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*determined

NPAR TESTS
  /WILCOXON=rank_determined rank_determined  rank_determined  rank_determined 
WITH rank_industrious
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*practical

NPAR TESTS
  /WILCOXON=rank_practical rank_practical rank_practical
WITH rank_industrious
 rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*industrious

NPAR TESTS
  /WILCOXON=rank_cautious
WITH rank_industrious
  (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*******************condition 2*******************************************
*is intelligence the central trait in condition 2?


USE ALL.
COMPUTE filter_$=(condition = 2).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*intelligent:

NPAR TESTS
  /WILCOXON=rank_intelligent rank_intelligent rank_intelligent rank_intelligent rank_intelligent 
rank_intelligent WITH rank_skillful rank_industrious rank_cold rank_determined 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*Yes, intelligence is more central

*determined:

NPAR TESTS
  /WILCOXON=rank_determined  rank_determined  rank_determined  rank_determined  rank_determined 
WITH rank_skillful rank_industrious rank_cold 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*skillful:

NPAR TESTS
  /WILCOXON=rank_skillful   rank_skillful  rank_skillful  rank_skillful 
WITH rank_industrious rank_cold 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*cold

NPAR TESTS
  /WILCOXON=rank_cold rank_cold rank_cold 
WITH rank_industrious 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*industrious

NPAR TESTS
  /WILCOXON=rank_industrious rank_industrious 
WITH rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*practical

NPAR TESTS
  /WILCOXON=rank_practical 
WITH rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*******************condition 3*******************************************

USE ALL.
COMPUTE filter_$=(condition = 3).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*weak

NPAR TESTS
  /WILCOXON=rank_weak rank_weak rank_weak rank_weak rank_weak
 WITH rank_obedient rank_shallow rank_warm rank_unambitious
rank_vain (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*shallow

NPAR TESTS
  /WILCOXON=rank_shallow rank_shallow rank_shallow rank_shallow 
 WITH rank_obedient  rank_warm rank_unambitious
rank_vain (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*unambitious

NPAR TESTS
  /WILCOXON=rank_unambitious rank_unambitious rank_unambitious
 WITH rank_obedient  rank_warm 
rank_vain (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*obedient

NPAR TESTS
  /WILCOXON=rank_obedient rank_obedient  
 WITH rank_warm 
rank_vain (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*******************condition 4*******************************************


USE ALL.
COMPUTE filter_$=(condition = 4).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*vain

NPAR TESTS
  /WILCOXON=rank_vain rank_vain rank_vain rank_vain rank_vain
 WITH rank_shrewd rank_unscrupulous rank_warm rank_shallow
rank_envious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*shallow

NPAR TESTS
  /WILCOXON=rank_shallow rank_shallow rank_shallow rank_shallow
 WITH rank_shrewd rank_unscrupulous rank_warm 
rank_envious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*unscrupulous

NPAR TESTS
  /WILCOXON=rank_unscrupulous rank_unscrupulous rank_unscrupulous
 WITH rank_shrewd rank_warm 
rank_envious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*shrewd

NPAR TESTS
  /WILCOXON=rank_shrewd rank_shrewd
 WITH  rank_warm 
rank_envious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*envious

NPAR TESTS
  /WILCOXON=rank_envious 
 WITH  rank_warm 
(PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).



*******************condition 5*******************************************


USE ALL.
COMPUTE filter_$=(condition = 5).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

NPAR TESTS
  /WILCOXON=rank_intelligent rank_intelligent rank_intelligent rank_intelligent rank_intelligent 
rank_intelligent WITH rank_skillful rank_sincere rank_cold rank_conscientious 
rank_helpful rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*sincere:

NPAR TESTS
  /WILCOXON=rank_sincere rank_sincere rank_sincere rank_sincere rank_sincere 
WITH rank_skillful rank_cold rank_conscientious 
rank_helpful rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*helpful

NPAR TESTS
  /WILCOXON=rank_helpful rank_helpful rank_helpful rank_helpful 
WITH rank_skillful rank_cold rank_conscientious 
rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*skillful

NPAR TESTS
  /WILCOXON=rank_skillful rank_skillful rank_skillful 
WITH rank_cold rank_conscientious 
rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*conscientious

NPAR TESTS
  /WILCOXON= rank_conscientious  rank_conscientious
WITH rank_cold 
rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*cold

NPAR TESTS
  /WILCOXON= rank_cold 
WITH rank_modest (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*******************condition 6*******************************************

USE ALL.
COMPUTE filter_$=(condition = 6).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

NPAR TESTS
  /WILCOXON=rank_intelligent rank_intelligent rank_intelligent rank_intelligent rank_intelligent 
rank_intelligent WITH rank_skillful rank_industrious rank_polite rank_determined
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*polite

NPAR TESTS
  /WILCOXON= rank_polite  rank_polite  rank_polite  rank_polite
WITH rank_skillful rank_industrious rank_determined
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*skillful

NPAR TESTS
  /WILCOXON=  rank_skillful rank_skillful  rank_skillful   rank_skillful
 WITH rank_industrious rank_determined
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*determined

NPAR TESTS
  /WILCOXON= rank_determined rank_determined rank_determined rank_determined
 WITH rank_industrious 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*practical

NPAR TESTS
  /WILCOXON= rank_practical rank_practical 
 WITH rank_industrious 
rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*industrious

NPAR TESTS
  /WILCOXON= rank_industrious 
 WITH rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*******************condition 7*******************************************

USE ALL.
COMPUTE filter_$=(condition = 7).
VARIABLE LABELS filter_$ 'condition = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

NPAR TESTS
  /WILCOXON=rank_intelligent rank_intelligent rank_intelligent rank_intelligent rank_intelligent 
rank_intelligent WITH rank_skillful rank_industrious rank_blunt rank_determined
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*determined


NPAR TESTS
  /WILCOXON=rank_determined rank_determined rank_determined rank_determined
rank_intelligent WITH rank_skillful rank_industrious rank_blunt 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).


*skillful


NPAR TESTS
  /WILCOXON=rank_skillful rank_skillful rank_skillful  rank_skillful 
WITH rank_industrious rank_blunt 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*industrious

NPAR TESTS
  /WILCOXON=rank_industrious rank_industrious rank_industrious  
WITH rank_blunt 
rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

*blunt

NPAR TESTS
  /WILCOXON=rank_blunt rank_blunt  
WITH rank_practical rank_cautious (PAIRED)
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /METHOD= MC CIN(99) SAMPLES(10000).

********************Mann whitney U test**************************

*First: for condition 1 vs 3
*intelligent, skillful, industrious


NPAR TESTS
  /M-W= rank_warm BY condition(1 3)
  /MISSING ANALYSIS.

***********************************************************************************************************************************
*********************TEXTUAL ANALYSES************************************************************************************
***********************************************************************************************************************************

*see Python script for more details 

*check if the number of utterances is similar for all conditions. It is, so its not the case that pp wrote much more in one condition than the other.

MEANS TABLES=nrWords nrLetters BY condition
  /CELLS MEAN COUNT STDDEV.

*valence: calculate the relative positivity of descriptions:

COMPUTE positivity = (nrPos).
COMPUTE negativity = (0-nrNeg).
COMPUTE posMINneg = (positivity+negativity).
EXECUTE.

COMPUTE relative.pos = nrPos/ (nrPos+nrNeg+nrNeu).
EXECUTE.

COMPUTE relative.neg = nrNeg/ (nrPos+nrNeg+nrNeu).
EXECUTE.

COMPUTE total = (nrPos+nrNeg+nrNeu).
EXECUTE.

COMPUTE rel_PosNeg = (nrPos-nrNeg) / (nrPos+nrNeg+nrNeu).
EXECUTE.

*trait_occurences_extended**************************

*this includes counts of the occurence of the specific trait (e.g., intelligent) as well as direct synonyms (e.g., smart).
*we would like to use teh extended one, but also check the nonextended one just to make sure teh results are not depending on the secific synonyms we use
*(as there is always a subjective component to picking synonyms)

*Q1: is warmth more central (mentioned more often) in condition 1 compared to 3 and 4?
*no: it actually goes the other way around!

UNIANOVA warm BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=condition.

*Q2: cold C2 vs C5
*cold is mentioned LESS often in C5 compared to C2!

UNIANOVA cold BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=condition.

*check everything

SPLIT FILE OFF.

GLM envious vain shrewd conscientious cold industrious unambitious skillful obedient blunt sincere 
    unscrupulous shallow weak polite modest warm cautious helpful intelligent practical determined BY 
    condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=DESCRIPTIVE ETASQ OPOWER
  /CRITERIA=ALPHA(.05)
  /DESIGN= condition.


*************

*is intelligence mentioned more than warmth?

SORT CASES  BY condition.
SPLIT FILE SEPARATE BY condition.

GLM intelligent warm
  /WSFACTOR=smart_warm 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(smart_warm) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=smart_warm.

*in C1: no

*coldness in C2:


GLM intelligent cold
  /WSFACTOR=smart_cold 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(smart_cold) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=smart_cold.



GLM nr_warmX nr_determinedX
  /WSFACTOR=warm_determined 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(warm_determined) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=warm_determined.


GLM nr_warmX nr_skillfulX
  /WSFACTOR=warm_skillful 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(warm_skillful) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=warm_skillful.

GLM nr_intelligentX nr_determinedX
  /WSFACTOR=intelligent_determined 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(intelligent_determined) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=intelligent_determined.

GLM nr_intelligentX nr_skillfulX
  /WSFACTOR=intelligent_skillful 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(intelligent_skillful) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=intelligent_skillful.


*C2:


GLM nr_coldX nr_determinedX
  /WSFACTOR=cold_determined 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(cold_determined) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=cold_determined.

GLM nr_intelligentX nr_determinedX
  /WSFACTOR=intelligent_determined 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(intelligent_determined) 
  /PRINT=DESCRIPTIVE 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=intelligent_determined.


*************trait_occurences**************************

*this includes counts of the occurence of the specific trait WITHOUT synonyms.

*Q1: is warmth more central (mentioned more often) in condition 1 compared to 3 and 4?
*Again: it actually goes the other way around!

UNIANOVA warm BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=condition.

*Q2: cold C2 vs C5
*Again: cold is mentioned LESS often in C5 compared to C2!

UNIANOVA cold BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=condition.

*good, the results seem similar regardless of whether we do or do not use synonyms.


***********open responses: change in valence*******************

USE ALL.
COMPUTE filter_$=(condition < 3).
VARIABLE LABELS filter_$ 'condition < 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

UNIANOVA rel_PosNeg BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(condition) COMPARE ADJ(LSD)
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=condition.


***************gender***
*in openended Qs

COMPUTE gender_mentioned = 0.
IF (nrMale > 0) gender_mentioned = 1.
IF (nrFemale > 0) gender_mentioned = 1.
EXECUTE.

*male words mentioned more often than female

GLM nrMale nrFemale
  /WSFACTOR=M_F 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(M_F) 
  /PRINT=DESCRIPTIVE ETASQ OPOWER 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=M_F.


*nr of uncertainties (e.g., probably): highly similar across conditions


UNIANOVA nrUncertain BY Condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(Condition) 
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=Condition.

*nr of contradictions (e.g., but):

UNIANOVA nrContradict BY Condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(Condition) 
  /PRINT=OPOWER ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=Condition.

*************************************roles**********************************************************************


COMPUTE nr_businessroles= (nr_ceo + nr_businesswoman +  nr_boss + nr_manager + nr_professional + nr_employee + nr_businessman + nr_leader).
EXECUTE.

COMPUTE nr_intellectualroles= (nr_professor + nr_doctor + nr_academic +  nr_scientist + nr_engineer).
EXECUTE.

COMPUTE nr_homeroles= (nr_wife +  nr_housewife +  nr_husband).
EXECUTE.

COMPUTE nr_allroles= (nr_businessroles + nr_intellectualroles + nr_homeroles).
EXECUTE.


***********************************************************************************************************************************
*********************TRAIT PAIR CHOICE**************************************************************************************
***********************************************************************************************************************************


*we had the valence and relatedness to warmth/competence rated by a seperate group of participants (on 7 p scales)
*teh values are centered around the mean
*thus, for the question 'how pos/neg is xx', we take the absolute values (ABS) and use these average values.

COMPUTE valence_generous = 2.37.
COMPUTE valence_wise = 2.49.
COMPUTE valence_happy = 2.11.
COMPUTE valence_goodnatured = 2.29.
COMPUTE valence_humorous = 1.89.
COMPUTE valence_sociable = 1.89.
COMPUTE valence_popular = 0.77.
COMPUTE valence_reliable = 2.34.
COMPUTE valence_important = 0.97.
COMPUTE valence_humane = 2.29.
COMPUTE valence_goodlooking = 1.20.
COMPUTE valence_persistent = 1.29.
COMPUTE valence_serious = 1.03.
COMPUTE valence_restrained = 1.06.
COMPUTE valence_altruistic = 1.69.
COMPUTE valence_imaginative = 1.91.
COMPUTE valence_strong = 1.54.
COMPUTE valence_honest = 2.43.
EXECUTE.

*now, we weigh the relative impact of the choice for the positiev response alternative.
*to do do, we should first recode soem options so that for all of them, higher numbers indicate more positive choices.

RECODE TPchoice_shrewd (1=0) (0=1) INTO TPchoice_wise.
RECODE TPchoice_unhappy (1=0) (0=1) INTO TPchoice_happy.
RECODE TPchoice_irritable (1=0) (0=1) INTO TPchoice_goodnatured.
RECODE TPchoice_unreliable (1=0) (0=1) INTO TPchoice_reliable.
RECODE TPchoice_ruthless (1=0) (0=1) INTO TPchoice_humane.
RECODE TPchoice_frivoulous (1=0) (0=1) INTO TPchoice_serious.
RECODE TPchoice_selfcentered (1=0) (0=1) INTO TPchoice_altruistic.
RECODE TPchoice_dishonest (1=0) (0=1) INTO TPchoice_honest.
EXECUTE.


*WARMTH/COMPETENCE

*to account for relatedness to warmth/ competence, we are not interested in how warm/competent the trait is, but on how strongly it is related to warmth/competence.
*thus, for the question 'how warm/competent is someone who is xxx', we take the absolute values (ABS) and use these average absolute values as indicator of warmth/competence realtedness.


COMPUTE competence_generous = 0.54.
COMPUTE competence_wise = 2.20.
COMPUTE competence_happy = 0.66.
COMPUTE competence_goodnatured = 0.60.
COMPUTE competence_humorous = 0.40.
COMPUTE competence_sociable = 0.63.
COMPUTE competence_popular = 0.54.
COMPUTE competence_reliable = 1.97.
COMPUTE competence_important = 0.97.
COMPUTE competence_humane = 0.46.
COMPUTE competence_goodlooking = 0.26.
COMPUTE competence_persistent = 1.40.
COMPUTE competence_serious = 1.26.
COMPUTE competence_restrained = 0.60.
COMPUTE competence_altruistic = 0.54.
COMPUTE competence_imaginative = 1.34.
COMPUTE competence_strong = 1.29.
COMPUTE competence_honest = 1.29.
EXECUTE.


COMPUTE warmth_generous = 2.40.
COMPUTE warmth_wise = 0.54.
COMPUTE warmth_happy = 2.31.
COMPUTE warmth_goodnatured = 2.17.
COMPUTE warmth_humorous = 1.40.
COMPUTE warmth_sociable = 1.94.
COMPUTE warmth_popular = 1.23.
COMPUTE warmth_reliable = 1.14.
COMPUTE warmth_important = 0.46.
COMPUTE warmth_humane = 2.06.
COMPUTE warmth_goodlooking = 0.34.
COMPUTE warmth_persistent = 0.69.
COMPUTE warmth_serious = 0.91.
COMPUTE warmth_restrained = 0.97.
COMPUTE warmth_altruistic = 1.14.
COMPUTE warmth_imaginative = 0.77.
COMPUTE warmth_strong = 0.43.
COMPUTE warmth_honest = 1.37.
EXECUTE.

*isthe  trait warm- or competence related? Do median split just to explore the face validity of our other data analysis approach



COMPUTE warmMINcomp_generous =  warmth_generous - competence_generous.
COMPUTE warmMINcomp_wise =  warmth_wise - competence_wise.
COMPUTE warmMINcomp_happy =  warmth_happy - competence_happy.
COMPUTE warmMINcomp_goodnatured =  warmth_goodnatured - competence_goodnatured.
COMPUTE warmMINcomp_humorous =  warmth_humorous - competence_humorous.
COMPUTE warmMINcomp_sociable =  warmth_sociable - competence_sociable.
COMPUTE warmMINcomp_popular =  warmth_popular - competence_popular.
COMPUTE warmMINcomp_reliable =  warmth_reliable - competence_reliable.
COMPUTE warmMINcomp_important =  warmth_important - competence_important.
COMPUTE warmMINcomp_humane =  warmth_humane - competence_humane.
COMPUTE warmMINcomp_goodlooking =  warmth_goodlooking - competence_goodlooking.
COMPUTE warmMINcomp_persistent =  warmth_persistent - competence_persistent.
COMPUTE warmMINcomp_serious =  warmth_serious - competence_serious.
COMPUTE warmMINcomp_restrained =  warmth_restrained - competence_restrained.
COMPUTE warmMINcomp_altruistic =  warmth_altruistic - competence_altruistic.
COMPUTE warmMINcomp_imaginative =  warmth_imaginative - competence_imaginative.
COMPUTE warmMINcomp_strong =  warmth_strong - competence_strong.
COMPUTE warmMINcomp_honest =  warmth_honest - competence_honest.
EXECUTE.


COMPUTE MEDIAN.warmMINcomp_TPchoice = MEDIAN (warmMINcomp_generous to warmMINcomp_honest).
EXECUTE.

*median: 0.23

*below the median: wise, reliable, important, good-looking, persistent, serious, imaginative, strong, honest
*above the median: generous, happy, good-natured, humorous, sociable, popular, humane, restrained, altruistic
*this all seems sensible.

*****************************study if there are significant differences between conditions****************

*list 1A vs 1B:

USE ALL.
COMPUTE filter_$=(condition < 3).
VARIABLE LABELS filter_$ 'condition < 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


NPAR TESTS
  /M-W= TPchoice_generous TPchoice_wise TPchoice_shrewd TPchoice_unhappy TPchoice_happy 
    TPchoice_irritable TPchoice_humorous TPchoice_sociable TPchoice_popular TPchoice_unreliable 
    TPchoice_important TPchoice_ruthless TPchoice_goodlooking TPchoice_persistent TPchoice_frivolous 
    TPchoice_restrained TPchoice_selfcentered TPchoice_imaginative TPchoice_strong TPchoice_dishonest 
    TPchoice_goodnatured TPchoice_reliable TPchoice_humane TPchoice_altruistic TPchoice_honest BY 
    condition(1 2)
  /STATISTICS=DESCRIPTIVES 
  /MISSING ANALYSIS.

*effect size: r = z/sqrt N (Andy Field)

*N = 289. Sqrt. 289 = 17

*TP_generous = -12.705/sqrt.289 = 0.75
*TP_wise = -7.536/sqrt.289= 0.44
*TP_shrewd = -7.536/sqrt.289= 0.44
*TP_happy: -10.667/sqrt.289= 0.63
*TP_irritable: -13.014/sqrt.289= 0.77
*TP_humorous: -12.47/sqrt.289= 0.73
*TP_sociable:-12.104/sqrt.289= 0.71
*TP_popular: -10.516/sqrt.289= 0.62
*TP_important: -1.447/sqrt.289= 0.09
*TP_humane: -11.281/sqrt.289= 0.66
*TP_goodlooking: -4.972/sqrt.289= 0.29
*TP_persistent: -1.077/sqrt.289= 0.06
*TP_restrained: -5.827/sqrt.289= 0.34
*TP_imaginative: -8.067/sqrt.289= 0.47
*TP_strong: -0.087/sqrt.289= 0.01
*TP_good-natured: -13.014/sqrt.289= 0.77
*TP_reliable: -0.758/sqrt.289= 0.04
*TP_altruistic: -9.707/sqrt.289= 0.57
*TP_honest: -3.937/sqrt.289= 0.23
*TP_serious: -1.150/sqrt.289= 0.07

*****************************


USE ALL.
COMPUTE filter_$=(condition < 3).
VARIABLE LABELS filter_$ 'condition < 3 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*****************Now, do the same for conditiodn 6 and 7 (polite and blunt)*********


NPAR TESTS
  /M-W= TPchoice_generous TPchoice_wise TPchoice_shrewd TPchoice_unhappy TPchoice_happy 
    TPchoice_irritable TPchoice_humorous TPchoice_sociable TPchoice_popular TPchoice_unreliable 
    TPchoice_important TPchoice_ruthless TPchoice_goodlooking TPchoice_persistent TPchoice_frivolous 
    TPchoice_restrained TPchoice_selfcentered TPchoice_imaginative TPchoice_strong TPchoice_dishonest 
    TPchoice_goodnatured TPchoice_reliable TPchoice_humane TPchoice_altruistic TPchoice_honest BY 
    condition(6 7)
  /STATISTICS=DESCRIPTIVES 
  /MISSING ANALYSIS.


*effect size: r = z/sqrt N (Andy Field)

*N = 311. Sqrt. 311 = 17.635

*TP_generous = -5.133/sqrt.311 = 0.29
*TP_wise = -4.478/sqrt.311 = 0.25
*TP_happy: -3.630/sqrt.311 =  0.21
*TP_irritable: -6.822/sqrt.311 =  0.39
*TP_humorous: -4.265/sqrt.311 =  0.24
*TP_sociable:-4.062sqrt.311 = 0.23
*TP_popular: -4.179/sqrt.311 = 0.24
*TP_important: -0.945/sqrt.311 = 0.05
*TP_humane: -5.360/sqrt.311 = 0.30
*TP_goodlooking: -0.840/sqrt.311 = 0.05
*TP_persistent: -0.032/sqrt.311 = 0.00
*TP_restrained: -1.309/sqrt.311 = 0.07
*TP_imaginative: -5.874/sqrt.311 = 0.33
*TP_strong: -1.085/sqrt.311 = 0.06
*TP_good-natured: -6.822/sqrt.311 = 0.39
*TP_reliable: -0.032/sqrt.311 = 0.00
*TP_altruistic: -5.632/sqrt.311 = 0.32
*TP_honest: -0.382/sqrt.311 = 0.02
*TP_serious: -1.150/sqrt.311 = 0.07



***********************************************************************************************************************************
*********************CODING OPEN QUESTIONS*****************************************************************************
***********************************************************************************************************************************

*open Qs were coded by an independent rater unaware of the hypotheses (Bart Meuleman).
*10% was also coded by the first author to establish inter rater reliability

*create var that distinguishes between warmth and cold in ratings:

COMPUTE warmth_plus_cold_coder1 = (warmth_coder1).
EXECUTE.


RECODE warmth_plus_cold_coder1 (3=4) (4=5) (5=6) (6=7) (7=8).
EXECUTE.

IF ((warmth_plus_cold_coder1 = 2) AND (cold_coder1 = "cold")) warmth_plus_cold_coder1 = 3.
EXECUTE.

VALUE LABELS warmth_coder1 1 'not mentioned' 2 'true warmth/coldness' 3 'hidden warmth'
4 'manipulative warmth' 5 'limited warmth'  6 'unresolved' 7 'uncategorized'. 
EXECUTE.

VALUE LABELS warmth_plus_cold_coder1  1 'not mentioned' 2 'true warmth' 3 'true coldness'
4 'hidden warmth' 5 'manipulative warmth' 6 'limited warmth'  7 'unresolved' 8 'uncategorized'. 
EXECUTE.

*inter rater reliability: 1 forunified, .81 for warmth

CORRELATIONS
  /VARIABLES=unified_coder1 warmth_coder1 unified_coder2 warmth_coder2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.


*coding instructions for rater:

*UNIFIED
*1: unified impression: the perceiver mentions multiple traits and characteristics but does more than simply sum them up.  
*The perceiver has a single, consistent view of the target. He ors he doesn't merely repeat the given traits, but forms a 
*rounded impression that refers to characters, situations etcetera that were not directly mentioned in the trait list, but are inferred from it. 
*For example, the perceiver may refer to the target's role (e.g., manager, housewife) or gender. If  a type or role is mentioned, 
*the impression is very likely to be unified. For example " Highly logical, very driven, emotionally unattached.  I would say like a Vulcan." is unified, because the perceiver relates the list of traits to each other with the type.
*In a unified impression, Contradictions will often be resolved, for example by finding an overarching characteristic that explains them 
*(for example: "the person is likely to be an engineer, as he is intelligent but not very social"). 
*In other cases, inconsistencies are more or less resolved by relating them to each other, as in the following example:
* "This person is hard working and good at what he does. He's not very emotional and tends to rely more on logic and reasoning.". In this case, the fact that a person is cold is used as a reason or cause for his competence. 
*2.aggregated impressions: the perceiver mentioned multiple traits or characteristics, but sums them up without trying to find a relationship between them. The impression is not unified, and the perceiver does not try to form an 
Examples:
•	"The person is industrious, determine, skillful and very intelligent." 
•	" The person would be dependable, reliable and really smart."
•	"A very conceited, push over. They let people push them around and are weak."
•	" they are annoying and not a likable person"
*3.simplified impression: the perceiver only mentions a single trait or characteristic. Example: "the person is weak".  
*So, if the perceiver mentions anything else, the impression already isn't simplified anymore: it is aggregated or unified. Thus "This person is a weak entrepreneur" is already 
not simplified because it contains more than a single characteristic. This category is likely to be extremely rare.

*WARMTH
1.	meaning of warmth/coldness
50 responses per condition, ONLY for conditions 1,2,3,4 and 5 (250 in total). 
*Options:
*1.	Not mentioned: warmth/coldness are not mentioned in the description, and neither are related characteristics. 
*For example, the description may only mentions competence-related traits or characteristics while completely ignoring social skills/warmth/likability. 
*2.	True warmth: the person is simply seen as a warm person (e.g., friendly, helpful etc). 
*No reservations are made about the person's warmth (e.g, nothing is said about the person seeming warming but not really being warm, or about the person really being warm but not seeming to be that way). Examples: 
•	"this person is kind-hearted", 
•	"This person is nice", 
•	"He is warm",
•	"He is a bit stand-offish"
*3.	Hidden warmth:  Although the person is actually a warm and friendly person deep-down, he or she may not appear that way on the outside. 
*Thus, there is a distinction between someone's inner and outer characteristics, between what he or she really is like and what he or she looks like to the outside world. Examples: 
•	" This person is a warm hearted person whose actions, however, are seen negatively. He hides his good-naturedness underneath a callous and indifferent facade.", 
•	 "They are determined, but can sometimes be cautious, making them appear cold.", 
•	"They can come across "cold" when you try and engage them in topics that are not similar to what interests them. They can give you lots of details specifically about their specialty.",
•	 "It reminds me of Spock from Star Trek: very intelligent and practical, but straight to the point and doesn't sugar coat telling someone exactly the way things need to be. This may cause others to perceive him as cold."
•	" At times, the person seems cold.". 
*4.	Manipulatively warm: the person is warm in a shallow way: he or she may seem or appear warm, but is not really warm. 
*He or she uses warmth in a calculating or manipulative way, he or she may seem charming but is only nice to people to get something out of it for himself. Or he or she may appear cold even though it's actually quite a nice person. Examples: 
•	"If they express sympathy for someone, it is probably fake and used to take advantage of them", 
•	" This person may seem nice, but she actually doesn't care much about anyone but herself.  While she only cares about outward things she will try and find a way to get what she wants.".
*5.	Limited warmth/coldness: the person can be warm or cold, but only at specific times/with specific people. Thus, the person is described as sometimes being warm, or as being warm only around friends or family. Examples:  
•	" This person is warm at times.",
•	 "They can be warm with their wives (sometimes) and their children but otherwise are jerks.",
•	"I think the person seems to be genuine most of the time and cold occasionally. "
 If inferences are made about why this is the case (e.g., to manipulate others), please put the sentence in that specific category. In this category, the limitations of warmth are mentioned but not necessarily accounted for. 
*6.	Unresolved: warmth/coldness is mentioned in the description, but it is presented as an inconsistency that the perceiver cannot resolve. Examples:
•	"I don't see how this person can be warm", 
•	"yet warm ????"
•	" I do want to know how someone can be vain, envious, and shallow but still be warm.  That doesn't even make sense. ". 








