alroth_shatter = class({})

LinkLuaModifier("modifier_shatter","lua/abilities/alroth_shatter",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shatter_slow","lua/abilities/alroth_shatter",LUA_MODIFIER_MOTION_NONE)

function alroth_shatter:GetIntrinsicModifierName()
	return "modifier_shatter"
end

modifier_shatter = class({})

function modifier_shatter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_shatter:OnAttackLanded(params)
	if IsServer() then
		local caster = self:GetParent()
		local target = params.target
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local mana_burn = self:GetAbility():GetSpecialValueFor("mana_burn")

		if params.attacker ~= self:GetParent() then return end

		if caster:PassivesDisabled() then return end

		local attackdamage = caster:GetAttackDamage()

		local t_mult_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_alroth_1") or 0

		local mult = self:GetAbility():GetSpecialValueFor("damage_mult") + t_mult_bonus

		local damage = attackdamage * mult

		if self:GetAbility():IsCooldownReady() then
			if caster:IsIllusion() then return end
			if target:IsBuilding() then return end
			if caster:GetTeam() == target:GetTeam() then return end
			target:AddNewModifier(caster, self:GetAbility(), "modifier_shatter_slow", {Duration=duration}) --[[Returns:void
			No Description Set
			]]
			self:GetAbility():InflictDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
			target:ReduceMana(damage*mana_burn)
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1))
			caster:EmitSound("Alroth.Shatter")
			CreateParticleHitloc(target,"particles/units/heroes/hero_alroth/shatter_hit_target_enemy.vpcf")
		end
	end
end

function modifier_shatter:IsHidden()
	if self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled() then
		return false
	end
	return true
end

modifier_shatter_slow = class({})

function modifier_shatter_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_shatter_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_shatter_slow:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("mres_reduction")
end