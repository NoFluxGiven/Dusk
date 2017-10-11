function gainstack(keys)
	local caster = keys.caster
	local damage =  keys.damage
	-- local return_damage = (keys.return_damage or 14)/100

	if not damage > 20 then return end

	if not caster:HasModifier("modifier_spellproof_bulwark_passive") then keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_spellproof_bulwark_passive", {}) end
	local stack = caster:GetModifierStackCount("modifier_spellproof_bulwark_passive",keys.ability)
	if stack < 7 then
		caster:SetModifierStackCount("modifier_spellproof_bulwark_passive",keys.ability,stack+1)
	end
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_spellproof_bulwark_passive_efft", {})
	keys.ability:ApplyDataDrivenModifier(caster, keys.attacker, "modifier_spellproof_bulwark_slow", {}) --[[Returns:void
	No Description Set
	]]
	
end

function losestack(keys)
	local caster = keys.caster
	if not caster:HasModifier("modifier_spellproof_bulwark_passive") then return end
	local stack = caster:GetModifierStackCount("modifier_spellproof_bulwark_passive",keys.ability)

	caster:SetModifierStackCount("modifier_spellproof_bulwark_passive",keys.ability,stack-1)

	if stack-1 <= 0 then caster:RemoveModifierByName("modifier_spellproof_bulwark_passive") end
end

function purge(keys)
	local caster = keys.caster
	caster:Purge(false, true, false, true, false)
end