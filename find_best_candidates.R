library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

cat("===== FINDING BEST CANDIDATE PAPERS =====\n\n")

# Papers where script was attempted but failed, AND have both data and code
candidates <- df %>%
  filter(
    run_script_final == 0 &  # Script was attempted but failed
    !is.na(url_dataset) & url_dataset != "" &  # Has data
    !is.na(url_scripts) & url_scripts != ""  # Has code
  ) %>%
  select(study, url_dataset, url_scripts, programming_language, 
         comments_on_reproducibility_sg, comments_on_reproducibility_po,
         comments_on_reproducibility_jg, comments_on_reproducibility_nc)

cat("Papers with BOTH data AND code that failed to run:\n")
cat(paste(rep("=", 80), collapse=""), "\n\n")

if (nrow(candidates) > 0) {
  for (i in 1:nrow(candidates)) {
    cat("CANDIDATE", i, ":", candidates$study[i], "\n")
    cat("  Data:", candidates$url_dataset[i], "\n")
    cat("  Code:", candidates$url_scripts[i], "\n")
    cat("  Language:", candidates$programming_language[i], "\n")
    
    # Get any comment that's not NA
    comments <- c(
      candidates$comments_on_reproducibility_sg[i],
      candidates$comments_on_reproducibility_po[i],
      candidates$comments_on_reproducibility_jg[i],
      candidates$comments_on_reproducibility_nc[i]
    )
    comments <- comments[!is.na(comments)]
    
    if (length(comments) > 0) {
      cat("  Issue:", comments[1], "\n")
    }
    cat("\n")
  }
} else {
  cat("No papers found with both data and code that failed!\n")
}

cat("\n\nAlso checking: Papers where script ran but wasn't fully reproducible:\n")
cat(paste(rep("=", 80), collapse=""), "\n\n")

partial <- df %>%
  filter(
    run_script_final == 1 &  # Script ran
    reproducible_final == 0 &  # But not fully reproducible
    !is.na(url_dataset) & url_dataset != "" &
    !is.na(url_scripts) & url_scripts != ""
  ) %>%
  select(study, url_dataset, url_scripts, programming_language,
         comments_on_reproducibility_sg, comments_on_reproducibility_po)

if (nrow(partial) > 0) {
  for (i in 1:nrow(partial)) {
    cat("PARTIAL", i, ":", partial$study[i], "\n")
    cat("  Language:", partial$programming_language[i], "\n")
    
    comments <- c(
      partial$comments_on_reproducibility_sg[i],
      partial$comments_on_reproducibility_po[i]
    )
    comments <- comments[!is.na(comments)]
    
    if (length(comments) > 0) {
      cat("  Issue:", comments[1], "\n")
    }
    cat("\n")
  }
} else {
  cat("No partially reproducible papers with both data and code!\n")
}
