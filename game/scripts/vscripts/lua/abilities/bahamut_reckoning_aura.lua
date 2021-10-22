bahamut_reckoning_aura = class({})

LinkLuaModifier("modifier_reckoning_aura","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reckoning_aura_buff","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reckoning_aura_debuff","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_reckoning_aura_power_up","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)

function bahamut_reckoning_aura:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	-- Particle
	-- Sound

	target:AddNewModifier(caster, self, "modifier_reckoning_aura_debuff", {Duration=duration})
	caster:AddNewModifier(caster, self, "modifier_reckoning_aura_buff", {Duration=duration})
end

modifier_reckoning_aura_buff = class({})

function modifier_reckoning_aura_buff:OnCreated()
	self.spell_amp_steal = self:GetAbility():GetSpecialValueFor("spell_amp_steal")
end

function modifier_reckoning_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_reckoning_aura_buff:GetModifierSpellAmplify_Percentage()
	return self.spell_amp_steal
end

function modifier_reckoning_aura_buff:GetEffectName()
	return "particles/units/heroes/hero_bahamut/reckoning_drain_buff.vpcf"
end

modifier_reckoning_aura_debuff = class({})

function modifier_reckoning_aura_debuff:OnCreated()
	self.spell_amp_steal = self:GetAbility():GetSpecialValueFor("spell_amp_steal")
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_reckoning_aura_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_reckoning_aura_debuff:GetModifierSpellAmplify_Percentage()
	return -self.spell_amp_steal
end

function modifier_reckoning_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow
end

function modifier_reckoning_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_bahamut/reckoning_drain.vpcf"
end

---------------------------------------------------------------------------------------------
-- DEPRECATED
---------------------------------------------------------------------------------------------
-- function modifier_reckoning_aura_buff:OnCreated()
-- 	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
-- 	self:SetStackCount(1)
-- end

-- function modifier_reckoning_aura_buff:OnRefresh()
-- 	if not IsServer() then return end
-- 	if self:GetStackCount() >= self.max_stacks then return end
-- 	self:SetStackCount(self:GetStackCount()+1)
-- end

-- function modifier_reckoning_aura_buff:GetModifierSpellAmplify_Percentage()
-- 	return self:GetAbility():GetSpecialValueFor("spell_damage_increase") * self:GetStackCount()
-- end

-- function modifier_reckoning_aura_buff:GetModifierPreAttack_BonusDamage()
-- 	return self:GetAbility():GetSpecialValueFor("attack_damage_bonus") * self:GetStackCount()
-- end

-- -- function modifier_reckoning_aura_buff:GetModifierMoveSpeedBonus_Constant()
-- -- 	return self:GetAbility():GetSpecialValueFor("movespeed_bonus") * self:GetStackCount()
-- -- end

-- function modifier_reckoning_aura_buff:GetModifierAttackSpeedBonus_Constant()
-- 	return self:GetAbility():GetSpecialValueFor("attack_speed_bonus") * self:GetStackCount()
-- end

-- modifier_reckoning_aura = class({})

-- function modifier_reckoning_aura:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_EVENT_ON_ATTACK_LANDED
-- 	}
-- 	return funcs
-- end

-- function modifier_reckoning_aura:IsHidden() return true end

-- function modifier_reckoning_aura:OnAttackLanded(params)
-- 	if params.attacker == self:GetParent() then

-- 		local duration = self:GetAbility():GetSpecialValueFor("duration")
-- 		local stacks = 1

-- 		if self:GetParent():PassivesDisabled() then return end
-- 		if not params.target:IsHero() then return end

-- 		-- if not params.target:IsRealHero() then
-- 		-- 	stacks = 1
-- 		-- end

-- 		-- local n = 0
-- 		-- repeat
-- 			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_reckoning_aura_buff", {Duration=duration, stacks=stacks})
-- 		-- 	n = n + 1
-- 		-- until n >= stacks
-- 	end
-- end