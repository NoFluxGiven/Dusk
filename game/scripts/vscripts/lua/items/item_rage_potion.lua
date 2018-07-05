item_rage_potion = class({})

LinkLuaModifier("modifier_rage_potion", "item_rage_potion", LUA_MODIFIER_MOTION_NONE)

function item_rage_potion:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("buff_duration")

	caster:AddNewModifier(caster, self, "modifier_rage_potion", {Duration=duration})
end

modifier_rage_potion = class({})

function modifier_rage_potion:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return func
end

function modifier_rage_potion:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_rage_potion:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_rage_potion:GetEffectName()
	return "particles/items/rage_potion.vpcf"
end