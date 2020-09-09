#!/bin/bash

datRawDir='/Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/'
datWorkDir='/Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/restingstatepipelineNFP/'
datFSDir='/Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/fmriprep/'

sublist='sub-MBB001
sub-MBB002
sub-MBB003
sub-MBB004
sub-MBB005'

sessions='ses-01
ses-02'

for sub in ${sublist}
do  
    mkdir ${datWorkDir}${sub}
          
    for sesh in ${sessions}
    do
    mkdir ${datWorkDir}${sub}/${sesh}
    mkdir ${datWorkDir}${sub}/${sesh}/func
    cp ${datRawDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_bold.nii.gz ${datWorkDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_bold.nii.gz
    cd ${datWorkDir}${sub}/${sesh}/func
    gunzip -f ./*bold.nii.gz
    cd ${datWorkDir}    
    mkdir ${datWorkDir}${sub}/${sesh}/anat
    cp ${datRawDir}derivatives/dtipipeline/${sub}/${sesh}/Analyze/MPRAGE/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii ${datWorkDir}${sub}/${sesh}/anat/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii
    cp ${datFSDir}${sub}/anat/${sub}_desc-aparcaseg_dseg.nii.gz ${datWorkDir}${sub}/${sesh}/anat/${sub}_desc-aparcaseg_dseg.nii.gz
    cp ${datFSDir}${sub}/anat/${sub}_desc-preproc_T1w.nii.gz ${datWorkDir}${sub}/${sesh}/anat/fslbrain.nii.gz
    mkdir ${datWorkDir}${sub}/${sesh}/freeMask
    cp ${datFSDir}${sub}/anat/${sub}_desc-aparcaseg_dseg.nii.gz ${datWorkDir}${sub}/${sesh}/freeMask/${sub}_desc-aparcaseg_dseg.nii.gz
    
    done
done
