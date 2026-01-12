# Reproducing Registered Reports 2026

## Project Overview
This project reproduces papers from Lakens et al. (2018) "Analysis of Open Data and Computational Reproducibility in Registered Reports in Psychology" using modern tools (R 4.4.x, Claude Code/AI).

**GitHub:** https://github.com/setgree/revised-reproducibility-rates

## Key Distinction: Three Types of Reproducibility

1. **Computational Reproducibility** - Running original author code → exact output
2. **Statistical Reproducibility** - Independent implementation → verified match to published tables
3. **Conceptual Reproducibility** - Standard analyses → theoretically interpretable results

**What this project achieved:** Primarily conceptual reproducibility (9/11 papers with accessible data)

**Critical finding:** Kuppuraj 2018 checked against published tables → conceptual match but numbers differ substantially

## Key Files

### Documentation
- `README.md` - Main public-facing documentation (honest about limitations)
- `HONEST_REASSESSMENT.md` - Detailed self-critique and methodology analysis
- `REPRODUCIBILITY_VERIFICATION.md` - Verification against published papers (Kuppuraj example)

### Results (Original Claims - See Reassessment)
- `FINAL_UPDATED_STATUS.md` - Extended session summary (originally claimed 85.7% success)
- `reproduction_attempts/FINAL_RESULTS.md` - First session summary (originally claimed 50% success)

### Reproduction Attempts
- `reproduction_attempts/` - First 6 papers (Steinemann, Weston, Kuppuraj, etc.)
- `additional_attempts/` - Extended session (Nauts, Blanken, Zickfeld, Brindley, Wesselman, Goldberg)

## What Modern Tools Solved
- ✅ SPSS conversion (haven package - 6/6 papers)
- ✅ Package installation automation
- ✅ File path issues
- ✅ Code simplification (e.g., Kuppuraj 500 lines → 150 lines)

## What Remains Unsolved
- ❌ Access barriers (dead links, empty OSF repos)
- ❌ Statistical reproducibility verification (need published tables)
- ❌ Incomplete data uploads (e.g., Sinclair 2014 missing Time 1 data)

## Collaboration Context
- **Original authors:** Daniel Lakens (lead), Pepijn Obels, Nicholas Coles, Jaroslav Gottfried, Seth Green
- **Current work:** Seth Green with Claude Code
- **Proposed collaboration:** Systematic verification against published papers with grad student team
- **Interested parties:** Tom Hardwicke, Maya Mathur, Russ Poldrack (AI-assisted research)

## Working Notes
- When discussing reproducibility, always specify which type (computational/statistical/conceptual)
- Be honest about limitations - we demonstrated infrastructure modernization, not verified reproduction
- The Kuppuraj case is key: shows conceptual ≠ statistical reproducibility
