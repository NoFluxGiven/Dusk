tek_jetpack = class({})

LinkLuaModifier("modifier_jetpack","lua/abilities/tek_jetpack",LUA_MODIFIER_MOTION_NONE)

function tek_jetpack:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_jetpack") then
			self:GetCaster():RemoveModifierByName("modifier_jetpack")
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_jetpack", {})
		end
	end
end

modifier_jetpack = class({})

function modifier_jetpack:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
	return func
end

function modifier_jetpack:GetModifierMoveSpeed_Max()
	return 700
end

function modifier_jetpack:GetModifierMoveSpeed_Limit()
	return 700
end

function modifier_jetpack:GetModifierMoveSpeed_Absolute()
	return 700
end

function modifier_jetpack:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end

function modifier_jetpack:GetEffectName()
	return "particles/units/heroes/hero_tek/jetpack.vpcf"
end