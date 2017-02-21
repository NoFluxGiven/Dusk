modifier_extraplanar_pact = class({})

function modifier_extraplanar_pact:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

	}
	return func
end

function modifier_extraplanar_pact:GetEffectName()
	local part = "particles/units/heroes/hero_gemini/gemini_extraplanar_pact_unit.vpcf"

	return part
end

function modifier_extraplanar_pact:GetModifierBaseDamageOutgoing_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_dmg") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierMoveSpeedBonus_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_movespeed") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierAttackSpeedBonus_Constant()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierSpellAmplify_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_spell_damage") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierPhysicalArmorBonus()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_armor") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierConstantHealthRegen()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_regen") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierConstantManaRegen()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_regen") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierMagicalResistanceBonus()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_mres") --[[Returns:table
	No Description Set
	]]
	return amt
end

function modifier_extraplanar_pact:GetModifierPreAttack_BonusDamage()
	local amt = self:GetAbility():GetSpecialValueFor("bonus_pdmg") --[[Returns:table
	No Description Set
	]]
	return amt
end