## ----label=opts, results='hide', echo=FALSE, message = FALSE, warning=FALSE----
library(knitr)
library(highr)
opts_chunk$set(echo=TRUE, prompt=FALSE, message=FALSE, warning=FALSE, comment="", dev='png')
knit_hooks$set(inline = function(x) { 
  if (is.numeric(x)) return(knitr:::format_sci(x, 'latex')) 
  hi_latex(x) 
}) 
setwd("~/Dropbox/Neurohacking/File_Formats")

## ----read.dicom----------------------------------------------------------
library(oro.dicom)
slice = readDICOM('Example_DICOM.dcm')
class(slice)

## ----hdr.dicom-----------------------------------------------------------
names(slice)
class(slice$hdr)
class(slice$hdr[[1]])
class(slice$img)
class(slice$img[[1]])

## ----display.dicom, fig.width=4,fig.height=4,out.width='.8\\linewidth'----
image(t(slice$img[[1]]), col=gray(0:64/64))

## ----pixelspacing.dicom--------------------------------------------------
hdr = slice$hdr[[1]]
hdr[ hdr$name == 'PixelSpacing', "value"]

## ----multi.dicom, cache=FALSE--------------------------------------------
all_slices = readDICOM('T1/')

## ----nifti---------------------------------------------------------------
nii = dicom2nifti(all_slices)
dim(nii); class(nii)

## ----writenifti----------------------------------------------------------
library(oro.nifti)
writeNIfTI(nim = nii, filename = "Output_3D_File")
list.files(getwd(), pattern = "Output_3D_File")

