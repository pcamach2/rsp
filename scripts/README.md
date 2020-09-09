#Be sure to have BXH/XCEDE tools installed from NITRC for your machine and added to the path variable

#Initialize Freesurfer, not really necessary if using fMRIPrep
export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/sources.sh

#Declare environmental variables for running the pipeline
#HeuDiConv results
export SUBS_DIR=/Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref
#Working directory for the pipeline
export DATA=$SUBS_DIR/derivatives/restingstatepipeline
#Output directory for pipeline results
export OUTPUT=$SUBS_DIR/derivatives/restingstatepipeline/out
#Scripts directory
export RSFCscripts=/Users/pcamach2/Downloads/BIDS_Pipeline/RSPipeline_BPS_withSUIT
#File with parcellation labels for Freesurfer cortical areas, this is not used after SUIT is added to the mask
export parcellation_labels_file=$RSFCscripts/aparc_labels.txt

#Then go to RSPipeline_BPS_withSUIT Script folder and run:
./RSFCprep.sh 
python2.7 ./maskGen    - no inputs, but it will ask to input subject name/session 
python2.7 ./FreeSurfer_ROIs.py - no inputs, but it will ask to input subject name/session      

./incorporate_suits4exp.sh
./path3SUIT subject_name/session

For BIDS-compatible original pipeline w/o fmriprep preprocessing of func in MNI152 space,
use files with NFP (no fmriprep) suffix
