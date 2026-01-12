# Honest Reassessment of Reproducibility Claims

## Executive Summary

After attempting to verify our reproductions against published papers, we must revise our claims about what we achieved. We primarily demonstrated **conceptual reproducibility** (appropriate analyses yielding theoretically sensible results), **not statistical reproducibility** (exact numerical matches to published tables).

---

## Three Types of Reproducibility

Following the framework from our discussion:

### 1. Computational Reproducibility
**Definition:** Run original author-provided code on original data → get exact same output

**What we achieved:**
- **Steinemann 2017**: ✓ Ran original code (with minor fixes for paths/packages)
- **Weston 2018**: ⚠️ Partial (had to work around scoreItems() error)
- **Kuppuraj 2018**: ⚠️ Simplified original code (500 lines → 150 lines)

**Total: 1-3 papers** (depending on how strictly you define "original code")

### 2. Statistical Reproducibility
**Definition:** Write standard implementation based on methods description → verify exact match to published results tables

**What we achieved:**
- **Kuppuraj 2018**: ❌ VERIFIED BUT NUMBERS DON'T MATCH
  - Published: Adjacent-Det β=-132.5ms, t=-5.14
  - Our reproduction: β=-80.09ms, t=-9.43
  - Published: Non-adj-Det p>.05 (not significant)
  - Our reproduction: p<.001 (highly significant)

- **All other papers**: ❓ NOT VERIFIED (couldn't access published papers or didn't try)

**Total: 0 papers with verified exact numerical match**

### 3. Conceptual Reproducibility
**Definition:** Implement appropriate analyses based on study design → get theoretically interpretable results

**What we achieved:**
- All 9 attempted papers with accessible data
- Appropriate statistical tests run
- Results in expected directions
- Theoretically sensible effect sizes

**Total: 9 papers**

---

## Detailed Case Studies

### Kuppuraj 2018 - The Critical Test Case

This is the **only paper** where we could access published results tables (via PubMed Central open access).

**Published Results (Session 1, Table 1):**
| Condition | β (ms) | t | p | Sig? |
|-----------|--------|---|---|------|
| Adjacent Determiner | −132.5 | −5.14 | <.001 | Yes |
| Adjacent Probabilistic | −88.2 | −3.42 | <.001 | Yes |
| Non-adjacent Determiner | −42.4 | −1.64 | >.05 | **No** |

**Our Reproduction (Visit 1):**
| Condition | β (ms) | t | p | Sig? |
|-----------|--------|---|---|------|
| Adjacent Determiner | −80.09 | −9.43 | <.001 | Yes |
| Adjacent Probabilistic | −40.86 | −4.81 | <.001 | Yes |
| Non-adjacent Determiner | −53.11 | −6.25 | <.001 | **Yes** |

**Verdict:**
- ✓ Conceptual: Same theoretical conclusion (statistical learning occurred)
- ✓ Directional: All effects negative (faster RTs)
- ❌ Statistical: Numbers substantially different
- ❌ Pattern: Different significance for Non-adjacent condition

**Implications:** If our "success story" (original code provided, simplified and ran successfully) doesn't match published tables, our other papers likely don't either.

---

### Steinemann 2017 - Can't Verify

**What we did:**
- Downloaded original author code (`analysis.R`)
- Fixed: hardcoded paths, package installation
- Successfully ran SEM model

**Results obtained:**
- χ² = 2.889, CFI = 1.000, RMSEA = 0.000
- Identification → Donation: β = -0.065, p = 0.014
- Appreciation → Donation: β = 0.057, p = 0.011

**Problem:** Published paper behind paywall (403 error)
- Cannot verify if these exact numbers appear in paper
- **Assumption:** They probably match (we ran their code)
- **Reality:** We don't know

**Verdict:**
- ✓ Computational: Ran original code successfully
- ❓ Statistical: Can't verify without published tables

---

### Papers Written From Scratch (No Original Code)

**Papers:** Nauts 2014, Blanken 2014, Zickfeld 2017, Brindley 2018, Wesselman 2014, Goldberg 2017

**What we did:**
1. Downloaded SPSS .sav files
2. Read methods sections
3. Inferred appropriate analyses
4. Wrote R code from scratch
5. Ran analyses, got results

**Example - Wesselman 2014 (Schachter replication):**
- Found: Deviate liking lower than Slider (t=-2.17, p=.033)
- Found: Deviate ranked lowest in sociometric votes (p<.001)
- **But did NOT check if these exact numbers appear in published paper**

**Verdict for all 6 papers:**
- ✓ Conceptual: Appropriate analyses, sensible results
- ❌ Statistical: Never verified against published tables
- ❌ Computational: No original code existed

---

## What Did We Actually Demonstrate?

### Strengths

1. **Infrastructure modernization works**
   - SPSS is no longer a barrier (`haven` package)
   - Package installation can be automated
   - File path errors easily fixed
   - API access simplifies data downloading

2. **AI can implement standard analyses**
   - Read methods sections
   - Infer appropriate statistical tests
   - Write clean, runnable R code
   - Handle SPSS → R conversion

3. **Conceptual reproducibility is high**
   - When data available: 9/11 papers (82%)
   - Got theoretically sensible results
   - Matched expected patterns

### Limitations

1. **Did not verify exact numerical correspondence**
   - Only checked 1 paper (Kuppuraj)
   - That one paper: numbers don't match
   - Implies others likely don't match either

2. **Cannot distinguish:**
   - Our code correctly implements what paper describes
   - vs. Our code runs successfully but calculates something different
   - vs. Our code matches what authors did but paper has typos

3. **Didn't follow Lakens' criteria strictly**
   - They allowed "minor changes" but focused on "main results"
   - They checked if "dozens of other values reproduced perfectly"
   - We didn't systematically verify values against published tables

---

## Revised Claims

### Original Claims (Too Strong)

❌ "Successfully reproduced 9 papers"
❌ "85.7% reproducibility rate"
❌ "Exact match" for Steinemann
❌ "Full reproduction" for Kuppuraj

### Honest Claims (Accurate)

✓ "Achieved conceptual reproducibility for 9/11 papers with accessible data (82%)"

✓ "Demonstrated that modern tools (R/haven, AI coding assistants) eliminate infrastructure barriers"

✓ "Showed SPSS format is no longer an obstacle to reproduction"

✓ "Verified 1 paper against published tables: directional findings match but exact numbers differ substantially"

⚠️ "Cannot confirm statistical reproducibility (exact numerical match) without systematic verification against published results"

---

## Implications for Collaboration with Daniel Lakens

Daniel asked specifically (emphasis added):

> "I am very interested in learning what Claude could solve, **how it did so**, and **how you determined this**."

> "It would require **manual checks** if Claude is actually adding or changing code to make it run - then we would need to see if **those changes are actually correct**."

### What We Can Honestly Report

1. **What Claude solved:**
   - Infrastructure issues (packages, paths, file formats)
   - SPSS → R conversion
   - Writing standard analyses from methods descriptions
   - Code organization and simplification

2. **How it did so:**
   - `haven::read_sav()` for SPSS files
   - Auto-installing packages
   - Inferring analyses from paper descriptions
   - Simplifying complex scripts

3. **How we determined success:**
   - ⚠️ **Primarily: Code runs without errors**
   - ⚠️ **Secondarily: Results seem reasonable**
   - ❌ **NOT: Verified against published tables**

### What This Means for the Proposed Project

**The good news:**
- Modern tools dramatically reduce infrastructure barriers
- AI can implement standard analyses reliably
- SPSS conversion is trivial

**The honest assessment:**
- We demonstrated *infrastructure modernization*, not *verified reproduction*
- To claim statistical reproducibility, we need systematic verification against published tables
- This is exactly the "manual check" Daniel mentioned

**The research opportunity:**
- Compare AI-generated analyses to published results systematically
- Quantify: When do they match exactly? When do they differ?
- Understand: What causes discrepancies?
  - AI implementation errors?
  - Published paper typos?
  - Undocumented preprocessing steps?
  - Package version differences?

---

## Recommendations for GitHub Repository

### Option 1: Be Completely Transparent

Include this honest reassessment alongside the original optimistic reports, showing the evolution of understanding. This demonstrates scientific integrity.

**Pros:**
- Full transparency
- Shows critical thinking
- Perfect for academic collaboration

**Cons:**
- Might seem like "taking it back"
- Could confuse casual readers

### Option 2: Lead with Honest Summary

Create new README that immediately distinguishes the three types and is clear about what was achieved.

**Pros:**
- Clear from the start
- No overstatements
- Sets realistic expectations

**Cons:**
- "Buries" the impressive infrastructure work
- Might undersell the value

### Option 3: Frame as "Infrastructure Modernization" Study

Reframe entirely: This was never about exact reproduction, it was about showing modern tools eliminate barriers.

**Pros:**
- Accurate framing
- Still valuable contribution
- No overstatements

**Cons:**
- Loses the "reproducibility rates" angle
- Different project than originally envisioned

---

## What to Include in Email to Daniel

### Suggested Approach

1. **Be upfront about the limitation:**
   "After attempting to verify our reproductions against published papers, I realized we primarily demonstrated *conceptual reproducibility* (appropriate analyses yielding sensible results) rather than *statistical reproducibility* (exact numerical matches). The one paper we could verify (Kuppuraj via PMC) showed directional consistency but substantially different effect sizes."

2. **Emphasize what we DID demonstrate:**
   "However, the work clearly shows modern tools (R/haven, AI coding) eliminate infrastructure barriers that blocked the 2018 team: package installation, SPSS conversion, file path issues, code organization."

3. **Propose the real value:**
   "The interesting research question becomes: For papers with accessible data, what fraction can achieve (a) computational, (b) statistical, and (c) conceptual reproducibility with modern tools? And when numbers differ, why?"

4. **Acknowledge his expertise:**
   "Your point about needing to verify whether code changes are 'actually correct' is exactly right - that's the gap in our current work."

---

## Bottom Line

**What we thought we did:** Reproduced 9 papers

**What we actually did:** Modernized infrastructure for 9 papers and got plausible-looking results

**What we need to do:** Systematically verify against published tables to claim statistical reproducibility

**What's still valuable:** Demonstrating that infrastructure is no longer a barrier, and establishing a framework for distinguishing types of reproducibility

---

**Date:** January 12, 2026
**Author:** Seth Ariel Green (with Claude Code Sonnet 4.5)
**Status:** Internal reassessment before sharing with collaborators
