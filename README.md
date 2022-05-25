A Whole-Brain 3D Myeloarchitectonic Atlas: Mapping the Vogt-Vogt Legacy to the Cortical Surface
=========
This repository contains a 3D MRI atlas containing detailed myeloarchitectural parcellations derived from Vogt & Vogt histological
data. It is based on the popular MNI-Colin27 brain template and has been validated on in-vivo MRI data.
As such, this atlas provides fine-grained cortical parcellations and is intended for use with both structural and functional imaging data and associated grey-level index maps provide information on myelin density per individual cortical field.

If you are implementing this atlas in your own research, please reference this [publication](https://doi.org/10.1101/2022.01.17.476369):
```
Foit, N. A., Yung, S., Lee, H. M., Bernasconi, A., Bernasconi, N., & Hong, S. J. (2022). A Whole-Brain 3D Myeloarchitectonic Atlas: Mapping the Vogt-Vogt Legacy to the Cortical Surface. bioRxiv.
```

The atlas includes:
1. Vogt-Vogt annotation files in MNI space (`*.annot`) for both hemispheres for use with FreeSurfer
2. Grey-level index maps in `Conte69` and `Colin27` space (``*.gii)``
3. Volumetric atlas versions in MNI space in NifTi file-format for both hemispheres (`vogt_multilabel_{rh,lh}.nii.gz`) with correspoding label descriptions
4. The `Colin27` brain template in NifTi format to facilitate registration purposes (`colin27_T1.nii.gz`)

Getting started
----
We provide code to apply the atlas to individual data which has been processed with FreeSurfer.
Please note that subjects needs to be processed with the recon -all pipeline prior to atlas application.

Usage notes
----
The atlas can be applied to individual data through the FreeSurfer command line interface and is fully scriptable.
Volumetric nifti-files are intended for use with imaging toolkits that do not use surface processing, e.g. SPM

How to get involved
----
If you've found a bug, are experiencing a problem, or have questions, create a new issue with some information about it!
Furthermore, we would appreciate your feedback on how implementing this atlas has helped your project.

Need help or questions
----
If you have any questions or need help, feel free to email us at `nfoit@bic.mni.mcgill.ca`

Licence
----
The MNI myeloarchitectonic atlas is licensed under the BDS-3 license, while FreeSurfer environment uses a more restrictive framework.
Details and usage notes can be found here: [https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense). Further information on the MNI-Colin27 brain
template is available from [https://www.bic.mni.mcgill.ca/ServicesAtlases/Colin27](https://www.bic.mni.mcgill.ca/ServicesAtlases/Colin27)
