function stoneblast_hit(keys)
	local caster = keys.caster
	local damage = keys.damage
	local stun = keys.stun
	local target = keys.target

	DealDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
	target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
	No Description Set
	]]
	target:EmitSound("Hero_EarthSpirit.BoulderSmash.Damage")
	ParticleManager:CreateParticle("", PATTACH_ROOTBONE_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
end

function reus_stalagmite(keys)
	local caster = keys.caster
	local min_range = keys.range_min
	local max_range = keys.range_max
	local damage = keys.damage
	local stun = keys.stun
	local radius = keys.radius or 100
	local num = keys.spike_number
	local travel_range = keys.range_travel
	local forward = caster:GetForwardVector()

	local startpoint = caster:GetAbsOrigin()+forward*RandomInt(min_range,max_range)
	local deviation = 0 -- deviation radius
	local deviation_max = 150 -- the maximum deviation that can occur

	caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")
	caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Cast")

	ScreenShake(caster:GetCenter(), 1200, 170, 0.4, 1200, 0, true)

	for i=1,num do
		Timers:CreateTimer(i*0.07,function()
			local point_not_moved_to_ground = startpoint+(forward*travel_range*i)+RandomVector(RandomInt(deviation,deviation_max))
			local point = GetGroundPosition(point_not_moved_to_ground,caster)
			local owner = FastDummy(point,caster:GetTeam(),1,0)
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_reus/reus_stalagmite.vpcf", PATTACH_POINT_FOLLOW, owner) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(p, 0, point) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          point,
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_ENEMY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		                    FIND_CLOSEST,
		                    false)
			caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Destroy")
			for k,v in pairs(enemy) do
				DealDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
				if not v:IsMagicImmune() then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_airtime", {}) --[[Returns:void
					No Description Set
					]]
					v:AddNewModifier(caster, nil, "modifier_stunned", {Duration = stun}) --[[Returns:void
					No Description Set
					]]
				end
			end
		end)
	end
end

function reus_magnitude_start(keys)
	local caster = keys.caster
	local target = keys.target
	local radius = keys.radius

	target:EmitSound("Hero_Earthshaker.Fissure")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_reus/reus_magnitude.vpcf", PATTACH_POINT_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 0, target:GetAbsOrigin()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius*1.15,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end

function reus_magnitude_quake_activate(keys)
	local caster = keys.caster
	local target = keys.target -- thinker

	local radius = keys.radius

	local root_time = keys.root_time

	ScreenShake(target:GetCenter(), 500, 5, root_time, radius*1.5, 0, true)

	target:EmitSound("Hero_ElderTitan.EarthSplitter.Cast")

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          target:GetAbsOrigin(),
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_ENEMY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NONE,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(enemy) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_magnitude_root", {}) --[[Returns:void
		No Description Set
		]]
	end

	local ally = FindUnitsInRadius( caster:GetTeamNumber(),
                          target:GetAbsOrigin(),
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NONE,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(ally) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_magnitude_slow", {}) --[[Returns:void
		No Description Set
		]]
	end
end

function reus_ancient_arena_start(keys)
	local caster = keys.caster
	local duration = keys.duration
	local radius = keys.radius or 875
	caster.ancient_owner = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),duration-0.03,0)

	caster:EmitSound("Hero_ElderTitan.EchoStomp")

	Timers:CreateTimer(0.6,function()
		caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")
		caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")
	end)

	local unit = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
		                    radius+50,
		                    DOTA_UNIT_TARGET_TEAM_BOTH,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(unit) do
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_ancient_arena_sticky", {}) --[[Returns:void
		No Description Set
		]]
		if v:IsRealHero() then
			v:GetAbilityByIndex(0):CreateVisibilityNode(caster:GetAbsOrigin(), radius+75, duration+0.03) --[[Returns:void
			No Description Set
			]]
		end
	end
end

function reus_ancient_arena_check(keys)
	local caster = keys.caster
	local range = keys.range

	if not caster.ancient_owner:IsNull() then

		local unit_in_radius = FindUnitsInRadius( caster:GetTeamNumber(),
	                          caster.ancient_owner:GetAbsOrigin(),
	                          nil,
			                    range+50,
			                    DOTA_UNIT_TARGET_TEAM_BOTH,
			                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
			                    DOTA_UNIT_TARGET_FLAG_NONE,
			                    FIND_CLOSEST,
			                    false)

		local unit_everywhere = FindUnitsInRadius( caster:GetTeamNumber(),
	                          caster.ancient_owner:GetAbsOrigin(),
	                          nil,
			                    FIND_UNITS_EVERYWHERE,
			                    DOTA_UNIT_TARGET_TEAM_BOTH,
			                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
			                    DOTA_UNIT_TARGET_FLAG_NONE,
			                    FIND_CLOSEST,
			                    false)

	

		for k,target in pairs(unit_in_radius) do

			local direction = (target:GetAbsOrigin()-caster.ancient_owner:GetAbsOrigin()):Normalized()
			local reversedirection = (caster.ancient_owner:GetAbsOrigin()-target:GetAbsOrigin()):Normalized()

			local distance = caster.ancient_owner:GetRangeToUnit(target)

			if target:HasModifier("modifier_spawned_in_last_frame") then keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_ancient_arena_sticky", {}) end

			if distance < range and not target:HasModifier("modifier_ancient_arena_sticky") then FindClearSpaceForUnit(target, (direction*(range+40))+caster.ancient_owner:GetAbsOrigin(), true) end

		end

		for k,target in pairs(unit_everywhere) do

			local direction = (target:GetAbsOrigin()-caster.ancient_owner:GetAbsOrigin()):Normalized()
			local reversedirection = (caster.ancient_owner:GetAbsOrigin()-target:GetAbsOrigin()):Normalized()

			local distance = caster.ancient_owner:GetRangeToUnit(target)

			if distance > range-100 and target:HasModifier("modifier_ancient_arena_sticky") then FindClearSpaceForUnit(target, (direction*(range-100))+caster.ancient_owner:GetAbsOrigin(), true) end

		end

	end
end
