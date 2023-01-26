export SUBJECTS_DIR=../2.process_with_freesurfer/results

SUBJ=$1
SUBJ="${SUBJ,,}" # to lowercase
SUBDIR=$SUBJECTS_DIR/${SUBJ}

# Inflate white surface 1mm
for h in lh rh
do
  mris_expand $SUBDIR/surf/$h.white 1 $SUBDIR/surf/$h.white_expanded
done

# Change surfaces to gifti
OUTDIR=./surfaces
mkdir $OUTDIR -p

for h in lh rh
do
  for surf in white white_expanded pial inflated sphere
  do
    mris_convert --to-scanner $SUBDIR/surf/$h.$surf $OUTDIR/$h.$surf.surf.gii
  done
done

# Change geometry to gifti
for h in lh rh
do
  for geo in sulc curv
  do
    mris_convert -c $SUBDIR/surf/$h.$geo $SUBDIR/surf/$h.sphere $OUTDIR/$h.$geo.shape.gii
  done
done
