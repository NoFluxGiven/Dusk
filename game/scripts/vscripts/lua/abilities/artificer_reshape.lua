artificer_reshape = class({})

-- LinkLuaModifier("modifier_reshape_lua","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_siren","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_siren_aura","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_serpent","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_serpent_aura","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_abyssal_one","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_abyssal_one_aura","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_monk","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reshape_monk_aura","lua/abilities/artificer_reshape",LUA_MODIFIER_MOTION_NONE)

function artificer_reshape:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end
	target:TriggerSpellReflect(self)

	local ability = self
	local ability_level = ability:GetLevel() - 1

	local duration_bonus = 0

	local creep_mult = 1

	if not target:IsHero() then creep_mult = 2 end

	local transform_target

	local SIREN,SERPENT,ABYSSAL_ONE,MONK = 1,2,3,4

	local r = RandomInt(1, 4) --[[Returns:int
	Get a random ''int'' within a range
	]]

	local t = {
		[SIREN] = "siren",
		[SERPENT] = "serpent",
		[ABYSSAL_ONE] = "abyssal_one",
		[MONK] = "monk"
	}

	transform_target = "modifier_reshape_" .. t[r]
	transform_sound = "Artificer.Reshape." .. t[r]
	transform_particle = "particles/units/heroes/hero_artificer/reshape_"..t[r].."_statue_glow.vpcf"

	if caster:HasTalent("special_bonus_artificer_reshape") then ToolsPrint("BONUS!!") duration_bonus = 1.5 end

	local duration = (ability:GetSpecialValueFor("duration") + duration_bonus)*creep_mult

	ToolsPrint(duration)

	disablePropsOnUnit(target)

	target:EmitSound("Hero_EarthSpirit.Petrify")
	target:EmitSound(transform_sound)
	
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		local mod = target:AddNewModifier(caster, ability, transform_target, {Duration = duration})
		ParticleManager:CreateParticle("particles/units/heroes/hero_artificer/reshape.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
		local part = ParticleManager:CreateParticle(transform_particle, PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
		mod:AddParticle( part, false, false, 1, false, false )
	end

end

-- MODIFIERS

-- modifier_reshape_lua = class({})

-- --[[Author: Noya, Pizzalol
-- 	Date: 27.09.2015.
-- 	Changes the model, reduces the movement speed and disables the target]]
-- function modifier_reshape_lua:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_MODEL_CHANGE,
-- 		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
-- 		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
-- 		MODIFIER_EVENT_ON_DEATH
-- 	}

-- 	return funcs
-- end

-- function modifier_reshape_lua:GetModifierModelChange()
-- 	return "models/props_structures/statue_mystical001.vmdl"
-- end

-- function modifier_reshape_lua:GetModifierMoveSpeedOverride()
-- 	return 0
-- end

-- function modifier_reshape_lua:GetModifierIncomingDamage_Percentage()
-- 	-- local bonus = 0
-- 	-- if self:GetAbility():GetCaster():HasTalent("special_bonus_artificer_reshape") then bonus = 25 end
-- 	return -(self:GetAbility():GetSpecialValueFor("damage_reduction")) --[[Returns:table
-- 	No Description Set
-- 	]]
-- end

-- function modifier_reshape_lua:OnDestroy()
-- 	if IsServer() then
-- 		enablePropsOnUnit(self:GetParent())
-- 	end
-- end

-- function modifier_reshape_lua:OnDeath(params)
-- 	if IsServer() then
-- 		if params.unit == self:GetParent() then
-- 			enablePropsOnUnit(self:GetParent())
-- 		end
-- 	end
-- end

-- function modifier_reshape_lua:CheckState()
-- 	local state = {
-- 	[MODIFIER_STATE_DISARMED] = true,
-- 	[MODIFIER_STATE_HEXED] = true,
-- 	[MODIFIER_STATE_MUTED] = true,
-- 	[MODIFIER_STATE_EVADE_DISABLED] = true,
-- 	[MODIFIER_STATE_BLOCK_DISABLED] = true,
-- 	[MODIFIER_STATE_SILENCED] = true,
-- 	[MODIFIER_STATE_ROOTED] = true,
-- 	[MODIFIER_STATE_STUNNED] = true,
-- 	[MODIFIER_STATE_INVULNERABLE] = true
-- 	}

-- 	return state
-- end

-- function modifier_reshape_lua:IsHidden()
-- 	return false
-- end

----------------------------------------------------------------------------------------
-- SIREN
----------------------------------------------------------------------------------------

modifier_reshape_siren = class({})

function modifier_reshape_siren:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_reshape_siren:GetModifierModelChange()
	return "maps/reef_assets/models/props/naga_city/darkreef_statue002.vmdl"
end

function modifier_reshape_siren:GetModifierMoveSpeedOverride()
	return 0
end

function modifier_reshape_siren:IsAura()
	return true
end

function modifier_reshape_siren:GetModifierAura()
	return "modifier_reshape_siren_aura"
end

function modifier_reshape_siren:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO
end

function modifier_reshape_siren:GetAuraSearchTeam()
	if self:GetParent():GetTeam() == self:GetAbility():GetCaster():GetTeam() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_reshape_siren:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_reshape_siren:OnDestroy()
	if IsServer() then
		enablePropsOnUnit(self:GetParent())
	end
end

function modifier_reshape_siren:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			enablePropsOnUnit(self:GetParent())
		end
	end
end

function modifier_reshape_siren:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return state
end

function modifier_reshape_siren:IsHidden()
	return false
end

modifier_reshape_siren_aura = class({})

function modifier_reshape_siren_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_reshape_siren_aura:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("siren_movespeed_slow")
end

function modifier_reshape_siren_aura:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("siren_attackspeed_slow")
end

----------------------------------------------------------------------------------------
-- SERPENT
----------------------------------------------------------------------------------------

modifier_reshape_serpent = class({})

function modifier_reshape_serpent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_reshape_serpent:GetModifierModelChange()
	return "models/props_structures/statue_eel001.vmdl"
end

function modifier_reshape_serpent:GetModifierMoveSpeedOverride()
	return 0
end

function modifier_reshape_serpent:IsAura()
	return true
end

function modifier_reshape_serpent:GetModifierAura()
	return "modifier_reshape_serpent_aura"
end

function modifier_reshape_serpent:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO
end

function modifier_reshape_serpent:GetAuraSearchTeam()
	if self:GetParent():GetTeam() == self:GetAbility():GetCaster():GetTeam() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_reshape_serpent:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_reshape_serpent:OnDestroy()
	if IsServer() then
		enablePropsOnUnit(self:GetParent())
	end
end

function modifier_reshape_serpent:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			enablePropsOnUnit(self:GetParent())
		end
	end
end

function modifier_reshape_serpent:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return state
end

function modifier_reshape_serpent:IsHidden()
	return false
end

modifier_reshape_serpent_aura = class({})

function modifier_reshape_serpent_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_reshape_serpent_aura:GetModifierPreAttack_BonusDamage()
	return -self:GetAbility():GetSpecialValueFor("serpent_damage_reduction")
end

function modifier_reshape_serpent_aura:GetModifierSpellAmplify_Percentage()
	return -self:GetAbility():GetSpecialValueFor("serpent_spell_reduction")
end

----------------------------------------------------------------------------------------
-- ABYSSAL ONE
----------------------------------------------------------------------------------------

modifier_reshape_abyssal_one = class({})

function modifier_reshape_abyssal_one:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_reshape_abyssal_one:GetModifierModelChange()
	return "models/props_structures/statue_mystical001.vmdl"
end

function modifier_reshape_abyssal_one:GetModifierMoveSpeedOverride()
	return 0
end

function modifier_reshape_abyssal_one:IsAura()
	return true
end

function modifier_reshape_abyssal_one:GetModifierAura()
	return "modifier_reshape_abyssal_one_aura"
end

function modifier_reshape_abyssal_one:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO
end

function modifier_reshape_abyssal_one:GetAuraSearchTeam()
	if self:GetParent():GetTeam() == self:GetAbility():GetCaster():GetTeam() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_reshape_abyssal_one:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_reshape_abyssal_one:OnDestroy()
	if IsServer() then
		enablePropsOnUnit(self:GetParent())
	end
end

function modifier_reshape_abyssal_one:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			enablePropsOnUnit(self:GetParent())
		end
	end
end

function modifier_reshape_abyssal_one:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return state
end

function modifier_reshape_abyssal_one:IsHidden()
	return false
end

modifier_reshape_abyssal_one_aura = class({})

function modifier_reshape_abyssal_one_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_reshape_abyssal_one_aura:GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("abyssal_one_armor_reduction")
end

function modifier_reshape_abyssal_one_aura:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("abyssal_one_magic_res_reduction")
end

----------------------------------------------------------------------------------------
-- MONK
----------------------------------------------------------------------------------------

modifier_reshape_monk = class({})

function modifier_reshape_monk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_reshape_monk:GetModifierModelChange()
	return "models/props/statues/priest/statue_priest.vmdl"
end

function modifier_reshape_monk:GetModifierMoveSpeedOverride()
	return 0
end

function modifier_reshape_monk:IsAura()
	return true
end

function modifier_reshape_monk:GetModifierAura()
	return "modifier_reshape_monk_aura"
end

function modifier_reshape_monk:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO
end

function modifier_reshape_monk:GetAuraSearchTeam()
	if self:GetParent():GetTeam() == self:GetAbility():GetCaster():GetTeam() then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_reshape_monk:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_reshape_monk:OnDestroy()
	if IsServer() then
		enablePropsOnUnit(self:GetParent())
	end
end

function modifier_reshape_monk:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			enablePropsOnUnit(self:GetParent())
		end
	end
end

function modifier_reshape_monk:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_MUTED] = true,
	[MODIFIER_STATE_EVADE_DISABLED] = true,
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}

	return state
end

function modifier_reshape_monk:IsHidden()
	return false
end

modifier_reshape_monk_aura = class({})

function modifier_reshape_monk_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_reshape_monk_aura:GetModifierConstantHealthRegen()
	return -self:GetAbility():GetSpecialValueFor("monk_neg_health_regen")
end

function modifier_reshape_monk_aura:GetModifierConstantManaRegen()
	return -self:GetAbility():GetSpecialValueFor("monk_neg_mana_regen")
end