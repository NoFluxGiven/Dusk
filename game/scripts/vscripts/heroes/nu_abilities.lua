function antimatter_mines(keys)
	local caster = keys.caster
	local pos = caster:GetCursorPosition()

	local radius = keys.radius or 500
	local duration = keys.duration
	local lvl = keys.ability:GetLevel()
	local delay = keys.delay or 0.8

	local amount = keys.amount or 20

	ToolsPrint("SUMMONING MINES")

	caster:EmitSound("Hero_TemplarAssassin.Trap.Trigger") --[[Returns:void
	 
	]]

	for i=1, amount do

		local randvec = RandomInt(0, radius) --[[Returns:int
		Get a random ''int'' within a range
		]]
		local randpos = RandomVector(randvec) --[[Returns:Vector
		Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
		]]

		local fpos = randpos+pos+Vector(0,0,80)

		local unit = FastDummy(fpos,caster:GetTeam(),duration,100)
		unit:SetOwner(caster)

		Timers:CreateTimer(delay,function()
			local ab = unit:AddAbility("nu_antimatter_mines_unit")
			ab:SetLevel(lvl)
		end)

		Timers:CreateTimer(duration-0.1,function()
			ParticleManager:DestroyParticle(unit.mine_particle,true)
		end)

		unit.mine_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/antimatter.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]

	end
end

function antimatter_mines_check(keys)
	local caster = keys.caster

	local check_radius = keys.check_radius
	local damage = keys.damage
	local delay = keys.delay

	if caster.exploding == true then return end
	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
              caster:GetAbsOrigin(),
              nil,
                check_radius,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_CLOSEST,
                false)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			if v.lastpos_am_mines == nil then
				v.lastpos_am_mines = v:GetAbsOrigin()
			end
			if v.lastpos_am_mines ~= v:GetAbsOrigin() then
				-- Detonate the mine after the delay time
				caster:EmitSound("Hero_Enigma.Death")
				Timers:CreateTimer(0,function()
					ParticleManager:DestroyParticle(caster.mine_particle,false)
					local _enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
		              caster:GetAbsOrigin(),
		              nil,
		                check_radius+50,
		                DOTA_UNIT_TARGET_TEAM_ENEMY,
		                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                DOTA_UNIT_TARGET_FLAG_NONE,
		                FIND_CLOSEST,
		                false)
					--caster:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
					for k,v in pairs(_enemy_found) do
						DealDamage(v,caster,damage,DAMAGE_TYPE_PURE)
					end
					v.lastpos_am_mines = nil
					caster:Destroy()
				end)
				caster.exploding = true
			end
			break
		end
	end
end

function TrackDamage(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target or keys.unit

	local dmg = keys.dmg
	local mult = keys.mult/100

	if dmg > 0 then
		if target.micronebula_damage == nil then
			target.micronebula_damage = 0
			target.micronebula_total_damage = 0
		end
		target.micronebula_damage = target.micronebula_damage+(dmg*mult)
		target.micronebula_total_damage = target.micronebula_damage
		ToolsPrint("MICRO: "..target.micronebula_total_damage)
	end
end

function micronebulaApply(keys)
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration

	

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_micronebula", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

function micronebulaDamage(keys)
	local caster = keys.caster
	local target = keys.target

	local radius = keys.radius

	if target.micronebula_damage ~= nil then 
		local tdmg = target.micronebula_total_damage
		local int = 0.1
		local time = 3
		local tick = time/int
		local dmg = tdmg/tick

		local found = FindUnitsInRadius( caster:GetTeamNumber(),
	              target:GetAbsOrigin(),
	              nil,
	                radius,
	                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                DOTA_UNIT_TARGET_FLAG_NONE,
	                FIND_CLOSEST,
	                false)

		for k,v in pairs(found) do
			DealDamage(v,caster,dmg,DAMAGE_TYPE_MAGICAL)
		end
	end
end

function micronebulaUnitDead(keys)
	local caster = keys.caster
	local target = keys.target or keys.unit

	local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),4,0)

	if target.micronebula_damage ~= nil then
		ParticleManager:CreateParticle("particles/units/heroes/hero_nu/micronebula_end_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
          target:GetAbsOrigin(),
          nil,
          325,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
          DOTA_UNIT_TARGET_FLAG_NONE,
          FIND_CLOSEST,
          false)
		for k,v in pairs(found) do
			DealDamage(v,caster,target.micronebula_damage*0.50,DAMAGE_TYPE_MAGICAL)
		end
	end
end

function micronebulaReset(keys)
	local caster = keys.caster
	local target = keys.target

	target.micronebula_damage = 0
	target.micronebula_total_damage = 0
end

function warpstar_start(keys)
	local caster = keys.caster
	local pos = caster:GetCursorPosition()
	local cpos = caster:GetAbsOrigin()
	local delay = keys.delay

	caster.warpstar_exit = FastDummy(cpos,caster:GetTeam(),delay+1,500)
	caster.warpstar_entrance = FastDummy(pos,caster:GetTeam(),delay+1,500)

	caster.warpstar_entrance:EmitSound("Nu.Warpstar") --[[Returns:void
	 
	]]

	keys.ability:ApplyDataDrivenModifier(caster, caster.warpstar_exit, "modifier_warpstar_exit", {Duration=delay}) --[[Returns:void	
	No Description Set
	]]
	keys.ability:ApplyDataDrivenModifier(caster, caster.warpstar_entrance, "modifier_warpstar_entrance", {Duration=delay}) --[[Returns:void
	No Description Set
	]]

	caster.warpstar_particle_exit = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/warpstar_exit_point.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.warpstar_exit) --[[Returns:int
	Creates a new particle effect
	]]
	caster.warpstar_particle_entrance = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/warpstar.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.warpstar_entrance) --[[Returns:int
	Creates a new particle effect
	]]

	ScreenShake(pos, 25, 2, 2, 800, 0, true) --[[Returns:void
	Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
	]]
end

function warpstar_transport(keys)
	local caster = keys.caster
	local target = keys.target
	local pos = target:GetAbsOrigin()
	local radius = keys.radius
	local damage = keys.damage
	local stun = keys.stun

	ParticleManager:DestroyParticle(caster.warpstar_particle_exit,false)
	ParticleManager:DestroyParticle(caster.warpstar_particle_entrance,false)

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
	              pos,
	              nil,
	                radius,
	                DOTA_UNIT_TARGET_TEAM_BOTH,
	                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                DOTA_UNIT_TARGET_FLAG_NONE,
	                FIND_CLOSEST,
	                false)

	Timers:CreateTimer(0.4,function()

		ScreenShake(pos, 90, 2, 2, 800, 0, true) --[[Returns:void
		Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
		]]
		ScreenShake(caster.warpstar_exit:GetAbsOrigin(), 90, 2, 2, 800, 0, true) --[[Returns:void
		Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
		]]
		for k,v in pairs(found) do
			if not v:IsAncient() then
				if v:GetTeam() ~= caster:GetTeam() then
					v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
					No Description Set
					]]
					DealDamage(v,caster,damage,DAMAGE_TYPE_PURE)
				end
				FindClearSpaceForUnit(v, caster.warpstar_exit:GetAbsOrigin(), true) --[[Returns:void
				Place a unit somewhere not already occupied.
				]]
			end
		end

	end)
end

function screenshake(keys)
	local caster =  keys.caster
	local target = caster:GetCursorPosition()

	ScreenShake(target, 25, 7, 1, 1500, 0, true) --[[Returns:void
		Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
		]]
end