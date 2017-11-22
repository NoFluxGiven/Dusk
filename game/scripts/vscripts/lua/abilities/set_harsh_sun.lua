set_harsh_sun = class({})

LinkLuaModifier("modifier_harsh_sun_owner","lua/abilities/set_harsh_sun",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_harsh_sun_aura","lua/abilities/set_harsh_sun",LUA_MODIFIER_MOTION_NONE)

function set_harsh_sun:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function set_harsh_sun:GetIntrinsicModifierName()
	return "modifier_harsh_sun_owner"
end

modifier_harsh_sun_owner = class({})

function modifier_harsh_sun_owner:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BONUS_DAY_VISION
	}
	return funcs
end

function modifier_harsh_sun_owner:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_harsh_sun_owner:OnIntervalThink()
	if IsServer() then
		if GameRules:IsDaytime() then
			self:SetStackCount(1)
		else
			self:SetStackCount(0)
		end

		if self:GetParent():PassivesDisabled() then
			self:SetStackCount(0)
		end
	end
end

function modifier_harsh_sun_owner:IsHidden()
	return true
end

function modifier_harsh_sun_owner:GetModifierMoveSpeedBonus_Constant()
	local mspd = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	return mspd * self:GetStackCount()
end

function modifier_harsh_sun_owner:GetBonusDayVision()
	local manacost = self:GetAbility():GetSpecialValueFor("bonus_day_vision")
	return manacost * self:GetStackCount()
end

function modifier_harsh_sun_owner:IsAura()
	if self:GetStackCount() > 0 then return true end
	return false
end

function modifier_harsh_sun_owner:GetModifierAura()
	return "modifier_harsh_sun_aura"
end

function modifier_harsh_sun_owner:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO
end

function modifier_harsh_sun_owner:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_harsh_sun_owner:GetAuraRadius()
	return -1 -- should be global?
end

modifier_harsh_sun_aura = class({})

function modifier_harsh_sun_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_harsh_sun_aura:GetBonusDayVision()
	local amt = self:GetAbility():GetSpecialValueFor("vision_reduction")
	return -amt
end

function modifier_harsh_sun_aura:GetModifierAttackSpeedBonus_Constant()
	local t_attack_slow_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_set_2") or 0
	local amt = self:GetAbility():GetSpecialValueFor("attack_slow") + t_attack_slow_bonus
	local camt = self:GetAbility():GetSpecialValueFor("creep_attack_slow") + t_attack_slow_bonus
	if not self:GetParent():IsHero() then
		amt = camt
	end
	return -amt
end

