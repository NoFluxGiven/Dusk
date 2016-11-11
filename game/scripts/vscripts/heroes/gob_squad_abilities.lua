function rocket_blast(keys)
	local caster = keys.caster
	local target = keys.target

	ScreenShake(target:GetCenter(), 1000, 3, 0.75, 1500, 0, true)
end

function whoops(keys)
	local caster = keys.caster
	local target = keys.target
	local respawn = keys.respawn/100
	
	ScreenShake(target:GetCenter(), 1000, 3, 0.75, 1500, 0, true)

	-- Reduce respawn time by percentage amount

	if caster:IsIllusion() then return end

end

function clearance_sale_start(keys)
	local caster = keys.caster

	local mod = "modifier_clearance_sale_throw"

	if caster:HasScepter() then
		mod = "modifier_clearance_sale_throw_aghs"
		mod2 = "modifier_clearance_sale_throw_end"
	end

	local duration = keys.duration

	keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {Duration=duration}) --[[Returns:void
	No Description Set
	]]
	if mod2 then
		keys.ability:ApplyDataDrivenModifier(caster, caster, mod2, {Duration=duration+1}) --[[Returns:void
		No Description Set
		]]
	end
end

function clearance_sale(keys)
	local caster = keys.caster

	local radius = keys.radius

	local damage = keys.damage

	local pos = caster:GetAbsOrigin()

	local bomb_pos = pos+RandomVector(RandomInt(200,475)) --[[Returns:Vector
	Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
	]]

	local unit = FastDummy(pos,caster:GetTeam(),1.6,250)
	local dunit = FastDummy(bomb_pos,caster:GetTeam(),0.1,0)

	local r = RandomInt(1, 10) --[[Returns:int
	Get a random ''int'' within a range
	]]
	unit.bomb_type = DAMAGE_TYPE_MAGICAL
	unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb.vpcf"
	unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion.vpcf"
	unit.explosion_sound = "Hero_TemplarAssassin.Trap.Explode"

	if r <= 3 then
		unit.bomb_type = DAMAGE_TYPE_PHYSICAL
		unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_physical.vpcf"
		unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_physical.vpcf"
		unit.explosion_sound = "Hero_Techies.RemoteMine.Detonate"
	end
	if r >= 9 then
		unit.bomb_type = DAMAGE_TYPE_PURE
		unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_pure.vpcf"
		unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_pure.vpcf"
		unit.explosion_sound = "Hero_Techies.StasisTrap.Stun"
	end

	local bp = ParticleManager:CreateParticle(unit.bomb_particle, PATTACH_ABSORIGIN_FOLLOW, unit)

	local distance = unit:GetRangeToUnit(dunit) --[[Returns:float
	No Description Set
	]]
	local direction = (unit:GetAbsOrigin() - bomb_pos):Normalized()

	Physics:Unit(unit)
  	unit:SetPhysicsFriction(0)
  	unit:PreventDI(true)
  	-- To allow going through walls / cliffs add the following:
  	unit:FollowNavMesh(false)
  	unit:SetAutoUnstuck(false)
  	unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
  
  	unit:SetPhysicsVelocity(direction * distance)
  	unit:AddPhysicsVelocity(Vector(0,0,800))
  
  	unit:SetPhysicsAcceleration(Vector(0,0,-(1800)))
  	unit:EmitSound("Hero_ChaosKnight.idle_throw")

	Timers:CreateTimer(1,function()
		local p = ParticleManager:CreateParticle(unit.explosion_particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:DestroyParticle(bp,false)
		unit:EmitSound(unit.explosion_sound) --[[Returns:void
		 
		]]
		ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)
		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              unit:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

		local ally_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              unit:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

		for k,v in pairs(enemy_found) do
			DealDamage(v,caster,damage,unit.bomb_type)
			if unit.bomb_type == DAMAGE_TYPE_PURE then
				v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.60}) --[[Returns:void
				No Description Set
				]]
			end
			if unit.bomb_type == DAMAGE_TYPE_PHYSICAL then
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_clearance_sale_slow", {Duration=2}) --[[Returns:void
				No Description Set
				]]
			end
		end

		for k,v in pairs(ally_found) do
			if v == caster then
				DealDamage(v,caster,damage*0.33,unit.bomb_type)
			end
		end
	end)
end

function clearance_sale_aghs_end(keys)
	local caster = keys.caster

	local radius = keys.radius

	local damage = keys.damage

	local pos = caster:GetAbsOrigin()

	local bomb_pos = pos+RandomVector(RandomInt(10,50)) --[[Returns:Vector
	Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
	]]

	local unit = FastDummy(pos,caster:GetTeam(),5,250)
	local dunit = FastDummy(bomb_pos,caster:GetTeam(),0.1,0)

	unit.bomb_type = DAMAGE_TYPE_MAGICAL
	unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_aghs.vpcf"
	unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_aghs.vpcf"
	unit.explosion_sound = "Hero_Gyrocopter.CallDown.Damage"

	local bp = ParticleManager:CreateParticle(unit.bomb_particle, PATTACH_ABSORIGIN_FOLLOW, unit)

	local distance = unit:GetRangeToUnit(dunit) --[[Returns:float
	No Description Set
	]]
	local direction = (unit:GetAbsOrigin() - bomb_pos):Normalized()

	Physics:Unit(unit)
  	unit:SetPhysicsFriction(0)
  	unit:PreventDI(true)
  	-- To allow going through walls / cliffs add the following:
  	unit:FollowNavMesh(false)
  	unit:SetAutoUnstuck(false)
  	unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
  
  	unit:SetPhysicsVelocity(direction * distance)
  	unit:AddPhysicsVelocity(Vector(0,0,1700))
  
  	unit:SetPhysicsAcceleration(Vector(0,0,-(1800)))
  	unit:EmitSound("Hero_ChaosKnight.idle_throw")

	Timers:CreateTimer(2,function()
		local p = ParticleManager:CreateParticle(unit.explosion_particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:DestroyParticle(bp,false)
		unit:EmitSound(unit.explosion_sound) --[[Returns:void
		 
		]]
		ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)
		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              unit:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

		local ally_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              unit:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

		for k,v in pairs(enemy_found) do
			DealDamage(v,caster,damage,unit.bomb_type)
		end

		for k,v in pairs(ally_found) do
			if v == caster then
				DealDamage(v,caster,damage*0.33,unit.bomb_type)
			end
		end
	end)
end

function kamikaze(keys)
	local caster = keys.caster
	local total = keys.total/100
	local damage = keys.damage + (caster:GetMaxHealth()*(keys.health_damage/100))*total

	local radius = keys.radius

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

	caster:ModifyHealth(caster:GetHealth()-(caster:GetMaxHealth()*(keys.health_damage/100)), keys.ability, true, 0) --[[Returns:void
	Sets the health to a specific value, with optional flags or inflictors.
	]]

	local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),1,0)

	unit:EmitSound("Hero_Techies.Suicide") --[[Returns:void
	 
	]]

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_gob_squad/kamikaze_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)

	caster:AddNewModifier(caster, nil, "modifier_stunned", {Duration=1}) --[[Returns:void
	No Description Set
	]]

	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
	end
end