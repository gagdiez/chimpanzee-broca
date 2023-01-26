subj=$1

BASE=./

TEMPLATE=../3.transform_surfaces_and_ROIs/surfaces

OUTDIR=$BASE/4.create_atlas/results/$subj

TRANSFORM=$OUTDIR/transform
LABELS=$OUTDIR/labels

mkdir $TRANSFORM -p
mkdir $LABELS -p

for h in lh rh
do
    echo == MSM - $subj $h
    msm --refmesh=$SUBJDIR/surfaces/$h.sphere.surf.gii \
        --inmesh=$TEMPLATE/$h.sphere.surf.gii \
        --refdata=$SUBJDIR/surfaces/$h.sulc.shape.gii \
        --indata=$TEMPLATE/$h.sulc.shape.gii \
        --refanat=$SUBJDIR/surfaces/$h.pial.surf.gii \
        --inanat=$TEMPLATE/$h.pial.surf.gii \
        --out=$TRANSFORM/$h.INVERSE. \
        --conf=./chimp-to-juna-msm-config.txt

    echo == Invert Transform $subj $h
    wb_command -surface-modify-sphere $SUBJDIR/surfaces/$h.sphere.surf.gii 100 $TRANSFORM/$h.sphere.surf.gii -recenter

    wb_command -surface-sphere-project-unproject $TRANSFORM/$h.sphere.surf.gii \
                                                 $TRANSFORM/$h.INVERSE.sphere.reg.surf.gii \
                                                 $TEMPLATE/$h.sphere.centered.surf.gii \
                                                 $TRANSFORM/$h.subj2template.reg.surf.gii

    if [ $h == lh ]
    then
        STRUC=LEFT
    else
        STRUC=RIGHT
    fi

    echo == Apply Transform $subj $h
    msmresample $TRANSFORM/$h.subj2template.reg.surf.gii \
                $LABELS/$h.$subj.broca \
                -labels $SUBJDIR/labels/$h.broca.func.gii \
                -project $TEMPLATE/$h.sphere.centered.surf.gii

    wb_command -set-structure $LABELS/$h.$subj.broca.func.gii CORTEX_$STRUC
done
