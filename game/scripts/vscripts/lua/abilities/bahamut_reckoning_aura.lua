bahamut_reckoning_aura = class({})

LinkLuaModifier("modifier_reckoning_aura","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reckoning_aura_buff","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reckoning_aura_power_up","lua/abilities/bahamut_reckoning_aura",LUA_MODIFIER_MOTION_NONE)

function bahamut_reckoning_aura:OnSpellStart()

	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()

	target:AddNewModifier(self:GetCaster(), self, "modifier_reckoning_aura_power_up", {Duration=duration}) --[[Returns:void
	No Description Set
	]]

end

function bahamut_reckoning_aura:GetIntrinsicModifierName()
	return "modifier_reckoning_aura"
end

modifier_reckoning_aura = class({})

function modifier_reckoning_aura:IsAura()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			return true
		end
		return false
	end
end

function modifier_reckoning_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_reckoning_aura:GetAuraSearchFlags()
	return 0
end

function modifier_reckoning_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_reckoning_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_reckoning_aura:GetModifierAura()
	return "modifier_reckoning_aura_buff"
end

function modifier_reckoning_aura:IsHidden()
	return true
end

modifier_reckoning_aura_buff = class({})

function modifier_reckoning_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_reckoning_aura_buff:GetModifierIncomingDamage_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("damage")
	return amt
end

function modifier_reckoning_aura_buff:IsHidden()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			return false
		else
			return true
		end
	end
end

modifier_reckoning_aura_power_up = class({})

function modifier_reckoning_aura_power_up:OnCreated()

	self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/reckoning_aura_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(self.p, 6, Vector(75,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

end

function modifier_reckoning_aura_power_up:OnDestroy()

	ParticleManager:DestroyParticle(self.p,false)	

end

function modifier_reckoning_aura_power_up:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_reckoning_aura_power_up:GetModifierIncomingDamage_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("damage") * 2.5
	return amt
end