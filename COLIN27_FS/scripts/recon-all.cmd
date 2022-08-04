
 mri_convert /host/pandarus/local_raid/seles/colin27_tal.nii /host/pandarus/local_raid/seles/colin27/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Thu Sep  7 12:42:44 EDT 2017

 cp /host/pandarus/local_raid/seles/colin27/mri/orig/001.mgz /host/pandarus/local_raid/seles/colin27/mri/rawavg.mgz 


 mri_convert /host/pandarus/local_raid/seles/colin27/mri/rawavg.mgz /host/pandarus/local_raid/seles/colin27/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /host/pandarus/local_raid/seles/colin27/mri/transforms/talairach.xfm /host/pandarus/local_raid/seles/colin27/mri/orig.mgz /host/pandarus/local_raid/seles/colin27/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Thu Sep  7 12:43:02 EDT 2017

 mri_nu_correct.mni --n 1 --proto-iters 1000 --distance 50 --no-rescale --i orig.mgz --o orig_nu.mgz 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 


 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Thu Sep  7 12:49:00 EDT 2017

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /export01/local/freesurfer//bin/extract_talairach_avi_QA.awk /host/pandarus/local_raid/seles/colin27/mri/transforms/talairach_avi.log 


 tal_QC_AZS /host/pandarus/local_raid/seles/colin27/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Thu Sep  7 12:49:01 EDT 2017

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /host/pandarus/local_raid/seles/colin27/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Thu Sep  7 12:58:13 EDT 2017

 mri_normalize -g 1 nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Thu Sep  7 13:01:18 EDT 2017

 mri_em_register -skull nu.mgz /export01/local/freesurfer//average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /export01/local/freesurfer//average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Thu Sep  7 13:32:05 EDT 2017

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /export01/local/freesurfer//average/RB_all_2008-03-26.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Thu Sep  7 13:54:46 EDT 2017

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /export01/local/freesurfer//average/RB_all_2008-03-26.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Thu Sep  7 13:56:30 EDT 2017

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /export01/local/freesurfer//average/RB_all_2008-03-26.gca transforms/talairach.m3z 

#--------------------------------------
#@# CA Reg Inv Thu Sep  7 17:43:19 EDT 2017

 mri_ca_register -invert-and-save transforms/talairach.m3z 

#--------------------------------------
#@# Remove Neck Thu Sep  7 17:44:26 EDT 2017

 mri_remove_neck -radius 25 nu.mgz transforms/talairach.m3z /export01/local/freesurfer//average/RB_all_2008-03-26.gca nu_noneck.mgz 

#--------------------------------------
#@# SkullLTA Thu Sep  7 17:45:33 EDT 2017

 mri_em_register -skull -t transforms/talairach.lta nu_noneck.mgz /export01/local/freesurfer//average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull_2.lta 

#--------------------------------------
#@# SubCort Seg Thu Sep  7 18:11:37 EDT 2017

 mri_ca_label -align norm.mgz transforms/talairach.m3z /export01/local/freesurfer//average/RB_all_2008-03-26.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /host/pandarus/local_raid/seles/colin27/mri/transforms/cc_up.lta colin27 

#--------------------------------------
#@# Merge ASeg Thu Sep  7 18:34:47 EDT 2017

 cp aseg.auto.mgz aseg.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Thu Sep  7 18:34:47 EDT 2017

 mri_normalize -aseg aseg.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Thu Sep  7 18:38:44 EDT 2017

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Thu Sep  7 18:38:47 EDT 2017

 mri_segment brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Thu Sep  7 18:41:40 EDT 2017

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Thu Sep  7 18:42:30 EDT 2017

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Thu Sep  7 18:42:40 EDT 2017

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Thu Sep  7 18:42:46 EDT 2017

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Thu Sep  7 18:43:26 EDT 2017

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology lh Thu Sep  7 18:48:54 EDT 2017

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 colin27 lh 


 mris_euler_number ../surf/lh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 

#--------------------------------------------
#@# Make White Surf lh Thu Sep  7 19:05:20 EDT 2017

 mris_make_surfaces -noaparc -whiteonly -mgz -T1 brain.finalsurfs colin27 lh 

#--------------------------------------------
#@# Smooth2 lh Thu Sep  7 19:11:41 EDT 2017

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white ../surf/lh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Thu Sep  7 19:11:48 EDT 2017

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/lh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Thu Sep  7 19:14:12 EDT 2017

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm colin27 lh curv sulc 

#--------------------------------------------
#@# Sphere lh Thu Sep  7 19:14:19 EDT 2017

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Surf Reg lh Thu Sep  7 20:16:12 EDT 2017

 mris_register -curv ../surf/lh.sphere /export01/local/freesurfer//average/lh.average.curvature.filled.buckner40.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Thu Sep  7 20:49:52 EDT 2017

 mris_jacobian ../surf/lh.white ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Thu Sep  7 20:49:55 EDT 2017

 mrisp_paint -a 5 /export01/local/freesurfer//average/lh.average.curvature.filled.buckner40.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Thu Sep  7 20:49:57 EDT 2017

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 lh ../surf/lh.sphere.reg /export01/local/freesurfer//average/lh.curvature.buckner40.filled.desikan_killiany.2010-03-25.gcs ../label/lh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh Thu Sep  7 20:50:55 EDT 2017

 mris_make_surfaces -white NOWRITE -mgz -T1 brain.finalsurfs colin27 lh 

#--------------------------------------------
#@# Surf Volume lh Thu Sep  7 21:04:11 EDT 2017

 mris_calc -o lh.area.mid lh.area add lh.area.pial 


 mris_calc -o lh.area.mid lh.area.mid div 2 


 mris_calc -o lh.volume lh.area.mid mul lh.thickness 

#-----------------------------------------
#@# WM/GM Contrast lh Thu Sep  7 21:04:12 EDT 2017

 pctsurfcon --s colin27 --lh-only 

#-----------------------------------------
#@# Parcellation Stats lh Thu Sep  7 21:04:24 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab colin27 lh white 

#-----------------------------------------
#@# Cortical Parc 2 lh Thu Sep  7 21:04:48 EDT 2017

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 lh ../surf/lh.sphere.reg /export01/local/freesurfer//average/lh.destrieux.simple.2009-07-29.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Thu Sep  7 21:05:53 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab colin27 lh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Thu Sep  7 21:06:20 EDT 2017

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 lh ../surf/lh.sphere.reg /export01/local/freesurfer//average/lh.DKTatlas40.gcs ../label/lh.aparc.DKTatlas40.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Thu Sep  7 21:07:17 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas40.stats -b -a ../label/lh.aparc.DKTatlas40.annot -c ../label/aparc.annot.DKTatlas40.ctab colin27 lh white 

#--------------------------------------------
#@# Tessellate rh Thu Sep  7 21:07:42 EDT 2017

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 rh Thu Sep  7 21:07:52 EDT 2017

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 rh Thu Sep  7 21:07:58 EDT 2017

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere rh Thu Sep  7 21:08:38 EDT 2017

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology rh Thu Sep  7 21:13:55 EDT 2017

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 colin27 rh 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf rh Thu Sep  7 21:37:49 EDT 2017

 mris_make_surfaces -noaparc -whiteonly -mgz -T1 brain.finalsurfs colin27 rh 

#--------------------------------------------
#@# Smooth2 rh Thu Sep  7 21:44:27 EDT 2017

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 rh Thu Sep  7 21:44:33 EDT 2017

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/rh.inflated 


#-----------------------------------------
#@# Curvature Stats rh Thu Sep  7 21:46:57 EDT 2017

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm colin27 rh curv sulc 

#--------------------------------------------
#@# Sphere rh Thu Sep  7 21:47:04 EDT 2017

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg rh Thu Sep  7 22:41:29 EDT 2017

 mris_register -curv ../surf/rh.sphere /export01/local/freesurfer//average/rh.average.curvature.filled.buckner40.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white rh Thu Sep  7 23:15:47 EDT 2017

 mris_jacobian ../surf/rh.white ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv rh Thu Sep  7 23:15:50 EDT 2017

 mrisp_paint -a 5 /export01/local/freesurfer//average/rh.average.curvature.filled.buckner40.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc rh Thu Sep  7 23:15:53 EDT 2017

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 rh ../surf/rh.sphere.reg /export01/local/freesurfer//average/rh.curvature.buckner40.filled.desikan_killiany.2010-03-25.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf rh Thu Sep  7 23:16:50 EDT 2017

 mris_make_surfaces -white NOWRITE -mgz -T1 brain.finalsurfs colin27 rh 

#--------------------------------------------
#@# Surf Volume rh Thu Sep  7 23:30:32 EDT 2017

 mris_calc -o rh.area.mid rh.area add rh.area.pial 


 mris_calc -o rh.area.mid rh.area.mid div 2 


 mris_calc -o rh.volume rh.area.mid mul rh.thickness 

#-----------------------------------------
#@# WM/GM Contrast rh Thu Sep  7 23:30:33 EDT 2017

 pctsurfcon --s colin27 --rh-only 

#-----------------------------------------
#@# Parcellation Stats rh Thu Sep  7 23:30:46 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab colin27 rh white 

#-----------------------------------------
#@# Cortical Parc 2 rh Thu Sep  7 23:31:10 EDT 2017

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 rh ../surf/rh.sphere.reg /export01/local/freesurfer//average/rh.destrieux.simple.2009-07-29.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 rh Thu Sep  7 23:32:15 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab colin27 rh white 

#-----------------------------------------
#@# Cortical Parc 3 rh Thu Sep  7 23:32:41 EDT 2017

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 colin27 rh ../surf/rh.sphere.reg /export01/local/freesurfer//average/rh.DKTatlas40.gcs ../label/rh.aparc.DKTatlas40.annot 

#-----------------------------------------
#@# Parcellation Stats 3 rh Thu Sep  7 23:33:37 EDT 2017

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas40.stats -b -a ../label/rh.aparc.DKTatlas40.annot -c ../label/aparc.annot.DKTatlas40.ctab colin27 rh white 

#--------------------------------------------
#@# Cortical ribbon mask Thu Sep  7 23:34:01 EDT 2017

 mris_volmask --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon colin27 

#--------------------------------------------
#@# ASeg Stats Thu Sep  7 23:47:08 EDT 2017

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /export01/local/freesurfer//ASegStatsLUT.txt --subject colin27 

#-----------------------------------------
#@# AParc-to-ASeg Thu Sep  7 23:50:56 EDT 2017

 mri_aparc2aseg --s colin27 --volmask 


 mri_aparc2aseg --s colin27 --volmask --a2009s 

#-----------------------------------------
#@# WMParc Thu Sep  7 23:55:04 EDT 2017

 mri_aparc2aseg --s colin27 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject colin27 --surf-wm-vol --ctab /export01/local/freesurfer//WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA Labels lh Fri Sep  8 00:08:30 EDT 2017
INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /host/pandarus/local_raid/seles; ln -s /export01/local/freesurfer//subjects/fsaverage; cd - 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA1.label --trgsubject colin27 --trglabel ./lh.BA1.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA2.label --trgsubject colin27 --trglabel ./lh.BA2.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA3a.label --trgsubject colin27 --trglabel ./lh.BA3a.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA3b.label --trgsubject colin27 --trglabel ./lh.BA3b.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA4a.label --trgsubject colin27 --trglabel ./lh.BA4a.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA4p.label --trgsubject colin27 --trglabel ./lh.BA4p.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA6.label --trgsubject colin27 --trglabel ./lh.BA6.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA44.label --trgsubject colin27 --trglabel ./lh.BA44.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA45.label --trgsubject colin27 --trglabel ./lh.BA45.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.V1.label --trgsubject colin27 --trglabel ./lh.V1.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.V2.label --trgsubject colin27 --trglabel ./lh.V2.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.MT.label --trgsubject colin27 --trglabel ./lh.MT.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.perirhinal.label --trgsubject colin27 --trglabel ./lh.perirhinal.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA1.thresh.label --trgsubject colin27 --trglabel ./lh.BA1.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA2.thresh.label --trgsubject colin27 --trglabel ./lh.BA2.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA3a.thresh.label --trgsubject colin27 --trglabel ./lh.BA3a.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA3b.thresh.label --trgsubject colin27 --trglabel ./lh.BA3b.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA4a.thresh.label --trgsubject colin27 --trglabel ./lh.BA4a.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA4p.thresh.label --trgsubject colin27 --trglabel ./lh.BA4p.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA6.thresh.label --trgsubject colin27 --trglabel ./lh.BA6.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA44.thresh.label --trgsubject colin27 --trglabel ./lh.BA44.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.BA45.thresh.label --trgsubject colin27 --trglabel ./lh.BA45.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.V1.thresh.label --trgsubject colin27 --trglabel ./lh.V1.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.V2.thresh.label --trgsubject colin27 --trglabel ./lh.V2.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/lh.MT.thresh.label --trgsubject colin27 --trglabel ./lh.MT.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s colin27 --hemi lh --ctab /export01/local/freesurfer//average/colortable_BA.txt --l lh.BA1.label --l lh.BA2.label --l lh.BA3a.label --l lh.BA3b.label --l lh.BA4a.label --l lh.BA4p.label --l lh.BA6.label --l lh.BA44.label --l lh.BA45.label --l lh.V1.label --l lh.V2.label --l lh.MT.label --l lh.perirhinal.label --a BA --maxstatwinner --noverbose 


 mris_label2annot --s colin27 --hemi lh --ctab /export01/local/freesurfer//average/colortable_BA.txt --l lh.BA1.thresh.label --l lh.BA2.thresh.label --l lh.BA3a.thresh.label --l lh.BA3b.thresh.label --l lh.BA4a.thresh.label --l lh.BA4p.thresh.label --l lh.BA6.thresh.label --l lh.BA44.thresh.label --l lh.BA45.thresh.label --l lh.V1.thresh.label --l lh.V2.thresh.label --l lh.MT.thresh.label --a BA.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -mgz -f ../stats/lh.BA.stats -b -a ./lh.BA.annot -c ./BA.ctab colin27 lh white 


 mris_anatomical_stats -mgz -f ../stats/lh.BA.thresh.stats -b -a ./lh.BA.thresh.annot -c ./BA.thresh.ctab colin27 lh white 

#--------------------------------------------
#@# BA Labels rh Fri Sep  8 00:13:49 EDT 2017

 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA1.label --trgsubject colin27 --trglabel ./rh.BA1.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA2.label --trgsubject colin27 --trglabel ./rh.BA2.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA3a.label --trgsubject colin27 --trglabel ./rh.BA3a.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA3b.label --trgsubject colin27 --trglabel ./rh.BA3b.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA4a.label --trgsubject colin27 --trglabel ./rh.BA4a.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA4p.label --trgsubject colin27 --trglabel ./rh.BA4p.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA6.label --trgsubject colin27 --trglabel ./rh.BA6.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA44.label --trgsubject colin27 --trglabel ./rh.BA44.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA45.label --trgsubject colin27 --trglabel ./rh.BA45.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.V1.label --trgsubject colin27 --trglabel ./rh.V1.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.V2.label --trgsubject colin27 --trglabel ./rh.V2.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.MT.label --trgsubject colin27 --trglabel ./rh.MT.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.perirhinal.label --trgsubject colin27 --trglabel ./rh.perirhinal.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA1.thresh.label --trgsubject colin27 --trglabel ./rh.BA1.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA2.thresh.label --trgsubject colin27 --trglabel ./rh.BA2.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA3a.thresh.label --trgsubject colin27 --trglabel ./rh.BA3a.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA3b.thresh.label --trgsubject colin27 --trglabel ./rh.BA3b.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA4a.thresh.label --trgsubject colin27 --trglabel ./rh.BA4a.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA4p.thresh.label --trgsubject colin27 --trglabel ./rh.BA4p.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA6.thresh.label --trgsubject colin27 --trglabel ./rh.BA6.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA44.thresh.label --trgsubject colin27 --trglabel ./rh.BA44.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.BA45.thresh.label --trgsubject colin27 --trglabel ./rh.BA45.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.V1.thresh.label --trgsubject colin27 --trglabel ./rh.V1.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.V2.thresh.label --trgsubject colin27 --trglabel ./rh.V2.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /host/pandarus/local_raid/seles/fsaverage/label/rh.MT.thresh.label --trgsubject colin27 --trglabel ./rh.MT.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s colin27 --hemi rh --ctab /export01/local/freesurfer//average/colortable_BA.txt --l rh.BA1.label --l rh.BA2.label --l rh.BA3a.label --l rh.BA3b.label --l rh.BA4a.label --l rh.BA4p.label --l rh.BA6.label --l rh.BA44.label --l rh.BA45.label --l rh.V1.label --l rh.V2.label --l rh.MT.label --l rh.perirhinal.label --a BA --maxstatwinner --noverbose 


 mris_label2annot --s colin27 --hemi rh --ctab /export01/local/freesurfer//average/colortable_BA.txt --l rh.BA1.thresh.label --l rh.BA2.thresh.label --l rh.BA3a.thresh.label --l rh.BA3b.thresh.label --l rh.BA4a.thresh.label --l rh.BA4p.thresh.label --l rh.BA6.thresh.label --l rh.BA44.thresh.label --l rh.BA45.thresh.label --l rh.V1.thresh.label --l rh.V2.thresh.label --l rh.MT.thresh.label --a BA.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -mgz -f ../stats/rh.BA.stats -b -a ./rh.BA.annot -c ./BA.ctab colin27 rh white 


 mris_anatomical_stats -mgz -f ../stats/rh.BA.thresh.stats -b -a ./rh.BA.thresh.annot -c ./BA.thresh.ctab colin27 rh white 

#--------------------------------------------
#@# Ex-vivo Entorhinal Cortex Label lh Fri Sep  8 00:18:59 EDT 2017
INFO: lh.EC_average subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to lh.EC_average subject...

 cd /host/pandarus/local_raid/seles; ln -s /export01/local/freesurfer//subjects/lh.EC_average; cd - 


 mris_spherical_average -erode 1 -orig white -t 0.4 -o colin27 label lh.entorhinal lh sphere.reg lh.EC_average lh.entorhinal_exvivo.label 


 mris_anatomical_stats -mgz -f ../stats/lh.entorhinal_exvivo.stats -b -l ./lh.entorhinal_exvivo.label colin27 lh white 

#--------------------------------------------
#@# Ex-vivo Entorhinal Cortex Label rh Fri Sep  8 00:19:17 EDT 2017
INFO: rh.EC_average subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to rh.EC_average subject...

 cd /host/pandarus/local_raid/seles; ln -s /export01/local/freesurfer//subjects/rh.EC_average; cd - 


 mris_spherical_average -erode 1 -orig white -t 0.4 -o colin27 label rh.entorhinal rh sphere.reg rh.EC_average rh.entorhinal_exvivo.label 


 mris_anatomical_stats -mgz -f ../stats/rh.entorhinal_exvivo.stats -b -l ./rh.entorhinal_exvivo.label colin27 rh white 

