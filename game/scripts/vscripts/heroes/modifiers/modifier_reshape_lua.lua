modifier_reshape_lua = class({})

--[[Author: Noya, Pizzalol
	Date: 27.09.2015.
	Changes the model, reduces the movement speed and disables the target]]
function modifier_reshape_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}

	return funcs
end

function modifier_reshape_lua:GetModifierModelChange()
	return "models/props_structures/statue_mystical001.vmdl"
end

function modifier_reshape_lua:GetModifierMoveSpeedOverride()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_reshape_lua:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_reshape_lua:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true
	}

	return state
end

function modifier_reshape_lua:IsHidden() 
	return false
end