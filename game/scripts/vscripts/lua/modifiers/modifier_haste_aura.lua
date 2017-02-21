modifier_haste_aura = class({})

function modifier_haste_aura:DeclareFunctions()
	local func = {
		
	}
	return func
end

function modifier_haste_aura:IsAura()
	if IsServer() then
		if not self:GetAbility():IsCooldownReady() then return false end
	end
	return true
end

function modifier_haste_aura:GetModifierAura()
	return "modifier_haste_aura_effect"
end

function modifier_haste_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_haste_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_haste_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_haste_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_haste_aura:IsHidden()
	return true
end