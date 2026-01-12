****syntax ratingtasks***
*first ratingtask: rate wramth & competence relatedness of traits. Run on MTurk, July 8 2013

*first: delete unneccesary vars

DELETE VARIABLES build.
DELETE VARIABLES pretrialpause to blocktimeout.
DELETE VARIABLES correct.
DELETE VARIABLES inwindow.
DELETE VARIABLES stimulusvpos1 to stimulusonset3.
DELETE VARIABLES stimulusnumber1.
DELETE VARIABLES blockcode.
DELETE VARIABLES blocknum to trialnum.
EXECUTE.

SELECT IF trialcode ~="INF".
SELECT IF trialcode ~="example_warm1".
SELECT IF trialcode ~="example_warm2".
SELECT IF trialcode ~="example_competent1".
SELECT IF trialcode ~="example_competent2".
SELECT IF trialcode ~="end".
EXECUTE.


***********

*oops, envious is measured twice. Remove the second one by hand (there are just 33 pp).


CASESTOVARS					
 /ID = time subject
 /INDEX = stimulusitem1 trialcode
 /GROUPBY = VARIABLE.
EXECUTE.

*SPSS has problems with teh hyphen. Rename hyphened vars

RENAME VARIABLES v1 = response.good_looking.competent1.
RENAME VARIABLES v2 = response.good_looking.warm1.
RENAME VARIABLES v3 = response.good_natured.competent1.
RENAME VARIABLES v4 = response.good_natured.warm1.
RENAME VARIABLES v5 = response.narrow_minded.competent1.
RENAME VARIABLES v6 = response.narrow_minded.warm1.
RENAME VARIABLES v7 = response.straight_forward.competent1.
RENAME VARIABLES v8 = response.straight_forward.warm1.
RENAME VARIABLES v9 = response.warm_hearted.competent1.
RENAME VARIABLES v10 = response.warm_hearted.warm1.
RENAME VARIABLES v11 = response.well_read.competent1.
RENAME VARIABLES v12 = response.well_read.warm1.
RENAME VARIABLES v13 = response.well_spoken.competent1.
RENAME VARIABLES v14 = response.well_spoken.warm1.
EXECUTE.

*calculate maen altency to find potential slackers:

COMPUTE MEAN.latency = MEAN (latency.able.competent1 to latency.withdrawn.warm1).
EXECUTE.

*no extreme latencies, so we can keep everyone in.

*pp were asked to indicate how warm/competent the taregt was on a 7 p scale.
*however, we woudl liek to know how strongly related the trait is to warmth/competence, so we need to recode responses here.
*we recode tehm so taht teh midpoint of teh scale is zero, and deviations from that (pos or neg) receive the same value.



RECODE response.able.competent1 response.able.warm1 response.active.competent1 
    response.active.warm1 response.admirable.competent1 response.admirable.warm1 
    response.aggressive.competent1 response.aggressive.warm1 response.altruistic.competent1 
    response.altruistic.warm1 response.ambitious.competent1 response.ambitious.warm1 
    response.annoying.competent1 response.annoying.warm1 response.antisocial.competent1 
    response.antisocial.warm1 response.anxious.competent1 response.anxious.warm1 
    response.artistic.competent1 response.artistic.warm1 response.average.competent1 
    response.average.warm1 response.blunt.competent1 response.blunt.warm1 response.boring.competent1 
    response.boring.warm1 response.bossy.competent1 response.bossy.warm1 response.bright.competent1 
    response.bright.warm1 response.calm.competent1 response.calm.warm1 response.candid.competent1 
    response.candid.warm1 response.capable.competent1 response.capable.warm1 
    response.careful.competent1 response.careful.warm1 response.cautious.competent1 
    response.cautious.warm1 response.charming.competent1 response.charming.warm1 
    response.clever.competent1 response.clever.warm1 response.cold.competent1 response.cold.warm1 
    response.competent.competent1 response.competent.warm1 response.conceited.competent1 
    response.conceited.warm1 response.confident.competent1 response.confident.warm1 
    response.conscientious.competent1 response.conscientious.warm1 response.conservative.competent1 
    response.conservative.warm1 response.considerate.competent1 response.considerate.warm1 
    response.cordial.competent1 response.cordial.warm1 response.courteous.competent1 
    response.courteous.warm1 response.crafty.competent1 response.crafty.warm1 
    response.creative.competent1 response.creative.warm1 response.critical.competent1 
    response.critical.warm1 response.cruel.competent1 response.cruel.warm1 response.cunning.competent1 
    response.cunning.warm1 response.deceitful.competent1 response.deceitful.warm1 
    response.decent.competent1 response.decent.warm1 response.deceptive.competent1 
    response.deceptive.warm1 response.demanding.competent1 response.demanding.warm1 
    response.dependable.competent1 response.dependable.warm1 response.dependent.competent1 
    response.dependent.warm1 response.depressed.competent1 response.depressed.warm1 
    response.diligent.competent1 response.diligent.warm1 response.direct.competent1 
    response.direct.warm1 response.disciplined.competent1 response.disciplined.warm1 
    response.dull.competent1 response.dull.warm1 response.eager.competent1 response.eager.warm1 
    response.earnest.competent1 response.earnest.warm1 response.educated.competent1 
    response.educated.warm1 response.efficient.competent1 response.efficient.warm1 
    response.egotistical.competent1 response.egotistical.warm1 response.emotional.competent1 
    response.emotional.warm1 response.envious.competent1 response.envious.warm1 
    response.ethical.competent1 response.ethical.warm1 response.experienced.competent1 
    response.experienced.warm1 response.forceful.competent1 response.forceful.warm1 
    response.frank.competent1 response.frank.warm1 response.friendly.competent1 response.friendly.warm1 
    response.generous.competent1 response.generous.warm1 response.good.competent1 response.good.warm1 
    response.good_looking.competent1 response.good_looking.warm1 response.good_natured.competent1 
    response.good_natured.warm1 response.greedy.competent1 response.greedy.warm1 
    response.happy.competent1 response.happy.warm1 response.helpful.competent1 response.helpful.warm1 
    response.hesitant.competent1 response.hesitant.warm1 response.honest.competent1 
    response.honest.warm1 response.honorable.competent1 response.honorable.warm1 
    response.humane.competent1 response.humane.warm1 response.humble.competent1 response.humble.warm1 
    response.humorous.competent1 response.humorous.warm1 response.imaginative.competent1 
    response.imaginative.warm1 response.immature.competent1 response.immature.warm1 
    response.important.competent1 response.important.warm1 response.impulsive.competent1 
    response.impulsive.warm1 response.independent.competent1 response.independent.warm1 
    response.indifferent.competent1 response.indifferent.warm1 response.insecure.competent1 
    response.insecure.warm1 response.insincere.competent1 response.insincere.warm1 
    response.intellectual.competent1 response.intellectual.warm1 response.intelligent.competent1 
    response.intelligent.warm1 response.interesting.competent1 response.interesting.warm1 
    response.inventive.competent1 response.inventive.warm1 response.jealous.competent1 
    response.jealous.warm1 response.kind.competent1 response.kind.warm1 response.lazy.competent1 
    response.lazy.warm1 response.liar.competent1 response.liar.warm1 response.likable.competent1 
    response.likable.warm1 response.logical.competent1 response.logical.warm1 
    response.lonely.competent1 response.lonely.warm1 response.loyal.competent1 response.loyal.warm1 
    response.materialistic.competent1 response.materialistic.warm1 response.mature.competent1 
    response.mature.warm1 response.mean.competent1 response.mean.warm1 response.methodical.competent1 
    response.methodical.warm1 response.meticulous.competent1 response.meticulous.warm1 
    response.moderate.competent1 response.moderate.warm1 response.modest.competent1 
    response.modest.warm1 response.moral.competent1 response.moral.warm1 response.naive.competent1 
    response.naive.warm1 response.narrow_minded.competent1 response.narrow_minded.warm1 
    response.neat.competent1 response.neat.warm1 response.nice.competent1 response.nice.warm1 
    response.normal.competent1 response.normal.warm1 response.obedient.competent1 
    response.obedient.warm1 response.opinionated.competent1 response.opinionated.warm1 
    response.original.competent1 response.original.warm1 response.outgoing.competent1 
    response.outgoing.warm1 response.outstanding.competent1 response.outstanding.warm1 
    response.perceptive.competent1 response.perceptive.warm1 response.perfectionistic.competent1 
    response.perfectionistic.warm1 response.persistent.competent1 response.persistent.warm1 
    response.pleasant.competent1 response.pleasant.warm1 response.polite.competent1 
    response.polite.warm1 response.popular.competent1 response.popular.warm1 
    response.positive.competent1 response.positive.warm1 response.practical.competent1 
    response.practical.warm1 response.precise.competent1 response.precise.warm1 
    response.preoccupied.competent1 response.preoccupied.warm1 response.productive.competent1 
    response.productive.warm1 response.proficient.competent1 response.proficient.warm1 
    response.proud.competent1 response.proud.warm1 response.prudent.competent1 response.prudent.warm1 
    response.quick.competent1 response.quick.warm1 response.quiet.competent1 response.quiet.warm1 
    response.rational.competent1 response.rational.warm1 response.realistic.competent1 
    response.realistic.warm1 response.reasonable.competent1 response.reasonable.warm1 
    response.reliable.competent1 response.reliable.warm1 response.reserved.competent1 
    response.reserved.warm1 response.resourceful.competent1 response.resourceful.warm1 
    response.respectable.competent1 response.respectable.warm1 response.respectful.competent1 
    response.respectful.warm1 response.responsible.competent1 response.responsible.warm1 
    response.restrained.competent1 response.restrained.warm1 response.righteous.competent1 
    response.righteous.warm1 response.romantic.competent1 response.romantic.warm1 
    response.rude.competent1 response.rude.warm1 response.sarcastic.competent1 response.sarcastic.warm1 
    response.scientific.competent1 response.scientific.warm1 response.selfish.competent1 
    response.selfish.warm1 response.sensible.competent1 response.sensible.warm1 
    response.sentimental.competent1 response.sentimental.warm1 response.serious.competent1 
    response.serious.warm1 response.shallow.competent1 response.shallow.warm1 
    response.shrewd.competent1 response.shrewd.warm1 response.shy.competent1 response.shy.warm1 
    response.silent.competent1 response.silent.warm1 response.sincere.competent1 response.sincere.warm1 
    response.skilled.competent1 response.skilled.warm1 response.skillful.competent1 
    response.skillful.warm1 response.smart.competent1 response.smart.warm1 response.snobbish.competent1 
    response.snobbish.warm1 response.sociable.competent1 response.sociable.warm1 
    response.social.competent1 response.social.warm1 response.stern.competent1 response.stern.warm1 
    response.stimulusitem1.trialcode response.straight_forward.competent1 
    response.straight_forward.warm1 response.strong.competent1 response.strong.warm1 
    response.stubborn.competent1 response.stubborn.warm1 response.studious.competent1 
    response.studious.warm1 response.suave.competent1 response.suave.warm1 
    response.submissive.competent1 response.submissive.warm1 response.superficial.competent1 
    response.superficial.warm1 response.sympathetic.competent1 response.sympathetic.warm1 
    response.talented.competent1 response.talented.warm1 response.thorough.competent1 
    response.thorough.warm1 response.thoughtful.competent1 response.thoughtful.warm1 
    response.timid.competent1 response.timid.warm1 response.trusting.competent1 response.trusting.warm1 
    response.trustworthy.competent1 response.trustworthy.warm1 response.truthful.competent1 
    response.truthful.warm1 response.unemotional.competent1 response.unemotional.warm1 
    response.unfriendly.competent1 response.unfriendly.warm1 response.unhappy.competent1 
    response.unhappy.warm1 response.unintelligent.competent1 response.unintelligent.warm1 
    response.unkind.competent1 response.unkind.warm1 response.unpleasant.competent1 
    response.unpleasant.warm1 response.untrustworthy.competent1 response.untrustworthy.warm1 
    response.vain.competent1 response.vain.warm1 response.warm.competent1 response.warm.warm1 
    response.warm_hearted.competent1 response.warm_hearted.warm1 response.weak.competent1 
    response.weak.warm1 response.well_read.competent1 response.well_read.warm1 
    response.well_spoken.competent1 response.well_spoken.warm1 response.wise.competent1 
    response.wise.warm1 response.withdrawn.competent1 response.withdrawn.warm1 (1=3) (2=2) (3=1) (4=0) (5=1) (6=2) (7=3).
EXECUTE.

DESCRIPTIVES VARIABLES=
response.generous.competent1 response.generous.warm1
response.wise.competent1 response.wise.warm1
response.happy.competent1 response.happy.warm1
response.good_natured.competent1 response.good_natured.warm1
response.humorous.competent1 response.humorous.warm1
response.sociable.competent1 response.sociable.warm1
response.popular.competent1 response.popular.warm1
response.reliable.competent1 response.reliable.warm1
response.important.competent1 response.important.warm1
response.humane.competent1 response.humane.warm1
response.good_looking.competent1 response.good_looking.warm1
response.persistent.competent1 response.persistent.warm1
response.serious.competent1 response.serious.warm1
response.restrained.competent1 response.restrained.warm1
response.altruistic.competent1 response.altruistic.warm1
response.imaginative.competent1 response.imaginative.warm1
response.strong.competent1 response.strong.warm1
response.honest.competent1 response.honest.warm1
  /STATISTICS=MEAN.


*second ratingtask: valence of traits. Run on MTurk, July 9 2013

*first: delete unneccesary vars

DELETE VARIABLES build.
DELETE VARIABLES pretrialpause to blocktimeout.
DELETE VARIABLES correct.
DELETE VARIABLES inwindow.
DELETE VARIABLES stimulusvpos1 to stimulusonset3.
DELETE VARIABLES stimulusnumber1.
DELETE VARIABLES blockcode.
DELETE VARIABLES blocknum to trialnum.
EXECUTE.

SELECT IF trialcode ~="INF".
SELECT IF trialcode ~="end".
EXECUTE.

*transpose data to get means in Python

COMPUTE MEAN = MEAN (var001 to var035).
EXECUTE.



***********

CASESTOVARS					
 /ID = time subject
 /INDEX = trialcode stimulusitem1 
 /GROUPBY = VARIABLE.
EXECUTE.

*pp 2 was a testrun-delete 

*SPSS has problems with the hyphen. Rename hyphened vars

RENAME VARIABLES v1 = response.valence.good_looking.
RENAME VARIABLES v2 = response.valence.good_natured.

*recode valence so that direction does not matter

RECODE response.valence.altruistic response.valence.generous response.valence.good_looking 
    response.valence.good_natured response.valence.happy response.valence.honest 
    response.valence.humane response.valence.humorous response.valence.imaginative 
    response.valence.important response.valence.persistent response.valence.popular 
    response.valence.reliable response.valence.restrained response.valence.serious 
    response.valence.sociable response.valence.strong response.valence.wise (1=3) (2=2) (3=1) (4=0) 
    (5=1) (6=2) (7=3).
EXECUTE.


DESCRIPTIVES VARIABLES=response.valence.altruistic response.valence.generous 
    response.valence.good_looking response.valence.good_natured response.valence.happy 
    response.valence.honest response.valence.humane response.valence.humorous 
    response.valence.imaginative response.valence.important response.valence.persistent 
    response.valence.popular response.valence.reliable response.valence.restrained 
    response.valence.serious response.valence.sociable response.valence.strong response.valence.wise
  /STATISTICS=MEAN.


