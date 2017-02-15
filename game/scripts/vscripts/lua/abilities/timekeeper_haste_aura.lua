timekeeper_haste_aura = class({})

LinkLuaModifier("modifier_haste_aura","lua/modifiers/modifier_haste_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste_aura_effect","lua/modifiers/modifier_haste_aura_effect",LUA_MODIFIER_MOTION_NONE)

function timekeeper_haste_aura:GetIntrinsicModifierName()
	return "modifier_haste_aura"
end