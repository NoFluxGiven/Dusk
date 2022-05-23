war_wrath = class({})

LinkLuaModifier("modifier_wrath","lua/abilities/war_wrath",LUA_MODIFIER_MOTION_NONE)

function war_wrath:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")

	-- local max_count = 3

    target:EmitSound("War.Wrath")

	target:AddNewModifier(caster, self, "modifier_wrath", {Duration=duration})
end

--------------------------------------------------------------------------------------------------------------

modifier_wrath = class({})

function modifier_wrath:IsHidden() return false end
function modifier_wrath:IsPurgable() return true end

function modifier_wrath:OnCreated(kv)
    -- self.base_attack_speed = self:GetAbility():GetSpecialValueFor("base_attack_speed")
    -- self.base_movespeed = self:GetAbility():GetSpecialValueFor("base_movespeed")
    -- self.base_physical_damage_reduction = self:GetAbility():GetSpecialValueFor("base_physical_damage_reduction")

    self.attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")

    local t_movespeed = self:GetAbility():GetCaster():FindTalentValue("special_bonus_war_1")

    self.movespeed_bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus") + t_movespeed
    self.incoming_damage_bonus = self:GetAbility():GetSpecialValueFor("incoming_damage_bonus")

    -- Purge Talent

    local t_purge = self:GetAbility():GetCaster():FindTalentValue("special_bonus_war_4") == 1
    if t_purge then
        self:GetParent():Purge(false, true, false, true, false)
    end
end

function modifier_wrath:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_wrath:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed_bonus
end

function modifier_wrath:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_bonus
end

function modifier_wrath:GetModifierIncomingDamage_Percentage()
    return self.incoming_damage_bonus
end

function modifier_wrath:GetEffectName()
    return "particles/units/heroes/hero_war/wrath.vpcf"
end

function modifier_wrath:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end