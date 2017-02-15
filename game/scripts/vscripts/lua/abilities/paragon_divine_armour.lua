paragon_divine_armour = class({})

LinkLuaModifier("modifier_divine_armour_lua","lua/modifiers/modifier_divine_armour_lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_divine_armour_block_lua","lua/modifiers/modifier_divine_armour_block_lua",LUA_MODIFIER_MOTION_NONE)

function paragon_divine_armour:GetIntrinsicModifierName()
	return "modifier_divine_armour_lua"
end