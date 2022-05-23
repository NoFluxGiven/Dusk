alexander_radiant = class({})

LinkLuaModifier("modifier_radiant","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_radiant_aura","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_radiant_allies","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_radiant_allies_aura","lua/abilities/alexander_radiant",LUA_MODIFIER_MOTION_NONE)

function alexander_radiant:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("iron")
	return true
end

function alexander_radiant:OnAbilityPhaseInterrupted()
	self:GetCaster():ClearActivityModifiers()
end

function alexander_radiant:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]

	local radius = self:GetSpecialValueFor("radius")

	local t_damage = self:GetCaster():FindTalentValue("special_bonus_alexander_2")

	local p = CreateParticleWorld(caster:GetCenter(), "particles/units/heroes/hero_alexander/raise_the_shield_dome.vpcf")

	caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_HITLOCATION)

	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	Timers:CreateTimer(4.0,
	function()
		ParticleManager:DestroyParticle(p, false)
	end)

	if t_damage then
		

		local e = FindEnemies(caster,caster:GetAbsOrigin(),radius)

		-- local p = CreateParticleHitloc(caster,"particles/units/heroes/hero_alexander/radiant_damage.vpcf")

		-- ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

		local p = CreateParticleWorld(caster:GetAbsOrigin(), "particles/units/heroes/hero_alexander/.vpcf")

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

		-- Sound

		for k,v in pairs(e) do
			self:InflictDamage(v,caster,t_damage,DAMAGE_TYPE_MAGICAL)
		end
	end

	caster:AddNewModifier(caster, self, "modifier_radiant", {Duration = duration}) --[[Returns:void
	No Description Set
	]]

	local t_affects_allies = self:GetCaster():FindTalentValue("special_bonus_alexander_4")

	if t_affects_allies then
		caster:AddNewModifier(caster, self, "modifier_radiant_allies", {Duration = duration})
	end
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
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_radiant:OnCreated( kv )

	if IsServer() then
		self:GetParent():EmitSound("Alexander.Radiant")
	end

end

function modifier_radiant:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("regen")
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

modifier_radiant_allies = class({})

function modifier_radiant_allies:IsAura()
	return true
end

function modifier_radiant_allies:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_radiant_allies:GetAuraDuration()
	return 0.1
end

function modifier_radiant_allies:GetAuraSearchFlags()
	return 0
end

function modifier_radiant_allies:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_radiant_allies:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_radiant_allies:GetModifierAura()
	return "modifier_radiant_allies_aura"
end

function modifier_radiant_allies:IsHidden()
	return true
end

modifier_radiant_allies_aura = class({})

function modifier_radiant_allies_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_radiant_allies_aura:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("regen")*0.5
end