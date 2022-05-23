fury_berserk = class({})

LinkLuaModifier("modifier_berserk","lua/abilities/fury_berserk",LUA_MODIFIER_MOTION_NONE)

function fury_berserk:OnSpellStart()
	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_fury_4") or 0
	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_berserk", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
	self:GetCaster():EmitSound("Hero_Ursa.Overpower")
end

modifier_berserk = class({})

function modifier_berserk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_berserk:OnAttackLanded(params)
	local caster = self:GetParent()

	local attacker = params.attacker
	local target = params.target or params.unit

	if (attacker == caster) then
		if not self:GetAbility():IsCooldownReady() and not target:IsBuilding() then
			local cdr = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
			local cd = self:GetAbility():GetCooldownTimeRemaining()
			local new_cd = cd-cdr

			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(new_cd)
		end
	end
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

function modifier_berserk:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
end

function modifier_berserk:GetMinHealth()
	return 1
end

function modifier_berserk:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("bat")
end

function modifier_berserk:CheckState()
	local state = {}

	local t_magic_immunity = self:GetAbility():GetCaster():FindTalentValue("special_bonus_fury_3")

	if t_magic_immunity then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end

	return state
end