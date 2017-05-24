astaroth_erase = class({})

LinkLuaModifier("modifier_erase","lua/abilities/astaroth_erase",LUA_MODIFIER_MOTION_NONE)

function astaroth_erase:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	local hp_damage = self:GetSpecialValueFor("hp_damage")
	local mana_damage = self:GetSpecialValueFor("mana_damage")

	local chp_damage = self:GetSpecialValueFor("current_hp_damage")
	local cmana_damage = self:GetSpecialValueFor("current_mana_damage")

	local tick_time = 1.0

	if self:GetCaster():GetHasTalent("special_bonus_astaroth_erase") then tick_time = tick_time * 0.5 end

	target:AddNewModifier(caster, self, "modifier_erase", {Duration = duration, hp_dmg = hp_damage, mana_dmg = mana_damage, chp_dmg = chp_damage, cmana_dmg = cmana_damage, tick_time = tick_time})--[[Returns:void	
	No Description Set
	]]
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_erase = class({})

function modifier_erase:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_MODIFIER_ADDED
	}
	return funcs
end

function modifier_erase:OnCreated( kv )

	if IsServer() then

		self.hp_damage = kv.hp_dmg
		self.chp_damage = kv.chp_dmg / 100
		self.mana_damage = kv.mana_dmg
		self.cmana_damage = kv.cmana_dmg / 100

		self:GetParent():EmitSound("Astaroth.Erase")

		self:StartIntervalThink(kv.tick_time)

	end

end

function modifier_erase:OnIntervalThink()
	if IsServer() then
		local target = self:GetParent()
		local damage = self.hp_damage + (target:GetHealth() * self.chp_damage)
		local mdamage = self.mana_damage + (target:GetMana() * self.cmana_damage)

		DealDamage(target,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		target:ReduceMana(mdamage)
	end
end

function modifier_erase:IsDebuff()
	return true
end

function modifier_erase:IsPurgable()
	return false
end

function modifier_erase:OnModifierAdded(params)
	PrintTable(params)
	print("MODIFIER ADDED")
end

function modifier_erase:GetEffectName()
	return "particles/units/heroes/hero_astaroth/astaroth_erase_unit_target.vpcf"
end