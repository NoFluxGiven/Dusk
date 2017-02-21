vassal_repair_module = class({})

LinkLuaModifier("modifier_repair_regen","lua/modifiers/modifier_repair_regen",LUA_MODIFIER_MOTION_NONE)

function vassal_repair_module:GetIntrinsicModifierName()
	return "modifier_repair_regen"
end