bahamut_desolation = class({})

LinkLuaModifier("modifier_desolation","lua/abilities/bahamut_desolation",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_desolation_aura","lua/abilities/bahamut_desolation",LUA_MODIFIER_MOTION_NONE)

function bahamut_desolation:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")
	local damage = self:GetSpecialValueFor("damage")

	if self:GetCaster():GetHasTalent("special_bonus_bahamut_desolation") then duration = duration+7 end

	target:AddNewModifier(caster, self, "modifier_desolation", {Duration = duration}) --[[Returns:void
	No Description Set
	]]

	--DealDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL,self)
	-- DEALDAMAGE is somewhat deprecated in Lua Abilities, as we can use the superior InflictDamage() instead.
	self:InflictDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)

	ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/desolation_model_caster_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/desolation_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	target:EmitSound("Hero_Terrorblade.Sunder.Cast") --[[Returns:void	 
	]]
end

modifier_desolation = class({})

function modifier_desolation:IsAura()
	return true
end

function modifier_desolation:GetEffectName()
	return "particles/units/heroes/hero_bahamut/desolation_model.vpcf"
end

function modifier_desolation:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_desolation:GetAuraSearchFlags()
	return 0
end

function modifier_desolation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_desolation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

-- function modifier_desolation:GetAuraEntityReject( handle )
-- 	return false
-- end

function modifier_desolation:GetModifierAura()
	return "modifier_desolation_aura"
end

function modifier_desolation:IsHidden()
	return false
end

modifier_desolation_aura = class({})

function modifier_desolation_aura:OnCreated()
	self:StartIntervalThink(1.0)
end

function modifier_desolation_aura:OnIntervalThink()
	if IsServer() then
		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),self:GetAbility():GetSpecialValueFor("dps"),DAMAGE_TYPE_MAGICAL)	
	end
end

function modifier_desolation_aura:GetEffectName()
	return "particles/units/heroes/hero_bahamut/desolation_model_secondary.vpcf"
end