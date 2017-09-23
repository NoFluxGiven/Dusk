fury_berserk = class({})

LinkLuaModifier("modifier_berserk","lua/abilities/fury_berserk",LUA_MODIFIER_MOTION_NONE)

function fury_berserk:OnSpellStart()
	local t_duration_bonus = self:GetCaster():FetchTalent("special_bonus_fury_4") or 0
	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_berserk", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
	self:GetCaster():EmitSound("Hero_Ursa.Overpower")
end

modifier_berserk = class({})

function modifier_berserk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_berserk:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"
end

function modifier_berserk:GetStatusEffectName()
	return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_berserk:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
end

function modifier_berserk:CheckState()
	local state = {}

	local t_magic_immunity = self:GetAbility():GetCaster():FetchTalent("special_bonus_fury_3")

	if t_magic_immunity then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end

	return state
end