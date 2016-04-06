joshdate=7_31_2014
Master_File.pdf: resid_dx_inference/${joshdate}/residuals_and_diagnostics.Rnw \
	sec_Ravi/RaviSectionsJSS.Rnw \
	makefile.R \
	strip_header.R \
	sec_gam/sec_gam.Rnw sec_machine/sec_machine.Rnw \
	sec_penal/sec_penal.Rnw
	echo "Josh section"
	# cd resid_dx_inference/${joshdate}; Rscript -e "require(cacheSweave); Sweave('residuals_and_diagnostics.Rnw', driver = cacheSweaveDriver);"
	cd resid_dx_inference/${joshdate}; Rscript -e "library(knitr); Sweave2knitr('residuals_and_diagnostics.Rnw'); knit('residuals_and_diagnostics-knitr.Rnw')"
	echo "Ravi section"
	# cd sec_Ravi/; Rscript -e "require(cacheSweave); Sweave('RaviSectionsJSS.Rnw', driver = cacheSweaveDriver)"	
	cd sec_Ravi/; Rscript -e "library(knitr); Sweave2knitr('RaviSectionsJSS.Rnw'); knit('RaviSectionsJSS-knitr.Rnw')"
	R CMD batch strip_header.R
	R CMD batch makefile.R	
	pdflatex Master_File
	bibtex Master_File
	pdflatex Master_File
	pdflatex Master_File
	open Master_File.pdf
