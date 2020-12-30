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
		local dot = self:GetAbility():GetSpecialValueFor("damage")
		local dtype = self:GetAbility():GetAbilityDamageType()

		local modifiers = self:GetParent():FindAllModifiers()

		local debuff_count = 0
		for _,m in pairs(modifiers) do
			print(m:GetName())
			print(m.IsHidden)
			if m:IsDebuff() and m:GetAbility():GetOwner():IsHero() then debuff_count = debuff_count + 1 end
		end

		dot = dot * debuff_count

		self:GetAbility():InflictDamage(self:GetParent(),self:GetCaster(),dot,dtype,DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)
	end
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
	local dur = GetModifierSV(self,"duration") or 4

	if att ~= self:GetParent() then return end

	if att:GetTeam() == unit:GetTeam() or CheckClass(unit,"npc_dota_building") then
		return
	end

	unit:AddNewModifier(att, self:GetAbility(), "modifier_venomous_lua", {Duration = dur})
end

function modifier_venomous_passive_lua:IsHidden()
	return true
end