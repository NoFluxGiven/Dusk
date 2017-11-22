// Created by Crowbar 0.24.0.0

$modelname "heroes/rubick/rubick_staff.mdl"

$bodygroup "default"
{
	studio "rubick_staff_reference.smd"
}

$lod 1
{
	replacemodel "rubick_staff_reference.smd" "rubick_staff_model_lod1.smd"
}

$cdmaterials ""

$texturegroup "skinfamilies"
{
	{
		"models\heroes\rubick\rubick_staff.vmt"
	}
	{
		"models\heroes\rubick\rubick_staff_staticremnant.vmt"
	}
}

$surfaceprop "default"

$contents "solid"


// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "Root_0" "" 0 101.805443 13.248837 0 -1.570796 -1.570796 0 0 0 0 0 0
// $definebone "Staff_1" "Root_0" 57.322487 40.913467 58.462761 1.928001 -0.068854 2.002607 0 0 0 0 0 0




$sequence "BindPose" "rubick_staff_anims\BindPose.smd" {
	fps 30
}


$keyvalues
{
}
