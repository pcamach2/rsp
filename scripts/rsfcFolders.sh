#!/bin/bash
#go to directory with restingstatepipeline outputs, make sure there's a difference between pre and post in labeling and no failed runs are in folder
cd /Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/restingstatepipeline/
ls | tee /Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/restingstatepipeline/rsfcSUITsFoldersPRE.txt
cd /Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/restingstatepipeline/
ls | tee /Users/pcamach2/Downloads/TDP_BIDS/HDCwsbref/derivatives/restingstatepipeline/rsfcSUITsFoldersPOST.txt
