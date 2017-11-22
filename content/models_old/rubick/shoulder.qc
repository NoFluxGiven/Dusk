// Created by Crowbar 0.24.0.0

$modelname "heroes/rubick/shoulder.mdl"

$bodygroup "default"
{
	studio "shoulder_reference.smd"
}

$lod 1
{
	replacemodel "shoulder_reference.smd" "shoulder_model_lod1.smd"
}

$cdmaterials ""

$texturegroup "skinfamilies"
{
	{
		"models\heroes\rubick\rubick_shoulder.vmt"
	}
	{
		"models\heroes\rubick\rubick_shoulder_staticremnant.vmt"
	}
}

$surfaceprop "default"

$contents "solid"


// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "Root_0" "" 0 101.805443 13.248837 0 -1.570796 -1.570796 0 0 0 0 0 0
// $definebone "Spine_3" "Root_0" -1.07314 0 72.584953 0 -1.51779 0 0 0 0 0 0 0
// $definebone "RTabord_R0C0" "Spine_3" 0.228882 -21.182943 -13.448996 1.476123 0.433617 2.919324 0 0 0 0 0 0
// $definebone "clavicle_L" "Spine_3" -4.942734 5.064598 -6.689816 1.570797 -0.405257 1.496007 0 0 0 0 0 0
// $definebone "clavicle_R" "Spine_3" -4.942734 -5.064597 -6.689815 -1.570796 0.405257 1.645585 0 0 0 0 0 0
// $definebone "RBRobe_R0C0" "Spine_3" -3.630859 -17.778255 15.750698 1.49808 0.005109 -3.113347 0 0 0 0 0 0
// $definebone "LTabord_R0C0" "Spine_3" 2.599625 22.07015 -13.798843 1.726936 0.605317 -2.871693 0 0 0 0 0 0
// $definebone "RTabord_R1C0" "RTabord_R0C0" 30.658607 -0.000015 0.00001 0.060955 0.192074 0.309436 0 0 0 0 0 0
// $definebone "RTabord_R2C0" "RTabord_R1C0" 31.243393 0.000011 -0.000006 0.008994 0.01981 -0.137622 0 0 0 0 0 0
// $definebone "bicep_L" "clavicle_L" 19.712433 -0.000008 -0.000031 -2.57615 0.970497 -1.252114 0 0 0 0 0 0
// $definebone "thumb_0_L" "bicep_L" 29.716011 0.957008 -41.312447 1.361336 1.112233 1.899275 0 0 0 0 0 0
// $definebone "LTabord_R1C0" "LTabord_R0C0" 35.56208 -0.000008 -0.000012 0.296832 0.043517 -0.031224 0 0 0 0 0 0




$sequence "BindPose" "shoulder_anims\BindPose.smd" {
	fps 30
}


$keyvalues
{
}
