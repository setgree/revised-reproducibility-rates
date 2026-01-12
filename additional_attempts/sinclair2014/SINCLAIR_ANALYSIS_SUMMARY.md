# Sinclair 2014 - Reproducibility Analysis

## Paper
Sinclair et al. (2014) - Romeo & Juliet Effect registered replication

## Data Available
- `FinalDelinkedDataSetMTurkRJ_1.sav` - SPSS data (N=396, 475 variables)
- `Codebook_of_Measures_for_RJ_study.pdf`
- `Data_Output_of_T1_v._T2_comparisons.pdf` - Expected t-test results
- `Supplemental_report_on_T1_and_T2_differences_Final.pdf`
- `Registered_Replication_Proposal_RJ_effect_REVISED_5.24.13.pdf`

## Reproduction Status: **NOT REPRODUCIBLE**

### Reason
The available SPSS file contains only the **N=396 participants who completed both Time 1 and Time 2 surveys**. However, the analyses in `Data_Output_T1_T2.pdf` compare:
- N=396 who returned for Time 2
- N=580 who completed Time 1 but did NOT return for Time 2
- Total N=976 Time 1 participants

The supplemental report confirms that 976 participants completed Time 1, but only 396 returned for Time 2.

### What's Missing
The full Time 1 dataset with all 976 participants is NOT available on OSF. Without this, we cannot reproduce the attrition analyses comparing returners vs non-returners on Time 1 demographics and relationship variables.

### Attempted Approach
Created `sinclair_reproduction.R` to reproduce the t-tests, but discovered all 396 rows in the dataset are Time 2 completers (all have non-missing `SCR01_T2` values). No non-returners are present in the data.

### Conclusion
This is similar to Evers 2014 - we have some data and documentation, but critical raw data (full Time 1 sample) is not available for complete computational reproduction.

**Category: Partially reproducible (incomplete data)**
