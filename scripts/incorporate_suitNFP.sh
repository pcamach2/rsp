#!/bin/bash
sublist='sub-SUB001'

sessions='ses-01'

SUITS_names=/scripts/SUIT_ROI_names.txt
SUITS_offset=3000;
scripts=/scripts
NFPdir=/data/HDC/derivatives/restingstatepipelineNFP/

for SUB in ${sublist}
do       
    for sesh in ${sessions}
    do
    RESDIR=${NFPdir}${SUB}/${sesh}/freeMask
    SUIT_parc_file=${NFPdir}${SUB}/${sesh}/anat/iw_Lobules-SUIT_u_a_IMG_brain_seg1.nii

    cd ${RESDIR}

    fslmaths mask.nii.gz -thr 0.5 -bin binMask
    fslmaths binMask -sub 1 -abs antiBinMask
    fslmaths ${SUIT_parc_file} -mas antiBinMask maskedSuits.nii.gz

    fslmaths ${NFPdir}${SUB}/${sesh}/anat/fslbrain.nii.gz -thr 0.5 -bin binFREEMASK
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

