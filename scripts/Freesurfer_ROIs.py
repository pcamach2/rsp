#!/usr/bin/python
# Creates ROI masks fom Freesurfer parcellation (which has previously been transformed to DTI Space)

import os
import nipype.interfaces.fsl as fsl
import csv
import subprocess
import logging
import shutil


parcellation_num = 68 # The number of regions which we are parcellating
#parcellation_num = int(os.environ['parcellation_number']) # The number of regions which we are using
parcellation_labels_file = os.environ['parcellation_labels_file'] # This would be aparc_labels.txt 
data = os.environ['DATA']

logging.basicConfig(format='%(asctime)s %(message)s ',
                    datefmt='%m/%d/%Y %I:%M:%S %p', level=logging.INFO)

numbers = str(raw_input('Enter subject numbers and sessions e.g. sub-MBB001/ses-01: ')).split()

for subnum in numbers:
    outdir = '{}/{}/freeMask'.format(data, subnum)

    Freesurfer_Regions_dict = {}
    Freesurfer_Regions_list = []

    with open(parcellation_labels_file, 'r') as f:
        for line in range(parcellation_num):
            current_line = f.readline()
            if line == parcellation_num - 1:
                current_line = current_line.split()
            else:
                current_line = current_line[:-1]
                current_line = current_line.split()
            Freesurfer_Regions_dict[current_line[1]] = int(current_line[0])
            Freesurfer_Regions_list.append(current_line[1])


    os.mkdir('{}/rois'.format(outdir))
    # create text file with all ROI masks (masks.txt)
    with open('{}/masks.txt'.format(outdir), 'w') as f:
        for roi in Freesurfer_Regions_list:
            f.write('{}/rois/{}.nii.gz\n'.format(outdir, roi))


    ROI_volumes_csv = []


   # create each ROI niftii file
    for index in range(parcellation_num):           # index goes 1:68
        # print 'Region Number {}'.format(index+1)
        x = Freesurfer_Regions_dict[Freesurfer_Regions_list[index]]
        get_ROI = fsl.maths.Threshold()
        get_ROI.inputs.in_file = '{}/{}_task-rest_dir-PA_rec-uncorrected_run-1_space-MNI152NLin2009cAsym_desc-aparcaseg_dseg.nii.gz'.format(outdir,subnum[:10])
        get_ROI.inputs.thresh = x - 0.5
        get_ROI.inputs.args = '-uthr {}'.format(x + 0.5)
        get_ROI.inputs.out_file = '{}/rois/{}.nii.gz'.format(
            outdir, Freesurfer_Regions_list[index])
        get_ROI.run()

        # get volume
        current_ROI_file = '{}/rois/{}.nii.gz'.format(
            outdir, Freesurfer_Regions_list[index])
        get_volume_ROI = fsl.ImageStats(
            in_file=current_ROI_file, op_string='-V > {}/ROI_volumes.txt'.format(outdir))
        get_volume_ROI.run()

        roi_volumes_line = [Freesurfer_Regions_list[index]]
        with open('{}/ROI_volumes.txt'.format(outdir), 'r') as f:
            lines = f.readlines()
            line = lines[0].split()
        roi_volumes_line.append(line[0])
        ROI_volumes_csv.append(roi_volumes_line)

    with open('{}/ROI_Volumes.csv'.format(outdir), 'w') as f:
        writer = csv.writer(f)
        writer.writerows(ROI_volumes_csv)

    # convert individual mask files into aggregate mask
    thisprocstr = str(os.path.dirname(os.path.realpath(__file__)) + "/maskCat " + outdir)
    logging.info('Running: ' + thisprocstr)
    subprocess.Popen(thisprocstr,shell=True).wait()
