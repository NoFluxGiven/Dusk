modifier_disrupt_slow_effect = class({})

function modifier_disrupt_slow_effect:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_disrupt_slow_effect:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	return slow
end

function modifier_disrupt_slow_effect:GetModifierAttackSpeedBonus_Constant()
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	return slow
end