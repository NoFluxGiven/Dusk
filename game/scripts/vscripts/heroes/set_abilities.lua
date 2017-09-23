function setCosmetics(keys)
	local caster = keys.caster
	

	local unitname = caster:GetName()
	local unit = ""

	if unitname == "npc_dota_unit_sand_puppet_warrior" then
		unit = "npc_dota_hero_phantom_lancer"
	end

	if unitname == "npc_dota_unit_sand_puppet_archer" then
		unit = "npc_dota_hero_drow_ranger"
	end

	CosmeticLib:ReplaceDefault(caster,unit)
end

function Dust(keys)
	local caster = keys.caster

	local particle = "particles/units/heroes/hero_phantom_lancer/phantom_lancer_death.vpcf"


	local p = ParticleManager:CreateParticle(particle, PATTACH_POINT, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, caster:GetCenter()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, caster:GetAbsOrigin()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 5, Vector(500,500,500)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	caster:AddNoDraw()
end

function syncLevel(caster,target,multiplier,add)

	local mult = multiplier or 1

	local add = add or 0

	local clvl = math.ceil(caster:GetLevel()*mult)

	local finallvl = clvl-1+add

	target:CreatureLevelUp(finallvl)

	local ab = target:GetAbilityByIndex(0)

	local ablvl = math.ceil(finallvl/2)

	if ablvl > 8 then
		ablvl = 8
	end

	ab:SetLevel(ablvl)
end

function sandWave(keys)
	local caster = keys.caster
	local facing = (caster:GetCursorPosition()-caster:GetAbsOrigin()):Normalized()
	local distance = keys.distance/1.4
	local pos = caster:GetAbsOrigin()+(facing*(distance/1.5))
	local ld = QAngle(0,-125,0)
	local r = keys.radius
	local rd = QAngle(0,125,0)
	local speed = distance*2
	local duration = keys.duration or 15

	local ls = RotatePosition(caster:GetAbsOrigin(), ld, pos) --[[Returns:Vector
	Rotate a ''Vector'' around a point.
	]]
	local rs = RotatePosition(caster:GetAbsOrigin(), rd, pos) --[[Returns:Vector
	Rotate a ''Vector'' around a point.
	]]

	local ldir = (pos - ls):Normalized() -- The directions to point towards our crossover point
	local rdir = (pos - rs):Normalized()

	local lu = FastDummy(ls,caster:GetTeamNumber(),1,0)
	local ru = FastDummy(rs,caster:GetTeamNumber(),1,0)

	caster:EmitSound("Hero_Morphling.Waveform")
	-- lu:EmitSound("Hero_Morphling.Waveform")
	-- ru:EmitSound("Hero_Morphling.Waveform")

	Physics:Unit(lu)
  	lu:SetPhysicsFriction(0)
	lu:PreventDI(true)
	  -- To allow going through walls / cliffs add the following:
	lu:FollowNavMesh(false)
	lu:SetAutoUnstuck(false)
	lu:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	lu:SetPhysicsVelocity(ldir * speed)
	  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))

	lu:SetPhysicsAcceleration(Vector(0,0,-speed*4))

	Physics:Unit(ru)
  	ru:SetPhysicsFriction(0)
	ru:PreventDI(true)
	  -- To allow going through walls / cliffs add the following:
	ru:FollowNavMesh(false)
	ru:SetAutoUnstuck(false)
	ru:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	ru:SetPhysicsVelocity(rdir * speed)
	  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))

	ru:SetPhysicsAcceleration(Vector(0,0,-speed*4))

	-- particles

	-- local pl = ParticleManager:CreateParticle("particles/units/heroes/hero_set/set_sand_wave.vpcf", PATTACH_POINT_FOLLOW, lu) --[[Returns:int
	-- Creates a new particle effect
	-- ]]

	-- ParticleManager:SetParticleControl(pl, 0, lu:GetAbsOrigin()) --[[Returns:void
	-- Set the control point data for a control on a particle effect
	-- ]]
	-- ParticleManager:SetParticleControl(pl, 1, Vector(0,r,0)) --[[Returns:void
	-- Set the control point data for a control on a particle effect
	-- ]]

	-- local pr = ParticleManager:CreateParticle("", PATTACH_POINT_FOLLOW, ru) --[[Returns:int
	-- Creates a new particle effect
	-- ]]

	-- ParticleManager:SetParticleControl(pr, 0, ru:GetAbsOrigin()) --[[Returns:void
	-- Set the control point data for a control on a particle effect
	-- ]]
	-- ParticleManager:SetParticleControl(pr, 1, Vector(0,r,0)) --[[Returns:void
	-- Set the control point data for a control on a particle effect
	-- ]]

	local info = 
	  {
	  Ability = keys.ability,
	  EffectName = "particles/units/heroes/hero_set/set_sand_wave_projectile.vpcf",
	  -- EffectName = "particles/units/heroes/hero_reus/reus_stoneblast.vpcf",
	  vSpawnOrigin = ls,
	  fDistance = speed,
	  fStartRadius = r,
	  fEndRadius = r,
	  Source = caster,
	  bHasFrontalCone = false,	
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  vVelocity = ldir * speed,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber()
	  }
	  ProjectileManager:CreateLinearProjectile(info)

	local info = 
	  {
	  Ability = keys.ability,
	  EffectName = "particles/units/heroes/hero_set/set_sand_wave_projectile.vpcf",
	  -- EffectName = "particles/units/heroes/hero_reus/reus_stoneblast.vpcf",
	  vSpawnOrigin = rs,
	  fDistance = speed,
	  fStartRadius = r,
	  fEndRadius = r,
	  Source = caster,
	  bHasFrontalCone = false,
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  vVelocity = rdir * speed,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber()
	  }
	  ProjectileManager:CreateLinearProjectile(info)

	Timers:CreateTimer(0.9,function()
		local summonl = CreateUnitByName("npc_dota_unit_sand_puppet_warrior", lu:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()) --[[Returns:handle
		Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
		]]
		local summonr = CreateUnitByName("npc_dota_unit_sand_puppet_archer", ru:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()) --[[Returns:handle
		Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
		]]

		summonl:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
		Set this unit controllable by the player with the passed ID.
		]]

		summonr:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
		Set this unit controllable by the player with the passed ID.
		]]

		summonl:AddNewModifier(caster, nil, "modifier_kill", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		summonr:AddNewModifier(caster, nil, "modifier_kill", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		summonl:SetIdleAcquire(true) --[[Returns:void
		No Description Set
		]]

		summonr:SetIdleAcquire(true) --[[Returns:void
		No Description Set
		]]

		syncLevel(caster,summonl)
		syncLevel(caster,summonr)
	end)

end

function dustStorm(keys)
	local caster = keys.caster
	local facing = (caster:GetCursorPosition()-caster:GetAbsOrigin()):Normalized()
	local distance = keys.distance
	local point = facing*distance
	local time = 6
	local t = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),time,450)

	-- local e = Entities:FindAllByName("npc_dota_roshan") --[[Returns:table
	-- Find all entities by name. Returns an array containing all the found entities in it.
	-- ]]

	-- for k,v in pairs(e) do
	-- 	v:SetHealth(v:GetMaxHealth())
	-- end

	keys.ability:ApplyDataDrivenModifier(caster, t, "modifier_duststorm_damage_over_time", {}) --[[Returns:void
	No Description Set
	]]
	t:EmitSound("Ability.SandKing_SandStorm.start")
	t:EmitSound("Ability.SandKing_SandStorm.loop")

	local info = 
	  {
	  Ability = keys.ability,
	  EffectName = "particles/units/heroes/hero_set/set_duststorm_projectile.vpcf",
	  -- EffectName = "particles/units/heroes/hero_reus/reus_stoneblast.vpcf",
	  vSpawnOrigin = caster:GetAbsOrigin(),
	  fDistance = distance,
	  fStartRadius = 0,
	  fEndRadius = 0,
	  Source = caster,
	  bHasFrontalCone = false,
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  vVelocity = facing*(distance/time),
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber()
	  }
	  ProjectileManager:CreateLinearProjectile(info)

	Physics:Unit(t)
  	t:SetPhysicsFriction(0)
	t:PreventDI(true)
	  -- To allow going through walls / cliffs add the following:
	t:FollowNavMesh(false)
	t:SetAutoUnstuck(false)
	t:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	t:SetPhysicsVelocity(facing * (distance/time))
	  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))

	t:SetPhysicsAcceleration(Vector(0,0,-700*4))

	Timers:CreateTimer(time-0.1,function()
		t:StopSound("Ability.SandKing_SandStorm.loop")
	end)
end

function aabts(keys)
	local caster = keys.caster
	local radius = keys.radius or 1000

	local modifier = "modifier_aabts_summon"
	local scepter_modifier = "modifier_aabts_summon_scepter"

	local mod = modifier

	if caster:HasScepter() then 
		mod = scepter_modifier
	end

	caster:EmitSound("Hero_Warlock.Upheaval")

	local u = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),15,0)

	caster.aabts_p = ParticleManager:CreateParticle("particles/units/heroes/hero_set/set_sinkhole.vpcf", PATTACH_ABSORIGIN, u) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(caster.aabts_p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	Timers:CreateTimer(1,function()

		caster:AddNewModifier(caster, nil, "modifier_invisible", {Duration=14}) --[[Returns:void
		No Description Set
		]]

	end)

	keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {}) --[[Returns:void
	No Description Set
	]]

	caster:EmitSound("Hero_NyxAssassin.Burrow.In")
end

function aabts_summon(keys)
	local caster = keys.caster
	local radius = keys.radius

	local unit = {}

	unit[1] = "npc_dota_unit_sand_puppet_warrior"
	unit[2] = "npc_dota_unit_sand_puppet_archer"

	local n = RandomInt(1, #unit)

	local point = caster:GetAbsOrigin()+RandomVector(RandomInt(radius*0.25,radius*0.50))

	local direction = (caster:GetAbsOrigin() - point):Normalized()

	local summon = CreateUnitByName(unit[n], point, true, caster, caster, caster:GetTeamNumber()) --[[Returns:handle
		Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
		]]

	local m = 0.64

	summon:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
	Set this unit controllable by the player with the passed ID.
	]]

	summon:SetForwardVector(direction)

	summon:AddNewModifier(caster, nil, "modifier_kill", {Duration=15}) --[[Returns:void
	No Description Set
	]]

	summon:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.1}) --[[Returns:void
	No Description Set
	]]

	summon:MoveToPositionAggressive(summon:GetAbsOrigin()+Vector(100,100,0)) --[[Returns:void
	Issue an Attack-Move-To command
	]]

	syncLevel(caster,summon,m,2)

	summon:SetIdleAcquire(true) --[[Returns:void
	No Description Set
	]]

	keys.ability:ApplyDataDrivenModifier(caster, summon, "modifier_aabts_check", {})

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_set/set_spawn_sand_puppet.vpcf", PATTACH_POINT, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, point) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	summon:EmitSound("Hero_PhantomLancer.Doppelganger.Appear")

end

function aabts_check(keys)
	local caster = keys.caster
	local target = keys.target

	local radius =  keys.radius

	target:SetIdleAcquire(true) --[[Returns:void
	No Description Set
	]]

	if not target:IsPositionInRange(caster:GetAbsOrigin(), radius) and not caster:HasScepter() then
		target:ForceKill(true)
	end

end

function aabts_end(keys)
	local caster = keys.caster

	ParticleManager:DestroyParticle(caster.aabts_p,false)

	caster:RemoveModifierByName("modifier_aabts_summon") --[[Returns:void
	Removes a modifier
	]]
	caster:RemoveModifierByName("modifier_aabts_summon_scepter") --[[Returns:void
	Removes a modifier
	]]

	caster:StopSound("Hero_Warlock.Upheaval")
	Timers:CreateTimer(2,function()
		caster:RemoveModifierByName("modifier_invisible") --[[Returns:void
		Removes a modifier
		]]
	end)

	local found_archer = Entities:FindAllByName("npc_dota_creature")

	local found_warrior = Entities:FindAllByName("npc_dota_creature")

	ToolsPrint("Found "..#found_archer+#found_warrior.." entries.")

	for k,v in pairs(found_archer) do
		if v:HasModifier("modifier_aabts_check") then
			v:ForceKill(true)
		end
	end
	for k,v in pairs(found_warrior) do
		if v:HasModifier("modifier_aabts_check") then
			v:ForceKill(true)
		end
	end
end

function HarshClimate(keys)
	local caster = keys.caster

	if GameRules:IsDaytime() then
		if not caster:HasModifier("modifier_harsh_sun_aura") then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_harsh_sun_aura", {}) --[[Returns:void
			No Description Set
			]]
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_harsh_sun_aura_creep", {}) --[[Returns:void
			No Description Set
			]]
		end
	else
		if caster:HasModifier("modifier_harsh_sun_aura") then
			caster:RemoveModifierByName("modifier_harsh_sun_aura") --[[Returns:void
			Removes a modifier
			]]
			caster:RemoveModifierByName("modifier_harsh_sun_aura_creep") --[[Returns:void
			Removes a modifier
			]]
		end
	end
end

function ReduceCooldowns(keys)
	local caster = keys.caster

	-- deprecated

	if 0 == 0 then return end

	ToolsPrint("REDUCING COOLDOWNS")

	if not caster:HasModifier("modifier_harsh_sun_aura") then return end

	local ab = caster:FindAbilityByName("set_harsh_sun")

	local level = ab:GetLevel()-1

	local reduction = 1 - math.abs((ab:GetLevelSpecialValueFor("cooldown_reduction", level)/100))

	ToolsPrint("Reduction is: "..reduction)

	local cooldown = keys.ability:GetCooldownTimeRemaining()
	keys.ability:EndCooldown()
	keys.ability:StartCooldown(reduction*cooldown)
end