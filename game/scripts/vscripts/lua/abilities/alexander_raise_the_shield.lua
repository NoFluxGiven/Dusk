alexander_raise_the_shield = class({})

LinkLuaModifier("modifier_raise_the_shield","lua/abilities/alexander_raise_the_shield",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raise_the_shield_aura","lua/abilities/alexander_raise_the_shield",LUA_MODIFIER_MOTION_NONE)

function alexander_raise_the_shield:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("iron")
    self:GetCaster():EmitSound("Alexander.RaiseTheShield.Pre")
	return true
end

function alexander_raise_the_shield:OnAbilityPhaseInterrupted()
	self:GetCaster():ClearActivityModifiers()
end

function alexander_raise_the_shield:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")

    self:GetCaster():ClearActivityModifiers()

    -- create thinker with modifier_raise_the_shield_aura
    -- thinker has an aura that:
    -- affects allies
    -- applies a modifier_raise_the_shield buff that:
    -- reduces incoming damage by specialvalue damage_reduction
    -- has 0.05s sticky time
    -- periodically checks if caster has the buff; if not, the thinker destroys itself

    self:GetCaster():EmitSound("Alexander.RaiseTheShield.Formation")

    -- thinker
    -----------------

    self.t = CreateModifierThinker(caster, self, "modifier_raise_the_shield_aura", {Duration=duration}, caster_pos, caster:GetTeamNumber(), false)

    -- particle
    -----------------

    -- This is a field on the ability because thinkers hate storing data for some weird reason

    self.raise_the_shield_particle = CreateParticleWorld(caster:GetCenter(), "particles/units/heroes/hero_alexander/raise_the_shield_dome.vpcf")

	ParticleManager:SetParticleControl(self.raise_the_shield_particle, 1, Vector(radius,0,0))

    self.t:EmitSound("Alexander.RaiseTheShield.Area")
end

--------------------------------------------------------------------------------------------------------------

modifier_raise_the_shield = class({})

function modifier_raise_the_shield:IsHidden() return false end
function modifier_raise_the_shield:IsPurgable() return false end

function modifier_raise_the_shield:OnCreated(kv)
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_raise_the_shield:DeclareFunctions()
    local func = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return func
end

function modifier_raise_the_shield:GetModifierIncomingDamage_Percentage()
    return -self.damage_reduction
end

-- function modifier_raise_the_shield:GetEffectName()
--     return "particles/units/heroes/hero_alexander/raise_the_shield_unit.vpcf"
-- end

--------------------------------------------------------------------------------------------------------------

modifier_raise_the_shield_aura = class({})

function modifier_raise_the_shield_aura:IsHidden() return true end
function modifier_raise_the_shield_aura:IsPurgable() return false end

function modifier_raise_the_shield_aura:OnCreated(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.search_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    self.search_units = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP

    self:StartIntervalThink(0.05)
end

function modifier_raise_the_shield_aura:OnIntervalThink()
    if (self:GetAbility():GetCaster():HasModifier("modifier_raise_the_shield")) then
        return
    end

    self:Destroy()
end

function modifier_raise_the_shield_aura:OnDestroy()
    self:GetAbility().t:StopSound("Alexander.RaiseTheShield.Area")
    ParticleManager:DestroyParticle(self:GetAbility().raise_the_shield_particle, false)
end

function modifier_raise_the_shield_aura:GetModifierAura()
    return "modifier_raise_the_shield"
end

function modifier_raise_the_shield_aura:IsAura()
    return true
end

function modifier_raise_the_shield_aura:GetAuraRadius()
    return self.radius
end

function modifier_raise_the_shield_aura:GetAuraSearchTeam()
    return self.search_team
end

function modifier_raise_the_shield_aura:GetAuraSearchType()
    return self.search_units
end

function modifier_raise_the_shield_aura:GetAuraDuration()
    return 0.05
end