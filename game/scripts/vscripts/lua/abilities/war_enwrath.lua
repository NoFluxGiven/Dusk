war_enwrath = class({})
--[[
	{yaml}
	name: Enwrath
	basic_description: In a large radius, War unleashes a powerful enchantment that increases the damage output,
	but decreases the attack damage of, all affected units, ally or enemy
]]

LinkLuaModifier("modifier_enwrath","lua/abilities/war_enwrath",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enwrath_buff","lua/abilities/war_enwrath",LUA_MODIFIER_MOTION_NONE)

function war_enwrath:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_enwrath", {Duration=duration})
end

modifier_enwrath = class({})

function modifier_enwrath:OnCreated(kv)
	-- particle
end

function modifier_enwrath:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return func
end

function modifier_enwrath:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage_output")
end

function modifier_enwrath:GetModifierStatusResistanceStacking()
	return -self:GetAbility():GetSpecialValueFor("status_res_reduction")
end
