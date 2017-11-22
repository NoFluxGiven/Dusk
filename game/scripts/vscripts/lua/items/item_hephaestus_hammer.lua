item_hephaestus_hammer = class({})

LinkLuaModifier("modifier_hephaestus_hammer","lua/items/item_hephaestus_hammer",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hephaestus_hammer_aura","lua/items/item_hephaestus_hammer",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hephaestus_guard","lua/items/item_hephaestus_hammer",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hephaestus_guard_cooldown","lua/items/item_hephaestus_hammer",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hephaestus_guard_slow","lua/items/item_hephaestus_hammer",LUA_MODIFIER_MOTION_NONE)

function item_hephaestus_hammer:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("aura_radius")
		local duration = self:GetSpecialValueFor("duration")
		local cooldown = self:GetSpecialValueFor("active_cooldown")
		local allies = FindAllies(caster,caster:GetAbsOrigin(),radius,DOTA_UNIT_TARGET_BUILDING)

		caster:EmitSound("Hephaestus")
		-- CreateParticleHitloc(caster,"particles/items/hephaestus_start.vpcf")

		for k,v in pairs(allies) do

			if not v:HasModifier("modifier_hephaestus_guard_cooldown") then
				v:AddNewModifier(caster, self, "modifier_hephaestus_guard", {Duration=duration})
				v:AddNewModifier(caster, self, "modifier_hephaestus_guard_cooldown", {Duration=cooldown})
			end
		end
	end
end

function item_hephaestus_hammer:GetIntrinsicModifierName()
	return "modifier_hephaestus_hammer"
end

modifier_hephaestus_hammer = class({})

function modifier_hephaestus_hammer:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return func
end

function modifier_hephaestus_hammer:IsAura()
	return true
end

function modifier_hephaestus_hammer:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_hephaestus_hammer:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_hephaestus_hammer:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_hephaestus_hammer:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BUILDING
end

function modifier_hephaestus_hammer:GetModifierAura()
	return "modifier_hephaestus_hammer_aura"
end

function modifier_hephaestus_hammer:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_hephaestus_hammer:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_hephaestus_hammer:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_hephaestus_hammer:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_hephaestus_hammer:IsHidden()
	return true
end

modifier_hephaestus_hammer_aura = class({})

function modifier_hephaestus_hammer_aura:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return func
end

function modifier_hephaestus_hammer_aura:GetEffectName()
	return "particles/items/hephaestus_aura.vpcf"
end

function modifier_hephaestus_hammer_aura:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("aura_armor_bonus")
end

modifier_hephaestus_guard = class({})

function modifier_hephaestus_guard:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_hephaestus_guard:GetEffectName()
	return "particles/items/hephaestus.vpcf"
end

function modifier_hephaestus_guard:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("active_damage_reduction")
end

function modifier_hephaestus_guard:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("active_regen_bonus")
end

function modifier_hephaestus_guard:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		if target == self:GetParent() then
			local duration = self:GetAbility():GetSpecialValueFor("active_slow_duration")

			attacker:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_hephaestus_guard_slow", {Duration=duration})
		end
	end
end

modifier_hephaestus_guard_slow = class({})

function modifier_hephaestus_guard_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_hephaestus_guard_slow:GetEffectName()
	return "particles/items/hephaestus_slow.vpcf"
end

function modifier_hephaestus_guard_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("active_move_slow")
end

function modifier_hephaestus_guard_slow:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("active_att_slow")
end

modifier_hephaestus_guard_cooldown = class({})