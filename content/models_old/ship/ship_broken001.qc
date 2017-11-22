// Created by Crowbar 0.24.0.0

$modelname "props_structures/ship_broken001.mdl"

$bodygroup "default"
{
	studio "ship_broken001_model.smd"
}
$bodygroup "clamped1"
{
	blank
}


$cdmaterials ""

$surfaceprop "default"

$contents "solid"


// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "root" "" 0 0 0 0 -1.258468 0 0 0 0 0 0 0
// $definebone "boat_body" "root" 294.350983 -9.569788 -17.065178 0 1.166696 0 0 0 0 0 0 0
// $definebone "midSail2_1" "boat_body" 67.366806 467.095612 303.02417 -1.576899 0.271494 -1.731326 0 0 0 0 0 0
// $definebone "mailSail2_0" "boat_body" 63.870026 549.80365 17.657349 -0.092227 -0.099248 -1.561633 0 0 0 0 0 0
// $definebone "midSail_R1C2" "midSail2_1" 43.430176 53.079895 118.21904 2.250088 -0.715116 -0.540854 0 0 0 0 0 0
// $definebone "midSail_R1C0" "midSail2_1" 80.653564 -118.866943 1.06945 2.236181 -0.833588 -0.571964 0 0 0 0 0 0
// $definebone "midSail_R2C2" "midSail_R1C2" 76.00354 5.36261 2.36969 0.011015 -0.021617 0.145866 0 0 0 0 0 0
// $definebone "midSail_R3C2" "midSail_R2C2" 68.008621 25.887878 5.019638 0.020166 -0.056598 0.128779 0 0 0 0 0 0
// $definebone "midSail_R2C0" "midSail_R1C0" 80.302963 10.01947 0.981354 0.036932 -0.082564 0.089457 0 0 0 0 0 0
// $definebone "midSail_R3C0" "midSail_R2C0" 82.567474 39.733887 6.256775 0.02431 -0.05663 0.013938 0 0 0 0 0 0
// $definebone "mainSail_R1C0" "mailSail2_0" 77.891052 -191.51886 -58.127594 2.236182 -0.833588 -0.571963 0 0 0 0 0 0
// $definebone "mainSail_R1C2" "mailSail2_0" 40.84613 107.345612 157.33374 2.250085 -0.715116 -0.540853 0 0 0 0 0 0
// $definebone "mainSail_R2C0" "mainSail_R1C0" 74.282227 0.000061 -0.000092 0.036932 -0.082563 0.089457 0 0 0 0 0 0
// $definebone "mainSail_R3C0" "mainSail_R2C0" 58.254486 -0.000092 0.000023 0.02431 -0.05663 0.013938 0 0 0 0 0 0
// $definebone "mainSail_R2C2" "mainSail_R1C2" 75.389549 7.895508 2.443573 0.011017 -0.021616 0.145867 0 0 0 0 0 0
// $definebone "mainSail_R3C2" "mainSail_R2C2" 71.511139 5.357117 4.538025 0.020166 -0.056598 0.128779 0 0 0 0 0 0
// $definebone "midSail_R0C0" "midSail2_1" 17.770691 -86.935516 -60.260601 2.178449 -0.748991 -0.488288 0 0 0 0 0 0
// $definebone "midSail_R0C2" "midSail2_1" -7.408447 83.739563 65.668015 2.124143 -0.661674 -0.408334 0 0 0 0 0 0

$sectionframes 30 960




$sequence "BindPose" "ship_broken001_anims\BindPose.smd" {
	fps 30
}

$sequence "ship_broken001_idle" "ship_broken001_anims\ship_broken001_idle.smd" {
	fps 30
	loop
}


$keyvalues
{
}
