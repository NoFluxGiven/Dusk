siegfried_epochs_protection = class({})

LinkLuaModifier("modifier_epochs_protection","lua/abilities/siegfried_epochs_protection",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epochs_protection_immunity","lua/abilities/siegfried_epochs_protection",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epochs_protection_cooldown","lua/abilities/siegfried_epochs_protection",LUA_MODIFIER_MOTION_NONE)

function siegfried_epochs_protection:GetIntrinsicModifierName()
	return "modifier_epochs_protection"
end

modifier_epochs_protection = class({})

function modifier_epochs_protection:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end

function modifier_epochs_protection:OnAbilityFullyCast(params)
	local unit = params.unit
	local par = self:GetParent()
	local ability = params.ability

	if ability:IsItem() then return end
	if par:PassivesDisabled() then return end

	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local t_duration_bonus = par:FindTalentValue("special_bonus_siegfried_4") or 0
	duration = duration + t_duration_bonus

	if unit ~= par then return end

	unit:AddNewModifier(unit, self:GetAbility(), "modifier_epochs_protection_immunity", {Duration=duration})
end

function modifier_epochs_protection:IsHidden()
	return true
end

modifier_epochs_protection_immunity = class({})

function modifier_epochs_protection_immunity:OnCreated(kv)
	if IsServer() then
		local t_purge = self:GetAbility():GetCaster():FindTalentValue("special_bonus_siegfried_1")

		if t_purge then
			self:GetParent():Purge(false,true,false,false,false)
		end
	end
end

function modifier_epochs_protection_immunity:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	return state
end

function modifier_epochs_protection_immunity:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	}
	return func
end

function modifier_epochs_protection_immunity:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_epochs_protection_immunity:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
end