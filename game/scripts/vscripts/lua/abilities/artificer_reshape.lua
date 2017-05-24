artificer_reshape = class({})

LinkLuaModifier("modifier_reshape_lua","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)

function artificer_reshape:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local ability = self
	local ability_level = ability:GetLevel() - 1

	local duration_bonus = 0

	if caster:GetHasTalent("special_bonus_artificer_reshape") then print("BONUS!!") duration_bonus = 1.5 end

	local duration = ability:GetSpecialValueFor("duration") + duration_bonus

	print(duration)

	disablePropsOnUnit(target)

	target:EmitSound("Hero_EarthSpirit.Petrify")
	
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		target:AddNewModifier(caster, ability, "modifier_reshape_lua", {Duration = duration})
		ParticleManager:CreateParticle("particles/units/heroes/hero_artificer/reshape.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
	end

end

-- MODIFIERS

modifier_reshape_lua = class({})

--[[Author: Noya, Pizzalol
	Date: 27.09.2015.
	Changes the model, reduces the movement speed and disables the target]]
function modifier_reshape_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_reshape_lua:GetModifierModelChange()
	return "models/props_structures/statue_mystical001.vmdl"
end

function modifier_reshape_lua:GetModifierMoveSpeedOverride()
	return 0
end

function modifier_reshape_lua:GetModifierIncomingDamage_Percentage()
	-- local bonus = 0
	-- if self:GetAbility():GetCaster():GetHasTalent("special_bonus_artificer_reshape") then bonus = 25 end
	return -(self:GetAbility():GetSpecialValueFor("damage_reduction")) --[[Returns:table
	No Description Set
	]]
end

function modifier_reshape_lua:OnDestroy()
	if IsServer() then
		enablePropsOnUnit(self:GetParent())
	end
end

function modifier_reshape_lua:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			enablePropsOnUnit(self:GetParent())
		end
	end
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