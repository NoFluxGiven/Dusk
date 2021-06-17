shade_shadowshift = class({})

LinkLuaModifier("modifier_shadowshift","lua/abilities/shade_shadowshift",LUA_MODIFIER_MOTION_NONE)

function shade_shadowshift:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shadowshift", {Duration=duration})
end

modifier_shadowshift = class({})

function modifier_shadowshift:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function modifier_shadowshift:OnCreated()
    ProjectileManager:ProjectileDodge(self:GetCaster())
    self:GetParent():EmitSound("Shade.Shadowshift.Start")
    self:GetParent():EmitSound("Shade.Shadowshift.Loop")
end

function modifier_shadowshift:OnDestroy()
    ProjectileManager:ProjectileDodge(self:GetCaster())
    self:GetParent():EmitSound("Shade.Shadowshift.End")
    self:GetParent():StopSound("Shade.Shadowshift.Loop")
end

function modifier_shadowshift:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_shadowshift:CheckState()
    local state = {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        --[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
    }

    return state
end

function modifier_shadowshift:GetEffectName()
    return "particles/units/heroes/hero_shade/shade_shadowshift_trail.vpcf"
end

function modifier_shadowshift:GetStatusEffectName()
    return "particles/units/heroes/hero_shade/shade_status_effect_shadowshift.vpcf"
end

function modifier_shadowshift:StatusEffectPriority()
	return 15
end