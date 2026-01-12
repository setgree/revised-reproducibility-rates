# load needed libraries ######################################################

import string, copy, random
import numpy as np

# open and prepare data ######################################################

#import data, omitting header line
D = open('2013-07-02 0941 Asch_for_Python.dat', 'r').readlines()[1:]

#break data into columns
D = [x.strip().split('\t') for x in D]

### remove punctuations and make lowercase ###

#copy data to create version without punctuation
Dnp = copy.deepcopy(D)

#make punctuation set
punct_set = set(string.punctuation)

for l in Dnp:
    
    #remove punctuation characters and make lowercase
    l[2] = ''.join(x for x in l[2].lower() if x not in punct_set)
    
# import subjectivity index data #############################################

#import subjectivity index data
tmp = open('subjectivity_index.csv', 'r').readlines()

#empty dict for keeping the subjectiviy index data
SI = dict()

for l in tmp:
    
    #get the word and valence from the 3rd and 5th column
    word = l.rstrip().split(',')[2].split('=')[1]
    val = l.rstrip().split(',')[5].split('=')[1]
    
    #add data to dict
    SI[word] = val

# import anderson trait list #################################################

#import trait list data (ignore header line)
tmp = open('Anderson_traitlist.csv', 'r').readlines()[1:]

#empty dict for keeping the anderson data
ATL = dict()

for l in tmp:
    
    #get the word and value from the columns
    word = l.rstrip().split(',')[0].replace('-', '')
    val = l.rstrip().split(',')[1]
    
    #add data to dict
    ATL[word] = [val]

#import ratings for trait list words (ignore header line)
tmp = open('traits_comp_warm.csv', 'r').readlines()[1:]

for l in tmp:
    
    #split line content
    lc = l.rstrip().split(',')
    
    #add rating data to anderson word list
    ATL[lc[0].replace('-','')].extend(lc[1:])

#header and format string for output file
header = 'Subject,Condition'
fstr = '%s,%s'

#result container
Res = []

# make list of trait matching words ##########################################

trait_match = {
    'industrious' : ['industriousness','industrious'],
    'cautious' : ['cautiousness','cautious-','cautious'],
    'vain' : ['vain','vainess'],
    'envious' : ['envious','enviousness'],
    'unscrupulous' : ['unscrupulous'],
    'unambitious' : ['unambitious'],
    'helpful' : ['helpful','helping','helps'],
    'intelligent' : ['intellect','intellgient','intellectual',
        'intelligently','intelligence','intellingent','intelligent',
        'intellegent'],
    'shallow': ['shallowness','shallower','shallow'],
    'weak' : ['weak','weak-willed'],
    'shrewd' : ['shrewd','shrewdness'],
    'polite' : ['polite'],
    'practical' : ['practical','practically'],
    'modest' : ['modesty','modest'],
    'warm' : ['warm','warms','warmth','warm-hearted','warmness'],
    'determined' : ['determine','determind','determined','determination'],
    'skillful' : ['skills','skilled','skillset','skillfull','skillful',
        'skill'],
    'blunt' : ['blunt','bluntness'],
    'cold' : ['coldness','cold','coldly'],
    'sincere' : ['sincere'],
    'obedient' : ['obedient'],
    'conscientious' : ['conscientious','conscientiously']}

trait_match_extended = {
    'industrious' : ['industriousness','industrious'],
    'cautious' : ['cautiousness','cautious-','cautious','wary'],
    'vain' : ['vain','vainess','swollen-headed'],
    'envious' : ['envious','enviousness','jealous','jealousy','resentful',
        'resent'],
    'unscrupulous' : ['unscrupulous','conscienceless','exploitative',
        'machiavellian'],
    'unambitious' : ['unambitious'],
    'helpful' : ['helpful','helping','helps'],
    'intelligent' : ['intellect','intellgient','intellectual',
        'intelligently','intelligence','intellingent','intelligent',
            'intellegent','bright','brilliant','clever','quick-witted',
            'sharp','smart'],
    'shallow' : ['shallowness','shallower','shallow','superficial',
        'superficially'],
    'weak' : ['weak','weak-willed','feebly','feebly','frail','limp',
        'spineless'],
    'shrewd' : ['shrewd','shrewdness','foxy','sly'],
    'polite' : ['polite','mannerly','civilized','gallant','curteous'],
    'practical' : ['practical','practically','handy','pragmatic',
        'pragmatically','pragmatical'],
    'modest' : ['modesty','modest','humble','self-effacing'],
    'warm' : ['warm','warms','warmth','warm-hearted','warmness','friendly',
        'kind','nice','kindly','pleasant','sympathetic'],
    'determined' : ['determine','determind','determined','determination',
        'driven','intent','resolute'],
    'skillful' : ['skills','skilled','skillset','skillfull','skillful',
        'skill','adept'],
    'blunt' : ['blunt','bluntness','impolite','rude','direct'],
    'cold' : ['coldness','cold','coldly','reserved','unfriendly',
        'unsympathetic'],
    'sincere' : ['sincere','honest','earnest','straightforward'],
    'obedient' : ['obedient','submissive','obliging','oblige','subservient',
        'sheeplike','yield','yielding','law-abiding'],
    'conscientious' : ['conscientious','meticulous','conscientiously']}

# uncertainty markers ########################################################

uncertain = ['probably','seems','maybe','perhaps','possibly','sometimes',
    'appear','somewhat','quite','mostly','generally']

# contradiction markers ######################################################

contradict = ['but','though','although','altough']

# gender markers #############################################################

gender = {
    'male' : ['he','his','male','man','guy','guys','men','males','boy','boys'],
    'female' : ['she','her','female','woman','girl','girls','women','females']}

# roles ######################################################################

roles = {'businessman','businesswoman','leader','ceo','engineer','boss',
    'manager','professor','scientist','professional','housewife','employee',
    'doctor','academic','wife','husband'}

# count number of words for each participant #################################

#get number of words
Res.append([len(x[2].split(' ')) for x in Dnp])

#extend header and format string
header += ',nrWords'
fstr += ',%d'

# count number of letters for each participant ###############################

#make punctuation set
white_set = set(string.whitespace)

#empty list for letter count
LC = []

for l in Dnp:
    
    #remove punctuation characters and count letters
    LC.append(len(''.join(x for x in l[2] if x not in white_set)))

#add number of letters to results
Res.append(LC)

#extend header and format string
header += ',nrLetters'
fstr += ',%d'

# count valence frequencies for each participant #############################

#empty lists for valence counts
ValPos,ValNeg,ValNeu,ValNone = [],[],[],[]

for l in Dnp:
    
    #start counters
    vpos,vneg,vneu,vnone = 0,0,0,0
    
    for w in l[2].split(' '):
        
        #check, if current word is in list and count according to valence
        if SI.has_key(w):
            if SI[w] == 'positive':
                vpos += 1
            elif SI[w] == 'negative':
                vneg += 1
            elif SI[w] == 'neutral':
                vneu += 1
        else:
            vnone += 1
    
    #append final counts to lists
    ValPos.append(vpos)
    ValNeg.append(vneg)
    ValNeu.append(vneu)
    ValNone.append(vnone)

#add valence counts to result
Res.extend([ValPos,ValNeg,ValNeu,ValNone])

#extend header and format string
header += ',ValNrPos,ValNrNeg,ValNrNeu,ValNone'
fstr += ',%d,%d,%d,%d'

# calculate average anderson-trait values ####################################

#empty list for trait averages and warmth-competence relatedness
AT,WCrel = [],[]

for l in Dnp:
    
    #empty array for values of found trait words
    avg,avg_wc = np.array([]),np.array([])
    
    #find whether word is in list and store likability
    for w in l[2].split(' '):
        if ATL.has_key(w):
            avg = np.append(avg, int(ATL[w][0]))
            
            if len(ATL[w]) > 1:
                avg_wc = np.append(avg_wc, float(ATL[w][3]))
    
    if len(avg) > 0:
        #append average of likability values
        AT.append(np.mean(avg))
    else:
        #append nan, no trait found
        AT.append(np.nan)
    
    if len(avg_wc) > 0:
        #append average of warmth-competence relatedness differences
        WCrel.append(np.mean(avg_wc))
    else:
        #append nan, no trait found
        WCrel.append(np.nan)

#append average likability and warmth-competence relatedness to results
Res.append(AT)
Res.append(WCrel)

#extend header and format string
header += ',avgLik,avgWCRel'
fstr += ',%.2f,%.2f'

# count occurences of trait-matching words ###################################

#make dict of empty result lists
TM = {k:[] for k in trait_match.keys()}

for l in D:
    
    #make dictionary with trait keys and zero counts
    tm_count = {k:0 for k in trait_match.keys()}
    
    #count whether words match any in the trait-match list
    for w in l[2].split(' '):
        for k in trait_match.keys():
            if w in trait_match[k]:
                tm_count[k] += 1
    
    #append final counts to lists
    for k in trait_match.keys():
        TM[k].append(tm_count[k])

#add trait-match counts to results
for k in trait_match.keys():
    Res.append(TM[k])

#extend header and format string
for k in trait_match.keys():
    header += ',nr_%s' % k
    fstr += ',%d'

# count occurences of trait-matching words, extended #########################

#make dict of empty result lists
TM = {k:[] for k in trait_match.keys()}

for l in D:
    
    #make dictionary with trait keys and zero counts
    tm_count = {k:0 for k in trait_match.keys()}
    
    #count whether words match any in the trait-match list
    for w in l[2].split(' '):
        for k in trait_match.keys():
            if w in trait_match_extended[k]:
                tm_count[k] += 1
    
    #append final counts to lists
    for k in trait_match.keys():
        TM[k].append(tm_count[k])

#add trait-match counts to results
for k in trait_match.keys():
    Res.append(TM[k])

#extend header and format string
for k in trait_match.keys():
    header += ',nr_%sX' % k
    fstr += ',%d'

# count uncertainty markers ##################################################

#make list for uncertainty count
UC = []

#count appearance of uncertainty markers in sentences
for l in Dnp:
    UC.append(len([x for x in l[2].split(' ') if x in uncertain]))

#add uncertainty count to results
Res.append(UC)

#extend header and format string
header += ',nrUncertain'
fstr += ',%d'

# count contradiction markers ################################################

#make list for contradiction counts
CON = []

#count appearance of contradictions in sentences
for l in Dnp:
    CON.append(len([x for x in l[2].split(' ') if x in contradict]))

#add contradiction count to results
Res.append(CON)

#extend header and format string
header += ',nrContradict'
fstr += ',%d'

# count gender markers #######################################################

#make dictionary for gender counts
GC = {k:[] for k in gender.keys()}

#count occurence of gender words in sentences
for l in Dnp:
    for k in gender.keys():
        GC[k].append(len([x for x in l[2].split(' ') if x in gender[k]]))

#append gender counts to results
Res.append(GC['male'])
Res.append(GC['female'])

#extend header and format string
header += ',nrMale,nrFemale'
fstr += ',%d,%d'

# count roles ################################################################

# TODO not finished yet

#make empty list for role counts
RO = {r:[] for r in roles}

#count occurence of role words in sentences
for l in Dnp:
    for k in RO.keys():
        RO[k].append(len([x for x in l[2].split(' ') if x == k]))

#append gender counts to results
for k in RO.keys():
    Res.append(RO[k])

#extend header and format string
for k in RO.keys():
    header += ',nr_%s' % (k)
    fstr += ',%d'

# write results to output file ###############################################

#extract just subject info
Sinfo = [x[0:2] for x in D]

#open output file
O = open('Results_textual_analysis.csv', 'w')

#write header
O.write(header + '\n')

for l in zip(Sinfo,*Res):
    
    #generate list of data for current subject
    tmp = tuple(list(l)[0] + list(l)[1:])
    
    #write data to file
    O.write(fstr % (tmp))
    O.write('\n')

#close output file
O.close()

# randomly choose responses to be rated ######################################

#set seed to reproduce our choice of rated items
random.seed(5361)

#empty lists for randomly chosen to-be-rated exemplars
training_set,rating_set = [],[]

#get conditions in set
cond =  np.unique(np.array([int(x[1]) for x in D]))

for c in cond:
    
    #get sublist of current condition data
    tmp = [x for x in D if int(x[1]) == c]
    
    #random shuffle sublist
    random.shuffle(tmp)
    
    for nr in range(5):
        #get training stimuli from end of list
        training_set.append(tmp.pop())
    
    for nr in range(50):
        #get actual to-be-rated stimuli from end of list
        rating_set.append(copy.copy(tmp.pop()))

for l in rating_set:
    #add default rater info to rating set list
    l.append('single')

for c in cond:
    
    #get sublist of current condition data
    tmp = [x for x in rating_set if int(x[1]) == c]
    
    #random shuffle sublist
    random.shuffle(tmp)
    
    for nr in range(5):
        #add dual rater info to random items
        tmp[nr][3] = 'dual'

#open file for training set
O = open('Training_set.dat', 'w')

#write header
O.write('subject\tcondition\tresponse.open\n')

for l in training_set:
    #write data
    O.write('%s\t%s\t%s\n' % tuple(l))

#close training set file
O.close()

#open file for rating set
O = open('Rating_set.dat', 'w')

#write header
O.write('subject\tcondition\tresponse.open\trater\n')

for l in rating_set:
    #write data
    O.write('%s\t%s\t%s\t%s\n' % tuple(l))

#close rating set file
O.close()
