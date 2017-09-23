artificer_naturalise = class({})

LinkLuaModifier("modifier_naturalise_armor","lua/abilities/artificer_naturalise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_naturalise_mres","lua/abilities/artificer_naturalise",LUA_MODIFIER_MOTION_NONE)

function artificer_naturalise:OnSpellStart()

	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration")

	if target:TriggerSpellAbsorb(self) then return end
	target:TriggerSpellReflect(self)

	self:ApplyNaturalise(target,duration)

	target:EmitSound("Hero_Treant.LeechSeed.Target")

	ParticleManager:CreateParticle("particles/units/heroes/hero_artificer/naturalise.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]

end

function artificer_naturalise:ApplyNaturalise(target,duration)
	local caster = self:GetCaster()

	target:AddNewModifier(caster, self, "modifier_naturalise_armor", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
	target:AddNewModifier(caster, self, "modifier_naturalise_mres", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

-- MODIFIERS

modifier_naturalise_armor = class({})

function modifier_naturalise_armor:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return func
end

function modifier_naturalise_armor:OnCreated()
	if IsServer() then
		local base_armor = self:GetParent():GetPhysicalArmorBaseValue() + self:GetParent():GetAgility()/7
		local current_armor = self:GetParent():GetPhysicalArmorValue()

		local diff = current_armor - base_armor

		if diff < 0 then diff = 0 end

		self:SetStackCount(diff)
	end

		-- local base_attack_damage = self:GetParent():GetAttackDamage()
		-- local current_attack_damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())

		-- self.diff_attack_damage = current_attack_damage-base_attack_damage
end

function modifier_naturalise_armor:GetModifierPhysicalArmorBonus()
	local reduction = self:GetStackCount()
	return -reduction
end

function modifier_naturalise_armor:GetModifierPreAttack_BonusDamage()
	local reduction = self:GetAbility():GetSpecialValueFor("attack_damage_reduction")
	return -reduction
end

function modifier_naturalise_armor:IsHidden()
	return true
end

modifier_naturalise_mres = class({})

function modifier_naturalise_mres:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return func
end

function modifier_naturalise_mres:OnCreated()

		local base_mres = self:GetParent():GetBaseMagicalResistanceValue()
		local current_mres = self:GetParent():GetMagicalArmorValue() * 100

		local diff = current_mres - base_mres

		if diff < 0 then diff = 0 end

		self:SetStackCount(diff)

		-- local base_attack_damage = self:GetParent():GetAttackDamage()
		-- local current_attack_damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())

		-- self.diff_attack_damage = current_attack_damage-base_attack_damage
end

function modifier_naturalise_mres:GetModifierMagicalResistanceBonus()
	local reduction = self:GetStackCount()
	return -reduction
end

function modifier_naturalise_mres:IsHidden()
	return true
end