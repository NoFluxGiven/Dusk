// Created by Crowbar 0.24.0.0

$modelname "heroes/rubick/cape.mdl"

$bodygroup "default"
{
	studio "cape_reference.smd"
}

$lod 1
{
	replacemodel "cape_reference.smd" "cape_model_lod1.smd"
}

$cdmaterials ""

$texturegroup "skinfamilies"
{
	{
		"models\heroes\rubick\rubick_robe.vmt"
	}
	{
		"models\heroes\rubick\rubick_robe_staticremnant.vmt"
	}
}

$surfaceprop "default"

$contents "solid"


// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "Root_0" "" 0 101.805443 13.248837 0 -1.570796 -1.570796 0 0 0 0 0 0
// $definebone "Spine_3" "Root_0" -1.07314 0 72.584953 0.000003 -1.51779 -0.000003 0 0 0 0 0 0
// $definebone "clavicle_L" "Spine_3" -4.942749 5.064598 -6.689817 1.570796 -0.405257 1.496007 0 0 0 0 0 0
// $definebone "LBRobe_R0C0" "Spine_3" -12.114792 19.332235 15.18074 1.454484 0.063602 -3.131016 0 0 0 0 0 0
// $definebone "clavicle_R" "Spine_3" -4.942734 -5.064599 -6.689815 -1.570796 0.405258 1.645586 0 0 0 0 0 0
// $definebone "FrontCloth1_0" "Spine_3" 10.341965 -0.000001 -19.941145 0 0 0 0 0 0 0 0 0
// $definebone "RBRobe_R0C0" "Spine_3" -3.630875 -17.778255 15.7507 1.498081 0.00511 -3.113346 0 0 0 0 0 0
// $definebone "bicep_L" "clavicle_L" 19.712433 -0.000008 -0.000031 -2.57615 0.970497 -1.252114 0 0 0 0 0 0
// $definebone "LFRobe_R0C0" "bicep_L" 33.430359 -8.982468 -0.957169 1.552683 -0.358214 0.297132 0 0 0 0 0 0
// $definebone "elbow_L" "bicep_L" 38.110275 0.000008 0 0.000019 1.537462 0.000019 0 0 0 0 0 0
// $definebone "LFRobe_R1C0" "LFRobe_R0C0" 87.940628 9.829605 -7.480286 0.127997 -0.428286 0.034081 0 0 0 0 0 0
// $definebone "LFRobe_R2C0" "LFRobe_R1C0" 45.35759 -0.000011 -0.000008 0.026124 -0.068992 0.04452 0 0 0 0 0 0
// $definebone "wrist_L" "elbow_L" 34.578819 0.000023 0 -0.491735 0.173477 0.439379 0 0 0 0 0 0
// $definebone "thumb_0_L" "wrist_L" 7.819435 2.386597 -8.415253 0 0 -0.000001 0 0 0 0 0 0
// $definebone "LBRobe_R1C0" "LBRobe_R0C0" 91.445412 0.000005 0.000008 0.099283 -0.392289 0.538233 0 0 0 0 0 0
// $definebone "LBRobe_R2C0" "LBRobe_R1C0" 69.439812 -0.000038 -0.000061 0.007935 0.008189 0.014167 0 0 0 0 0 0
// $definebone "RFRobe_R0C0" "clavicle_R" -25.686165 2.776627 -2.987595 0.138333 -1.426049 2.769269 0 0 0 0 0 0
// $definebone "thumb_1_R" "clavicle_R" -8.477408 48.687767 3.652237 0.986433 -0.408464 3.047877 0 0 0 0 0 0
// $definebone "RFRobe_R1C0" "RFRobe_R0C0" 43.230759 -0.000006 0 0.059647 -0.216307 -0.070142 0 0 0 0 0 0
// $definebone "RFRobe_R2C0" "RFRobe_R1C0" 54.82692 0.000002 0 -0.222275 0.238678 -0.032777 0 0 0 0 0 0
// $definebone "RFRobe_R3C0" "RFRobe_R2C0" 48.622101 0 0.000008 0.028225 0.172198 -0.023607 0 0 0 0 0 0
// $definebone "RBRobe_R1C0" "RBRobe_R0C0" 93.573723 0.000004 0.000021 0.10231 0.175199 0.406221 0 0 0 0 0 0
// $definebone "RBRobe_R2C0" "RBRobe_R1C0" 70.726295 -0.000027 0 0.039557 -0.004207 -0.004256 0 0 0 0 0 0




$sequence "BindPose" "cape_anims\BindPose.smd" {
	fps 30
}


$keyvalues
{
}
