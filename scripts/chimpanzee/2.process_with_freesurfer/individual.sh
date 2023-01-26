export SUBJECTS_DIR=./results
EXPERT=./general/expert.opts

SCRIPTS=./general
SUBJ=C0408

T1=../1.prepare_for_freesurfer/results/$SUBJ/$SUBJ.nii

# Just to start it
recon-all -motioncor -s ${SUBJ} -i $T1 -expert $EXPERT -hires

# Nu doesn't work very well with this data, so lets just skip it
MRI=$SUBJECTS_DIR/$SUBJ/mri
cp $MRI/orig.mgz $MRI/nu.mgz

recon-all -s ${SUBJ} -autorecon1 -talairach -notal-check -hires -normalization -nonuintensitycor -noskullstrip

# We are doing -noskullstrip, so we need to create mri/brainmask.mgz manually
cp $MRI/T1.mgz $MRI/brainmask.mgz

# We are doing -noskullstrip, so we need to create mri/brainmask.mgz manually
MRI=$SUBJECTS_DIR/$SUBJ/mri
cp $MRI/T1.mgz $MRI/brainmask.mgz

recon-all -s $SUBJ -autorecon2 -normneck -noskull-lta 

# Manual editing of wm (this needs human interaction before being run)
MANUAL=/data/pt_02101/external_data/Sherwood_Chimpanzee_MRI/2.process_with_freesurfer/wm_manual/$SUBJ.mgz
WM=$SUBJECTS_DIR/$SUBJ/mri/wm.mgz

cp $WM ${WM}_backup.mgz
cp $MANUAL $WM

# Finish the reconstruction
recon-all -s $SUBJ -autorecon2-wm -autorecon3 -noparcstats -noparcstats2 -nonormalization2 -nosegmentation