function thunder_wave(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local modifier = "modifier_thunder_wave_generate"
	local speed = keys.speed
	local distance = 1250
	local direction = (target - caster:GetAbsOrigin()):Normalized()

	local dummy = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),8,100)
	keys.ability:ApplyDataDrivenModifier(caster, dummy, modifier, {}) --[[Returns:void
	No Description Set
	]]

	dummy.stop = false

	Physics:Unit(dummy)
  	dummy:SetPhysicsFriction(0.0)
  	dummy:PreventDI(true)

  	dummy:FollowNavMesh(false)
	dummy:SetAutoUnstuck(false)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
  
  	dummy:SetPhysicsVelocity(direction * distance)

  	Timers:CreateTimer(1,function()
    dummy:SetPhysicsVelocity(Vector(0,0,0))
--    FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
    	
    	
	dummy.stop = true
    end
    )
 
end

function generate_thunder(keys)
	local caster = keys.target
	local radius = keys.radius
	local dmg = keys.damage
	local ldmg = keys.lightningdamage or 225
	local count = 0
	local vector = caster:GetAbsOrigin() + RandomVector(150)

	print("[GENERATE_THUNDER]")

	if caster.stop == false then

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thuderstrike_aoe_area.vpcf", PATTACH_ABSORIGIN, caster) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(particle, 0, vector) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:SetParticleControl(particle, 2, vector) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		caster:EmitSound("Hero_Zuus.ArcLightning.Target")

		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              vector,
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

		for k,v in pairs(enemy_found) do
			DealDamage(v,keys.caster,dmg,DAMAGE_TYPE_MAGICAL)
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thunder_wave_buff", {}) --[[Returns:void
			No Description Set
			]]
		end

		Timers:CreateTimer(1,function()
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              vector,
	                              nil,
	                                radius/2,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)
			caster:EmitSound("Hero_Zuus.LightningBolt")
			for k,v in pairs(enemy_found) do
				DealDamage(v,keys.caster,ldmg,DAMAGE_TYPE_MAGICAL)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_thunder_wave_buff", {}) --[[Returns:void
				No Description Set
				]]
			end
			local targetmod = vector+Vector(0,0,800)
		    local boltparticle  = ParticleManager:CreateParticle("particles/units/heroes/hero_lightning/thunder_wave_lightning_bolt.vpcf", PATTACH_ABSORIGIN, caster)
		    ParticleManager:SetParticleControl(boltparticle,0,vector+Vector(0,0,25))
		    ParticleManager:SetParticleControl(boltparticle,1,targetmod)
		end
		)
	end
end

function overload(keys)
	local caster = keys.caster
	local ability1 = caster:FindAbilityByName("lightning_lightning_dagger")
	local ability2 = caster:FindAbilityByName("lightning_thunder_wave")

	ability1:EndCooldown()
	--ability2:EndCooldown()
end

function check_pos(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin()

	if caster.poscount == nil then caster.poscount = -1 end
	if caster.lastpos == nil then caster.lastpos = pos else caster.lastpos = caster.lastpos end

	if pos == caster.lastpos then
		print("[CHECK_POS] ADDING COUNT")
		caster.poscount = caster.poscount+1
	else
		caster.poscount = 0
	end

	if caster.poscount > 10 then
		print("[CHECK_POS] REMOVING MODIFIER")
		caster:RemoveModifierByName("modifier_blinding_speed_active") --[[Returns:void
		Removes a modifier
		]]
		caster:RemoveModifierByName("modifier_bloodseeker_thirst_speed") --[[Returns:void
		Removes a modifier
		]]
		caster:RemoveModifierByName("modifier_blinding_speed_active_aghs") --[[Returns:void
		Removes a modifier
		]]
		caster.poscount = -1
	end

	caster.lastpos = pos
end

function blinding_speed(keys)
	local caster = keys.caster
	local aghs = caster:HasScepter()
	local modifier = "modifier_blinding_speed_active"
	local aghs_modifier = "modifier_blinding_speed_active_aghs"

	if aghs then
		keys.ability:ApplyDataDrivenModifier(caster, caster, aghs_modifier, {}) --[[Returns:void
		No Description Set
		]]
	else
		keys.ability:ApplyDataDrivenModifier(caster, caster, modifier, {}) --[[Returns:void
		No Description Set
		]]
	end
end

function purge(keys)
	local caster = keys.caster
	caster:Purge(false, true, false, true, false)
end

function blinding_speed_increase_stack(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("lightning_blinding_speed2")
	local mod = "modifier_blinding_speed_stack"
	local max_stacks_mod = "modifier_blinding_speed_max_stack"
	local max_stacks = ability:GetLevelSpecialValueFor("max_stack", ability:GetLevel()) --[[Returns:table
	No Description Set
	]]
	local stacks = 0
	if caster:HasModifier(mod) then
		stacks = caster:GetModifierStackCount(mod,caster)
	end
	ability:ApplyDataDrivenModifier(caster, caster, mod, {}) --[[Returns:void
		No Description Set
		]]
	if stacks+1 >= max_stacks then
		ability:ApplyDataDrivenModifier(caster, caster, max_stacks_mod, {}) --[[Returns:void
		No Description Set
		]]
		caster:SetModifierStackCount(mod,caster,max_stacks)
	else
		caster:SetModifierStackCount(mod,caster,stacks+1)
	end
end

function blinding_speed_remove_modifiers(keys)
	local caster = keys.caster
	local mod = "modifier_blinding_speed_stack"
	local max_stacks_mod = "modifier_blinding_speed_max_stack"

	caster:RemoveModifierByName(mod) --[[Returns:void
	Removes a modifier
	]]
	caster:RemoveModifierByName(max_stacks_mod) --[[Returns:void
	Removes a modifier
	]]
end

function LightningDagger(keys)
	local caster = keys.caster
	local target = keys.target or keys.unit

end

function lightningDaggerMarkOnAttack(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target or keys.unit

	if attacker == caster then
		LightningDagger(keys)
	end
end

function Spark(keys)
	-- local caster = keys.caster

	-- local spark = caster:FindAbilityByName("lightning_spark") --[[Returns:handle
	-- Retrieve an ability by name from the unit.
	-- ]]

	-- if caster:PassivesDisabled() then return end

	-- if spark:GetLevel() <= 0 then return end

	-- local damage = spark:GetLevelSpecialValueFor("bonus_damage", spark:GetLevel())
	-- local radius = spark:GetLevelSpecialValueFor("radius", spark:GetLevel())

	-- local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
 --      caster:GetCenter(),
 --      nil,
 --        radius,
 --        DOTA_UNIT_TARGET_TEAM_ENEMY,
 --        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
 --        DOTA_UNIT_TARGET_FLAG_NONE,
 --        FIND_CLOSEST,
 --        false)

	-- caster:EmitSound("Hero_Zuus.StaticField")

	-- for k,v in pairs(enemy) do

	-- 	DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
	-- 	ParticleManager:CreateParticle("particles/units/heroes/hero_lightning/spark.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
	-- 	spark:ApplyDataDrivenModifier(caster, v, "modifier_spark_slow", {}) --[[Returns:void
	-- 	No Description Set
	-- 	]]

	-- end
end