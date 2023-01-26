BASE=./

SUBJ=$1
Subj="$(tr '[:lower:]' '[:upper:]' <<< ${SUBJ:0:1})${SUBJ:1}"

FREESURFER=$BASE/2.process_with_freesurfer/results/$SUBJ
ORIGROI=$BASE/3.original_cytoareas/
OUTDIR=$BASE/4.surf_and_rois/results/$SUBJ

SCRIPTS=$BASE/4.surf_and_rois/scripts

# Bring volumetric ROIs into Subject freesurfer-space
mkdir $OUTDIR/rois -p

mrthreshold -abs 1 $FREESURFER/mri/nu.mgz $OUTDIR/rois/bmask.nii -force

mrtransform $OUTDIR/rois/bmask.nii $OUTDIR/rois/bmask_flip.nii -flip 0 -force

flirt -in $ORIGROI/broca/nifti/$Subj.nii -ref $OUTDIR/rois/bmask_flip.nii \
      -out $OUTDIR/rois/broca_tmp.nii.gz -interp nearestneighbour \
      -omat $OUTDIR/rois/${SUBJ}_roi2free.txt -dof 7

mrtransform $OUTDIR/rois/broca_tmp.nii.gz $OUTDIR/rois/broca.nii.gz -flip 0 -force

# Project volume to surface of the subject
SURF=$BASE/surfaces

for h in lh rh
do
  surf=pial
  wb_command -volume-to-surface-mapping $OUTDIR/rois/broca.nii.gz $SURF/$h.$surf.surf.gii $OUTDIR/labels/$h.$surf.broca.func.gii -enclosing
done