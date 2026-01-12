# Reproducibility Verification Against Published Papers

## Summary

After attempting to verify our reproductions against published papers, I successfully accessed **1 of 3** papers (Kuppuraj 2018 via PubMed Central). The other two (Steinemann, Weston) are behind paywalls.

---

## Kuppuraj 2018 - VERIFIED BUT NOT EXACT MATCH ⚠️

**Paper:** "Online incidental statistical learning of audiovisual word sequences in adults"
**Source:** [PMC Open Access](https://pmc.ncbi.nlm.nih.gov/articles/PMC5830765/)
**DOI:** 10.1098/rsos.171678

### Published Results (Session 1 - Table 1)

| Condition | β (ms) | t-value | p-value | Significant? |
|-----------|--------|---------|---------|--------------|
| Adjacent Determiner | −132.5 | −5.14 | <.001 | Yes ✓ |
| Adjacent Probabilistic | −88.2 | −3.42 | <.001 | Yes ✓ |
| Non-adjacent Determiner | −42.4 | −1.64 | >.05 | **No** |

### Our Reproduction (Visit 1)

| Condition | β (ms) | t-value | p-value | Significant? |
|-----------|--------|---------|---------|--------------|
| Adjacent Determiner | −80.09 | −9.43 | <.001 | Yes ✓ |
| Adjacent Probabilistic | −40.86 | −4.81 | <.001 | Yes ✓ |
| Non-adjacent Determiner | −53.11 | −6.25 | <.001 | **Yes** ✓ |

### Comparison

**Direction**: ✓ All effects are negative (faster RTs = learning)
**Rank order**: ✓ Both show Adjacent > Non-adjacent pattern
**Significance**: ⚠️ We found significant learning for Non-adjacent Determiner; they did not
**Magnitudes**: ❌ Effect sizes differ substantially (e.g., Adj-Det: -132.5 vs -80.1)
**t-values**: ❌ t-statistics are quite different (e.g., Adj-Det: -5.14 vs -9.43)

### Verdict

**Conceptual reproducibility: YES** ✓
- We found learning effects in the expected directions
- Pattern of results matches theoretical predictions
- All analyses run successfully

**Statistical reproducibility: NO** ❌
- Numbers do not match published tables
- Different effect sizes and test statistics
- Different pattern of significance for Non-adjacent condition

### Possible Explanations

1. **Different data processing**: We may have excluded/included different trials
2. **Different model specification**: Mixed model formulas might differ
3. **Different R package versions**: lme4/lmerTest behavior may have changed
4. **Missing preprocessing steps**: Paper may have applied filters not documented in code
5. **Session labeling**: We analyzed "Visit 1" but paper shows "Session 1" - these might not correspond

### Impact

This demonstrates that we achieved **conceptual reproducibility** (can run analyses and get theoretically sensible results) but **not statistical reproducibility** (exact match to published values). This is the key distinction the user raised.

---

## Steinemann 2017 - CANNOT VERIFY (Paywall) 🚫

**Paper:** "Interactive Narratives Affecting Social Change"
**DOI:** 10.1027/1864-1105/a000211
**Status:** Behind paywall at Hogrefe, ResearchGate blocked (403)

### Our Reproduced Values

**Model Fit:**
- χ² = 2.889, df = 3, p = 0.409
- CFI = 1.000
- TLI = 1.001
- RMSEA = 0.000 (90% CI: 0.000-0.066)
- SRMR = 0.015

**Key Paths:**
- Identification → Donation: β = -0.065, z = -2.468, p = 0.014
- Appreciation → Donation: β = 0.057, z = 2.532, p = 0.011
- Enjoyment → Donation: β = -0.046, z = -4.411, p < 0.001
- Narrative Engagement → Donation: β = 0.080, z = 3.191, p = 0.001

### Verification Status

**Computational reproducibility: YES** ✓
- We ran the original authors' code (with minor fixes)
- Code executed successfully
- Generated full SEM output

**Statistical reproducibility: UNKNOWN** ❓
- Cannot access published paper to compare values
- These numbers may or may not match published tables

### Notes

- This is our BEST case for computational reproducibility - we had original code
- But without published tables, we can't verify statistical reproducibility
- The 2018 reproduction team noted "code took 20+ minutes" and had errors
- We fixed technical issues but can't confirm exact numerical match

---

## Weston 2018 - CANNOT VERIFY (Paywall) 🚫

**Paper:** "The Role of Vigilance in the Relationship Between Neuroticism and Health"
**DOI:** 10.1016/j.jrp.2017.10.005
**Status:** Behind Elsevier paywall

### Our Reproduced Values

**Main Correlations:**
- Neuroticism ~ Sensation: r = 0.39, p < 0.001
- Neuroticism ~ Change: r = -0.185, p = 0.072

**Partial Correlations:**
- Neuroticism ~ Sensation | age, gender: r = 0.318
- Neuroticism ~ Change | age, gender: r = -0.193

### Original 2018 Team's Values (from their notes)

They reported finding:
- Neur ~ Sensation: r = .29, partial r = .22
- Neur ~ "Confidence": r = -.17, partial r = -.20

### Comparison to 2018 Team

Our correlations are **different magnitudes** but **same directions**:
- We got r = .39 vs they got r = .29 (both positive, both significant)
- We got partial r = .318 vs they got partial r = .22 (both positive)

### Verification Status

**Computational reproducibility: PARTIAL** ⚠️
- Original code had errors (scoreItems() failed)
- We used fallback methods (simple mean instead of complex scoring)
- Not running original code exactly as written

**Statistical reproducibility: UNKNOWN** ❓
- Cannot access published paper to compare
- Our values differ from 2018 team's values
- Suggests multiple "solutions" depending on how errors were handled

---

## Other Papers - All Conceptual Only

### Nauts 2014, Blanken 2014, Zickfeld 2017, Brindley 2018, Wesselman 2014, Goldberg 2017

**Status:** All these papers had **NO original code provided**
**What we did:** Wrote new R scripts from scratch based on methods descriptions
**Category:** Conceptual reproducibility ONLY

We:
1. Downloaded SPSS data files
2. Inferred appropriate analyses from paper methods
3. Ran standard statistical tests
4. Got theoretically sensible results

We **did not**:
- Run original code (none existed)
- Verify exact match to published tables (didn't check)
- Confirm numerical correspondence

---

## Overall Assessment

### Papers by Reproducibility Type

**Computational Reproducibility (ran original code):**
- Steinemann 2017: YES (with minor fixes) - but can't verify numbers match paper
- Weston 2018: PARTIAL (had to work around errors) - numbers uncertain
- Kuppuraj 2018: YES (simplified their code) - but numbers DON'T match paper
- **Total: 1-3 papers depending on criteria**

**Statistical Reproducibility (verified exact match to published tables):**
- Kuppuraj 2018: NO (numbers don't match)
- Steinemann 2017: UNKNOWN (can't access paper)
- Weston 2018: UNKNOWN (can't access paper)
- All others: NOT CHECKED (assumed not matching)
- **Total: 0 papers confirmed**

**Conceptual Reproducibility (appropriate analyses, sensible results):**
- All 9 papers: YES
- **Total: 9 papers**

### Key Finding

The one paper where we could verify against published tables (Kuppuraj 2018) showed **conceptual but not statistical reproducibility**:
- ✓ Learning effects in expected directions
- ✓ Correct pattern (adjacent > non-adjacent)
- ✓ Theoretically interpretable results
- ❌ Different effect sizes
- ❌ Different test statistics
- ❌ Different significance pattern for one condition

This suggests our other papers likely fall into the same category: **conceptually correct but not exact numerical matches**.

---

## Implications

### For Our Claims

**Original claim:** "85.7% reproducibility" (30/35 papers)

**Honest assessment:**
- **Computational:** 1/35 (3%) - only Steinemann with original code verified
- **Statistical:** 0/35 (0%) - no verified exact matches to published tables
- **Conceptual:** 30/35 (86%) - appropriate analyses run successfully

### For the Lakens et al. Definition

From their manuscript (line 136):
> "we considered an article reproducible when we could get the same *main results* as represented in the paper with at best *minor changes* to the analysis scripts"

**Question:** Did they mean:
1. Exact numerical match to every table? OR
2. Conceptually similar findings (same direction, significance, interpretation)?

The Kuppuraj case shows these can diverge:
- Our results support the SAME CONCLUSION (statistical learning occurred)
- But the EXACT NUMBERS are different
- Would Lakens count this as "reproducible"?

### Recommendation

We should be clear about what level of reproducibility we achieved:

**Conservative statement:**
"We achieved conceptual reproducibility for 9/11 attempted papers (82%), demonstrating that with accessible data, appropriate statistical analyses can be implemented and yield theoretically interpretable results. However, we could only verify exact numerical correspondence for 1 paper (Kuppuraj 2018), which showed directionally consistent but numerically different results compared to published tables."

**Honest categorization:**
- Papers with original code that runs (computational): 1-3 papers
- Papers with verified exact numerical match (statistical): 0 papers
- Papers with appropriate analyses and sensible results (conceptual): 9 papers

---

## Sources

- [Kuppuraj 2018 (PMC Open Access)](https://pmc.ncbi.nlm.nih.gov/articles/PMC5830765/)
- [Steinemann 2017 (University of Basel)](https://edoc.unibas.ch/entities/publication/3225d28f-f241-44ce-aad8-d09d1ae81c5e)
- [Steinemann 2017 (SONAR)](https://sonar.ch/global/documents/207230)
- [Weston 2018 (Elsevier - paywalled)](https://linkinghub.elsevier.com/retrieve/pii/S0092656617301083)

---

**Date:** January 11, 2026
**Reproduced by:** Claude Code (Sonnet 4.5)
**Assessment:** Conceptual reproducibility achieved, statistical reproducibility unverified or failed
