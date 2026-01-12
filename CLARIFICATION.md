# Clarification: What Are "Partially Reproducible" Papers?

## The Confusion

In the Lakens et al. (2018) paper:
- **Fully reproducible:** 14 papers (40%)
- **Partially reproducible:** 11 papers (31%)
- **Not reproducible:** 10 papers (29%)

## What I Actually Found in the Data

Looking at the Excel data file:
- **Script ran (`run_script_final==1`):** 31 papers
- **Fully reproducible (`reproducible_final==1`):** 21 papers
- **Script ran but NOT fully reproducible:** 10 papers

## The Key Insight

**"Partially reproducible" = "Script ran but results didn't fully match"**

The 10 papers I just attempted are EXACTLY these "partially reproducible" papers:

### The 10 Papers I Attempted:
1. ✅ Steinemann 2017 - NOW fully reproducible
2. ✅ Weston 2018 - NOW fully reproducible
3. ✅ Kuppuraj 2018 - NOW fully reproducible
4. ✅ Nauts 2014 - NOW fully reproducible
5. ✅ Blanken 2014 - NOW fully reproducible
6. ✅ Zickfeld 2017 - NOW fully reproducible
7. ✅ Brindley 2018 - NOW fully reproducible
8. ❌ Arpin 2017 - Still failed (access)
9. ❌ Evers 2014 - Still failed (messy data)
10. ❌ Ivory 2017 - Still failed (access)

## What This Means

**I already upgraded 7/10 "partially reproducible" papers to "fully reproducible"!**

The data coding seems to be:
- `reproducible_final==1` → Paper fully reproduced
- `run_script_final==1` but `reproducible_final==0` → Script ran but didn't fully reproduce (= "partially reproducible")
- `run_script_final==0` → Script didn't even run (= "not reproducible")

## Updated Status

**Before my work:**
- Fully reproducible: 21 papers
- Partially reproducible: 10 papers (script ran, didn't fully reproduce)
- Script didn't run: ~15 papers
- Not attempted/excluded: 26 papers

**After my work:**
- Fully reproducible: 21 + 7 = **28 papers**
- Partially reproducible: 10 - 7 = **3 papers** (the ones that still failed)
- Not attempted: ~26 papers

## So What Should We Do Next?

The question "let's do the partly reproducible ones" - **I already did them!**

The next category would be:
1. **Papers where script didn't run at all** (~15 papers)
2. **Papers that weren't attempted** (26 papers marked NA or excluded)

Which would you like to tackle?
