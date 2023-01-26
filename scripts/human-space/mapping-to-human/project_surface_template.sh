CHIMP=../../../results/chimpanzee-atlas/JUNA-surface-reconstruction
HUMAN=../../../results/human-comparison/MNI-surface-reconstruction
MSM=~/apps/msm_ubuntu_v3

OUTDIR=./results

TRANSFORM=$OUTDIR/transform
LABELS=$OUTDIR/chimp_regions
TMP=$OUTDIR/tmp
APARC=$OUTDIR/aparc

mkdir -p $TRANSFORM
mkdir -p $LABELS
mkdir -p $TMP

for h in lh rh
do
    echo == MSM - ANAT - $subj $h
    $MSM --refmesh=$CHIMP/$h.sphere.surf.gii \
         --inmesh=$HUMAN/$h.sphere.surf.gii \
         --refdata=$CHIMP/$h.aparc.shape.gii \
         --indata=$HUMAN/$h.aparc.shape.gii \
         --out=$TRANSFORM/$h.INVERSE.anat.

    echo == MSM - SULC - $subj $h
    $MSM --refmesh=$CHIMP/$h.sphere.surf.gii \
         --inmesh=$TRANSFORM/$h.INVERSE.anat.sphere.reg.surf.gii \
         --refdata=$CHIMP/$h.sulc.shape.gii \
         --indata=$HUMAN/$h.sulc.shape.gii \
         --out=$TRANSFORM/$h.INVERSE.final. \
         --conf=human-to-chimp-msm-config.txt

    echo == Invert Transform $subj $h
    wb_command -surface-sphere-project-unproject $CHIMP/$h.sphere.centered.surf.gii \
                                                 $TRANSFORM/$h.INVERSE.final.sphere.reg.surf.gii \
                                                 $HUMAN/$h.sphere.centered.surf.gii \
                                                 $TRANSFORM/$h.chimp2human.reg.surf.gii
    if [ $h == lh ]
    then
        STRUC=LEFT
    else
        STRUC=RIGHT
    fi

    echo == Apply Transform $subj $h
    for r in BA44 BA45 
    do
        msmresample $TRANSFORM/$h.chimp2human.reg.surf.gii \
                    $LABELS/chimp.$h.$r \
                    -labels $CHIMP/$h.$r.atlas.shape.gii \
                    -project $HUMAN/$h.sphere.centered.surf.gii

        wb_command -set-structure $LABELS/chimp.$h.$r.func.gii CORTEX_$STRUC
    done
done
