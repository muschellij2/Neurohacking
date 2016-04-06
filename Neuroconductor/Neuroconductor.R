## ----label=opts, results='hide', echo=FALSE, message = FALSE, warning=FALSE----
library(knitr)
library(highr)
opts_chunk$set(echo=TRUE, prompt=FALSE, message=FALSE, 
               cache = TRUE,
               eval=FALSE,
               warning=FALSE, comment="", dev='png', out.height='0.5\\textheight,keepaspectratio',
               out.width='\\textwidth')
knit_hooks$set(inline = function(x) { 
  if (is.numeric(x)) return(knitr:::format_sci(x, 'latex')) 
  hi_latex(x) 
}) 
setwd("~/Dropbox/Neurohacking/Neuroconductor/")
library(oro.nifti)
library(fslr)
library(extrantsr)
library(ANTsR)
library(WhiteStripe)
library(scales)

## ----install_devtools_fslr, eval=FALSE-----------------------------------
## if (!require(devtools)){
## 	install.packages('devtools')
## }
## devtools::install_github("muschellij2/oro.nifti")
## devtools::install_github("muschellij2/fslr")
## install.package("WhiteStripe")
## devtools::install_github("stnava/cmaker")
## devtools::install_github("stnava/ITKR")
## devtools::install_github("stnava/ANTsR")

## ----check_fsl_set_real, eval=TRUE, echo=FALSE, cache=FALSE--------------
options(fsl.path="/usr/local/fsl")

## ----read_img, cache=FALSE-----------------------------------------------
library(oro.nifti)
nim = readNIfTI("Output_3D_File.nii.gz", 
reorient=FALSE)
nim

## ----read_ants-----------------------------------------------------------
library(ANTsR)
aimg = antsImageRead("Output_3D_File.nii.gz", 
dimension = 3)

## ----ants_class----------------------------------------------------------
class(aimg)
aimg
slotNames(aimg)

## ----view_img, cache=TRUE------------------------------------------------
orthographic(nim)

## ----view_img_overlay, cache=TRUE----------------------------------------
library(fslr)
ortho2(nim, nim > 200, col.y=alpha("red", 0.5))

## ----bc, cache = TRUE----------------------------------------------------
library(extrantsr)
n4img = bias_correct(nim, correction ="N4", retimg=TRUE)

## ----echo=FALSE----------------------------------------------------------
options(fsl.path="/usr/local/fsl")

## ----bet,  cache = TRUE--------------------------------------------------
brain_img = fslbet(infile=n4img, retimg=TRUE)
### rerurn with new cog
cog = cog(brain_img, ceil=TRUE)
brain_img2 = fslbet(infile=n4img, 
                    retimg=TRUE, 
                    opts = paste("-c", paste(cog, collapse= " ")))

## ----plot_bet,  echo = FALSE, cache=TRUE, results='hide'-----------------
library(scales)
png("BET_Image.png")
orthographic(robust_window(brain_img), text="Brain-Extracted\n Image")
dev.off()
png("BET_Image_Overlay.png")
ortho2(robust_window(n4img),
cal_img(brain_img > 0),
NA.y=TRUE,
col.y=alpha("red", 0.5),
text = "Brain Mask Overlay")
dev.off()
png("BET_Image_Overlay2.png")
ortho2(robust_window(n4img),
cal_img(brain_img2 > 0),
NA.y=TRUE,
col.y=alpha("red", 0.5),
text = "Brain Mask Overlay\nAfter COG")
dev.off()

## ----kmeans, echo=TRUE, results='hide', cache=TRUE-----------------------
library(fslr)
a = oro2ants(brain_img2)
x = oro2ants((brain_img2>0)*1)
k = 5; km = kmeansSegmentation(a, k=k, kmask=x)
res = ants2oro(km$segmentation)
voxsize = prod(voxdim(n4img))/1000
ks = seq(k); sizes = sapply(ks, function(i) sum(res == i)) * voxsize
keep_ks = ks[ sizes > 200 ] # Arbitrary size - need to be "big"
wm = cal_img(res == max(keep_ks))

## ----plot_bw, echo = FALSE, cache=TRUE, results='hide'-------------------
png("WM_Image.png")
xyz = cog(wm, ceil=TRUE)
ortho2(robust_window(n4img), wm, col.y=alpha("red", 0.5), xyz=xyz,
       text ="White Matter\n Segmentation")
dev.off()

## ----cache=FALSE, echo=FALSE---------------------------------------------
options(fsl.path="/usr/local/fsl")

## ----fast, echo=TRUE, results='hide', cache=FALSE------------------------
fast_img = fast(file = brain_img2, retimg=TRUE)

## ----plot_fast,  echo = FALSE, cache=FALSE, results='hide'---------------
png("FAST_Image.png")
ortho2(robust_window(n4img), fast_img ==3, col.y=alpha("red", 0.5), xyz=xyz,
       text ="FAST\n White Matter\n Segmentation")
dev.off()

## ----cache=FALSE, echo=FALSE---------------------------------------------
options(fsl.path="/usr/local/fsl")

## ----regwrite_template---------------------------------------------------
brain_to_temp = ants_regwrite(file = brain_img2,
                              template.file = "MNI152_T1_1mm_brain.nii.gz", 
                              typeofTransform = "SyN")

## ----plot_brain, echo=FALSE, results='hide', cache=FALSE-----------------
template_brain = readNIfTI("MNI152_T1_1mm_brain.nii.gz", reorient=FALSE)
png("Template_brain.png")
orthographic(robust_window(template_brain), text="Template Brain \n Image")
dev.off()
png("SyN_Reg_Image.png")
orthographic(robust_window(brain_to_temp), 
             text = "Registered \n N4-Corrected\n Image")
dev.off()

## ----check_fsl-----------------------------------------------------------
Sys.getenv("FSLDIR")
library(fslr)
have.fsl()

## ----check_fsl_set, eval=FALSE-------------------------------------------
## options(fsl.path="/my/path/to/fsl")

