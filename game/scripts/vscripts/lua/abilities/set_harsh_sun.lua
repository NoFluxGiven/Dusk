set_harsh_sun = class({})

function set_harsh_sun:GetIntrinsicModifierName()
	return "modifier_harsh_sun_owner"
end

modifier_harsh_sun_owner = class({})

function modifier_harsh_sun_owner:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_harsh_sun_owner:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hp_regen")
end

function modifier_harsh_sun_owner:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_harsh_sun_owner:IsAura()
	return true
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
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_harsh_sun_aura:GetModifierAttackSpeedBonus_Constant()
	local amt = self:GetAbility():GetSpecialValueFor("attack_slow")
	local camt = self:GetAbility():GetSpecialValueFor("creep_attack_slow")
	if not self:GetParent():IsHero() then
		amt = camt
	end
	return amt
end

function modifier_harsh_sun_aura:GetModifierDamageOutgoing_Percentage()
	local amt = self:GetAbility():GetSpecialValueFor("damage_reduction")
	local camt = self:GetAbility():GetSpecialValueFor("creep_damage_reduction")
	if not self:GetParent():IsHero() then
		amt = camt
	end
	return amt
end