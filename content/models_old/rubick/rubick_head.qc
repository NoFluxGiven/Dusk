// Created by Crowbar 0.24.0.0

$modelname "heroes/rubick/rubick_head.mdl"

$bodygroup "default"
{
	studio "rubick_head_reference.smd"
}

$lod 1
{
	replacemodel "rubick_head_reference.smd" "rubick_head_model_lod1.smd"
}

$cdmaterials ""

$surfaceprop "default"

$contents "solid"


// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "Root_0" "" 0 101.805443 13.248837 0 -1.570796 -1.570796 0 0 0 0 0 0
// $definebone "Spine_3" "Root_0" -1.07314 0 72.584953 0 -1.51779 0 0 0 0 0 0 0
// $definebone "clavicle_L" "Spine_3" -4.942749 5.064597 -6.689816 1.570796 -0.405257 1.496007 0 0 0 0 0 0
// $definebone "Head_0" "Spine_3" 13.777847 0 0.000003 0 -0.009409 0 0 0 0 0 0 0
// $definebone "Head_1" "Head_0" 26.469299 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "PonyTail0_0" "Head_1" -6.154834 -0.000001 25.043823 0 0 0 0 0 0 0 0 0




$sequence "BindPose" "rubick_head_anims\BindPose.smd" {
	fps 30
}


$keyvalues
{
}
