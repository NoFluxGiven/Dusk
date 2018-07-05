item_seers_lantern = class({})

-- GHOST SCEPTER + ARCANITE SHARDS + VOID STONE

-- Grants +8 to all stats, +10 damage, +1.00 Mana Regen
-- Upon activation, units within a 550 radius become Ethereal
-- (they are Attack Immune, Disarmed, and take 40% more Magical Damage)
-- Slows enemies by 25%.
-- You gain True Sight through fog of enemies in the radius.
-- 21s cooldown.

LinkLuaModifier("modifier_seers_lantern","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seers_lantern_aura","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seers_lantern_aura_ally","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seers_lantern_true_sight_aura","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seers_lantern_ethereal","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seers_lantern_ethereal_ally","lua/items/item_seers_lantern",LUA_MODIFIER_MOTION_NONE)

function item_seers_lantern:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local true_sight_duration = self:GetSpecialValueFor("true_sight_duration")

	caster:EmitSound("SeersLantern")

	caster:AddNewModifier(caster,self,"modifier_seers_lantern_aura",{Duration=duration})
	caster:AddNewModifier(caster,self,"modifier_seers_lantern_aura_ally",{Duration=duration})
	caster:AddNewModifier(caster,self,"modifier_seers_lantern_true_sight_aura",{Duration=true_sight_duration})
end

function item_seers_lantern:GetIntrinsicModifierName()
	return "modifier_seers_lantern"
end

-----------------------

modifier_seers_lantern = class({})

function modifier_seers_lantern:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_seers_lantern:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_seers_lantern:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_seers_lantern:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_seers_lantern:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_seers_lantern:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_seers_lantern:IsHidden()
	return true
end

-----------------------

modifier_seers_lantern_aura = class({})

function modifier_seers_lantern_aura:IsAura()
	return true
end

function modifier_seers_lantern_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_seers_lantern_aura:GetAuraSearchFlags()
	return 0
end

function modifier_seers_lantern_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_seers_lantern_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_seers_lantern_aura:GetAuraDuration()
	return 0.25
end

function modifier_seers_lantern_aura:GetModifierAura()
	return "modifier_seers_lantern_ethereal"
end

function modifier_seers_lantern_aura:IsPurgable()
	return true
end

-----------------------

modifier_seers_lantern_aura_ally = class({})

function modifier_seers_lantern_aura_ally:IsAura()
	return true
end

function modifier_seers_lantern_aura_ally:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_seers_lantern_aura_ally:GetAuraSearchFlags()
	return 0
end

function modifier_seers_lantern_aura_ally:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_seers_lantern_aura_ally:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_seers_lantern_aura_ally:GetModifierAura()
	return "modifier_seers_lantern_ethereal_ally"
end

function modifier_seers_lantern_aura_ally:GetAuraDuration()
	return 0.25
end

function modifier_seers_lantern_aura_ally:IsPurgable()
	return true
end

function modifier_seers_lantern_aura_ally:IsHidden()
	return true
end

-----------------------

modifier_seers_lantern_true_sight_aura = class({})

function modifier_seers_lantern_true_sight_aura:IsAura()
	return true
end

function modifier_seers_lantern_true_sight_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_seers_lantern_true_sight_aura:GetAuraSearchFlags()
	return 0
end

function modifier_seers_lantern_true_sight_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_seers_lantern_true_sight_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_seers_lantern_true_sight_aura:GetAuraDuration()
	return 1.25
end

function modifier_seers_lantern_true_sight_aura:GetModifierAura()
	return "modifier_truesight"
end

function modifier_seers_lantern_true_sight_aura:GetEffectName()
	return "particles/items_fx/seers_lantern_user.vpcf"
end

function modifier_seers_lantern_true_sight_aura:IsPurgable()
	return true
end

function modifier_seers_lantern_true_sight_aura:IsHidden()
	return true
end

-----------------------

modifier_seers_lantern_ethereal = class({})

function modifier_seers_lantern_ethereal:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end

function modifier_seers_lantern_ethereal:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return func
end

function modifier_seers_lantern_ethereal:OnCreated(kv)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_true_sight", {IsHidden=true,Duration=self:GetDuration()})
	end
end

function modifier_seers_lantern_ethereal:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_seers_lantern_ethereal:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("magic_res_reduction")
end

function modifier_seers_lantern_ethereal:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_seers_lantern_ethereal:GetModifierProvidesFOWVision()
	if IsServer() then
		local cteam = self:GetAbility():GetCaster():GetTeam()
		local uteam = self:GetParent():GetTeam()

		if cteam ~= uteam then
			return 1
		end
		return 0
	end
end

function modifier_seers_lantern_ethereal:GetEffectName()
	return "particles/items_fx/seers_lantern.vpcf"
end

function modifier_seers_lantern_ethereal:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_seers_lantern_ethereal:StatusEffectPriority()
	return 10
end

-----------------------

modifier_seers_lantern_ethereal_ally = class({})

function modifier_seers_lantern_ethereal_ally:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	return state
end

function modifier_seers_lantern_ethereal_ally:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
	return func
end

function modifier_seers_lantern_ethereal_ally:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("magic_res_reduction")
end

function modifier_seers_lantern_ethereal_ally:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_seers_lantern_ethereal_ally:GetEffectName()
	return "particles/items_fx/seers_lantern.vpcf"
end

function modifier_seers_lantern_ethereal_ally:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_seers_lantern_ethereal_ally:StatusEffectPriority()
	return 10
end