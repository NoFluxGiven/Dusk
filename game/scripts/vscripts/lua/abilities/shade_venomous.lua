shade_venomous = class({})

-- Link("modifier_venomous_lua")
-- Link("modifier_venomous_passive_lua")

LinkLuaModifier("modifier_venomous_lua","lua/modifiers/modifier_venomous_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venomous_passive_lua","lua/modifiers/modifier_venomous_passive_lua",LUA_MODIFIER_MOTION_NONE)

function shade_venomous:GetIntrinsicModifierName()
	return "modifier_venomous_passive_lua"
end