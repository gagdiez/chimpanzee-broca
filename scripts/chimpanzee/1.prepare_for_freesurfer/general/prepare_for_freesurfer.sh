# This file prepares the nifti file to be run in freesurfer

while getopts s:b:c:i:t:p:l:f opts; do
   case ${opts} in
      s) S=${OPTARG} ;;      # subject name
      b) BiTHR=${OPTARG} ;;  # background threhold superior
      c) BsTHR=${OPTARG} ;;  # background threhold inferior
      i) ITHR=${OPTARG} ;;   # inversion threhold
      p) BORDER=${OPTARG} ;; # border thickness to remove (pixels)
      l) LAPLACIAN=${OPTARG} ;; # laplacian threshold to remove
      f) FLIP=1 ;;           # flip flag
      t) THRend=${OPTARG} ;; # final threshold
   esac
done

if [ $# < 4 ]
then
    echo
    echo "Usage: ./prepare_for_freesurfer.sh -s <subject_name> -b <bckgrnd_inf_threshold> -c <bkgrnd_sup_threshold> -i <inversion_threshold> -t <border_to_remove> [-f]"
    exit 1
fi

BASE=./original_data
NIFTI=$BASE/$S/nii/data.nii.gz

if [ ! -f $NIFTI ]
then
    echo
    echo "File $NIFTI does not exist"
    echo
    exit 1
fi

sub="${S,,}" # to lowercase
SCRIPTS=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OUT=./results/$sub

echo $OUT
mkdir $OUT -p

rm $OUT/* -f

echo - STEP 1: .img to .nii in approx. freesurfer orientation
mrconvert $NIFTI $OUT/orig.nii -axes 0,2,1
echo - STEP 2: Flip if necesary
if [ -z "$FLIP" ]
then
    echo " No Flip"
else
    echo " Flipping image"
    mrtransform $OUT/orig.nii $OUT/orig.nii -flip 1 -force
fi

echo - STEP 3: Remove background
$SCRIPTS/gaussian_masking.py $OUT/orig.nii $OUT/${sub}_masked.nii $BiTHR $BsTHR
$SCRIPTS/biggest_component.py $OUT/${sub}_masked.nii $OUT/${sub}_masked.nii

echo - STEP 4: Change resolution to 0.7 for performance 
mrgrid $OUT/${sub}_masked.nii regrid -voxel 0.7 $OUT/${sub}_masked_resized.nii

fslmaths $OUT/${sub}_masked_resized.nii -thr 0 $OUT/${sub}_masked_resized.nii.gz

echo - STEP 5: Invert colors
if [ -z "$ITHR" ]
then
    echo No invert
    mrconvert $OUT/${sub}_masked_resized.nii.gz $OUT/${sub}_masked_resized_inverted.nii -force
else
    $SCRIPTS/invert_intensities.py $OUT/${sub}_masked_resized.nii $OUT/${sub}_masked_resized_inverted.nii $ITHR
fi

echo - STEP 6: Remove outter ring
$SCRIPTS/remove_high_border_values.py $OUT/${sub}_masked_resized_inverted.nii $OUT/${sub}_masked_resized_inverted_noborder.nii $BORDER $LAPLACIAN

echo - STEP 7: Applyign Minimum blurring
fslmaths $OUT/${sub}_masked_resized_inverted_noborder.nii -s 0.4 $OUT/${sub}_masked_resized_inverted_noborder_gauss.nii.gz

fslmaths $OUT/${sub}_masked_resized_inverted_noborder_gauss.nii.gz -sub $THRend -thr 0 $OUT/${sub}_masked_resized_inverted_noborder_gauss_thresholded.nii

# Rename final file to "${sub}.nii"
mv $OUT/${sub}_masked_resized_inverted_noborder_gauss_thresholded.nii.gz $OUT/${sub}.nii.gz

gzip -d $OUT/${sub}.nii.gz -f

#rm $OUT/${sub}_masked*
