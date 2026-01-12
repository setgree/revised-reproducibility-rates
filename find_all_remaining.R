library(readxl)
library(dplyr)

data <- read_excel("lakens_data.xlsx")
papers <- data %>% filter(!is.na(study))

cat("===== ALL PAPER CATEGORIES =====\n\n")

# Already successfully fixed (7 papers)
already_fixed <- c("Steinemann 2017", "Weston 2018", "Kuppuraj 2018", 
                   "Nauts 2014", "Blanken 2014", "Zickfeld, 2017", "Brindley 2018")

# Already failed (3 papers)
already_failed <- c("Arpin 2017", "Evers 2014", "Ivory, 2017")

# Papers where script didn't run at all
no_run <- papers %>%
  filter(!study %in% c(already_fixed, already_failed),
         run_script_final == 0 | is.na(run_script_final))

cat("1. SCRIPTS DIDN'T RUN (", nrow(no_run), " papers):\n", sep="")
for (i in 1:nrow(no_run)) {
  cat("  ", no_run$study[i], " - ", no_run$programming_language[i], 
      " - Reason: ", no_run$main_reason_not_reproducible[i], "\n", sep="")
}

# Reproducible papers (to see what's already working)
fully_repro <- papers %>%
  filter(reproducible_final == 1,
         !study %in% already_fixed)

cat("\n2. ALREADY FULLY REPRODUCIBLE (", nrow(fully_repro), " papers - skip these):\n", sep="")
if (nrow(fully_repro) <= 10) {
  for (i in 1:nrow(fully_repro)) {
    cat("  ", fully_repro$study[i], "\n", sep="")
  }
} else {
  cat("  (", nrow(fully_repro), " papers - not listing all)\n", sep="")
}

cat("\n3. ALREADY FIXED BY ME (7 papers):\n")
for (paper in already_fixed) {
  cat("  ✓", paper, "\n")
}

cat("\n4. ALREADY FAILED - ACCESS ISSUES (3 papers):\n")
for (paper in already_failed) {
  cat("  ✗", paper, "\n")
}

cat("\n===== TARGET LIST: SCRIPTS DIDN'T RUN =====\n")
cat("Total to attempt:", nrow(no_run), "\n\n")

# Create detailed list
for (i in 1:nrow(no_run)) {
  cat("---\n")
  cat("Study:", no_run$study[i], "\n")
  cat("Language:", no_run$programming_language[i], "\n")
  cat("Data URL:", no_run$url_dataset[i], "\n")
  cat("Script URL:", no_run$url_scripts[i], "\n")
  cat("Reason:", no_run$main_reason_not_reproducible[i], "\n")
}
