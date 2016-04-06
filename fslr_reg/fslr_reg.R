setwd("~/Dropbox/Neurohacking/fslr_reg/")

## ----install_devtools, eval=FALSE----------------------------------------
## if (!require(devtools)){
## 	install.packages('devtools')
## }
## devtools::install_github("muschellij2/fslr")

## ----check_fsl-----------------------------------------------------------
Sys.getenv("FSLDIR")
library(fslr)
have.fsl()

## ----check_fsl_set, eval=FALSE-------------------------------------------
## options(fsl.path="/my/path/to/fsl")

## ----check_fsl_set_real, eval=TRUE, echo=FALSE---------------------------
options(fsl.path="/usr/local/fsl")

## ----read_img, eval=TRUE-------------------------------------------------
library(oro.nifti)
t1_fname = "Output_3D_File.nii.gz"
nim = readNIfTI(t1_fname, reorient=FALSE)

## ----ants_math, eval=TRUE------------------------------------------------
mean(nim)
fslstats(nim, opts="-m")
fslstats("Output_3D_File.nii.gz", opts = "-m")

## ----n3correct, eval=TRUE, cache = TRUE----------------------------------
fast_img = fsl_biascorrect(nim, 
	retimg=TRUE)


## ----bet, eval=TRUE, cache = TRUE----------------------------------------
bet_fast = fslbet(infile=fast_img, retimg=TRUE)

## ----plot_bet, eval=TRUE, echo = FALSE, cache=TRUE, results='hide'-------
library(scales)
png("BET_Image.png")
orthographic(robust_window(bet_fast), text="Brain-Extracted\n Image")
dev.off()
png("BET_Image_Overlay.png")
ortho2(robust_window(fast_img),
       cal_img(bet_fast > 0),
       NA.y=TRUE,
       col.y=alpha("red", 0.5),
       text = "Brain Mask Overlay")
dev.off()

## ----bet_cog, eval=TRUE, cache = TRUE------------------------------------
cog = cog(bet_fast, ceil=TRUE)
bet_fast2 = fslbet(infile=fast_img, retimg=TRUE, 
                   opts = 
                     paste("-c", paste(cog, collapse= " ")))

## ----plot_bet2, eval=TRUE, echo = FALSE, cache=TRUE, results='hide'------
library(scales)
png("BET_Image2.png")
orthographic(robust_window(bet_fast2), 
             text="Post-COG\n Brain-Extracted\n Image")
dev.off()
png("BET_Image_Overlay2.png")
ortho2(robust_window(fast_img),
       cal_img(bet_fast2 > 0),
       NA.y=TRUE,
       col.y=alpha("red", 0.5), 
       text = "Post-COG \n Brain Mask Overlay")
dev.off()

## ----image_reg, eval=TRUE, cache = TRUE----------------------------------
registered_fast = flirt(infile=fast_img, 
	reffile = "MNI152_T1_1mm.nii.gz",
	dof = 6,
	retimg = TRUE)

## ----plot_images, eval=TRUE, echo = FALSE, cache=TRUE, results='hide'----
template = readNIfTI("MNI152_T1_1mm.nii.gz", reorient=FALSE)
png("Template.png")
orthographic(template, text="Template Image")
dev.off()
template_brain = readNIfTI("MNI152_T1_1mm_brain.nii.gz", reorient=FALSE)
png("Template_brain.png")
orthographic(template_brain, text="Template Brain \n Image")
dev.off()
png("FLIRT_Reg_Image.png")
orthographic(robust_window(registered_fast), 
text = "Registered \n FAST-Corrected\n Image")
dev.off()

## ----image_reg_bet, eval=TRUE, cache = TRUE------------------------------
registered_fast_brain = flirt(infile=bet_fast2, 
  reffile = "MNI152_T1_1mm_brain.nii.gz",
	dof = 6,
	retimg = TRUE)

## ----plot_images_bet, eval=TRUE, echo = FALSE, cache=TRUE, results='hide'----
png("FLIRT_Reg_Image_Brain.png")
orthographic(robust_window(registered_fast_brain), 
text = "Registered \n FAST-Corrected\n Brain")
dev.off()

## ----image_affine_bet, eval=TRUE, cache = TRUE, echo=FALSE---------------
affine_fast_brain = flirt(infile=bet_fast2, 
  reffile = "MNI152_T1_1mm_brain.nii.gz",
  dof = 12,
	retimg = TRUE)
png("FLIRT_Affine_Image_Brain.png")
orthographic(robust_window(affine_fast_brain), 
text = "Affine-Registered \n FAST-Corrected\n Brain")
dev.off()

## ----image_fnirt, eval=TRUE, cache = TRUE--------------------------------
fnirt_fast = fnirt_with_affine(infile=bet_fast2, 
	reffile = "MNI152_T1_1mm_brain.nii.gz",
	outfile = "FNIRT_to_Template", retimg=TRUE)

## ----plot_fnirt_images, eval=TRUE, echo = FALSE, cache=TRUE, results='hide'----
png("FNIRT_Reg_Image.png")
orthographic(robust_window(fnirt_fast), text = "FNIRT Registered \n FAST-Corrected\n Image")
dev.off()

