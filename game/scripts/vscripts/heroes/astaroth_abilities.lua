function soul_drain_deprecated(keys)
	local caster = keys.caster
	local target = keys.unit or keys.target

	local stats = keys.stats
	local hero_kill = keys.hero_kill
	local hero_multiplier = keys.hero_multiplier
	local duration = keys.duration
	local perm_stats = 0

	if target:IsIllusion() then return end

	if target:IsRealHero() then
		stats = stats*hero_multiplier
		perm_stats = hero_kill
	end

	if not caster:HasModifier("modifier_soul_drain_stats_temporary") then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_drain_stats_temporary", {}) --[[Returns:void
		No Description Set
		]]
	end

	if perm_stats > 0 then
		if not caster:HasModifier("modifier_soul_drain_stats_permanent") then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_drain_stats_permanent", {})
		end
	end

	local modtemp = caster:FindModifierByName("modifier_soul_drain_stats_temporary")
	local modperm = caster:FindModifierByName("modifier_soul_drain_stats_permanent") or nil

	local modtempstack = modtemp:GetStackCount()
	local modpermstack = 0
	if modperm then modpermstack = modperm:GetStackCount() end

	modtemp:SetStackCount(modtempstack+stats)
	modtemp:ForceRefresh()
	if modperm then modperm:SetStackCount(modpermstack+perm_stats) end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/soul_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p, 1, target, PATTACH_POINT_FOLLOW, "follow_hitloc", target:GetAbsOrigin(), true) --[[Returns:void
	No Description Set
	]]
	ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "follow_hitloc", caster:GetAbsOrigin(), true) --[[Returns:void
	No Description Set
	]]

	caster:CalculateStatBonus()

	Timers:CreateTimer(duration, function()
		if modtemp then
			local modtempstack = modtemp:GetStackCount()
			if modtempstack <= stats then modtemp:Destroy() else
				modtemp:SetStackCount(modtempstack-stats)
			end
		end
	end)
end

function deathmark(keys)
	local caster = keys.caster or keys.attacker
	local target = keys.unit or keys.target

	local hp = target:GetHealth()

	local damage = keys.damage
	local hits = keys.hits
	local stun = keys.stun
	local removal = keys.removal / 100

	local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()-1) --[[Returns:float
	Get the cooldown duration for this ability at a given level, not the amount of cooldown actually left.
	]]

	local mult = 1 - removal

	local mod = nil

	if not target:IsHero() then return end

	if caster:PassivesDisabled() then return end
	if caster:IsIllusion() then return end

	if not keys.ability:IsCooldownReady() then return end

	if CheckClass(target,"npc_dota_roshan") then return end
	if CheckClass(target,"npc_dota_building") then return end
	if target:IsMagicImmune() then return end

	if not target:HasModifier("modifier_astaroth_marks") then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_astaroth_marks", {Duration=16})
		mod = target:FindModifierByName("modifier_astaroth_marks")
		mod:ForceRefresh()
	else
		mod = target:FindModifierByName("modifier_astaroth_marks")
		mod:ForceRefresh()
	end

	mod:IncrementStackCount()
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_black_insignia_strike.vpcf", PATTACH_POINT_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)

	target:EmitSound("Astaroth.B"..mod:GetStackCount()+2) --[[Returns:void
	 
	]]

	if not target.deathmark_particle then
		target.deathmark_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_black_insignia.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(target.deathmark_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)
	end

	ParticleManager:SetParticleControl(target.deathmark_particle, 1, Vector(mod:GetStackCount(),0,0))

	if mod:GetStackCount() >= hits then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_deathmark_bonus", {}) --[[Returns:void
		No Description Set
		]]
		mod:Destroy()
		if target:IsHero() then keys.ability:StartCooldown(cooldown) end
		target:ModifyHealth(hp*mult, keys.ability, false, -1) --[[Returns:void
		Sets the health to a specific value, with optional flags or inflictors.
		]]
		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
		local p = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)
		if target.deathmark_particle then ParticleManager:DestroyParticle(target.deathmark_particle,true) target.deathmark_particle = nil end
	end
end

function removeParticle(keys)
	local caster = keys.caster
	local target = keys.target

	if target.deathmark_particle then ParticleManager:DestroyParticle(target.deathmark_particle,false) target.deathmark_particle = nil end
end

function pain_transferral(keys)
	local caster = keys.caster
	local damage = keys.attack_damage
	local unit = keys.unit or keys.target

	local mult = keys.mult/100

	local units_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                                FIND_UNITS_EVERYWHERE,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                FIND_CLOSEST,
                                false)

	for k,v in pairs(units_found) do
		if v:FindModifierByNameAndCaster("modifier_astaroth_ptransferral_effects",caster) then
			if v ~= unit then
				DealDamage(v,caster,damage*mult,DAMAGE_TYPE_PHYSICAL)
				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_pain_transferral.vpcf", PATTACH_CUSTOMORIGIN, v) --[[Returns:int
				Creates a new particle effect
				]]
				ParticleManager:SetParticleControlEnt(p, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetCenter(), true)

			end
		end
	end
end

function erase(keys)
	local caster = keys.caster
	local target = keys.target

	local damage = keys.hp
	local manadmg = keys.mana
	local chp_dmg = keys.cdmgh/100
	local cmp_dmg = keys.cdmgm/100

	local extra_dmg = chp_dmg*target:GetHealth()
	local extra_drain = cmp_dmg*target:GetMana()

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_astaroth_erase_reduce_stats", {})

	--local modifier = target:FindModifierByName("modifier_astaroth_erase_reduce_stats")

	--modifier:IncrementStackCount()

	--target:CalculateStatBonus()

	DealDamage(target,caster,damage+extra_dmg,DAMAGE_TYPE_MAGICAL)
	target:ReduceMana(manadmg+extra_drain)
end