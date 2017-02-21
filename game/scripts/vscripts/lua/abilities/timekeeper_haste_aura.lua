timekeeper_haste_aura = class({})

LinkLuaModifier("modifier_haste_aura","lua/modifiers/modifier_haste_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste_aura_effect","lua/modifiers/modifier_haste_aura_effect",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste_aura_effect_act","lua/modifiers/modifier_haste_aura_effect_act",LUA_MODIFIER_MOTION_NONE)

function timekeeper_haste_aura:GetIntrinsicModifierName()
	return "modifier_haste_aura"
end

function timekeeper_haste_aura:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_haste_aura_effect_act", {Duration=self:GetSpecialValueFor("act_duration")}) --[[Returns:void
	No Description Set
	]]

	target:EmitSound("Timekeeper.HasteAura.Act")

end