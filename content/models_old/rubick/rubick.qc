// Created by Crowbar 0.24.0.0

$modelname "heroes/rubick/rubick.mdl"

$bodygroup "default"
{
	studio "rubick_reference.smd"
}


$poseparameter "turn" -1 1 0

$cdmaterials ""

$attachment "attach_wing_barb_2" "Staff_1" -0.91 107.43 -0.04 rotate -45 180 90
$attachment "attach_weapon" "Staff_1" 0 0 0 rotate 0 0 0
$attachment "attach_attack3" "Staff_1" -0.91 107.43 -0.04 rotate -45 -180 90
$attachment "attach_wing_barb_1" "Staff_1" -0.91 -135.49 -0.04 rotate -45 180 90
$attachment "attach_wing_barb_3" "Staff_1" -0.91 -54.5 -0.04 rotate -45 180 90
$attachment "attach_totem" "Staff_1" -0.9 -27.54 -0.18 rotate 0 90 0
$attachment "attach_staff_ambient" "Staff_1" -0.91 53.41 -0.04 rotate 0 180 90
$attachment "attach_wing_barb_4" "Staff_1" -0.91 26.52 -0.04 rotate -45 180 90
$attachment "attach_attack1" "Staff_1" -0.91 107.43 -0.04 rotate -45 180 90
$attachment "attach_neck" "Head_1" 12.91 0 -7.23 rotate 0 0 0
$attachment "attach_eyeL" "Head_1" 10 3.5 2 rotate 0 0 0
$attachment "attach_ogerhead" "Head_1" 12.91 0 -7.23 rotate 0 0 0
$attachment "attach_eyeR" "Head_1" 10 -3.5 2 rotate 0 0 0
$attachment "attach_mouth" "Head_1" 12.91 0 -7.23 rotate 0 0 0
$attachment "attach_head" "Head_1" -5.71 0 -8.68 rotate -27.4 0 0
$attachment "attach_cast4_primal_roar" "Head_1" 3.29 0 -7.23 rotate 0 0 0
$attachment "attach_attack2" "wrist_R" 0 0 0 rotate 67.5 -180 90
$attachment "attach_weapon_chain_rt" "wrist_R" 0 0 0 rotate 67.5 -180 90
$attachment "attach_hitloc" "Spine_3" 0 0 0 rotate 90 0 0
$attachment "attach_thorax" "Root_0" -30.16 0 -32.62 rotate 38.15 180 90

$surfaceprop "default"

$contents "solid"

// $hboxset "default"
// $hbox 0 "Root_0" -28.110332 -28.035278 -53.432652 26.079056 25.438694 27.353189
// $hbox 0 "thigh_R" -60.482372 -15.604093 -36.362766 -3.06405 14.730014 22.216066
// $hbox 0 "knee_R" -42.444664 -8.91621 -18.500017 0.341696 12.933933 14.811693
// $hbox 0 "thigh_L" 7.318187 -12.529438 -22.468349 60.482372 15.604093 36.362766
// $hbox 0 "knee_L" -0.341693 -9.449296 -14.31391 42.478081 8.893946 14.680162
// $hbox 0 "Spine_0" 2.44999 -21.51446 -19.934092 21.818296 21.51446 21.17205
// $hbox 0 "Spine_3" -23.269548 -22.561113 -23.083973 20.752151 19.171722 22.28661
// $hbox 0 "bicep_R" -39.897213 -11.187529 -14.064192 7.142607 9.391462 13.609893
// $hbox 0 "elbow_R" -31.44161 -12.357465 -17.994131 11.104517 11.579523 11.358005
// $hbox 0 "PonyTail0_0" -16.019955 -6.431553 -1.893881 1.080226 6.431553 19.871927
// $hbox 0 "FrontCloth1_0" -26.383457 -5.832476 -10.771722 -9.222898 6.073871 -4.165196
// $hbox 0 "bicep_L" -5.003801 -16.287123 -17.663054 38.600475 37.600182 12.414204
// $hbox 0 "elbow_L" -1.836519 -14.530523 -10.312886 32.070267 14.330452 22.643431
// $hboxset "select_low"
// $hbox 0 "Root_0" -90.670998 -87.233498 -98.982498 92.172997 87.235497 132.632507
// $hboxset "feet"
// $hbox 0 "ankle_R" -32.467377 -10.529678 -8.166436 6.740648 11.700991 9.566954
// $hbox 0 "ankle_L" -8.585799 -11.70099 -9.566954 32.467377 10.529678 9.626793
// $hboxset "hands"
// $hbox 0 "wrist_R" -19.051647 -10.059009 -7.294841 1.688371 7.399174 14.56274
// $hbox 0 "wrist_L" -0.792009 -10.665735 -11.564106 20.779478 10.665735 11.564106
// $hboxset "head"
// $hbox 0 "Head_1" -11.112341 -8.229296 -15.622676 13.240141 8.229296 18.289753
// $hboxset "select_high"
// $hbox 0 "Root_0" -29.398001 -40.019001 -97.724998 30.9 40.021 45.907001
// $hbox 0 "Spine_3" -48.341499 -42.120998 -29.4125 27.265499 36.595001 30.2085
// $skipboneinbbox

// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "Root_0" "" 0 101.805443 13.248837 0 -1.570796 -1.570796 0 0 0 0 0 0
// $definebone "thigh_L" "Root_0" -6.25725 15.255458 0.745514 0.611139 1.448066 0.670094 0 0 0 0 0 0
// $definebone "thigh_R" "Root_0" -6.25725 -15.255458 0.745514 -2.530454 -1.448065 2.471498 0 0 0 0 0 0
// $definebone "Spine_0" "Root_0" 0.048274 0 35.578331 3.141591 -1.540503 -3.141591 0 0 0 0 0 0
// $definebone "knee_L" "thigh_L" 47.869278 -0.000002 -0.000002 0 0.208102 0 0 0 0 0 0 0
// $definebone "ankle_L" "knee_L" 47.902958 0.00001 0 -0.930494 -1.350996 0.828974 0 0 0 0 0 0
// $definebone "toeBase_L" "ankle_L" 13.858887 0.000006 0 -0.003683 -0.241498 0.015399 0 0 0 0 0 0
// $definebone "knee_R" "thigh_R" -47.869289 -0.000002 -0.000002 0 0.208102 0 0 0 0 0 0 0
// $definebone "ankle_R" "knee_R" -47.903015 0.000002 0.000004 -0.930494 -1.350996 0.828974 0 0 0 0 0 0
// $definebone "toeBase_R" "ankle_R" -13.858883 -0.000006 -0.000002 -0.003683 -0.241498 0.015399 0 0 0 0 0 0
// $definebone "Spine_3" "Spine_0" 37.023621 0.000002 0.000008 0 0.0833 0 0 0 0 0 0 0
// $definebone "Head_0" "Spine_3" 13.777832 0.000001 0.000001 0 -0.009409 0 0 0 0 0 0 0
// $definebone "clavicle_L" "Spine_3" -4.942749 5.064597 -6.689815 1.570796 -0.405257 1.496007 0 0 0 0 0 0
// $definebone "RTabord_R0C0" "Spine_3" 0.228867 -21.182949 -13.448993 1.476124 0.433617 2.919324 0 0 0 0 0 0
// $definebone "clavicle_R" "Spine_3" -4.942749 -5.064599 -6.689815 -1.570796 0.405258 1.645585 0 0 0 0 0 0
// $definebone "FrontCloth1_0" "Spine_3" 10.341949 -0.000001 -19.941151 0 0 0 0 0 0 0 0 0
// $definebone "RBRobe_R0C0" "Spine_3" -3.630859 -17.778255 15.750704 1.498081 0.005109 -3.113347 0 0 0 0 0 0
// $definebone "LTabord_R0C0" "Spine_3" 2.599625 22.070147 -13.798848 1.726936 0.605317 -2.871692 0 0 0 0 0 0
// $definebone "LBRobe_R0C0" "Spine_3" -12.114792 19.332239 15.180743 1.454484 0.063602 -3.131016 0 0 0 0 0 0
// $definebone "Head_1" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base1" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base2" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base3" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base4" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base5" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base6" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base7" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base8" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base9" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base10" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base11" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base12" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base13" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base14" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base15" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base16" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base17" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base18" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base19" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base20" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base21" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base22" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base23" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base24" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base25" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base26" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "Head_1Base27" "Head_0" 26.469284 0.000001 -0.000001 -0.000002 1.527199 -0.000002 0 0 0 0 0 0
// $definebone "PonyTail0_0" "Head_1" -6.154834 -0.000001 25.043823 0 0 0 0 0 0 0 0 0
// $definebone "bicep_L" "clavicle_L" 19.712433 -0.000008 -0.000031 -2.57615 0.970497 -1.252114 0 0 0 0 0 0
// $definebone "elbow_L" "bicep_L" 38.110268 0.000008 0 0.000005 1.537462 0.000008 0 0 0 0 0 0
// $definebone "LFRobe_R0C0" "bicep_L" 33.430359 -8.982475 -0.957169 1.552683 -0.358214 0.297132 0 0 0 0 0 0
// $definebone "wrist_L" "elbow_L" 34.578812 0.000015 0.000008 -0.491735 0.173477 0.439379 0 0 0 0 0 0
// $definebone "thumb_0_L" "wrist_L" 7.819427 2.38662 -8.415222 0 0 0 0 0 0 0 0 0
// $definebone "ring_0_L" "wrist_L" 12.999969 -5.012558 0.174995 0 0 0 0 0 0 0 0 0
// $definebone "index_0_L" "wrist_L" 15.135651 -5.616226 -7.465988 1.687718 0.151559 0.27206 0 0 0 0 0 0
// $definebone "Staff_1" "wrist_L" -82.956482 74.427681 126.731438 2.019923 -1.276254 2.185256 0 0 0 0 0 0
// $definebone "index_1_L" "index_0_L" 5.680939 0.000031 0.000008 0 0 0 0 0 0 0 0 0
// $definebone "LFRobe_R1C0" "LFRobe_R0C0" 87.940636 9.829601 -7.480286 0.127997 -0.428286 0.034081 0 0 0 0 0 0
// $definebone "LFRobe_R2C0" "LFRobe_R1C0" 45.357594 -0.00001 -0.000023 0.026124 -0.068992 0.04452 0 0 0 0 0 0
// $definebone "RTabord_R1C0" "RTabord_R0C0" 30.658615 0 0.000006 0.060955 0.192074 0.309436 0 0 0 0 0 0
// $definebone "RTabord_R2C0" "RTabord_R1C0" 31.243446 0 -0.000009 0.008993 0.01981 -0.137622 0 0 0 0 0 0
// $definebone "RFRobe_R0C0" "clavicle_R" -25.686159 2.776627 -2.987595 0.13833 -1.426049 2.769273 0 0 0 0 0 0
// $definebone "bicep_R" "clavicle_R" -19.712427 0.000006 0.000015 -2.599663 0.963226 -1.250387 0 0 0 0 0 0
// $definebone "RFRobe_R1C0" "RFRobe_R0C0" 43.230759 -0.000005 0 0.059647 -0.216307 -0.070142 0 0 0 0 0 0
// $definebone "RFRobe_R2C0" "RFRobe_R1C0" 54.826912 0 0 -0.222275 0.238678 -0.032777 0 0 0 0 0 0
// $definebone "RFRobe_R3C0" "RFRobe_R2C0" 48.622101 0 0.000008 0.028225 0.172198 -0.023607 0 0 0 0 0 0
// $definebone "elbow_R" "bicep_R" -38.942596 0.000008 -0.000015 0.000003 1.515215 0.000002 0 0 0 0 0 0
// $definebone "wrist_R" "elbow_R" -30.439163 0.000015 0.000038 -0.563445 0.102589 0.443746 0 0 0 0 0 0
// $definebone "ring_0_R" "wrist_R" -15.90876 4.512943 0.810745 2.782065 -0.093388 0.71892 0 0 0 0 0 0
// $definebone "thumb_0_R" "wrist_R" -7.897392 -1.492161 9.568436 -2.403497 0.124912 0.809624 0 0 0 0 0 0
// $definebone "index_0_R" "wrist_R" -17.048271 4.619358 9.398239 1.69336 0.223773 0.115231 0 0 0 0 0 0
// $definebone "ring_1_R" "ring_0_R" -7.164505 -0.000015 0.000015 0 0 0 0 0 0 0 0 0
// $definebone "thumb_1_R" "thumb_0_R" -7.602158 0.000031 -0.000004 0 0 0 0 0 0 0 0 0
// $definebone "index_1_R" "index_0_R" -6.644447 0.000008 0.000008 0 0.799494 0 0 0 0 0 0 0
// $definebone "index_2_R" "index_1_R" -3.825586 -0.000031 -0.000015 0 0 0 0 0 0 0 0 0
// $definebone "RBRobe_R1C0" "RBRobe_R0C0" 93.573708 0.000003 0.000019 0.10231 0.175199 0.406221 0 0 0 0 0 0
// $definebone "RBRobe_R2C0" "RBRobe_R1C0" 70.726303 -0.000027 -0.000008 0.039557 -0.004207 -0.004256 0 0 0 0 0 0
// $definebone "LTabord_R1C0" "LTabord_R0C0" 35.562065 -0.000015 -0.00001 0.296832 0.043517 -0.031224 0 0 0 0 0 0
// $definebone "LBRobe_R1C0" "LBRobe_R0C0" 91.445396 0.000005 0.000004 0.099283 -0.392289 0.538233 0 0 0 0 0 0
// $definebone "LBRobe_R2C0" "LBRobe_R1C0" 69.439774 -0.000023 0 0.007935 0.008188 0.014167 0 0 0 0 0 0

$sectionframes 30 137

// $weightlist "weights_rubick_steal_swarcry" {
// 	 "Root_0" 0
// 	 "thigh_L" 0
// 	 "thigh_R" 0
// 	 "Spine_0" 1
// 	 "knee_L" 0
// 	 "ankle_L" 0
// 	 "toeBase_L" 0
// 	 "knee_R" 0
// 	 "ankle_R" 0
// 	 "toeBase_R" 0
// 	 "Spine_3" 1
// 	 "Head_0" 1
// 	 "clavicle_L" 1
// 	 "RTabord_R0C0" 1
// 	 "clavicle_R" 1
// 	 "FrontCloth1_0" 1
// 	 "RBRobe_R0C0" 1
// 	 "LTabord_R0C0" 1
// 	 "LBRobe_R0C0" 1
// 	 "Head_1" 1
// 	 "Head_1Base" 1
// 	 "Head_1Base1" 1
// 	 "Head_1Base2" 1
// 	 "Head_1Base3" 1
// 	 "Head_1Base4" 1
// 	 "Head_1Base5" 1
// 	 "Head_1Base6" 1
// 	 "Head_1Base7" 1
// 	 "Head_1Base8" 1
// 	 "Head_1Base9" 1
// 	 "Head_1Base10" 1
// 	 "Head_1Base11" 1
// 	 "Head_1Base12" 1
// 	 "Head_1Base13" 1
// 	 "Head_1Base14" 1
// 	 "Head_1Base15" 1
// 	 "Head_1Base16" 1
// 	 "Head_1Base17" 1
// 	 "Head_1Base18" 1
// 	 "Head_1Base19" 1
// 	 "Head_1Base20" 1
// 	 "Head_1Base21" 1
// 	 "Head_1Base22" 1
// 	 "Head_1Base23" 1
// 	 "Head_1Base24" 1
// 	 "Head_1Base25" 1
// 	 "Head_1Base26" 1
// 	 "Head_1Base27" 1
// 	 "PonyTail0_0" 1
// 	 "bicep_L" 1
// 	 "elbow_L" 1
// 	 "LFRobe_R0C0" 1
// 	 "wrist_L" 1
// 	 "thumb_0_L" 1
// 	 "ring_0_L" 1
// 	 "index_0_L" 1
// 	 "Staff_1" 1
// 	 "index_1_L" 1
// 	 "LFRobe_R1C0" 1
// 	 "LFRobe_R2C0" 1
// 	 "RTabord_R1C0" 1
// 	 "RTabord_R2C0" 1
// 	 "RFRobe_R0C0" 1
// 	 "bicep_R" 1
// 	 "RFRobe_R1C0" 1
// 	 "RFRobe_R2C0" 1
// 	 "RFRobe_R3C0" 1
// 	 "elbow_R" 1
// 	 "wrist_R" 1
// 	 "ring_0_R" 1
// 	 "thumb_0_R" 1
// 	 "index_0_R" 1
// 	 "ring_1_R" 1
// 	 "thumb_1_R" 1
// 	 "index_1_R" 1
// 	 "index_2_R" 1
// 	 "RBRobe_R1C0" 1
// 	 "RBRobe_R2C0" 1
// 	 "LTabord_R1C0" 1
// 	 "LBRobe_R1C0" 1
// 	 "LBRobe_R2C0" 1
// }
// $weightlist "weights_rubick_steal_bmwildaxesb" {
// 	 "Root_0" 0
// 	 "thigh_L" 0
// 	 "thigh_R" 0
// 	 "Spine_0" 1
// 	 "knee_L" 0
// 	 "ankle_L" 0
// 	 "toeBase_L" 0
// 	 "knee_R" 0
// 	 "ankle_R" 0
// 	 "toeBase_R" 0
// 	 "Spine_3" 1
// 	 "Head_0" 1
// 	 "clavicle_L" 1
// 	 "RTabord_R0C0" 1
// 	 "clavicle_R" 1
// 	 "FrontCloth1_0" 1
// 	 "RBRobe_R0C0" 1
// 	 "LTabord_R0C0" 1
// 	 "LBRobe_R0C0" 1
// 	 "Head_1" 1
// 	 "Head_1Base" 1
// 	 "Head_1Base1" 1
// 	 "Head_1Base2" 1
// 	 "Head_1Base3" 1
// 	 "Head_1Base4" 1
// 	 "Head_1Base5" 1
// 	 "Head_1Base6" 1
// 	 "Head_1Base7" 1
// 	 "Head_1Base8" 1
// 	 "Head_1Base9" 1
// 	 "Head_1Base10" 1
// 	 "Head_1Base11" 1
// 	 "Head_1Base12" 1
// 	 "Head_1Base13" 1
// 	 "Head_1Base14" 1
// 	 "Head_1Base15" 1
// 	 "Head_1Base16" 1
// 	 "Head_1Base17" 1
// 	 "Head_1Base18" 1
// 	 "Head_1Base19" 1
// 	 "Head_1Base20" 1
// 	 "Head_1Base21" 1
// 	 "Head_1Base22" 1
// 	 "Head_1Base23" 1
// 	 "Head_1Base24" 1
// 	 "Head_1Base25" 1
// 	 "Head_1Base26" 1
// 	 "Head_1Base27" 1
// 	 "PonyTail0_0" 1
// 	 "bicep_L" 1
// 	 "elbow_L" 1
// 	 "LFRobe_R0C0" 1
// 	 "wrist_L" 1
// 	 "thumb_0_L" 1
// 	 "ring_0_L" 1
// 	 "index_0_L" 1
// 	 "Staff_1" 1
// 	 "index_1_L" 1
// 	 "LFRobe_R1C0" 1
// 	 "LFRobe_R2C0" 1
// 	 "RTabord_R1C0" 1
// 	 "RTabord_R2C0" 1
// 	 "RFRobe_R0C0" 1
// 	 "bicep_R" 1
// 	 "RFRobe_R1C0" 1
// 	 "RFRobe_R2C0" 1
// 	 "RFRobe_R3C0" 1
// 	 "elbow_R" 1
// 	 "wrist_R" 1
// 	 "ring_0_R" 1
// 	 "thumb_0_R" 1
// 	 "index_0_R" 1
// 	 "ring_1_R" 1
// 	 "thumb_1_R" 1
// 	 "index_1_R" 1
// 	 "index_2_R" 1
// 	 "RBRobe_R1C0" 1
// 	 "RBRobe_R2C0" 1
// 	 "LTabord_R1C0" 1
// 	 "LBRobe_R1C0" 1
// 	 "LBRobe_R2C0" 1
// }
// $weightlist "weights_rubick_steal_swarcry_dupe1" {
// 	 "Root_0" 0
// 	 "thigh_L" 0
// 	 "thigh_R" 0
// 	 "Spine_0" 1
// 	 "knee_L" 0
// 	 "ankle_L" 0
// 	 "toeBase_L" 0
// 	 "knee_R" 0
// 	 "ankle_R" 0
// 	 "toeBase_R" 0
// 	 "Spine_3" 1
// 	 "Head_0" 1
// 	 "clavicle_L" 1
// 	 "RTabord_R0C0" 1
// 	 "clavicle_R" 1
// 	 "FrontCloth1_0" 1
// 	 "RBRobe_R0C0" 1
// 	 "LTabord_R0C0" 1
// 	 "LBRobe_R0C0" 1
// 	 "Head_1" 1
// 	 "Head_1Base" 1
// 	 "Head_1Base1" 1
// 	 "Head_1Base2" 1
// 	 "Head_1Base3" 1
// 	 "Head_1Base4" 1
// 	 "Head_1Base5" 1
// 	 "Head_1Base6" 1
// 	 "Head_1Base7" 1
// 	 "Head_1Base8" 1
// 	 "Head_1Base9" 1
// 	 "Head_1Base10" 1
// 	 "Head_1Base11" 1
// 	 "Head_1Base12" 1
// 	 "Head_1Base13" 1
// 	 "Head_1Base14" 1
// 	 "Head_1Base15" 1
// 	 "Head_1Base16" 1
// 	 "Head_1Base17" 1
// 	 "Head_1Base18" 1
// 	 "Head_1Base19" 1
// 	 "Head_1Base20" 1
// 	 "Head_1Base21" 1
// 	 "Head_1Base22" 1
// 	 "Head_1Base23" 1
// 	 "Head_1Base24" 1
// 	 "Head_1Base25" 1
// 	 "Head_1Base26" 1
// 	 "Head_1Base27" 1
// 	 "PonyTail0_0" 1
// 	 "bicep_L" 1
// 	 "elbow_L" 1
// 	 "LFRobe_R0C0" 1
// 	 "wrist_L" 1
// 	 "thumb_0_L" 1
// 	 "ring_0_L" 1
// 	 "index_0_L" 1
// 	 "Staff_1" 1
// 	 "index_1_L" 1
// 	 "LFRobe_R1C0" 1
// 	 "LFRobe_R2C0" 1
// 	 "RTabord_R1C0" 1
// 	 "RTabord_R2C0" 1
// 	 "RFRobe_R0C0" 1
// 	 "bicep_R" 1
// 	 "RFRobe_R1C0" 1
// 	 "RFRobe_R2C0" 1
// 	 "RFRobe_R3C0" 1
// 	 "elbow_R" 1
// 	 "wrist_R" 1
// 	 "ring_0_R" 1
// 	 "thumb_0_R" 1
// 	 "index_0_R" 1
// 	 "ring_1_R" 1
// 	 "thumb_1_R" 1
// 	 "index_1_R" 1
// 	 "index_2_R" 1
// 	 "RBRobe_R1C0" 1
// 	 "RBRobe_R2C0" 1
// 	 "LTabord_R1C0" 1
// 	 "LBRobe_R1C0" 1
// 	 "LBRobe_R2C0" 1
// }
// $weightlist "weights_rubick_steal_uenrage" {
// 	 "Root_0" 0
// 	 "thigh_L" 0
// 	 "thigh_R" 0
// 	 "Spine_0" 1
// 	 "knee_L" 0
// 	 "ankle_L" 0
// 	 "toeBase_L" 0
// 	 "knee_R" 0
// 	 "ankle_R" 0
// 	 "toeBase_R" 0
// 	 "Spine_3" 1
// 	 "Head_0" 1
// 	 "clavicle_L" 1
// 	 "RTabord_R0C0" 1
// 	 "clavicle_R" 1
// 	 "FrontCloth1_0" 1
// 	 "RBRobe_R0C0" 1
// 	 "LTabord_R0C0" 1
// 	 "LBRobe_R0C0" 1
// 	 "Head_1" 1
// 	 "Head_1Base" 1
// 	 "Head_1Base1" 1
// 	 "Head_1Base2" 1
// 	 "Head_1Base3" 1
// 	 "Head_1Base4" 1
// 	 "Head_1Base5" 1
// 	 "Head_1Base6" 1
// 	 "Head_1Base7" 1
// 	 "Head_1Base8" 1
// 	 "Head_1Base9" 1
// 	 "Head_1Base10" 1
// 	 "Head_1Base11" 1
// 	 "Head_1Base12" 1
// 	 "Head_1Base13" 1
// 	 "Head_1Base14" 1
// 	 "Head_1Base15" 1
// 	 "Head_1Base16" 1
// 	 "Head_1Base17" 1
// 	 "Head_1Base18" 1
// 	 "Head_1Base19" 1
// 	 "Head_1Base20" 1
// 	 "Head_1Base21" 1
// 	 "Head_1Base22" 1
// 	 "Head_1Base23" 1
// 	 "Head_1Base24" 1
// 	 "Head_1Base25" 1
// 	 "Head_1Base26" 1
// 	 "Head_1Base27" 1
// 	 "PonyTail0_0" 1
// 	 "bicep_L" 1
// 	 "elbow_L" 1
// 	 "LFRobe_R0C0" 1
// 	 "wrist_L" 1
// 	 "thumb_0_L" 1
// 	 "ring_0_L" 1
// 	 "index_0_L" 1
// 	 "Staff_1" 1
// 	 "index_1_L" 1
// 	 "LFRobe_R1C0" 1
// 	 "LFRobe_R2C0" 1
// 	 "RTabord_R1C0" 1
// 	 "RTabord_R2C0" 1
// 	 "RFRobe_R0C0" 1
// 	 "bicep_R" 1
// 	 "RFRobe_R1C0" 1
// 	 "RFRobe_R2C0" 1
// 	 "RFRobe_R3C0" 1
// 	 "elbow_R" 1
// 	 "wrist_R" 1
// 	 "ring_0_R" 1
// 	 "thumb_0_R" 1
// 	 "index_0_R" 1
// 	 "ring_1_R" 1
// 	 "thumb_1_R" 1
// 	 "index_1_R" 1
// 	 "index_2_R" 1
// 	 "RBRobe_R1C0" 1
// 	 "RBRobe_R2C0" 1
// 	 "LTabord_R1C0" 1
// 	 "LBRobe_R1C0" 1
// 	 "LBRobe_R2C0" 1
// }
// $weightlist "weights_rubick_steal_uoverpower" {
// 	 "Root_0" 0
// 	 "thigh_L" 0
// 	 "thigh_R" 0
// 	 "Spine_0" 1
// 	 "knee_L" 0
// 	 "ankle_L" 0
// 	 "toeBase_L" 0
// 	 "knee_R" 0
// 	 "ankle_R" 0
// 	 "toeBase_R" 0
// 	 "Spine_3" 1
// 	 "Head_0" 1
// 	 "clavicle_L" 1
// 	 "RTabord_R0C0" 1
// 	 "clavicle_R" 1
// 	 "FrontCloth1_0" 1
// 	 "RBRobe_R0C0" 1
// 	 "LTabord_R0C0" 1
// 	 "LBRobe_R0C0" 1
// 	 "Head_1" 1
// 	 "Head_1Base" 1
// 	 "Head_1Base1" 1
// 	 "Head_1Base2" 1
// 	 "Head_1Base3" 1
// 	 "Head_1Base4" 1
// 	 "Head_1Base5" 1
// 	 "Head_1Base6" 1
// 	 "Head_1Base7" 1
// 	 "Head_1Base8" 1
// 	 "Head_1Base9" 1
// 	 "Head_1Base10" 1
// 	 "Head_1Base11" 1
// 	 "Head_1Base12" 1
// 	 "Head_1Base13" 1
// 	 "Head_1Base14" 1
// 	 "Head_1Base15" 1
// 	 "Head_1Base16" 1
// 	 "Head_1Base17" 1
// 	 "Head_1Base18" 1
// 	 "Head_1Base19" 1
// 	 "Head_1Base20" 1
// 	 "Head_1Base21" 1
// 	 "Head_1Base22" 1
// 	 "Head_1Base23" 1
// 	 "Head_1Base24" 1
// 	 "Head_1Base25" 1
// 	 "Head_1Base26" 1
// 	 "Head_1Base27" 1
// 	 "PonyTail0_0" 1
// 	 "bicep_L" 1
// 	 "elbow_L" 1
// 	 "LFRobe_R0C0" 1
// 	 "wrist_L" 1
// 	 "thumb_0_L" 1
// 	 "ring_0_L" 1
// 	 "index_0_L" 1
// 	 "Staff_1" 1
// 	 "index_1_L" 1
// 	 "LFRobe_R1C0" 1
// 	 "LFRobe_R2C0" 1
// 	 "RTabord_R1C0" 1
// 	 "RTabord_R2C0" 1
// 	 "RFRobe_R0C0" 1
// 	 "bicep_R" 1
// 	 "RFRobe_R1C0" 1
// 	 "RFRobe_R2C0" 1
// 	 "RFRobe_R3C0" 1
// 	 "elbow_R" 1
// 	 "wrist_R" 1
// 	 "ring_0_R" 1
// 	 "thumb_0_R" 1
// 	 "index_0_R" 1
// 	 "ring_1_R" 1
// 	 "thumb_1_R" 1
// 	 "index_1_R" 1
// 	 "index_2_R" 1
// 	 "RBRobe_R1C0" 1
// 	 "RBRobe_R2C0" 1
// 	 "LTabord_R1C0" 1
// 	 "LBRobe_R1C0" 1
// 	 "LBRobe_R2C0" 1
// }



$sequence "BindPose" "rubick_anims\BindPose.smd" {
	fps 30
}

$sequence "loadout_spawn" "rubick_anims\loadout_spawn.smd" {
	fps 30
	activity "ACT_DOTA_SPAWN" 1
	fadeout 0.3
}

$sequence "loadout_rare" "rubick_anims\loadout_rare.smd" {
	fps 30
	activity "ACT_DOTA_LOADOUT_RARE" 1
}

$sequence "rubick_spawn" "rubick_anims\rubick_spawn.smd" {
	fps 30
	activity "ACT_DOTA_SPAWN" 1
}

$sequence "rubick_idle" "rubick_anims\rubick_idle.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 4
	loop
}

$sequence "rubick_run" "rubick_anims\rubick_run.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
	{ event AE_CL_PLAYSOUND 1 "Hero_Rubick.Footsteps" }
	{ event AE_CL_PLAYSOUND 16 "Hero_Rubick.Footsteps" }
}

$sequence "rubick_attack" "rubick_anims\rubick_attack.smd" {
	fps 30
	activity "ACT_DOTA_ATTACK" 1
}

$sequence "harlequin_attack_default_copy" "rubick_anims\harlequin_attack_default_copy.smd" {
	fps 30
	activity "ACT_DOTA_ATTACK" 1
}

$sequence "harlequin_attack_workshop" "rubick_anims\harlequin_attack_workshop.smd" {
	fps 30
	activity "ACT_DOTA_ATTACK" 3
}

$sequence "rubick_run_alt" "rubick_anims\rubick_run_alt.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
}

$sequence "rubick_idle_alt" "rubick_anims\rubick_idle_alt.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 1
	loop
}

$sequence "rubick_capture" "rubick_anims\rubick_capture.smd" {
	fps 30
	activity "ACT_DOTA_CAPTURE" 1
	loop
}

$sequence "rubick_cast_fadebolt" "rubick_anims\rubick_cast_fadebolt.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_3" 1
}

$sequence "rubick_cast_telekinesis" "rubick_anims\rubick_cast_telekinesis.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_1" 1
}

$sequence "rubick_cast_spell_steal" "rubick_anims\rubick_cast_spell_steal.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_7" 1
}

$sequence "rubick_flail" "rubick_anims\rubick_flail.smd" {
	fps 30
	activity "ACT_DOTA_FLAIL" 1
	loop
}

$sequence "rubick_stun" "rubick_anims\rubick_stun.smd" {
	fps 30
	activity "ACT_DOTA_DISABLED" 1
	loop
}

$sequence "rubick_die" "rubick_anims\rubick_die.smd" {
	fps 30
	activity "ACT_DOTA_DIE" 1
	{ event AE_CL_PLAYSOUND 61 "BodyImpact_Common.Light" }
}

$sequence "rubick_run_injured" "rubick_anims\rubick_run_injured.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
}

$sequence "rubick_idle_injured" "rubick_anims\rubick_idle_injured.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 1
	loop
}

$sequence "rubick_teleport_start" "rubick_anims\rubick_teleport_start.smd" {
	fps 30
	activity "ACT_DOTA_TELEPORT" 1
}

$sequence "rubick_teleport_end" "rubick_anims\rubick_teleport_end.smd" {
	fps 30
	activity "ACT_DOTA_TELEPORT_END" 1
}

$sequence "rubick_defeat" "rubick_anims\rubick_defeat.smd" {
	fps 30
	activity "ACT_DOTA_DEFEAT" 1
	loop
}

$sequence "rubick_victory" "rubick_anims\rubick_victory.smd" {
	fps 30
	activity "ACT_DOTA_VICTORY" 1
	loop
}

$sequence "rubick_generic_casta" "rubick_anims\rubick_generic_casta.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_generic_castb" "rubick_anims\rubick_generic_castb.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_6" 1
}

$sequence "rubick_channel" "rubick_anims\rubick_channel.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
	loop
}

$sequence "rubick_steal_pudgehooka" "rubick_anims\rubick_steal_pudgehooka.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_1" 1
}

$sequence "rubick_steal_pudgehookb" "rubick_anims\rubick_steal_pudgehookb.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_1" 1
}

$sequence "rubick_steal_wall" "rubick_anims\rubick_steal_wall.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_ravage" "rubick_anims\rubick_steal_ravage.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_brfireflya" "rubick_anims\rubick_steal_brfireflya.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_brfireflyb" "rubick_anims\rubick_steal_brfireflyb.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
	addlayer "rubick_steal_brfireflyb_turns"
}

$sequence "rubick_steal_skburrowa" "rubick_anims\rubick_steal_skburrowa.smd" {
	fps 30
	activity "ACT_DOTA_SAND_KING_BURROW_IN" 1
}

$sequence "rubick_steal_skburrowb" "rubick_anims\rubick_steal_skburrowb.smd" {
	fps 30
	activity "ACT_DOTA_SAND_KING_BURROW_OUT" 1
}

$sequence "rubick_steal_jspina" "rubick_anims\rubick_steal_jspina.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_1" 1
}

$sequence "rubick_steal_jspinb" "rubick_anims\rubick_steal_jspinb.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_1" 1
	loop
}

$sequence "rubick_steal_mleap" "rubick_anims\rubick_steal_mleap.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_3" 1
}

$sequence "rubick_steal_mleapend" "rubick_anims\rubick_steal_mleapend.smd" {
	fps 30
	activity "ACT_MIRANA_LEAP_END" 1
}

$sequence "rubick_steal_jomni" "rubick_anims\rubick_steal_jomni.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_4" 1
}

$sequence "rubick_steal_brfireflyb_idle" "rubick_anims\rubick_steal_brfireflyb_idle.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 1
	loop
}

$sequence "rubick_run_haste" "rubick_anims\rubick_run_haste.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
}

$sequence "rubick_steal_swarcry" "rubick_anims\rubick_steal_swarcry.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_4" 1
}

$sequence "rubick_steal_sstormhammer" "rubick_anims\rubick_steal_sstormhammer.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_bmwildaxesb" "rubick_anims\rubick_steal_bmwildaxesb.smd" {
	fps 30
	activity "ACT_DOTA_CAST_WILD_AXES_END" 1
}

$sequence "rubick_steal_bmwildaxesa" "rubick_anims\rubick_steal_bmwildaxesa.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_bmprimalroar" "rubick_anims\rubick_steal_bmprimalroar.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_swarcry_dupe1" "rubick_anims\rubick_steal_swarcry_dupe1.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_3" 1
}

$sequence "rubick_steal_sbchargefinish" "rubick_anims\rubick_steal_sbchargefinish.smd" {
	fps 30
	activity "ACT_DOTA_SPIRIT_BREAKER_CHARGE_END" 1
}

$sequence "rubick_steal_sbchargepose" "rubick_anims\rubick_steal_sbchargepose.smd" {
	fps 30
	activity "ACT_DOTA_SPIRIT_BREAKER_CHARGE_POSE" 1
}

$sequence "rubick_steal_sbruncharge" "rubick_anims\rubick_steal_sbruncharge.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
}

$sequence "rubick_steal_sbnetherstrike" "rubick_anims\rubick_steal_sbnetherstrike.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_esfissure" "rubick_anims\rubick_steal_esfissure.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_sbruncharge_dupe1" "rubick_anims\rubick_steal_sbruncharge_dupe1.smd" {
	fps 30
	activity "ACT_DOTA_SPIRIT_BREAKER_ULT_RUN" 1
	loop
}

$sequence "rubick_steal_esslam" "rubick_anims\rubick_steal_esslam.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_estotem" "rubick_anims\rubick_steal_estotem.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_llaguna" "rubick_anims\rubick_steal_llaguna.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_llsa" "rubick_anims\rubick_steal_llsa.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_lslave" "rubick_anims\rubick_steal_lslave.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_wdward" "rubick_anims\rubick_steal_wdward.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_ssstatic" "rubick_anims\rubick_steal_ssstatic.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_ssstaticb" "rubick_anims\rubick_steal_ssstaticb.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_ssroll_pre" "rubick_anims\rubick_steal_ssroll_pre.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_ssroll" "rubick_anims\rubick_steal_ssroll.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_4" 1
	loop
}

$sequence "rubick_steal_ssvortex" "rubick_anims\rubick_steal_ssvortex.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_sassassinate" "rubick_anims\rubick_steal_sassassinate.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_sshrapnel" "rubick_anims\rubick_steal_sshrapnel.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_npteleport" "rubick_anims\rubick_steal_npteleport.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_npsprout" "rubick_anims\rubick_steal_npsprout.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_npsummon" "rubick_anims\rubick_steal_npsummon.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_npwrath" "rubick_anims\rubick_steal_npwrath.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_uenrage" "rubick_anims\rubick_steal_uenrage.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_4" 1
}

$sequence "rubick_steal_uoverpower" "rubick_anims\rubick_steal_uoverpower.smd" {
	fps 30
	activity "ACT_DOTA_OVERRIDE_ABILITY_3" 1
}

$sequence "rubick_steal_uearthshock" "rubick_anims\rubick_steal_uearthshock.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_attackb" "rubick_anims\rubick_attackb.smd" {
	fps 30
	activity "ACT_DOTA_ATTACK" 1
}

$sequence "rubick_attackc" "rubick_anims\rubick_attackc.smd" {
	fps 30
	activity "ACT_DOTA_ATTACK" 1
}

$sequence "rubick_steal_amblink" "rubick_anims\rubick_steal_amblink.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_qopblink" "rubick_anims\rubick_steal_qopblink.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_qopshadowstrike" "rubick_anims\rubick_steal_qopshadowstrike.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_qopsonic_wave" "rubick_anims\rubick_steal_qopsonic_wave.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_qopscream" "rubick_anims\rubick_steal_qopscream.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_ammana" "rubick_anims\rubick_steal_ammana.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_vstrike" "rubick_anims\rubick_steal_vstrike.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_nsdarkness" "rubick_anims\rubick_steal_nsdarkness.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_nsfear" "rubick_anims\rubick_steal_nsfear.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_nsvoid" "rubick_anims\rubick_steal_nsvoid.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_axeculling" "rubick_anims\rubick_steal_axeculling.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_pdismember" "rubick_anims\rubick_steal_pdismember.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_bbrain_sap" "rubick_anims\rubick_steal_bbrain_sap.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_bfiends_grip" "rubick_anims\rubick_steal_bfiends_grip.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
	loop
}

$sequence "rubick_steal_limpale" "rubick_anims\rubick_steal_limpale.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_lmana_drain" "rubick_anims\rubick_steal_lmana_drain.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_lfinger" "rubick_anims\rubick_steal_lfinger.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_eblackhole" "rubick_anims\rubick_steal_eblackhole.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
	loop
}

$sequence "rubick_steal_plife_drain" "rubick_anims\rubick_steal_plife_drain.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_cmnova" "rubick_anims\rubick_steal_cmnova.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_cmfrostbite" "rubick_anims\rubick_steal_cmfrostbite.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_cmfreezingfield" "rubick_anims\rubick_steal_cmfreezingfield.smd" {
	fps 30
	activity "ACT_DOTA_STATUE_SEQUENCE" 1
}

$sequence "rubick_steal_cmfreezingfield_10s" "rubick_anims\rubick_steal_cmfreezingfield_10s.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_nmshadowraze" "rubick_anims\rubick_steal_nmshadowraze.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_nmrequiem" "rubick_anims\rubick_steal_nmrequiem.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_okpurification" "rubick_anims\rubick_steal_okpurification.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_okrepel" "rubick_anims\rubick_steal_okrepel.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_okguardian_angel" "rubick_anims\rubick_steal_okguardian_angel.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_wrpowershot" "rubick_anims\rubick_steal_wrpowershot.smd" {
	fps 30
	activity "ACT_DOTA_CHANNEL_ABILITY_5" 1
}

$sequence "rubick_steal_wrshackleshot" "rubick_anims\rubick_steal_wrshackleshot.smd" {
	fps 30
}

$sequence "rubick_steal_wrwindrun" "rubick_anims\rubick_steal_wrwindrun.smd" {
	fps 30
	activity "ACT_DOTA_RUN" 1
	loop
	addlayer "rubick_run_haste_turns"
}

$sequence "rubick_steal_vmgale" "rubick_anims\rubick_steal_vmgale.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_vmpoison_nova" "rubick_anims\rubick_steal_vmpoison_nova.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_steal_vmplague_ward" "rubick_anims\rubick_steal_vmplague_ward.smd" {
	fps 30
	activity "ACT_DOTA_CAST_ABILITY_5" 1
}

$sequence "rubick_forcestaff_start" "rubick_anims\rubick_forcestaff_start.smd" {
	fps 30
}

$sequence "rubick_forcestaff_end" "rubick_anims\rubick_forcestaff_end.smd" {
	fps 30
}

$sequence "rubick_forcestaff_enemy" "rubick_anims\rubick_forcestaff_enemy.smd" {
	fps 30
}

$sequence "taunt_giddy_up" "rubick_anims\taunt_giddy_up.smd" {
	fps 30
	activity "ACT_DOTA_TAUNT" 1
	{ event AE_CL_PLAYSOUND 15 "Hero_Rubick.Taunt_Giddy_Up" }
}

$sequence "rubick_steal_brfireflyb_turns_lookFrame_0" "rubick_anims\rubick_steal_brfireflyb_turns_lookFrame_0.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_steal_brfireflyb_turns_lookFrame_1" "rubick_anims\rubick_steal_brfireflyb_turns_lookFrame_1.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_steal_brfireflyb_turns_lookFrame_2" "rubick_anims\rubick_steal_brfireflyb_turns_lookFrame_2.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_run_haste_turns_lookFrame_0" "rubick_anims\rubick_run_haste_turns_lookFrame_0.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_run_haste_turns_lookFrame_1" "rubick_anims\rubick_run_haste_turns_lookFrame_1.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_run_haste_turns_lookFrame_2" "rubick_anims\rubick_run_haste_turns_lookFrame_2.smd" {
	fps 30
	delta
	hidden
}

$sequence "rubick_steal_brfireflyb_turns" {
	"@rubick_steal_brfireflyb_turns_lookFrame_0"
	"@rubick_steal_brfireflyb_turns_lookFrame_1"
	"@rubick_steal_brfireflyb_turns_lookFrame_2"
	fps 30
	delta
	blendwidth 3
	blend "turn" -1 1
}

$sequence "rubick_run_haste_turns" {
	"@rubick_run_haste_turns_lookFrame_0"
	"@rubick_run_haste_turns_lookFrame_1"
	"@rubick_run_haste_turns_lookFrame_2"
	fps 30
	delta
	blendwidth 3
	blend "turn" -1 1
}

$bonemerge "Root_0"
$bonemerge "thigh_L"
$bonemerge "thigh_R"
$bonemerge "Spine_0"
$bonemerge "knee_L"
$bonemerge "ankle_L"
$bonemerge "toeBase_L"
$bonemerge "knee_R"
$bonemerge "ankle_R"
$bonemerge "toeBase_R"
$bonemerge "Spine_3"
$bonemerge "Head_0"
$bonemerge "clavicle_L"
$bonemerge "RTabord_R0C0"
$bonemerge "clavicle_R"
$bonemerge "FrontCloth1_0"
$bonemerge "RBRobe_R0C0"
$bonemerge "LTabord_R0C0"
$bonemerge "LBRobe_R0C0"
$bonemerge "Head_1"
$bonemerge "Head_1Base"
$bonemerge "Head_1Base1"
$bonemerge "Head_1Base2"
$bonemerge "Head_1Base3"
$bonemerge "Head_1Base4"
$bonemerge "Head_1Base5"
$bonemerge "Head_1Base6"
$bonemerge "Head_1Base7"
$bonemerge "Head_1Base8"
$bonemerge "Head_1Base9"
$bonemerge "Head_1Base10"
$bonemerge "Head_1Base11"
$bonemerge "Head_1Base12"
$bonemerge "Head_1Base13"
$bonemerge "Head_1Base14"
$bonemerge "Head_1Base15"
$bonemerge "Head_1Base16"
$bonemerge "Head_1Base17"
$bonemerge "Head_1Base18"
$bonemerge "Head_1Base19"
$bonemerge "Head_1Base20"
$bonemerge "Head_1Base21"
$bonemerge "Head_1Base22"
$bonemerge "Head_1Base23"
$bonemerge "Head_1Base24"
$bonemerge "Head_1Base25"
$bonemerge "Head_1Base26"
$bonemerge "Head_1Base27"
$bonemerge "PonyTail0_0"
$bonemerge "bicep_L"
$bonemerge "elbow_L"
$bonemerge "LFRobe_R0C0"
$bonemerge "wrist_L"
$bonemerge "thumb_0_L"
$bonemerge "ring_0_L"
$bonemerge "index_0_L"
$bonemerge "Staff_1"
$bonemerge "index_1_L"
$bonemerge "LFRobe_R1C0"
$bonemerge "LFRobe_R2C0"
$bonemerge "RTabord_R1C0"
$bonemerge "RTabord_R2C0"
$bonemerge "RFRobe_R0C0"
$bonemerge "bicep_R"
$bonemerge "RFRobe_R1C0"
$bonemerge "RFRobe_R2C0"
$bonemerge "RFRobe_R3C0"
$bonemerge "elbow_R"
$bonemerge "wrist_R"
$bonemerge "ring_0_R"
$bonemerge "thumb_0_R"
$bonemerge "index_0_R"
$bonemerge "ring_1_R"
$bonemerge "thumb_1_R"
$bonemerge "index_1_R"
$bonemerge "index_2_R"
$bonemerge "RBRobe_R1C0"
$bonemerge "RBRobe_R2C0"
$bonemerge "LTabord_R1C0"
$bonemerge "LBRobe_R1C0"
$bonemerge "LBRobe_R2C0"


$keyvalues
{
}
