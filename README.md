# Reproducing Registered Reports in 2026: Infrastructure Modernization with AI Tools

**A follow-up to Lakens et al. (2018): "Analysis of Open Data and Computational Reproducibility in Registered Reports in Psychology"**

**Authors:** Seth Ariel Green (with Claude Code Sonnet 4.5)

**Date:** January 2026

**Status:** Work in progress - verification against published papers ongoing

---

## Summary

In 2018, Lakens, Obels, Coles, Gottfried, & Green [attempted to computationally reproduce](https://journals.sagepub.com/doi/full/10.1177/2515245920918872) 62 Registered Reports in psychology. They successfully reproduced 21/36 papers (58%) that shared both data and code.

In January 2026, we revisited papers that failed in 2018 to test whether modern tools—particularly AI coding assistants and updated R packages—could overcome the barriers that blocked reproduction eight years ago.

**Main finding:** Modern tools eliminate **infrastructure barriers** (package installation, SPSS conversion, file path issues) but verification against published results tables reveals **conceptual reproducibility** (appropriate analyses → sensible results) does not guarantee **statistical reproducibility** (exact numerical match).

---

## Three Types of Reproducibility

This project revealed the importance of distinguishing:

### 1. Computational Reproducibility
**Definition:** Running original author code on original data reproduces exact output

**Result:** 1-3 papers (depending on criteria)
- Steinemann 2017: ✓ Original code runs (with minor path/package fixes)
- Weston 2018: ⚠️ Partial (workarounds needed for errors)
- Kuppuraj 2018: ⚠️ Simplified original code

### 2. Statistical Reproducibility
**Definition:** Independent implementation based on methods matches published tables exactly

**Result:** 0 papers verified
- Kuppuraj 2018: Checked against published tables → numbers differ substantially
- Others: Not verified (paywalled papers or not attempted)

### 3. Conceptual Reproducibility
**Definition:** Standard analyses based on study design yield theoretically interpretable results

**Result:** 9/11 papers with accessible data (82%)
- All produce sensible effect directions
- All yield publishable-quality analyses
- None verified against published exact values

---

## What Modern Tools Solved

### Infrastructure Barriers (100% success rate)

1. **SPSS format no longer a barrier**
   - R's `haven` package reads .sav files perfectly
   - Variable labels and values preserved
   - 6/6 SPSS papers successfully converted

2. **Package installation automated**
   - No more "package not found" errors
   - Modern dependency resolution works
   - Package version management improved

3. **File path issues trivial**
   - Relative paths easy to fix
   - Folder structure quickly reorganized
   - No more hardcoded Windows paths breaking Mac/Linux

4. **Code organization simplified**
   - Complex scripts condensed (e.g., 500 → 150 lines)
   - Essential analyses identified
   - Exploratory vs confirmatory separated

### Papers "Upgraded" from 2018

| Paper | 2018 Status | 2026 Status | What Changed |
|-------|-------------|-------------|--------------|
| Steinemann 2017 | Failed (package errors) | Computational ✓ | Auto package install, path fixes |
| Weston 2018 | Failed (scoreItems error) | Conceptual ⚠️ | Fallback scoring method |
| Kuppuraj 2018 | Failed (gave up, 45min) | Conceptual ✓ | API download, code simplification |
| Nauts 2014 | Never attempted (SPSS) | Conceptual ✓ | haven conversion |
| Blanken 2014 | Never attempted (SPSS) | Conceptual ✓ | haven conversion |
| Zickfeld 2017 | Never attempted (SPSS) | Conceptual ✓ | haven conversion, lmer |
| Brindley 2018 | Never attempted (SPSS) | Conceptual ✓ | haven conversion |
| Wesselman 2014 | Never attempted (SPSS) | Conceptual ✓ | haven conversion |
| Goldberg 2017 | Never attempted | Conceptual ✓ | CSV format, standard ANOVA |

---

## Critical Finding: Kuppuraj 2018 Verification

Kuppuraj et al. (2018) was published open access, allowing us to verify our reproduction against [published Table 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC5830765/).

**Published Results (Session 1):**
- Adjacent Determiner: β = −132.5ms, t = −5.14, p < .001
- Adjacent Probabilistic: β = −88.2ms, t = −3.42, p < .001
- Non-adjacent Determiner: β = −42.4ms, t = −1.64, p > .05 (not significant)

**Our Reproduction (Visit 1):**
- Adjacent Determiner: β = −80.09ms, t = −9.43, p < .001
- Adjacent Probabilistic: β = −40.86ms, t = −4.81, p < .001
- Non-adjacent Determiner: β = −53.11ms, t = −6.25, p < .001 **(significant!)**

**Interpretation:**
- ✓ Same theoretical conclusion (statistical learning occurred)
- ✓ All effects in expected direction (negative/faster)
- ✓ Appropriate statistical model (mixed effects)
- ❌ Effect sizes differ substantially (not rounding errors)
- ❌ Different significance pattern for one condition

This demonstrates **conceptual but not statistical reproducibility**.

---

## What Remains Unchanged: Access Barriers

Modern tools cannot solve:

- **Dead links** (404 errors from OSF repositories)
- **Empty repositories** (OSF link exists, no files uploaded)
- **Access restrictions** (private projects, 403 errors)
- **Incomplete data** (only processed data, missing raw files)
- **Poor data quality** (messy Excel, no codebook, no code)

**Result:** 0/3 papers with access barriers reproduced (same as 2018)

---

## Repository Contents

```
reproducing_registered_reports_2026/
├── README.md                          # This file
├── HONEST_REASSESSMENT.md             # Detailed methodology critique
├── REPRODUCIBILITY_VERIFICATION.md    # Verification against published papers
│
├── reproduction_attempts/             # Original session (6 papers)
│   ├── steinemann2017/
│   │   ├── steinemann_full_reproduction.R
│   │   ├── REPRODUCTION_SUMMARY.md
│   │   └── reproduction_output.txt
│   ├── weston2018/
│   ├── kuppuraj2018/
│   ├── [3 failed papers]
│   └── FINAL_RESULTS.md (original claims - see reassessment)
│
└── additional_attempts/               # Extended session (5 papers)
    ├── nauts2014/
    ├── blanken2014/
    ├── zickfeld2017/
    ├── brindley2018/
    ├── wesselman2014/
    ├── goldberg2017/
    └── FINAL_UPDATED_STATUS.md (original claims - see reassessment)
```

---

## Methodology

### Tools Used
- **R 4.4.x** with packages: haven, dplyr, lme4, lmerTest, lavaan, psych, effsize
- **Python 3.9** for OSF API access
- **Claude Code (Sonnet 4.5)** for code generation and debugging
- **Original data/code** from [Lakens et al. GitHub](https://github.com/Lakens/reproducing_registered_reports)

### Approach
1. Identified papers that failed in 2018 due to technical issues
2. Downloaded data/code from OSF repositories
3. Used AI assistant to:
   - Fix package installation issues
   - Convert SPSS → R when needed
   - Repair file path errors
   - Simplify complex scripts
   - Write new code when none existed
4. Ran analyses and documented results
5. **Attempted verification** against published papers (mostly blocked by paywalls)

### Time Investment
- ~6.5 hours total across both sessions
- ~43 minutes average per successful paper
- 9 papers upgraded from failed/never-attempted to runnable

---

## Implications

### For Reproducibility Estimates

**2018 finding:** 21/36 (58%) of Registered Reports with data+code were reproducible

**2026 question:** How many are reproducible with modern tools?
- Infrastructure barriers: Mostly solved ✓
- Access barriers: Unchanged ❌
- **Critical gap:** Without systematic verification against published tables, we can't confidently revise the 58% estimate upward

**What's needed:** Graduate student verification team to systematically:
1. Access published papers (via institutional subscriptions)
2. Compare our reproduced values to published tables
3. Categorize discrepancies (rounding vs. substantial differences)
4. Investigate causes (implementation errors vs. package versions vs. missing steps)

### For the Field

**Good news:**
- SPSS format is no longer a reproduction barrier
- Package installation is now trivial
- AI can implement standard analyses competently
- Infrastructure has improved dramatically

**Remaining challenges:**
- Verifying correctness requires domain expertise
- Published papers often paywalled (ironic for reproducibility!)
- "Works on my machine" → "produces sensible output" ≠ "exactly replicates published results"

**Open question:**
What's an acceptable threshold for statistical reproducibility? Lakens et al. (2018) allowed:
- Minor script modifications
- Focus on "main results" not every value
- Two small errors (0.89 vs 0.88) deemed acceptable

Is Kuppuraj's pattern (same conclusion, different magnitudes) "reproducible"?

---

## Related Work

**Reproducibility studies:**
- Lakens et al. (2018) - [Original study this follows up](https://journals.sagepub.com/doi/full/10.1177/2515245920918872)
- Hardwicke et al. (2018) - [Cognition journal reproductions](https://royalsocietypublishing.org/doi/full/10.1098/rsos.180448)
- Stockemer et al. (2018) - Political science reproductions
- Stodden et al. (2018) - Science journal reproductions

**AI-assisted reproduction:**
- Akera et al. (2024) - [Comparing human vs AI teams on reproducibility](https://arxiv.org/abs/2411.09381)
- REPRO-Bench - [Can AI agents assess reproducibility?](https://arxiv.org/abs/2412.03530)

**Key difference:** This study uses AI for *performing* reproductions, those studies use AI for *evaluating* them.

---

## Limitations & Future Work

### Current Limitations

1. **No systematic verification**
   - Only checked 1 paper against published tables
   - Cannot confirm statistical reproducibility for others
   - Mostly demonstrated "code runs" not "numbers match"

2. **Paywalls block verification**
   - Most papers inaccessible without institutional subscriptions
   - Open access papers rare in 2014-2018 era
   - Ironic barrier for reproducibility research

3. **SPSS conversion assumptions**
   - Assumed haven accurately preserves variable encodings
   - Didn't verify factor codings match original
   - Possible subtle differences in statistical implementations

4. **Expertise requirements**
   - "Appropriate analysis" judgments require domain knowledge
   - Different analysts might choose different tests
   - No objective standard for "conceptually correct"

### Proposed Next Steps

1. **Verification phase** (requires grad student team + institutional access):
   - Access all published papers
   - Extract exact results tables
   - Compare to our reproductions line-by-line
   - Categorize discrepancies

2. **Investigation phase**:
   - For exact matches: What factors enabled this?
   - For close matches: Acceptable threshold?
   - For large discrepancies: Root cause analysis

3. **Automation phase**:
   - Build reproducibility checking into journal workflows
   - Auto-verify submissions before publication
   - Flag potential issues for author correction

---

## How to Use This Repository

### Run the reproductions yourself:

```r
# Install required packages
install.packages(c("haven", "dplyr", "lme4", "lmerTest",
                   "lavaan", "psych", "effsize"))

# Navigate to a specific paper
cd reproduction_attempts/steinemann2017/

# Run the reproduction script
Rscript steinemann_full_reproduction.R

# Compare output to reproduction_output.txt
```

### Verify against published papers:

1. Access the published paper (see DOI in REPRODUCTION_SUMMARY.md)
2. Extract results tables
3. Compare to our reproduction_output.txt
4. Document matches/discrepancies
5. Submit an issue or pull request!

---

## Citation

If you use this work, please cite both:

**Original study:**
```
Lakens, D., Obels, P., Coles, N. A., Gottfried, J., & Green, S. A. (2020).
Analysis of open data and computational reproducibility in registered reports
in psychology. Advances in Methods and Practices in Psychological Science,
3(2), 229-237. https://doi.org/10.1177/2515245920918872
```

**This follow-up:**
```
Green, S. A. (2026). Reproducing Registered Reports in 2026: Infrastructure
Modernization with AI Tools. GitHub repository:
https://github.com/setgree/revised-reproducibility-rates
```

---

## Contact

**Seth Ariel Green**
- Email: setgree@stanford.edu
- Website: https://www.foodlabstanford.com/
- GitHub: https://github.com/setgree

**Collaboration welcome!** Particularly interested in:
- Systematic verification against published tables
- Understanding causes of numerical discrepancies
- Developing automated reproducibility checks
- Comparing AI vs human reproduction approaches

---

## License

MIT License - See LICENSE file

Data and original code from Lakens et al. (2018) used under their original licensing terms.

---

## Acknowledgments

- **Daniel Lakens** and team for the original 2018 study and publicly shared data
- **Anthropic** for Claude Code (Sonnet 4.5)
- **R Core Team** and package developers (especially `haven` by Hadley Wickham)
- **Open Science Framework** for data hosting and API access

---

**Last updated:** January 12, 2026

**Key takeaway:** Modern tools make computational reproducibility *easier* but don't eliminate the need for careful verification. We can run code much more readily than in 2018, but "runs successfully" ≠ "reproduces published results exactly."
