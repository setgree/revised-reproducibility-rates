# Evers 2014 - Complete Analysis Summary

## What I Reproduced

**Classroom Faces Data (2012-2013)**
- N = 211 (after excluding 8 distractor choices)
- Chi-square: X² = 7.42, **p = 0.006** (significant)
- Cramer's V = 0.188 (small-medium effect)

## The Results

### Tversky's (1977) Predictions:
When distractor is **smiling** (p):
- Should choose **frowning** face (b) as similar to neutral: 44%
- Should choose smiling face (c): 42%

When distractor is **frowning** (q):
- Should choose **smiling** face (c) as similar to neutral: 80%
- Should choose frowning face (b): 12%

### Classroom Data Results:
When distractor is **smiling** (p):
- Chose frowning (b): 42.6%
- Chose smiling (c): **50.4%** ← **OPPOSITE**

When distractor is **frowning** (q):
- Chose frowning (b): **65.4%** ← **OPPOSITE**
- Chose smiling (c): 34.6%

## Why "Partially Reproducible"?

1. ✅ **Script runs successfully**
2. ✅ **Statistical test executes correctly**
3. ✅ **Significant effect found** (p = 0.006)
4. ❌ **Effect is in the OPPOSITE direction**

Instead of showing Tversky's **diagnosticity principle** (pick dissimilar), the classroom data shows **similarity attraction** (pick similar to distractor).

## What's Available vs What's Missing

**Available:**
- ✅ Classroom faces data (N=219): `Classroom_Data_Faces_2012_and_2013.xlsx`
- ✅ Summary statistics in `ALL_DATA.xlsx` (rows 90-95)
- ✅ Countries experiment data (separate study)

**Missing:**
- ❌ MTurk faces raw trial-level data
- ❌ Only summary statistics for MTurk shown (row 95 indicates N and proportions)
- ❌ Analysis code for the full study

**MTurk Summary Data Found:**
In `ALL_DATA.xlsx` row 95, there are aggregate statistics for MTurk faces data showing different effect sizes than classroom data, but no raw trial data to reproduce analyses.

## Interpretation

The classroom replication **failed** to replicate Tversky's diagnosticity principle. This is likely why:
1. The paper was marked "partially reproducible"
2. The script runs but doesn't match the theoretical prediction
3. The published paper may have relied on MTurk data which showed the predicted effect

## Files Created

- `evers_faces_reproduction.R` - Main analysis script
- `examine_evers_data.R` - Data exploration
- `RESULTS_SUMMARY.md` - Initial results summary
- `EVERS_ANALYSIS_SUMMARY.md` - This comprehensive summary

## Conclusion

**Status: Script Runs, Results Contradict Hypothesis**

This is a textbook example of "computational reproducibility" (code runs) without "empirical reproducibility" (results replicate). The classroom data clearly contradicts Tversky's principle, showing similarity attraction instead of diagnosticity.
