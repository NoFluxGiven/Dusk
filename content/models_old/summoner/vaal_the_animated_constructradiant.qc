// Created by Crowbar 0.24.0.0

$modelname "items/courier/vaal_the_animated_constructradiant/vaal_the_anim"

$bodygroup "default"
{
	studio "vaal_the_animated_constructradiant_reference.smd"
}

$lod 1
{
	replacemodel "vaal_the_animated_constructradiant_reference.smd" "vaal_the_animated_constructradiant_lod1.smd"
}

$poseparameter "turn" -1 1 0

$cdmaterials ""

$attachment "attach_eye_l" "Golem_head" 0 0 0 rotate 0 0 0
$attachment "attach_eye_r" "Golem_head" 0 0 0 rotate 0 0 0
$attachment "attach_hitloc" "Golem_head" 0 0 0 rotate 0 0 0

$surfaceprop "default"

$contents "solid"

// $hboxset "default"
// $hbox 0 "GolemPivot" -2.691 -1.215 -7.856999 0 0 7.856999
// $hbox 0 "GolemLLeg1" -4.203 -9.558 -8.945999 14.822999 12.023999 8.154
// $hbox 0 "GolemLLeg2" -3.825 -5.67 -4.608 14.031 5.013 4.041
// $hbox 0 "GolemLLegAnkle" -4.824 -4.608 -3.717 10.17 4.59 4.617
// $hbox 0 "GolemSpine1" -10.818 -16.983 -18.018 17.900999 20.268 16.83
// $hbox 0 "GolemSpine2" -19.178999 -17.261999 -18.018 12.284999 20.709 16.83
// $hbox 0 "GolemSpine3" -21.302999 -38.177998 -36.269997 41.300999 25.362 49.068001
// $hbox 0 "GolemChest" 0 0 -12.123 13.176 4.878 12.123
// $hbox 0 "Golem_head" -8.514 -11.763 -11.952 8.270999 17.775 9.035999
// $hbox 0 "GolemLArm1" -17.018999 -12.851999 -12.302999 28.799999 15.48 15.327001
// $hbox 0 "GolemLArm2" -1.386 -12.492 -7.533 23.705999 9.351 12.249
// $hbox 0 "GolemLArmPalm" -18.980999 -12.24 -9.414 19.484999 17.927999 12.599999
// $hbox 0 "GolemRArm1" -2.421 -15.146999 -16.334999 28.737 12.654 10.728
// $hbox 0 "GolemRArm2" -1.746 -12.834 -12.447 24.344999 9.513 7.677
// $hbox 0 "GolemRArmPalm" -19.313999 -12.438 -12.627 18.872999 17.927999 9.414
// $hbox 0 "GolemRLeg1" -5.517 -9.342 -5.517 14.805 11.448 9.801
// $hbox 0 "GolemRLeg2" -3.078 -6.624 -4.365 13.923 5.013 5.175
// $hbox 0 "GolemRLegAnkle" -4.743 -4.635 -4.545 10.17 4.644 3.69
// $hboxset "select_high"
// $hbox 0 "GolemPivot" -18 -22.5 -18 54 13.5 18
// $hboxset "select_low"
// $hbox 0 "GolemPivot" -18 -67.5 -58.5 54 58.5 58.5

// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "GolemPivot" "" 0 26.662155 6.604067 1.570796 0 1.570797 0 0 0 0 0 0
// $definebone "GolemLLeg1" "GolemPivot" -2.991657 -1.353974 8.733232 3.029467 -0.411934 2.631746 0 0 0 0 0 0
// $definebone "GolemLLeg2" "GolemLLeg1" 10.153626 0.000008 0.000093 0.159332 -0.067324 -0.615261 0 0 0 0 0 0
// $definebone "GolemLLegAnkle" "GolemLLeg2" 10.831983 0.000003 -0.000001 -0.312295 0.141122 1.083069 0 0 0 0 0 0
// $definebone "GolemSpine1" "GolemPivot" 0 0 0 0 0 -0.079366 0 0 0 0 0 0
// $definebone "GolemSpine2" "GolemSpine1" 13.647873 0 0.000002 0 0 0.090161 0 0 0 0 0 0
// $definebone "GolemSpine3" "GolemSpine2" 13.647884 0 -0.000001 0 0 0.281422 0 0 0 0 0 0
// $definebone "GolemChest" "GolemSpine3" 13.647888 0 0.000001 0 0 0.144116 0 0 0 0 0 0
// $definebone "Golem_head" "GolemChest" 14.636009 5.421162 0 0 0 0.523599 0 0 0 0 0 0
// $definebone "GolemLArmCollarbone" "GolemChest" 0 -0.000002 13.46607 2.542522 -1.436807 -2.500929 0 0 0 0 0 0
// $definebone "GolemLArm1" "GolemLArmCollarbone" 10.191362 -0.000006 0.000008 -0.460234 -0.535185 0.307187 0 0 0 0 0 0
// $definebone "GolemLArm2" "GolemLArm1" 19.072788 -0.000014 -0.000076 -1.422529 -0.060673 0.11784 0 0 0 0 0 0
// $definebone "GolemLArmPalm" "GolemLArm2" 14.00633 0.000076 -0.000017 0.224257 -0.212778 -0.033947 0 0 0 0 0 0
// $definebone "GolemLArmDigit11" "GolemLArmPalm" 19.920465 5.17804 -1.31638 -0.273305 0.136261 0.750088 0 0 0 0 0 0
// $definebone "GolemLArmDigit12" "GolemLArmDigit11" 11.361504 0.000031 -0.000058 0.037418 -0.048697 -0.655654 0 0 0 0 0 0
// $definebone "GolemLArmDigit21" "GolemLArmPalm" 19.283506 -3.046215 5.284578 0.258442 -1.049516 -0.172093 0 0 0 0 0 0
// $definebone "GolemLArmDigit22" "GolemLArmDigit21" 11.340055 -0.000034 0.000042 -0.033777 0.803254 -0.115554 0 0 0 0 0 0
// $definebone "GolemLArmDigit31" "GolemLArmPalm" 19.486977 -3.119148 -2.640398 -0.918706 0.547149 -0.631482 0 0 0 0 0 0
// $definebone "GolemLArmDigit32" "GolemLArmDigit31" 11.34006 0.000065 0.000021 0.029003 -0.726388 -0.042045 0 0 0 0 0 0
// $definebone "GolemRArmCollarbone" "GolemChest" -0.000008 -0.000002 -13.46607 -2.542521 1.436807 -2.500927 0 0 0 0 0 0
// $definebone "GolemRArm1" "GolemRArmCollarbone" 10.191357 -0.000002 0.000008 0.460234 0.535185 0.307187 0 0 0 0 0 0
// $definebone "GolemRArm2" "GolemRArm1" 19.072783 0.000015 -0.000107 1.422529 0.060673 0.11784 0 0 0 0 0 0
// $definebone "GolemRArmPalm" "GolemRArm2" 14.006347 -0.000076 -0.000021 -0.224257 0.212778 -0.033947 0 0 0 0 0 0
// $definebone "GolemRArmDigit11" "GolemRArmPalm" 19.920416 5.177742 1.316191 0.273305 -0.136261 0.750088 0 0 0 0 0 0
// $definebone "GolemRArmDigit12" "GolemRArmDigit11" 11.361412 -0.000031 -0.00006 -0.037418 0.048697 -0.655654 0 0 0 0 0 0
// $definebone "GolemRArmDigit21" "GolemRArmPalm" 19.2836 -3.046425 -5.28464 -0.258442 1.049516 -0.172093 0 0 0 0 0 0
// $definebone "GolemRArmDigit22" "GolemRArmDigit21" 11.340063 0.000019 0.000031 0.033777 -0.803254 -0.115554 0 0 0 0 0 0
// $definebone "GolemRArmDigit31" "GolemRArmPalm" 19.487026 -3.119453 2.640308 0.918706 -0.547149 -0.631482 0 0 0 0 0 0
// $definebone "GolemRArmDigit32" "GolemRArmDigit31" 11.340137 -0.000072 0.000019 -0.029003 0.726388 -0.042045 0 0 0 0 0 0
// $definebone "GolemRLeg1" "GolemPivot" -2.991659 -1.353975 -8.733232 -3.029417 0.411907 2.631871 0 0 0 0 0 0
// $definebone "GolemRLeg2" "GolemRLeg1" 10.153634 0.000118 -0.00006 -0.159376 0.067261 -0.61478 0 0 0 0 0 0
// $definebone "GolemRLegAnkle" "GolemRLeg2" 10.831335 0.000019 -0.000002 0.312429 -0.141138 1.0827 0 0 0 0 0 0


$animation "courier_turn_center" "vaal_the_animated_constructradiant_anims\courier_turn_center.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "courier_turn_center" 0
}
$animation "courier_turn_left" "vaal_the_animated_constructradiant_anims\courier_turn_left.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "courier_turn_center" 0
}
$animation "courier_turn_right" "vaal_the_animated_constructradiant_anims\courier_turn_right.smd" {
	fps 30
	// This subtract line guesses the animation name and frame index. There is no way to determine which $animation and which frame was used. Change as needed.
	subtract "courier_turn_center" 0
}


$sequence "courier_idle" "vaal_the_animated_constructradiant_anims\courier_idle.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 1
	loop
}

$sequence "courier_idle_rare" "vaal_the_animated_constructradiant_anims\courier_idle_rare.smd" {
	fps 30
	activity "ACT_DOTA_IDLE_RARE" 1
	loop
}

$sequence "courier_spawn" "vaal_the_animated_constructradiant_anims\courier_spawn.smd" {
	fps 30
	activity "ACT_DOTA_SPAWN" 1
}

$sequence "courier_death" "vaal_the_animated_constructradiant_anims\courier_death.smd" {
	fps 30
	activity "ACT_DOTA_DIE" 1
}

$sequence "courier_run" "vaal_the_animated_constructradiant_anims\courier_run.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
	addlayer "courier_turns"
}

$sequence "center_pose" "vaal_the_animated_constructradiant_anims\center_pose.smd" {
	fps 30
}

$sequence "left_pose" "vaal_the_animated_constructradiant_anims\left_pose.smd" {
	fps 30
}

$sequence "right_pose" "vaal_the_animated_constructradiant_anims\right_pose.smd" {
	fps 30
}

$sequence "courier_turns" {
	"courier_turn_left"
	"courier_turn_center"
	"courier_turn_right"
	fps 30
	delta
	blendwidth 3
	blend "turn" -1 1
}

