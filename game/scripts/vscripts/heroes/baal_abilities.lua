function otherworld_screenspace(keys)
	local caster = keys.target
	local player = caster:GetPlayerID()
	player = PlayerResource:GetPlayer(player) --[[Returns:handle
	No Description Set
	]]

	player.otherworld_particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_baal/baal_otherworld_screen_effect.vpcf", PATTACH_ABSORIGIN, caster, player) --[[Returns:int
	Creates a new particle effect that only plays for the specified player
	]]
end

function otherworld_stop(keys)
	local caster = keys.target
	local player = caster:GetPlayerID()
	player = PlayerResource:GetPlayer(player)

	ParticleManager:DestroyParticle(player.otherworld_particle,false)
end

function otherworld_check(keys)
	local caster = keys.caster

	if caster:IsStunned() or caster:IsSilenced() then
		caster:RemoveModifierByName("modifier_otherworld") --[[Returns:void
		Removes a modifier
		]]
	end
end

function otherworld_cast(keys)
	local caster = keys.caster

	local cast = keys.cast == 1

	local player = caster:GetPlayerOwner()

	local ab = keys.ability
	--local ab2 = caster:FindAbilityByName("baal_otherworld_exit")

	--ab2:SetLevel(1)

	if cast then
		--ab:SetHidden(true)
		--ab2:SetHidden(false)
		caster:EmitSound("Baal.Otherworld.Enter")
		EmitSoundOnClient("Baal.Otherworld",player)
		EmitSoundOnClient("Baal.Superposition",player)
	else
		--ab:SetHidden(false)
		--ab2:SetHidden(true)
		caster:EmitSound("Baal.Otherworld.Exit")
		StopSoundOn("Baal.Otherworld",player)
		StopSoundOn("Baal.Superposition",player)
	end
end

function superposition_start(keys)
	local caster = keys.caster

	local duration = keys.duration
	local radius = keys.radius

	local point = caster:GetCursorPosition()

	caster.superposition_unit = FastDummy(point,caster:GetTeam(),duration+2,radius)

	FindClearSpaceForUnit(caster, point, true) --[[Returns:void
	Place a unit somewhere not already occupied.
	]]

	caster.superposition_unit:EmitSound("Baal.Superposition")

	local ab = caster:FindAbilityByName("baal_axial_seal") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]

	local lvl = ab:GetLevel()

	local found = Entities:FindAllByModel("models/heroes/oracle/crystal_ball.vmdl")

	for k,v in pairs(found) do
		local r = RandomInt(200,500)
		local rv = RandomVector(r)

		FindClearSpaceForUnit(v, point+rv, true)
		v:AddNewModifier(caster, nil, "modifier_kill", {Duration=35, IsHidden=true}) --[[Returns:void
		No Description Set
		]]
	end
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_superposition_teleport.vpcf", PATTACH_ABSORIGIN, caster) --[[Returns:int
    Creates a new particle effect
    ]]
	caster:Interrupt()
end

function superposition_check(keys)
	local caster = keys.caster
	local target = keys.target
	local radius = keys.radius

	-- find units in radius
	-- check if they are the caster or Axial Seals
	-- apply modifier if so

	local found = FindUnitsInRadius( target:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

	for k,v in pairs(found) do
		if v == caster then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_superposition_buff", {Duration=0.4, IsHidden=true}) --[[Returns:void
			No Description Set
			]]
		end
	end

end

function vector_plate_check(keys)
	local caster = keys.caster
	local target = keys.target -- unit

	local radius = keys.radius

	local distance = keys.push

	local facing = target:GetForwardVector()

	local damage = keys.damage

	local found = FindUnitsInRadius( target:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_HERO,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

	for k,unit in pairs(found) do
		if not unit:HasModifier("modifier_vector_plate_dont_affect_baal") then 
			Physics:Unit(unit)
			unit:SetPhysicsVelocity(Vector(0,0,0))
			unit:SetPhysicsFriction(0.2)
			unit:PreventDI(true)
			-- To allow going through walls / cliffs add the following:
			unit:FollowNavMesh(false)
			unit:SetAutoUnstuck(false)
			unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)

			unit:SetPhysicsVelocity(facing * distance * (1/0.25))
			unit:SetPhysicsAcceleration(Vector(0,0,-(distance*10)))
			-- keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_vector_plate_ignore", {})
			unit:Interrupt()
			unit:SetForwardVector(facing)
			unit:EmitSound("Baal.VectorPlate.Hero")
			Timers:CreateTimer(1.25,function()
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true) --[[Returns:void
				Place a unit somewhere not already occupied.
				]]
			end)
		end
		if unit:GetTeam() ~= caster:GetTeam() then
			keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_vector_plate_slow", {}) --[[Returns:void
			No Description Set
			]]
		end
	end
end

function vector_plate_start(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()

	--local facing = (point - caster:GetAbsOrigin()):Normalized()
	local facing = caster:GetForwardVector()

	local unit = FastDummy(point,caster:GetTeam(),25,0)

	local ab = caster:FindAbilityByName("baal_vector_plate_change")
	keys.ability:SetHidden(true)
	ab:SetHidden(false)
	ab:SetLevel(1)

	Timers:CreateTimer(2.5,function()
		local ab = caster:FindAbilityByName("baal_vector_plate_change")
		keys.ability:SetHidden(false)
		ab:SetHidden(true)
	end)

	unit:EmitSound("Baal.VectorPlate")

	unit:SetForwardVector(facing)

	unit.p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_vector_plate.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	Timers:CreateTimer(24.97,function() ParticleManager:DestroyParticle(unit.p,true) end)

	keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_vector_plate_particle_thinker", {}) --[[Returns:void
	No Description Set
	]]

	caster.vector_plate_changer_unit = unit
end

function vector_plate_face(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()
	local unit = caster.vector_plate_changer_unit
	local face = (point - unit:GetAbsOrigin()):Normalized()

	local ab = caster:FindAbilityByName("baal_vector_plate")
	keys.ability:SetHidden(true)
	ab:SetHidden(false)

	if unit then unit:SetForwardVector(face) end
end

function axial_seal(keys)
	local caster = keys.caster
	--local target = keys.target
	local point = caster:GetCursorPosition()

	--target:Kill(keys.ability,caster)
	--target:AddNoDraw()

	local nnnnn = 0

	local lvl = keys.ability:GetLevel()-1

	if lvl < 1 then lvl = 1 end

	repeat

		Timers:CreateTimer(nnnnn*0.15,function()
			local n = CreateUnitByName("npc_dota_unit_axial_"..lvl, point, true, caster, caster, caster:GetTeam()) --[[Returns:handle
			Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
			]]

			ToolsPrint("npc_dota_unit_axial_"..keys.ability:GetLevel().." "..n:GetUnitName())

			--n:AddNoDraw()

			n:EmitSound("Baal.Axial")

			n:SetOwner(caster)

			n:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
			Set this unit controllable by the player with the passed ID.
			]]

			--n:SetAbsOrigin(n:GetAbsOrigin()+Vector(0,0,150))

			n.p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_axial_seal.vpcf", PATTACH_ABSORIGIN_FOLLOW, n) --[[Returns:int
			Creates a new particle effect
			]]

			n:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.06, IsHidden = true}) --[[Returns:void
			No Description Set
			]]
			n:AddNewModifier(caster, nil, "modifier_kill", {Duration = 45}) --[[Returns:void
			No Description Set
			]]
		end)

		nnnnn = nnnnn+1

	until nnnnn >= lvl+1
end

function axial_death(keys)
	local target = keys.target

	if target.p then
		ParticleManager:DestroyParticle(target.p,false)
	end
end

function axial_phase(keys)
	local caster = keys.caster

	if caster:HasModifier("modifier_kill") then
		local mod = caster:FindModifierByName("modifier_kill")

		local remaining = mod:GetRemainingTime()
		caster.axial_r = remaining

		mod:SetDuration(999,true)
	end

	if caster.p then
		ParticleManager:DestroyParticle(caster.p,true)
	end

	caster.p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_axial_seal_phased.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_axialphase", {Duration=8}) --[[Returns:void
	No Description Set
	]]

	Timers:CreateTimer(8,function()
		if IsValidEntity(caster) then
			if caster:IsAlive() then
				local mod = caster:FindModifierByName("modifier_kill")
				local target = caster
				local caster = target:GetOwner()
				local n = CreateUnitByName("npc_dota_unit_axial_"..keys.ability:GetLevel(), target:GetAbsOrigin(), true, caster, caster, caster:GetTeam()) --[[Returns:handle
				Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
				]]

				--n:AddNoDraw()

				n:EmitSound("Baal.Axial")

				n:SetOwner(caster)

				n:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
				Set this unit controllable by the player with the passed ID.
				]]

				n:SetAbsOrigin(n:GetAbsOrigin()+Vector(0,0,150))

				n.p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_axial_seal.vpcf", PATTACH_ABSORIGIN_FOLLOW, n) --[[Returns:int
				Creates a new particle effect
				]]

				n:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.06, IsHidden = true}) --[[Returns:void
				No Description Set
				]]
				n:AddNewModifier(caster, nil, "modifier_kill", {Duration = 35}) --[[Returns:void
				No Description Set
				]]
			end
		else
			return
		end

		mod:SetDuration(caster.axial_r,true)
	end)
end

function axial_kill_unit(keys)
	local caster = keys.caster
	local owner = caster:GetOwner()
	caster = owner

	local target = keys.unit

	local duration = keys.duration

	target:AddNoDraw()

	local n = 0

	if target:IsRealHero() then
		nn = 3
	else
		nn = 1
	end

	while nn > 0 do

		local n = CreateUnitByName("npc_dota_unit_axial_phase", target:GetAbsOrigin(), true, caster, caster, caster:GetTeam()) --[[Returns:handle
		Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
		]]

		--n:AddNoDraw()

		n:EmitSound("Baal.Axial")

		n:SetOwner(caster)

		n:SetControllableByPlayer(caster:GetPlayerID(), true) --[[Returns:void
		Set this unit controllable by the player with the passed ID.
		]]

		--n:SetAbsOrigin(n:GetAbsOrigin()+Vector(0,0,150))

		n.p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_axial_seal_phased.vpcf", PATTACH_ABSORIGIN_FOLLOW, n) --[[Returns:int
		Creates a new particle effect
		]]

		n:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.06, IsHidden = true}) --[[Returns:void
		No Description Set
		]]
		n:AddNewModifier(caster, nil, "modifier_kill", {Duration = duration}) --[[Returns:void
		No Description Set
		]]

		nn = nn - 1

	end

end

function spatial_rift_start(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()
	local radius = keys.radius or 230
	local duration = keys.duration or 6

	caster.spatial_rift_unit = FastDummy(point+Vector(0,0,150),caster:GetTeam(),duration+1.5,radius)

	caster.spatial_rift_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_spatial_rift_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.spatial_rift_unit)
end

function spatial_riftend(keys)
	local caster = keys.caster

	ParticleManager:DestroyParticle(caster.spatial_rift_particle,true)
	ParticleManager:DestroyParticle(caster.spatial_rift_start_particle,true)
	caster.spatial_rift_unit:ForceKill(false)
	caster.spatial_rift_unit = nil
end

function _spatial_riftend(caster)
	local caster = caster

	ParticleManager:DestroyParticle(caster.spatial_rift_particle,true)
	caster.spatial_rift_unit:ForceKill(false)
	caster.spatial_rift_unit = nil
end

function spatial_rift(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()
	local radius = keys.radius or 230
	local duration = keys.duration or 6
	local ability = caster:FindAbilityByName("baal_port_out")

	if caster.spatial_rift_unit == nil then keys.ability:EndCooldown() keys.ability:RefundManaCost() return end

	ParticleManager:DestroyParticle(caster.spatial_rift_start_particle,false)

	caster.spatial_rift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_spatial_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.spatial_rift_unit)

	ability:SetActivated(true)

	caster.spatial_rift_unit:EmitSound("Hero_ChaosKnight.RealityRift.Target")

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_spatial_rift_show", {}) --[[Returns:void
		No Description Set
		]]

	Timers:CreateTimer(duration+0.1,function()
		ability:SetActivated(false)
	end)

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              point,
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

	for k,v in pairs(found) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_spatial_rift_slow", {}) --[[Returns:void
		No Description Set
		]]
	end
end

function port(keys)
	local caster = keys.caster
	local point = caster:GetAbsOrigin()
	if IsValidEntity(caster.spatial_rift_unit) then
		point = caster.spatial_rift_unit:GetAbsOrigin()
	else
		keys.ability:SetActivated(false)
		return
	end

	local unit = FastDummy(caster:GetCenter(),caster:GetTeam(),2,350)

	ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_rift_shockwave_port.vpcf",PATTACH_ROOTBONE_FOLLOW,unit)

	unit:EmitSound("Hero_Puck.EtherealJaunt")

	Timers:CreateTimer(0.06, function()
		ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_rift_shockwave_port.vpcf",PATTACH_ROOTBONE_FOLLOW,caster)

		FindClearSpaceForUnit(caster, point, true) --[[Returns:void
		Place a unit somewhere not already occupied.
		]]

		caster:RemoveModifierByName("modifier_spatial_rift_show")

		keys.ability:SetActivated(false)

		_spatial_riftend(caster)
	end)
end

function port_activated(keys)
	keys.ability:SetActivated(false)
end

function compress_start(keys)
	local caster = keys.caster
	local target = keys.target

	local speed = 950

	local ab1 = keys.ability
	local ab2 = caster:FindAbilityByName("baal_fire")

	if target:IsMagicImmune() then return end

	if target == caster then keys.ability:RefundManaCost() keys.ability:EndCooldown() return end

	target.compress_follow = caster
	caster.compress_target = target

	caster.compress_targetc = false

	target:Interrupt()

	target:AddNoDraw()
	target:EmitSound("Hero_Dark_Seer.Vacuum")
	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_compress_target_inv", {}) --[[Returns:void
	No Description Set
	]]

	--particles!

	local info = 
	  {
	  Target = caster,
	  Source = target,
	  Ability = keys.ability,
	  EffectName = "particles/units/heroes/hero_baal/baal_compress_projectile2.vpcf",
	  vSpawnOrigin = target:GetAbsOrigin(),
	  fDistance = 2500,
	  fStartRadius = 64,
	  fEndRadius = 64,
	  bHasFrontalCone = false,
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_ALL,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  bDeleteOnHit = true,
	  iMoveSpeed = speed,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber(),
	  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	  }

	ab1:SetHidden(true)
	ab2:SetHidden(false)
	ab2:SetLevel(ab1:GetLevel())

	ProjectileManager:CreateTrackingProjectile(info) --[[Returns:int
	Creates a linear projectile and returns the projectile ID
	]]

	local hold_time = 3.00

	if target:GetTeam() == caster:GetTeam() then hold_time = hold_time*2 else keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_compress_dot", {}) end

	Timers:CreateTimer("baal_compress_timer", {
		useGameTime = true,
		endTime = hold_time,
		callback = function()
			caster.compress_target:RemoveModifierByName("modifier_compress_target_inv")
			caster:RemoveModifierByName("modifier_compress_dot") --[[Returns:void
			Removes a modifier
			]]
		end
	})

end

function compress_follow_tick(keys)
	local caster = keys.caster
	local target = keys.target

	local follow = target.compress_follow

	target:SetAbsOrigin(caster:GetAbsOrigin()) --[[Returns:void
	SetAbsOrigin
	]]
end

function compress_release(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()

	local target = caster.compress_target
	local aoe = keys.radius
	local damage = keys.damage

	if not IsValidEntity(target) then ab1:SetHidden(false) ab2:SetHidden(true) return end

	unit = FastDummy(point,caster:GetTeam(),5,0)

	caster.compress_targetc = true

	Timers:RemoveTimer("baal_compress_timer")

	local distance = caster:GetRangeToUnit(unit)

	local speed = 950

	local time = distance/speed

	local ab1 = caster:FindAbilityByName("baal_compress")
	local ab2 = caster:FindAbilityByName("baal_fire")

	local info = 
	  {
	  Target = unit,
	  Source = caster,
	  Ability = keys.ability,
	  EffectName = "particles/units/heroes/hero_baal/baal_compress_projectile2_end.vpcf",
	  vSpawnOrigin = caster:GetAbsOrigin(),
	  fDistance = distance,
	  fStartRadius = 64,
	  fEndRadius = 64,
	  bHasFrontalCone = false,
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_ALL,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  bDeleteOnHit = true,
	  iMoveSpeed = speed,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber(),
	  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	  }

	ProjectileManager:CreateTrackingProjectile(info) --[[Returns:int
	Creates a linear projectile and returns the projectile ID
	]]

	Timers:CreateTimer(time,function()

		FindClearSpaceForUnit(caster.compress_target, point, true) --[[Returns:void
		Place a unit somewhere not already occupied.
		]]

		local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                aoe,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

		for k,v in pairs(found) do
			DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end

		caster:RemoveModifierByName("modifier_compress_dot") --[[Returns:void
		Removes a modifier
		]]

		caster.compress_target:RemoveModifierByName("modifier_compress_target_inv")

		caster.compress_target:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")

	end)

end

function compress_end(keys)
	local caster = keys.caster
	local target = keys.target

	local ab1 = caster:FindAbilityByName("baal_compress")
	local ab2 = caster:FindAbilityByName("baal_fire")

	ab1:SetHidden(false)
	ab2:SetHidden(true)
	ab1:SetLevel(ab2:GetLevel())

	if not caster.compress_targetc then caster:AddNewModifier(caster, nil, "modifier_stunned", {Duration=2}) end

	caster:RemoveModifierByName("modifier_compress_dot") --[[Returns:void
	Removes a modifier
	]]

	target:RemoveNoDraw()
end

function compress_dot(keys)
	local caster = keys.caster
	local target = nil
	if caster.compress_target then target = caster.compress_target end

	if target:GetTeam() == caster:GetTeam() then return end

	local atk = target:GetAverageTrueAttackDamage(target)

	local dmg = atk*0.10

	DealDamage(caster,target,dmg,DAMAGE_TYPE_PURE)
end

function st_anchor_start(keys)
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration
	local radius = keys.radius

	

	local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),duration+0.8,0)

	target.st_anchor_unit = unit

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	Timers:CreateTimer(duration,function()
		ParticleManager:DestroyParticle(p,false)
	end)

	target:EmitSound("Hero_Visage.GraveChill.Cast")
end

function st_anchor(keys)
	local caster = keys.caster
	local target = keys.target
	local stun = keys.stun
	local radius = keys.radius
	local damage = keys.damage

	if not IsValidEntity(target.st_anchor_unit) then return end

	if not target.st_anchor_unit then return end

	if target:IsMagicImmune() then return end

	if target:GetRangeToUnit(target.st_anchor_unit) > radius then
		DealDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
		target:EmitSound("Baal.VectorPlate")
		ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor_target_start.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
		Timers:CreateTimer(0.03,function()
			FindClearSpaceForUnit(target, target.st_anchor_unit:GetAbsOrigin(), true) --[[Returns:void
			Place a unit somewhere not already occupied.
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor_target.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
		end)
		--target:RemoveModifierByName("modifier_st_anchor")
		--target.st_anchor_unit:ForceKill(true)
	end
end