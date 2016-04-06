library(knitr)
library(tools)
homedir = getwd()
sections = list.files(path = homedir, 
                      full.names=TRUE, pattern="\\.(Rnw|Rmd)$", 
                      recursive=TRUE)
# rmds = sections[grep("md$", sections)]
# rnws = sections[grep("nw$", sections)]

for (isec in seq_along(sections)){
  section = sections[isec]
  folname = dirname(section)
  setwd(folname)
  knit(input=section)
  if (grepl("nw$", section)){
    sname = basename(section)
    sname = gsub("\\.Rnw", "", sname)
    system(sprintf("pdflatex %s", sname))
    system(sprintf("bibtex %s", sname))
    system(sprintf("pdflatex %s", sname))  
    system(sprintf("pdflatex %s", sname))  
  }
  purl(input=section)
}

setwd(homedir)


