war_berserker_aura = class({})

LinkLuaModifier("modifier_berserker_aura","lua/abilities/war_berserker_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_berserker_aura_buff","lua/abilities/war_berserker_aura",LUA_MODIFIER_MOTION_NONE)

function war_berserker_aura:GetIntrinsicModifierName()
	return "modifier_berserker_aura"
end

modifier_berserker_aura = class({})

function modifier_berserker_aura:IsAura()
	return true
end

function modifier_berserker_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_berserker_aura:GetAuraSearchFlags()
	return 0
end

function modifier_berserker_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_berserker_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_berserker_aura:GetModifierAura()
	return "modifier_berserker_aura_buff"
end

function modifier_berserker_aura:IsHidden()
	return true
end

modifier_berserker_aura_buff = class({})

function modifier_berserker_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_berserker_aura_buff:GetModifierPreAttack_BonusDamage()
	local caster = self:GetAbility():GetCaster()
	local target = self:GetParent()

	if caster:PassivesDisabled() then return nil end

	local t_dmg_bonus = caster:FetchTalent("special_bonus_war_2") or 0

	local dmg = self:GetAbility():GetSpecialValueFor("max_bonus_damage") + t_dmg_bonus --[[Returns:table
	No Description Set
	]]

	local hppct = target:GetHealthPercent()/100

	local baseline = 0.25

	local pct = ( (1 / baseline) - (hppct / baseline) ) * 0.33

	if pct > 1.00 then pct = 1.00 end

	local fdmg = dmg*pct
	if fdmg >= 1 then fdmg = math.ceil(fdmg) else fdmg = 0 end
	
	return fdmg
end

function modifier_berserker_aura_buff:GetModifierAttackSpeedBonus_Constant()
	local caster = self:GetAbility():GetCaster()
	local target = self:GetParent()

	if caster:PassivesDisabled() then return nil end

	-- local dmg = self:GetSpecialValueFor("max_bonus_damage")

	local t_atk_bonus = caster:FetchTalent("special_bonus_war_2") or 0

	local atk = self:GetAbility():GetSpecialValueFor("max_bonus_attack_speed") + t_atk_bonus

	local hppct = target:GetHealthPercent()/100

	local baseline = 0.25

	local pct = ( (1 / baseline) - (hppct / baseline) ) * 0.33

	if pct > 1.00 then pct = 1.00 end

	-- local fdmg = math.floor(dmg*pct)
	local fatk = atk*pct
	if fatk >= 1 then fatk = math.ceil(fatk) else fatk = 0 end

	return fatk
end

function modifier_berserker_aura_buff:IsHidden()
	if self:GetAbility():GetCaster():PassivesDisabled() then return true else return false end
end