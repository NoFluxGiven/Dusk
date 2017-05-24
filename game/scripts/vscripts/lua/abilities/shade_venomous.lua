shade_venomous = class({})

-- Link("modifier_venomous_lua")
-- Link("modifier_venomous_passive_lua")

LinkLuaModifier("modifier_venomous_lua","lua/abilities/shade_venomous",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venomous_passive_lua","lua/abilities/shade_venomous",LUA_MODIFIER_MOTION_NONE)

function shade_venomous:GetIntrinsicModifierName()
	return "modifier_venomous_passive_lua"
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_venomous_lua = class({})

function modifier_venomous_lua:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return func
end

function modifier_venomous_lua:OnCreated()
	self:StartIntervalThink(1.0)
	self.start_time = GameRules:GetGameTime()
end

function modifier_venomous_lua:OnIntervalThink()
	if IsServer() then
		local agh_interval = 8
		local dot = self:GetAbility():GetSpecialValueFor("damage")
		local dmg = dot
		local dtype = self:GetAbility():GetAbilityDamageType()
		if self:GetCaster():HasScepter() then
			local time_elapsed = GameRules:GetGameTime() - self.start_time
			dmg = (time_elapsed / agh_interval) * dot + dot
			local limit = 200
			if dmg > limit then dmg = limit end
		end
		DealDamage(self:GetParent(),self:GetCaster(),dmg,dtype)
	end
end

function modifier_venomous_lua:GetModifierMoveSpeedBonus_Percentage()
	local agh_interval = 8
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	if self:GetCaster():HasScepter() then
		local time_elapsed = GameRules:GetGameTime() - self.start_time
		slow = (time_elapsed / agh_interval) * slow + slow
	end
	return slow
end

function modifier_venomous_lua:GetModifierAttackSpeedBonus_Constant()
	local agh_interval = 8
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	if self:GetCaster():HasScepter() then
		local time_elapsed = GameRules:GetGameTime() - self.start_time
		slow = (time_elapsed / agh_interval) * slow + slow
	end
	return slow
end

function modifier_venomous_lua:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_venomous_lua:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_venomous_passive_lua = class({})

function modifier_venomous_passive_lua:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_venomous_passive_lua:OnAttackLanded( params )
	local att = params.attacker
	local dmg = params.attack_damage
	local unit = params.unit or params.target
	local dur = GetModifierSV(self,"duration")

	if att ~= self:GetParent() then return end

	if att:GetTeam() == unit:GetTeam() or CheckClass(unit,"npc_dota_building") then
		return
	end

	unit:AddNewModifier(att, self:GetAbility(), "modifier_venomous_lua", {Duration = dur}) --[[Returns:void
	No Description Set
	]]
end