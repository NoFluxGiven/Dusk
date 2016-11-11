function dissipation(keys)
	local caster = keys.caster
	local radius = keys.radius

	if caster:PassivesDisabled() then return end

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_ouroboros_dissipation_dot", {}) --[[Returns:void
			No Description Set
			]]
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_ouroboros_dissipation_show", {}) --[[Returns:void
			No Description Set
			]]
		end
	end
end