function Cast(keys)
	local caster = keys.caster

	local mod = "modifier_celestial_spear_attack_range_active"

	if caster:IsRangedAttacker() then
		keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {}) --[[Returns:void
		No Description Set
		]]
	end
end

function CheckRanged(keys)
	local caster = keys.caster

	local mod = "modifier_celestial_spear_attack_range"

	if caster:IsRangedAttacker() then
		keys.ability:ApplyDataDrivenModifier(caster, caster, mod, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
end