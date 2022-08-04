#!/bin/bash 

CASE=${1}   # Your individual subject index that was used in FreeSurfer processing (e.g., bert, subject1)
HEMI=${2}   # lh or rh
SRCDIR=${3} # /local_raid1/03_user/seokjun/01_project/08_Vogt_Vogt_mapping/02_data/Final/
PARCEL=${4} # select one among "vogt_vogt", "Baillarger_type" and "Intrusion_type"
print=''  

if [ "${PARCEL}" = "vogt_vogt" ]
then
    label_name=( 1 2 3 4 5 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 67III 67IV 68I 68II 68III 69 70med 70I 70II 71m 71I 71II 72 73I 73II 73III 74I 74II 75med 75sup 75if 76s 76i 77 78 79 80 81 82 83I 83II 83III 83IV 84 85I 85II 85III 85IV 86 87 88a 88p 89a 89m 89p 89ip 89t 90a 90m 90p 90ip 90t 90o 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111l 111m 112l 112m 113 114 115 116 117 118 119 BA18 BA17 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 )
elif [ "${PARCEL}" = "Baillarger_type" ]
then
    label_name=( Astriate Bistriate Unistriate Unitostriate Nodata )
elif [ "${PARCEL}" = "Intrusion_type" ]
then
    label_name=( Euradiate Infraradiate Supraradiate Nodata )
fi

echo ${label_name[@]}

if [ ! -e ${SUBJECTS_DIR}/${CASE}/label/${HEMI}.${PARCEL}.annot ]; then

	${print} mkdir ${SUBJECTS_DIR}/${CASE}/label/${PARCEL}/
	for label in "${label_name[@]}"
	do

		${print} mri_label2label --srclabel ${SRCDIR}/${HEMI}.colin27.${PARCEL}.label/${HEMI}.${label}.label --srcsubject COLIN27_FS --trglabel ${SUBJECTS_DIR}/${CASE}/label/${PARCEL}/${HEMI}.${label}.label --trgsubject ${CASE} --regmethod surface --hemi ${HEMI}
		
	done

	${print} mris_label2annot --s ${CASE} --h ${HEMI} --ctab ${SRCDIR}/${PARCEL}.ctab --a ${CASE}.${PARCEL} --ldir ${SUBJECTS_DIR}/${CASE}/label/${PARCEL}/ --nhits ${SUBJECTS_DIR}/${CASE}/overlapped_vertex.mgh --no-unknown

fi
