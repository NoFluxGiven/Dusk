neith_rally = class({})

LinkLuaModifier("modifier_rally_buff","lua/abilities/neith_rally",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rally_debuff","lua/abilities/neith_rally",LUA_MODIFIER_MOTION_NONE)

function neith_rally:OnSpellStart()
	local c = self:GetCaster()
	local damage_bonus = self:GetSpecialValueFor("damage_increase")
	local creep_damage_bonus = self:GetSpecialValueFor("damage_increase_creep")
	local attackspeed_bonus = self:GetSpecialValueFor("attack_speed_increase")
	local movespeed_bonus = self:GetSpecialValueFor("bonus_movespeed")
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	local targets = DOTA_UNIT_TARGET_TEAM_FRIENDLY

	local scepter_duration = self:GetSpecialValueFor("scepter_duration")
	local scepter_radius = self:GetSpecialValueFor("scepter_radius")

	if c:HasScepter() then
		duration = scepter_duration
		radius = scepter_radius
		targets = DOTA_UNIT_TARGET_TEAM_FRIENDLY+DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	c:EmitSound("Hero_LegionCommander.PressTheAttack")

	local ent = FindEntities(c,c:GetAbsOrigin(),radius,targets)

	for k,v in pairs(ent) do
		if v:GetTeam() == c:GetTeam() then
			v:AddNewModifier(c, self, "modifier_rally_buff", {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		else
			v:AddNewModifier(c, self, "modifier_rally_debuff", {Duration=duration})
		end
	end
end

modifier_rally_buff = class({})

function modifier_rally_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_rally_buff:GetModifierPreAttack_BonusDamage()
	if self:GetParent():IsHero() then
		return self:GetAbility():GetSpecialValueFor("damage_increase")
	else
		return self:GetAbility():GetSpecialValueFor("damage_increase_creep")
	end
end

function modifier_rally_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed_increase")
end

function modifier_rally_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_rally_buff:GetModifierPhysicalArmorBonus()
	if IsClient() then
		local armor_bonus = self:GetAbility():FetchTalent() or 0
		return armor_bonus
	end
end

function modifier_rally_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

modifier_rally_debuff = class({})

function modifier_rally_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_rally_debuff:GetModifierPreAttack_BonusDamage()
	if self:GetParent():IsHero() then
		return -self:GetAbility():GetSpecialValueFor("damage_increase")
	else
		return -self:GetAbility():GetSpecialValueFor("damage_increase_creep")
	end
end

function modifier_rally_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("attack_speed_increase")
end

function modifier_rally_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_rally_debuff:GetEffectName()
	return "particles/units/heroes/hero_neith/rally_enemy.vpcf"
end

function modifier_rally_debuff:IsDebuff()
	return true
end