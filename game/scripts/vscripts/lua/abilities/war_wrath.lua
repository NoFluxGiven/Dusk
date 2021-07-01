war_wrath = class({})

LinkLuaModifier("modifier_wrath","lua/abilities/war_wrath",LUA_MODIFIER_MOTION_NONE)

function war_wrath:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")

	-- local max_count = 3

	target:AddNewModifier(caster, self, "modifier_wrath", {Duration=duration})
end

--------------------------------------------------------------------------------------------------------------

modifier_wrath = class({})

function modifier_wrath:IsHidden() return false end
function modifier_wrath:IsPurgable() return true end

function modifier_wrath:OnCreated(kv)
    self.base_attack_speed = self:GetAbility():GetSpecialValueFor("base_attack_speed")
    self.base_movespeed = self:GetAbility():GetSpecialValueFor("base_movespeed")
    self.base_physical_damage_reduction = self:GetAbility():GetSpecialValueFor("base_physical_damage_reduction")

    self.attack_speed_increase = self:GetAbility():GetSpecialValueFor("attack_speed_increase")
    self.movespeed_increase = self:GetAbility():GetSpecialValueFor("movespeed_increase")
    self.physical_damage_reduction_increase = self:GetAbility():GetSpecialValueFor("physical_damage_reduction_increase")

    self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")

    self:SetStackCount(0)

    -- self:StartIntervalThink(0.5)
end

function modifier_wrath:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

-- function modifier_wrath:OnIntervalThink()
--     if not self:GetParent():IsAttacking() then
--         self:DecrementStackCount()
--     end
-- end

function modifier_wrath:OnAttackLanded(params)
    if (params.attacker == self:GetParent()) then
        if self:GetStackCount() < self.max_stacks then
            self:IncrementStackCount()
        end
    end
end

function modifier_wrath:GetModifierAttackSpeedBonus_Constant()
    return self.base_attack_speed + self:GetStackCount() * self.attack_speed_increase
end

function modifier_wrath:GetModifierMoveSpeedBonus_Percentage()
    return self.base_movespeed + self:GetStackCount() * self.movespeed_increase
end

function modifier_wrath:GetModifierIncomingPhysicalDamage_Percentage()
    return -1 * (self.base_physical_damage_reduction + self:GetStackCount() * self.physical_damage_reduction_increase)
end