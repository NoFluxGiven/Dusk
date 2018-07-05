aeronaut_hidden_engine = class({})

LinkLuaModifier("modifier_aeronaut_hidden_engine","lua/abilities/aeronaut_hidden_engine",LUA_MODIFIER_MOTION_NONE)

function aeronaut_hidden_engine:GetIntrinsicModifierName()
	return "modifier_aeronaut_hidden_engine"
end

modifier_aeronaut_hidden_engine = class({})

function modifier_aeronaut_hidden_engine:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
	return func
end

function modifier_aeronaut_hidden_engine:GetAttackSound()
	return "Hero_Gyrocopter.Attack"
end

function modifier_aeronaut_hidden_engine:IsHidden()
	return true
end