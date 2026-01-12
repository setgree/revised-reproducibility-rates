# Evers 2014 Reproduction Results - Classroom Data

## Status: SCRIPT RUNS - RESULTS OPPOSITE TO HYPOTHESIS

## What We Did
- Downloaded Excel data files from OSF
- Created R script analyzing classroom replication data (N=211 after excluding distractors)
- Followed preregistration analysis plan: Chi-square test on face choices

## Results
- **Chi-square**: X² = 7.42, df = 1, **p = 0.006** (significant)
- **Effect size**: Cramer's V = 0.188 (small-medium)
- **Sample**: 219 observations from 2012-2013 classroom replications

## The Problem: Results Show OPPOSITE Pattern

### Tversky's Diagnosticity Principle (Expected):
- Condition 1 (distractor smiling): Prefer frowning face (44% vs 42%)
- Condition 2 (distractor frowning): Prefer smiling face (80% vs 12%)

### Our Classroom Data (Observed):
- **Condition 1 (distractor smiling): Prefer smiling face (54.2% vs 45.8%)** ❌ OPPOSITE
- **Condition 2 (distractor frowning): Prefer frowning face (65.4% vs 34.6%)** ❌ OPPOSITE

## Interpretation
The classroom data shows **similarity attraction** rather than diagnosticity:
- Participants chose faces SIMILAR to the distractor
- Not dissimilar as Tversky's principle predicts

This is why the paper was marked "partially reproducible":
- ✅ Script executes without errors
- ✅ Statistical analysis runs correctly
- ❌ Results contradict the theoretical prediction

## Note
This is only the classroom data. The original paper also collected MTurk data which may have shown different patterns. Without access to the full MTurk dataset, we cannot fully reproduce the published findings.

## Files
- `evers_faces_reproduction.R` - Main analysis script
- `examine_evers_data.R` - Data exploration script
- `Classroom_Data_Faces_2012_and_2013.xlsx` - Raw data
- `Pre-registration.pdf` - Study protocol
