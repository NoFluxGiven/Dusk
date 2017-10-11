function tek_skycrack(keys)
	local caster = keys.caster
	local length = keys.length

	local powered = keys.powered or 0

	if caster:HasScepter() then powered = 1 length = length * 2 end

	local particle = "particles/units/heroes/hero_tek/skycrack.vpcf"

	if powered == 1 then particle = "particles/units/heroes/hero_tek/skycrack_powered.vpcf" end

	local pos = caster:GetCenter()
	local target = pos+ caster:GetForwardVector() * length + Vector(0,0,80) -- position
	local start = pos+ caster:GetForwardVector() * 40 + Vector(0,0,80)

	caster:EmitSound("Hero_Leshrac.Lightning_Storm")

	local p = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 0, start) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, target) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/skycrack_eff.vpcf", PATTACH_ROOTBONE_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	local info = 
	{
		Ability = keys.ability,
    	vSpawnOrigin = pos,
    	fDistance = length-30,
    	fStartRadius = 80,
    	fEndRadius = 80,
    	Source = caster,
    	bHasFrontalCone = false,
    	bReplaceExisting = false,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * length * 6,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(info) --[[Returns:int
	Creates a linear projectile and returns the projectile ID
	]]
end

function tek_mosquito_acquire_target(keys)
	local caster = keys.caster
	local range = keys.range or 1200

	if caster.mosquito_targets == nil then caster.mosquito_targets = {} else caster.mosquito_targets = caster.mosquito_targets end
	if caster.temp_targets == nil then caster.temp_targets = {} else caster.temp_targets = caster.temp_targets end

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            range,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                            FIND_CLOSEST,
                            false)

	local found = false

	for k,v in pairs(enemy) do
		
		if CheckTable(caster.temp_targets,v) == nil then -- if this unit is not in the target table, target it
			ToolsPrint("FOUND UNIT")
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/targeting_reticule.vpcf", PATTACH_ROOTBONE_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]
			playTargetingSound(caster)
			table.insert(caster.temp_targets,v)
			if #caster.temp_targets >= #enemy then
				for k,v in pairs(caster.temp_targets) do
					ToolsPrint("INSERTING "..k.." INTO TABLE")
					table.insert(caster.mosquito_targets,v)
				end
				caster.temp_targets = {}
			end
			break
		end
		ToolsPrint("UNIT ALREADY IN TABLE")
		-- if #target_table > #caster.mosquito_targets then
		-- 	target_table = {}
		-- end

	end
end

function tek_fire_mosquito_missiles(keys)
	local caster = keys.caster

	if caster.mosquito_targets == nil then ToolsPrint("NIL TABLE") return end

	for k,v in pairs(caster.temp_targets) do -- capture the remaining targets
		ToolsPrint("INSERTING "..k.." INTO TABLE")
		table.insert(caster.mosquito_targets,v)
	end

	ToolsPrint("TARGETS: "..#caster.mosquito_targets)

	for k,v in pairs(caster.mosquito_targets) do
		Timers:CreateTimer(k*(0.20-(keys.ability:GetLevel()-1)*0.05),function()
			if IsValidEntity(v) then
				caster:EmitSound("Hero_Leshrac.Pulse_Nova_Strike")
				local info = 
				  {
				  Target = v,
				  Source = caster,
				  Ability = keys.ability,  
				  EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
				  vSpawnOrigin = caster:GetAbsOrigin(),
				  fDistance = 9999,
				  fStartRadius = 64,
				  fEndRadius = 64,
				  bHasFrontalCone = false,
				  bReplaceExisting = false,
				  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				  fExpireTime = GameRules:GetGameTime() + 10.0,
				  bDeleteOnHit = true,
				  iMoveSpeed = 1200,
				  bProvidesVision = false,
				  iVisionRadius = 0,
				  iVisionTeamNumber = caster:GetTeamNumber(),
				  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
				  }
				  if caster:IsAlive() and not caster:IsStunned() and not caster:IsSilenced() then
				  	local projectile = ProjectileManager:CreateTrackingProjectile(info)
				  end
			end
		end)
	end

	caster.mosquito_targets = {}
	caster.temp_targets = {}
	caster:RemoveModifierByName("modifier_tek_acquire_targets") --[[Returns:void
	Removes a modifier
	]]
	caster:RemoveModifierByName("modifier_tek_powered_acquire_targets") --[[Returns:void
	Removes a modifier
	]]
end

function swap_abilities(keys)
	local caster = keys.caster
	local swap = keys.swap

	ToolsPrint("SWAPPING ABILITIES")

	local abilities = {
		caster:FindAbilityByName("tek_skycrack"),
		caster:FindAbilityByName("tek_mosquito_missiles"),
		caster:FindAbilityByName("tek_shield"),
		caster:FindAbilityByName("tek_power_up")
	}

	local abilities_powered = {
		caster:FindAbilityByName("tek_powered_skycrack"),
		caster:FindAbilityByName("tek_powered_mosquito_missiles"),
		caster:FindAbilityByName("tek_powered_shield"),
		caster:FindAbilityByName("tek_power_power_up")
	}

	local levels = {}
	local powered_levels = {}

	for k,v in pairs(abilities) do
		table.insert(levels, k, v:GetLevel())
	end

	for k,v in pairs(abilities_powered) do
		table.insert(powered_levels, k, v:GetLevel())
	end

	if swap == 0 then -- swapping back
		for k,v in pairs(abilities) do
			v:SetHidden(false)
			v:SetLevel(powered_levels[k])
		end
		for k,v in pairs(abilities_powered) do
			v:SetHidden(true)
		end
	end

	if swap == 1 then
		for k,v in pairs(abilities) do
			v:SetHidden(true)
		end
		for k,v in pairs(abilities_powered) do
			v:SetHidden(false)
			v:SetLevel(levels[k])
		end
	end
end

function tek_selfdestruct_charge(keys) -- creates the particle effects
	local caster = keys.caster

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/self_destruct_charge.vpcf", PATTACH_ROOTBONE_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	caster:EmitSound("Hero_Tinker.MechaBoots.Loop")
	caster:EmitSound("Hero_Oracle.FalsePromise.Target")

	Timers:CreateTimer(1,function()
		caster:StopSound("Hero_Tinker.MechaBoots.Loop")
	end)
end

function tek_selfdestruct(keys) -- creates the particle effects
	local caster = keys.caster
	local damage = keys.damage or 600*keys.ability:GetLevel()

	caster:RemoveModifierByName("modifier_tek_powered_shield_on") --[[Returns:void
	Removes a modifier
	]]
	caster:RemoveModifierByName("modifier_tek_shield_on") --[[Returns:void
	Removes a modifier
	]]
	caster:Purge(true,true,false,true,false)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/self_destruct_explosion.vpcf", PATTACH_ROOTBONE_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, caster:GetCenter()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	caster:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
	--caster:EmitSound("Ability.Ravage")
	caster:EmitSound("Hero_Oracle.FalsePromise.Damaged")
	caster:EmitSound("Hero_Oracle.FortunesEnd.Target")

	ScreenShake(caster:GetCenter(), 1200, 170, 2, 1000, 0, true) --[[Returns:void
	Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
	]]

	caster:AddNewModifier(caster, nil, "modifier_stunned", {Duration=2}) --[[Returns:void
	No Description Set
	]]

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            450,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_BUILDING,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,
                            false)

	for k,v in pairs(enemy) do
		ToolsPrint("FOUND UNIT!")
		DealDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
	end
	DealDamage(caster,caster,damage,DAMAGE_TYPE_PHYSICAL)

	--if not caster:IsAlive() then caster:AddNoDraw() end
end

function aamines_start(keys)
	local caster = keys.caster
	local mod = "modifier_tek_aamines_charges"
	local amount = keys.stack
	local autofire_delay = 4 -- the time it takes for us to fire automatically if we're not using the ability
	local auto = false

	-- if caster:HasScepter() then auto = true end

	if auto == true then aamines_start_auto(keys) return end

	if caster:HasModifier(mod) then
		keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {Duration=4})
		local modifier = caster:FindModifierByName(mod)
		aamines_place_target(keys)
		modifier:SetStackCount(modifier:GetStackCount()-1)
		if modifier:GetStackCount() <= 0 then
			aamines_fire(keys)
			keys.ability.ignoreFire = true
			modifier:Destroy()
			keys.ability.ignoreFire = false
		else
			ToolsPrint("Resetting cooldown and refunding Mana cost.")
			keys.ability:EndCooldown()
			keys.ability:RefundManaCost()
		end
		return
	end

	keys.ability.aamines_units = {}

	local modifier = keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {Duration=4}) --[[Returns:void
	No Description Set
	]]

	modifier:SetStackCount(amount-1)

	aamines_place_target(keys)

	keys.ability:EndCooldown()
	keys.ability:RefundManaCost()
end

function aamines_start_auto(keys)
	local caster = keys.caster
	local mod = "modifier_tek_aamines_charges"
	local amount = keys.stack * 2
	local autofire_delay = 4 -- the time it takes for us to fire automatically if we're not using the ability

	keys.ability.aamines_units = {}

	local n = 0

	repeat
		local pos = caster:GetCursorPosition()+RandomVector(RandomInt(0,450)) --[[Returns:Vector
		Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
		]]
		aamines_place_target(keys,pos)
		n = n+1
	until
		n > amount

	aamines_fire(keys)
end

function aamines_place_target(keys, position)
	local caster = keys.caster
	local target = caster:GetCursorPosition()
	if position ~= nil then target = position end
	local direction = (caster:GetAbsOrigin() - target):Normalized()
	local ability = keys.ability

	-- Clamp the range, since immediate abilities ignore cast range
	-- local maxrange = ability:GetCastRange()
	-- local range_unit = FastDummy(target,caster:GetTeam(),0.06,0)
	-- if caster:GetRangeToUnit(range_unit) > maxrange then
	-- 	target = direction*maxrange
	-- end

	local unit = FastDummy(target,caster:GetTeam(),25,75)

	unit:SetOwner(caster)

	playTargetingSound(caster)

	if not ability.aamines_units then
		ability.aamines_units = {}
	end

	table.insert(ability.aamines_units,unit)

	ToolsPrint("Added "..unit:GetName().." to ability.aamines_units @ "..#ability.aamines_units-1)

	ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_tek/aamines_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit,caster:GetTeam()) --[[Returns:int
	Creates a new particle effect
	]]
end

function aamines_fire(keys)
	local caster = keys.caster
	local targets = keys.ability.aamines_units
	local landtime = 1 -- takes 1 second to begin landing after firing
	local landdelay = 1.8 -- takes 1 second after beginning landing to hit the ground
	local interval = 0.25 -- takes 0.2 seconds between each
	local interval_reduction = 0.98
	local min_interval = 0.05
	local delay = keys.delay -- the time it takes for the mine to explode once it hits the ground

	if keys.ability.ignoreFire then return end

	keys.ability:UseResources(true,false,true)

	for k,v in pairs(targets) do
		local interval_time = math.max(interval*(interval_reduction^k),min_interval)*k
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_tek_aamines_explode", {Duration=landdelay+landtime+interval_time+delay}) --[[Returns:void
			No Description Set
			]]
		ToolsPrint(interval_time)
		Timers:CreateTimer(interval_time,function()
			ParticleManager:CreateParticle("particles/units/heroes/hero_tek/aamines_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			caster:EmitSound("Hero_Rattletrap.Rocket_Flare.Fire") --[[Returns:void
			 
			]]
			ToolsPrint("Firing...")
		end)
		Timers:CreateTimer(landtime+interval_time,function()
			ToolsPrint("Landing...")
			ParticleManager:CreateParticle("particles/units/heroes/hero_tek/aamines_land.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]
		end)
		Timers:CreateTimer(landdelay+landtime+interval_time,function()
			ToolsPrint("Sticking...")
			v.stick_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/aamines_stick.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]
			v:EmitSound("Hero_Rattletrap.Battery_Assault_Launch")
		end)
	end
end

function aamines_explode(keys)
	local caster = keys.target -- the unit

	local damage = keys.damage
	local con_damage = keys.con_damage

	local radius = keys.radius

	local con_radius = keys.con_radius

	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/aamines_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:DestroyParticle(caster.stick_particle,true)

	ToolsPrint("EXPLODING!")

	caster:EmitSound("Hero_StormSpirit.StaticRemnantExplode") --[[Returns:void
			 
			]]
	caster:EmitSound("Hero_Rattletrap.Rocket_Flare.Explode")


	ParticleManager:SetParticleControl(p1, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	ScreenShake(caster:GetAbsOrigin(), 25, 7, 1, 1500, 0, true)

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)

	for k,v in pairs(enemy) do
		local damage = damage
		if not v:IsHero() then damage = damage/2 end
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.05})
	end

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            con_radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)

	for k,v in pairs(enemy) do
		local damage = con_damage
		if not v:IsHero() then damage = damage/2 end
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.05}) --[[Returns:void
		No Description Set
		]]
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_tek_aamines_slow", {}) --[[Returns:void
		No Description Set
		]]
	end

	Timers:CreateTimer(1,function() UTIL_Remove(caster) end)
end

function playTargetingSound(emitter)
	local r = RandomInt(2,2)

	local sound = "Tek.MosquitoMissiles.Acquire"..tostring(r)

	if emitter then
		ToolsPrint("Emitting "..sound.." on "..emitter:GetName())
		emitter:EmitSound(sound)
	end
end

function microarray_start(keys)
	local caster = keys.caster
	local casterpos = caster:GetAbsOrigin()
	local target = caster:GetCursorPosition()

	local unit = FastDummy(target,caster:GetTeam(),1,0)

	local distance = caster:GetRangeToUnit(unit) --[[Returns:float
	No Description Set
	]]

	ToolsPrint("Begin range is "..distance)

	local speed = 4000 -- the speed with which we travel to the target location.

	local travel_time = distance/speed

	local min_chargetime = keys.min_chargetime or 1

	local bonus_chargetime = 1

	local max_chargetime = keys.max_chargetime or 3

	local bonus_units = 500 -- every X units we have to travel, add Y seconds to the charge time

	local chargetime = (bonus_chargetime*(distance/bonus_units))

	if chargetime > max_chargetime then chargetime = max_chargetime end

	if chargetime < min_chargetime then chargetime = min_chargetime end

	local p_charge = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/ftl_microarray.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	local p_go = 0

	Timers:CreateTimer(chargetime,function()
		direction = (target - caster:GetAbsOrigin()):Normalized()
		unit = FastDummy(target,caster:GetTeam(),1,0)

		distance = caster:GetRangeToUnit(unit) --[[Returns:float
		No Description Set
		]]
		ToolsPrint("Range is "..distance)
		travel_time = distance/speed

		caster.ma_distance_travelled = 0
		caster.ma_max_distance = distance
		caster.ma_speed = speed
		Timers:CreateTimer(travel_time,function()
			caster:SetPhysicsVelocity(Vector(0,0,0))
			caster:SetModelScale(0.8)
			ParticleManager:DestroyParticle(p_go,false)
			caster:RemoveModifierByName("modifier_tek_microarray_check") --[[Returns:void
			Removes a modifier
			]]
		end)
		caster:SetModelScale(0)
		Physics:Unit(caster)
		caster:SetPhysicsFriction(0)
		caster:SetPhysicsVelocity(direction * speed)
		caster:FollowNavMesh(false)
		caster:SetAutoUnstuck(false)
		caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		ParticleManager:DestroyParticle(p_charge,false)
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_tek_microarray_check", {}) --[[Returns:void
		No Description Set
		]]
		p_go = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/ftl_microarray_travel.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end)
	Timers:CreateTimer(chargetime+travel_time+0.06,function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true) --[[Returns:void
		Place a unit somewhere not already occupied.
		]]
	end)

end

function microarray_check(keys)
	local caster = keys.caster
	local distance = caster.ma_max_distance
	local max_damage = keys.max_damage or 400
	local max_stun = keys.max_stun or 4
	local radius = keys.radius or 125
	local min_stun = keys.min_stun or 0.4
	local min_damage = keys.min_damage or 50

	local range_for_max = 2500

	local damage = max_damage*(distance/range_for_max)

	if damage > max_damage then damage = max_damage end

	if damage < min_damage then damage = min_damage end

	local stun = max_stun*(distance/range_for_max)

	if stun > max_stun then stun = max_stun end

	if stun < min_stun then stun = min_stun end

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)

	local damaged = {}

	for k,v in pairs(enemy) do
		if not v:HasModifier("modifier_tek_microarray_stun") then
			DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_tek_microarray_stun", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
	end

end

function tesla_start(keys)
	local caster = keys.caster
	local target = keys.target

	local chargetime = keys.chargetime

	Timers:CreateTimer(0.1,function() caster:Hold() end)

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_tek_microarray_charge", {Duration=chargetime}) --[[Returns:void
	No Description Set
	]]

	caster:EmitSound("Hero_Invoker.EMP.Charge") --[[Returns:void
	 
	]]
end

function tesla_end(keys)
	local caster = keys.caster
	local target = keys.target
	local radius = keys.radius
	local damage = keys.damage
	local stun = keys.stun
	local chargetime = keys.chargetime or 1.25

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          target:GetAbsOrigin(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)

	target:EmitSound("Hero_Invoker.EMP.Discharge")

	target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.5}) --[[Returns:void
	No Description Set
	]]
	local n = 0
	for k,v in pairs(enemy) do
		if v:IsHero() then n = n + 1 end
		if v:IsStunned() or v:IsSilenced() then damage = damage * 2 end
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_tek_microarray_stun", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		v:EmitSound("Hero_Invoker.SunStrike.Ignite.Apex")
	end

	if n >= 3 then
		for k,v in pairs(enemy) do
			if v:IsHero() then
				v:EmitSound("Hero_Invoker.DeafeningBlast")
				break
			end
		end
	end
end