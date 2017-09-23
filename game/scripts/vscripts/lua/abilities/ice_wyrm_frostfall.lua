ice_wyrm_frostfall = class({})

LinkLuaModifier("modifier_frostfall","lua/abilities/ice_wyrm_frostfall",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostfall_aura","lua/abilities/ice_wyrm_frostfall",LUA_MODIFIER_MOTION_NONE)

function ice_wyrm_frostfall:GetIntrinsicModifierName()
	return "modifier_frostfall_aura"
end

modifier_frostfall_aura = class({})

function modifier_frostfall_aura:IsAura()
	return true
end

function modifier_frostfall_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_frostfall_aura:GetAuraSearchFlags()
	return 0
end

function modifier_frostfall_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_frostfall_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_frostfall_aura:GetModifierAura()
	return "modifier_frostfall"
end

function modifier_frostfall_aura:IsHidden()
	return true
end

function modifier_frostfall_aura:OnCreated()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/frostfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	self:AddParticle( p, false, false, 10, false, false )
end

function modifier_frostfall_aura:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Ancient_Apparition.IceVortex")
	end
end

modifier_frostfall = class({})

function modifier_frostfall:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
	return funcs
end

function modifier_frostfall:GetModifierPercentageCasttime()
	return -50
end

function modifier_frostfall:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(2.0)
		self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
	end
end

function modifier_frostfall:OnIntervalThink()
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("damage")/100
		local hp = self:GetParent():GetHealth()

		local damage = hp*damage
		self:GetAbility():InflictDamage(
			self:GetParent(),
			self:GetAbility():GetCaster(),
			damage,
			DAMAGE_TYPE_MAGICAL)
	end
end