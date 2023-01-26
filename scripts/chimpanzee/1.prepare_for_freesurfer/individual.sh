## Individual file - C0408

GENERAL=/data/pt_02101/external_data/Sherwood_Chimpanzee_MRI/1.prepare_for_freesurfer/scripts/general

$GENERAL/prepare_for_freesurfer.sh -s Anna -b 480 -i 347 -p 2 -h -t 203 -l 400

echo - Flip left-right
t1=/data/pt_02101/external_data/Sherwood_Chimpanzee_MRI/1.prepare_for_freesurfer/results/anna/anna.nii
mrtransform $t1 $t1 -flip 0 -force

echo - Running n4unbias

for i in 1 2 3 4 5 6 7 8;
do
    echo   Step $i
    N4BiasFieldCorrection -i $t1 -o $t1
done
