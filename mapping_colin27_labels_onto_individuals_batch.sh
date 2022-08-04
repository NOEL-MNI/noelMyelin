#!/bin/bash 

export FREESURFER_HOME=/export01/local/freesurfer/
source $FREESURFER_HOME/SetUpFreeSurfer.sh

SUBJECTS_DIR= # /local_raid/seles/fs_individual/
 
CASES=${1} 
SRCDIR=${2} # /local_raid1/03_user/seokjun/01_project/08_Vogt_Vogt_mapping/02_data/Final/
print=''  

for CASE in `cat ${CASES}`; do

	${SRCDIR}/mapping_colin27_labels_onto_individuals.sh ${CASE} lh ${SRCDIR}
    ${SRCDIR}/mapping_colin27_labels_onto_individuals.sh ${CASE} lh ${SRCDIR}

done
