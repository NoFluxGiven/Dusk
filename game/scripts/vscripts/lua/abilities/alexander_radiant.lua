alexander_radiant = class({})

LinkLuaModifier("modifier_radiant","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_radiant_aura","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)

function alexander_radiant:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]

	caster:AddNewModifier(caster, self, "modifier_radiant", {Duration = duration}) --[[Returns:void
	No Description Set
	]]
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_radiant = class({})

function modifier_radiant:IsAura()
	return true
end

function modifier_radiant:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_radiant:GetAuraDuration()
	return 0.1
end

function modifier_radiant:GetAuraSearchFlags()
	return 0
end

function modifier_radiant:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_radiant:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_radiant:GetModifierAura()
	return "modifier_radiant_aura"
end

function modifier_radiant:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_radiant:OnCreated( kv )

	if IsServer() then
		self:GetParent():EmitSound("Alexander.Radiant")
	end

end

function modifier_radiant:GetModifierConstantHealthRegen()
	local bonus = 1
	if self:GetAbility():GetCaster():GetHasTalent("special_bonus_alexander_radiant") then bonus = 2 end
	return self:GetParent():GetMaxHealth()*( (self:GetAbility():GetSpecialValueFor("regen")*bonus)/100 )
end

function modifier_radiant:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
end

function modifier_radiant:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end

modifier_radiant_aura = class({})

function modifier_radiant_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	return funcs
end

function modifier_radiant_aura:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss") --[[Returns:table
	No Description Set
	]]
end