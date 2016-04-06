## ----label=opts, results='hide', echo=FALSE, message = FALSE, warning=FALSE----
library(knitr)
library(highr)
opts_chunk$set(echo=TRUE, prompt=FALSE, message=FALSE, warning=FALSE, comment="", dev='png', out.height='0.5\\textheight,keepaspectratio',
               out.width='\\textwidth')
knit_hooks$set(inline = function(x) { 
  if (is.numeric(x)) return(knitr:::format_sci(x, 'latex')) 
  hi_latex(x) 
}) 
setwd("~/Dropbox/Neurohacking/Image_Visualization/")

## ----readnifti-----------------------------------------------------------
library(oro.nifti)
print({nii = readNIfTI(fname = "Output_3D_File")})

## ----image1, cache=TRUE--------------------------------------------------
image(nii[,,20])

## ----image.nifti, cache=TRUE---------------------------------------------
image(nii, z = 20, plot.type='single')

## ----image.mult, cache =TRUE---------------------------------------------
image(nii, z = 20)

## ----image.ortho, cache =TRUE--------------------------------------------
orthographic(nii)

## ----image.hist, cache =TRUE, fig.width=6, fig.height=3, out.width='\\textwidth'----
par(mfrow=c(1,2)); 
hist(nii, breaks = 2000); hist(nii[nii > 20], breaks = 2000)

## ----image.overlay, cache =TRUE------------------------------------------
library(fslr) # need niftiarr
mask = fslr::niftiarr(nii, nii > 300 & nii < 400)
mask[mask == 0] = NA
overlay(nii, mask, col.y= c("red"), 
        plot.type="single", z = 10)

## ----image.overlay.show, eval =FALSE-------------------------------------
## library(fslr) # need niftiarr
## mask = fslr::niftiarr(nii, nii > 300 & nii < 400)
## mask[mask == 0] = NA
## overlay(nii, mask, col.y= c("red"), 
##         plot.type="single", z = 10)

## ----image_ortho_overlay, cache =TRUE------------------------------------
orthographic(nii, mask, col.y= c("red"), 
             text ="Image overlaid with mask")

