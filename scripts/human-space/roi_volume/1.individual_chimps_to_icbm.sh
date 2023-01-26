# The chimpanzee individual region (ba44, ba45) in the JUNA space
CHIMP_LABEL=$1
HUMAN=../../../results/human-comparison/MNI-surface-reconstruction
OUT=./results

for h in lh rh
do
        # Bring from Juna space to MNI space
        msmresample ../mapping-to-human/results/$h.chimp2human.reg.surf.gii \
                    $OUT/$CHIMP_LABEL \
                    -labels $CHIMP_LABEL \
                    -project $HUMAN/$h.sphere.centered.surf.gii

        # MAP to the MNI volumetric space
        wb_command -metric-to-volume-mapping $OUT/$CHIMP_LABEL \
                   ../../../human-comparison/MNI-surface-reconstruction/$h.midthicknes.surf.gii \
                   icbm152_asym_09c.nii.gz \
                   $OUT/$CHIMP_LABEL.nii.gz \
                   -ribbon-constrained \
                     ../../../human-comparison/MNI-surface-reconstruction/$h.white.surf.gii \
                     ../../../human-comparison/MNI-surface-reconstruction/$h.pial.surf.gii \
                     -greedy
    done
done
