#!/bin/bash
sublist='sub-SUB001'

sessions='ses-01'

SUITS_names=/scripts/SUIT_ROI_names.txt
SUITS_offset=3000;
scripts=/scripts
Outdir=/data/HDC/derivatives/restingstatepipeline/

for SUB in ${sublist}
do       
    for sesh in ${sessions}
    do
    RESDIR=${Outdir}${SUB}/${sesh}/freeMask
    SUIT_parc_file=${Outdir}${SUB}/${sesh}/anat/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii

    cd ${RESDIR}
    
    flirt -cost mutualinfo -dof 6 -in ${Outdir}${SUB}/${sesh}/anat/BOLDrefBrain.nii.gz -ref ${Outdir}${SUB}/${sesh}/anat/IMG_brain.nii -omat bold2rage.mat -out bold_in_rage.nii.gz
    convert_xfm -omat rage2bold.mat -inverse bold2rage.mat
    flirt -interp nearestneighbour -in ${SUIT_parc_file} -ref ${Outdir}${SUB}/${sesh}/anat/BOLDrefBrain.nii.gz -applyxfm -init rage2bold.mat -out cereb_atlas_BOLD.nii.gz

    fslmaths mask.nii.gz -thr 0.5 -bin binMask
    fslmaths binMask -sub 1 -abs antiBinMask
    fslmaths cereb_atlas_BOLD.nii.gz -mas antiBinMask maskedSuits.nii.gz

    fslmaths ${Outdir}${SUB}/${sesh}/anat/BOLDrefBrain.nii.gz -thr 0.5 -bin binFREEMASK
    fslmaths binFREEMASK -sub 1 -abs antiFREEMASK
    fslmaths maskedSuits.nii.gz -mas antiFREEMASK outofbounds_Suits.nii.gz

    fslmaths outofbounds_Suits.nii.gz -thr 0.5 -bin binOutOfBounds
    fslmaths binOutOfBounds -sub 1 -abs antiOutOfBounds
    fslmaths maskedSuits.nii.gz -mas antiOutOfBounds extraMasked_Suits

    cd ${RESDIR}

    roi_num=1
    while read roi_name_tmp; do
     roi_lowthresh=$( echo "scale=2; $roi_num - 0.5" | bc )
     roi_highthresh=$( echo "scale=2; $roi_num + 0.5" | bc )
     echo "$roi_lowthresh"
     echo "$roi_name_tmp"
     fslmaths extraMasked_Suits -thr $roi_lowthresh -uthr $roi_highthresh roitmp
     fslmaths roitmp -div $roi_num -mul $SUITS_offset roi_offset 
   
     fslstats roitmp.nii.gz -V > roivolume.txt
     roi_volume_tmp=$( awk '{printf int($1); }' roivolume.txt )
     echo $roi_volume_tmp
     # read in volumes form suites
     echo "${roi_name_tmp},${roi_volume_tmp}" >> ROI_Volumes.csv
     ((roi_num+=1))      
    
     fslmaths roitmp -add roi_offset roitmp
     mv roitmp.nii.gz ./rois/${roi_name_tmp}.nii.gz 
    
     echo "${RESDIR}/rois/${roi_name_tmp}.nii.gz" >> masks.txt
    
    done <$SUITS_names    

    cd ${scripts}
    ./maskCat ${RESDIR}
    done
done

