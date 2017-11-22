// Created by Crowbar 0.24.0.0

$modelname "items/rattletrap/warmachine_cog_dc/warmachine_cog_dc.mdl"

$bodygroup "default"
{
	studio "warmachine_cog_dc_reference.smd"
}

$lod 1
{
	replacemodel "warmachine_cog_dc_reference.smd" "warmachine_cog_dc_lod1.smd"
}

$cdmaterials ""

$attachment "attach_attack1" "main" 0 0 0 rotate 0 0 0

$surfaceprop "default"

$contents "solid"

// $hboxset "default"
// $hbox 0 "root" -35 -35 -74.5 35 35 0.5
// $hboxset "select_low"
// $hbox 0 "root" -52 -52 -85 48 48 5
// $hboxset "select_high"
// $hbox 0 "root" -35 -35 -74.5 35 35 0.5

// NOTE: The following commented-out $definebone lines might be needed, as is often the case for view models. When needed, simply remove the two slashes '//' from the start of each line.
// $definebone "root" "" 0.082443 0 0.090775 1.570797 0 0 0 0 0 0 0 0
// $definebone "main" "root" -0.08244 0.093518 -48.661415 -1.570818 1.559867 1.570802 0 0 0 0 0 0
// $definebone "door_l" "main" 1.312904 0 0 0 0 1.633058 0 0 0 0 0 0
// $definebone "door_r" "main" 1.312904 0 0 0 0 -1.612006 0 0 0 0 0 0
// $definebone "door_main" "root" -0.082437 -0.090775 -12.249577 -1.570818 1.559867 1.570802 0 0 0 0 0 0




$sequence "ref" "warmachine_cog_dc_anims\ref.smd" {
	fps 30
}

$sequence "ward_idle" "warmachine_cog_dc_anims\ward_idle.smd" {
	fps 30
	activity "ACT_DOTA_IDLE" 1
	loop
}

$sequence "spawn" "warmachine_cog_dc_anims\spawn.smd" {
	fps 30
	activity "ACT_DOTA_SPAWN" 1
}

$sequence "death" "warmachine_cog_dc_anims\death.smd" {
	fps 30
	activity "ACT_DOTA_DIE" 1
}

