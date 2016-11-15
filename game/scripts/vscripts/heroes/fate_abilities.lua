function DisplaceStart(keys)
	local caster = keys.caster
	local target = keys.target

	if target:HasModifier("modifier_displace_debuff") then keys.ability:RefundManaCost() keys.ability:EndCooldown() return end

	if target.displace_damage == nil then target.displace_damage = 0 end
	if target.displace_heal == nil then target.displace_heal = 0 end

	target.displace_health = target:GetHealth()

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_displace", {}) --[[Returns:void
	No Description Set
	]]

	target:Purge(true,true,false,true,false)

	target:EmitSound("Fate.Displace.Ambience")
end

function DisplaceHeal(keys)
	local caster = keys.caster
	local target = keys.unit

	local mult = 1+(keys.mult/100)

	print((target:GetHealth()-target.displace_health)*mult)

	Timers:CreateTimer(0.03,function()
		print((target:GetHealth()-target.displace_health)*mult)
		target.displace_heal = target.displace_heal+((target:GetHealth()-target.displace_health)*mult)
		if target.displace_health then
			target:SetHealth(target.displace_health)
		end
	end
	)
end

function DisplaceDamage(keys)
	local caster = keys.caster
	local target = keys.target

	local duration = keys.duration

	local tick_time = keys.tick_time

	if target.displace_damage == nil then target.displace_damage = 0 end
	if target.displace_heal == nil then target.displace_heal = 0 end
	if target.displace_attacker == nil or target.displace_attacker:IsNull() then target.displace_attacker = caster end

	local damage_per_tick = target.displace_damage/(duration*(1/tick_time))
	local heal_per_tick = target.displace_heal/(duration*(1/tick_time))

	if target:HasModifier("paragon_tranquil_seal_mod_ally") then target:RemoveModifierByName("paragon_tranquil_seal_mod_ally") end
	if target:HasModifier("paragon_tranquil_seal_mod_enemy") then target:RemoveModifierByName("paragon_tranquil_seal_mod_enemy") end
	if target:HasModifier("modifier_displace") then return end

	if target:IsInvulnerable()
	then
		local mod = target:FindModifierByName("modifier_displace_debuff")
		local dur = mod:GetDuration()
		mod:SetDuration(duration,true)
	else
		DealDamage(target,target.displace_attacker,damage_per_tick,DAMAGE_TYPE_PURE)
	end

	print("Healing for "..heal_per_tick)

	target:Heal(heal_per_tick, caster)
end

function DisplaceEnd(keys)
	local caster = keys.caster
	local target = keys.target

	print("DMG "..target.displace_damage)

	print("HEAL "..target.displace_heal)

	print("HEALTH "..target.displace_health)

	target.displace_damage = 0
	target.displace_heal = 0
	target.displace_health = 1
end

function ChainsOfFateDeath(keys)
	local caster = keys.caster
	local target = keys.unit

	local damage = keys.damage/100

	if not target:IsRealHero() then damage = keys.creep_damage/100 end

	if target:IsIllusion() then return end

	damage = target:GetMaxHealth()*damage

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
		                    FIND_UNITS_EVERYWHERE,
		                    DOTA_UNIT_TARGET_TEAM_BOTH,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NONE,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(enemy) do
		if v:HasModifier("modifier_chains_of_fate") then
			DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end
	end
end

function Realign(keys)
	local target = keys.target

	target:RemoveModifierByName("modifier_displace")
end

function DoomsayerApply(keys)
	local caster = keys.caster
	local target = keys.target

	local p = keys.p

	local dmg = keys.damage

	if target:GetHealthPercent() > p  then
		DealDamage(target,caster,dmg,DAMAGE_TYPE_MAGICAL)
		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_doomsayer_fizz.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
		target:EmitSound("Fate.Doomsayer.Fizz")
		return
	end

	if target:GetTeam() == caster:GetTeam() then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_doomsayer_ally", {}) --[[Returns:void
		No Description Set
		]]
	else
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_doomsayer", {}) --[[Returns:void
		No Description Set
		]]
	end
end

function DoomsayerStart(keys)
	local caster = keys.caster
	local target = keys.target

	local timer = keys.timer

	print("LOLOLOLOLOLOLOLOLOLOLOLOLOL")

	local timer_str = tostring(timer)

	if #timer_str == 1 then timer_str = "00"..timer_str end
	if #timer_str == 2 then timer_str = "0"..timer_str end

	print(timer_str)

	local tt = {}

	for i = 1, 3 do
		if tonumber(string.sub(timer_str,i,i)) == nil then
			tt[#tt+1] = 0
		else
			tt[#tt+1] = tonumber(string.sub(timer_str,i,i))
		end
	end

	target.doomsayer_timer = timer
	target.doomsayer_disabled = false

	target:EmitSound("Fate.Doomsayer.Start")
	target:EmitSound("Fate.Doomsayer.Ambience")

	target.doomsayer_count = ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_doomsayer.vpcf", PATTACH_OVERHEAD_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(target.doomsayer_count, 1, Vector(tt[3],tt[2],tt[1])) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(target.doomsayer_count, 3, Vector(0,0,-100)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	Timers:CreateTimer(0,function()
		local tick = 1

		if caster:HasScepter() then tick = tick*0.5 end

		if target:HasModifier("modifier_displace") or target:HasModifier("modifier_displace_debuff") then tick = tick*0.5 end

		local timer = target.doomsayer_timer

		local timer_str = tostring(timer)

		if #timer_str == 1 then timer_str = "00"..timer_str end
		if #timer_str == 2 then timer_str = "0"..timer_str end

		print(timer_str)

		local tt = {}

		for i = 1, 3 do
			if tonumber(string.sub(timer_str,i,i)) == nil then
				tt[#tt+1] = 0
			else
				tt[#tt+1] = tonumber(string.sub(timer_str,i,i))
			end
		end

		target.doomsayer_timer = target.doomsayer_timer - 1

		ParticleManager:SetParticleControl(target.doomsayer_count, 1, Vector(tt[3],tt[2],tt[1])) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		if target.doomsayer_timer == 2/tick then
			target:EmitSound("Fate.Doomsayer.Activate")
			target.doomsayer_activation = ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_doomsayer_activate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
		end

		if target.doomsayer_timer > -1 then
			return tick
		else
			target:RemoveModifierByName("modifier_doomsayer")
			target:RemoveModifierByName("modifier_doomsayer_ally")
		end
	end
	)
end

function DoomsayerEnd(keys)
	local caster = keys.caster
	local target = keys.target

	local respawn_time_percentage = 1-((keys.respawn_time or 60)/100)

	if not target.doomsayer_disabled then
		if target:HasModifier("modifier_displace") then
			target:RemoveModifierByName("modifier_displace")
		end
		target:Kill(keys.ability, caster) --[[Returns:void
		Kills this NPC, with the params Ability and Attacker
		]]
		print("RESPAWN TIME IS "..target:GetRespawnTime())
		print("PERCENTAGE IS "..respawn_time_percentage)
		target:SetTimeUntilRespawn(target:GetRespawnTime() * respawn_time_percentage)
		print("RESPAWN TIME SHOULD BE "..target:GetRespawnTime()*respawn_time_percentage)
	end

	ParticleManager:DestroyParticle(target.doomsayer_count,false)
	if target.doomsayer_activation ~= nil then
		ParticleManager:DestroyParticle(target.doomsayer_activation,false)
	end
	target:StopSound("Fate.Doomsayer.Ambience")
	target.doomsayer_timer = -1
end

function DoomsayerOnDeath(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local unit = keys.unit or keys.target

	if not unit:IsRealHero() then return end

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
		                    FIND_UNITS_EVERYWHERE,
		                    DOTA_UNIT_TARGET_TEAM_BOTH,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(found) do
		v.doomsayer_disabled = true
		v:RemoveModifierByName("modifier_doomsayer")
		v:RemoveModifierByName("modifier_doomsayer_ally")
	end
end

function DisplaceStop(keys)
	local caster = keys.caster
	local target = keys.target

	target:StopSound("Fate.Displace.Ambience")
	target:EmitSound("Fate.Displace.Debuff")
	target:EmitSound("Fate.Displace.Start")
end

function ChainStop(keys)
	local caster = keys.caster
	local target = keys.target

	target:StopSound("Fate.ChainsOfFate.Ambience")
end

function DoomsayerCheck(keys)
	local caster = keys.caster
	local target = keys.target
	local hp = target:GetHealthPercent()

	if hp < 9 and caster:GetTeam() ~= target:GetTeam() and not target:HasModifier("fury_rampage_mod") and not target:HasModifier("fury_berserk_mod") then
		target:RemoveModifierByName("modifier_doomsayer")
	end
end

function MRApply(keys)
	local caster = keys.caster
	local point = caster:GetCursorPosition()
	local dmg = keys.damage/100
	local delay = keys.delay
	local rad = keys.r
	Timers:CreateTimer(delay,function() 
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
	                          point,
	                          nil,
			                    rad,
			                    DOTA_UNIT_TARGET_TEAM_ENEMY,
			                    DOTA_UNIT_TARGET_HERO,
			                    DOTA_UNIT_TARGET_FLAG_NONE,
			                    FIND_CLOSEST,
			                    false)

		for k,v in pairs(found) do
			local hp = v:GetMaxHealth()
			local fdmg = hp*dmg
			local str = v:GetStrength()
			local reduc = math.ceil(str*0.15)

			if v:HasModifier("modifier_displace") then v:RemoveModifierByName("modifier_displace") end

			if caster:HasScepter() then
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_doomsayer_health_reduction", {Duration=5}) --[[Returns:void
				No Description Set
				]]
				local mod = v:FindModifierByName("modifier_doomsayer_health_reduction")
				mod:SetStackCount(reduc)
				v:CalculateStatBonus()
			end

			DealDamage(v,caster,fdmg,DAMAGE_TYPE_PURE)

			ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_mortality_rune_unit.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]
		end
	end)

end