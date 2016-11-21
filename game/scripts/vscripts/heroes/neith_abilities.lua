function Inspire(keys)
	local caster = keys.caster
	local ab = caster:FindAbilityByName("neith_inspire")
	local lvl = ab:GetLevel()
	local radius = keys.radius or 575
	local mod = "modifier_inspire_attack_damage"..tostring(lvl)
	local mod_creep = "modifier_inspire_attack_damage_creep"

	if lvl == 0 then return end

	if caster:PassivesDisabled() then return end

	print("Inspire")

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(found) do
		if v:IsHero() then
			ab:ApplyDataDrivenModifier(caster, v, mod, {}) --[[Returns:void
			No Description Set
			]]
		else
			ab:ApplyDataDrivenModifier(caster, v, mod_creep, {}) --[[Returns:void
			No Description Set
			]]
		end

	end
end

function Rally(keys)
	local caster = keys.caster
	local ab1 = caster:FindAbilityByName("neith_monsoon") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]
	local ab2 = caster:FindAbilityByName("neith_decisive_strike")

	local scepter = caster:HasScepter()

	local radius = keys.radius

	local duration = keys.duration

	if scepter then duration = keys.scepter_duration end

	local ally_mod_hero = "modifier_rally_damage_increase_hero"
	local ally_mod_creep = "modifier_rally_attack_movespeed_increase"
	local ally_mod_creep_dmg = "modifier_rally_damage_increase_creep"
	local ally_mod_show = "modifier_rally_show_effects"

	local enemy_mod_hero = "modifier_rally_damage_decrease_hero"
	local enemy_mod_creep = "modifier_rally_attack_movespeed_decrease"
	local enemy_mod_creep_dmg = "modifier_rally_damage_decrease_creep"
	local enemy_mod_show = "modifier_rally_show_effects_negative"

	-- ab1:EndCooldown()
	-- ab2:EndCooldown()

	caster:EmitSound("Hero_LegionCommander.PressTheAttack")

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		                    FIND_CLOSEST,
		                    false)

	for k,v in pairs(found) do
		if v:IsHero() then
			keys.ability:ApplyDataDrivenModifier(caster, v, ally_mod_hero, {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		else
			keys.ability:ApplyDataDrivenModifier(caster, v, ally_mod_creep_dmg, {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		end
		keys.ability:ApplyDataDrivenModifier(caster, v, ally_mod_creep, {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		keys.ability:ApplyDataDrivenModifier(caster, v, ally_mod_show, {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		v:EmitSound("Hero_LegionCommander.Overwhelming.Buff")
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_neith/neith_rally.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
		Creates a new particle effect
		]]
	end

	if scepter then
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
		                    radius,
		                    DOTA_UNIT_TARGET_TEAM_ENEMY,
		                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
		                    DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		                    FIND_CLOSEST,
		                    false)

		for k,v in pairs(found) do
		if v:IsHero() then
			keys.ability:ApplyDataDrivenModifier(caster, v, enemy_mod_hero, {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		else
			keys.ability:ApplyDataDrivenModifier(caster, v, enemy_mod_creep_dmg, {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		end
		keys.ability:ApplyDataDrivenModifier(caster, v, enemy_mod_creep, {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		keys.ability:ApplyDataDrivenModifier(caster, v, enemy_mod_show, {Duration=duration}) --[[Returns:void
		No Description Set
		]]
	end
	end
end