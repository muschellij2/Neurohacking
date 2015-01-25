library(oro.nifti)
library(fslr)
library(AnalyzeFMRI)

setwd('/Users/elizabethsweeney/Dropbox/Elizabeth_Sweeney_Documents/Current_Projects/Neurohacking/Basic_Data_Manipulations/Figures')
mridir <- '/Users/elizabethsweeney/Dropbox/Elizabeth_Sweeney_Documents/Current_Projects/Neurohacking/Basic_Data_Manipulations/Kirby21'

T1 <- readNIfTI(file.path(mridir, '/SUBJ0001-01-MPRAGE.nii.gz'), 
  reorient=FALSE)
mask <- readNIfTI(file.path(mridir, '/SUBJ0001_mask.nii.gz'), 
                  reorient=FALSE) 

pdf('orthoT1.pdf')
orthographic(T1)
dev.off()

pdf('mask.pdf')
orthographic(mask)
dev.off()

masked.T1 <- niftiarr(T1, T1*mask)

pdf('maskT1.pdf')
orthographic(masked.T1)
dev.off()


T1.follow <- readNIfTI(file.path(mridir, '/SUBJ0001-02-MPRAGE.nii.gz'), 
                       reorient=FALSE)

subtract.T1 <- niftiarr(T1, T1.follow - T1)

pdf('subtractT1.pdf')
orthographic(subtract.T1)
dev.off()


T1.base.process <- readNIfTI(file.path(mridir, '/SUBJ0001-01-MPRAGE_N3.nii.gz'), 
                reorient=FALSE)


T1.follow.process <- readNIfTI(file.path(mridir, '/SUBJ0001-02-MPRAGE_N3_REG.nii.gz'), 
                             reorient=FALSE)

subtract.T1.process <- niftiarr(T1, T1.follow.process - T1.base.process)

pdf('processsubtractT1.pdf')
orthographic(subtract.T1.process)
dev.off()
