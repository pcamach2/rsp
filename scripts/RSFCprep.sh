#!/bin/bash

datPrepDir='/data/derivatives/fmriprep/'
datWorkDir='/data/derivatives/restingstatepipeline/'
datRawDir='/data/'

mkdir ${datWorkDir}

sublist=$subjects

sessions=$sessions

for sub in ${sublist}
do  
    mkdir ${datWorkDir}${sub}

    for sesh in ${sessions}
    do
    mkdir ${datWorkDir}${sub}/${sesh}
    mkdir ${datWorkDir}${sub}/${sesh}/func
    cp ${datPrepDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz ${datWorkDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
    cd ${datWorkDir}${sub}/${sesh}/func
    gunzip -f ./*bold.nii.gz
    cd ${datWorkDir}    
    mkdir ${datWorkDir}${sub}/${sesh}/anat
    cd ${datRawDir}
    cp ${datRawDir}derivatives/dtipipeline/${sub}/${sesh}/Analyze/MPRAGE/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii ${datWorkDir}${sub}/${sesh}/anat/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii
    cp ${datPrepDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz ${datWorkDir}${sub}/${sesh}/anat/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz
    cp ${datPrepDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_boldref.nii.gz ${datWorkDir}${sub}/${sesh}/anat/BOLDrefBrain.nii.gz
    cp ${datPrepDir}${sub}/anat/${sub}_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz ${datWorkDir}${sub}/${sesh}/anat/fslbrain.nii.gz
    cp ${datRawDir}derivatives/dtipipeline/${sub}/${sesh}/Analyze/MPRAGE/IMG_brain.nii ${datWorkDir}${sub}/${sesh}/anat/IMG_brain.nii
    mkdir ${datWorkDir}${sub}/${sesh}/freeMask
    cp ${datPrepDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz ${datWorkDir}${sub}/${sesh}/anat/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz
    cp ${datPrepDir}${sub}/${sesh}/func/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz ${datWorkDir}${sub}/${sesh}/freeMask/${sub}_${sesh}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz
    done
done
