item_ironblood_potion = class({})

LinkLuaModifier("modifier_ironblood_potion", "item_ironblood_potion", LUA_MODIFIER_MOTION_NONE)

function item_ironblood_potion:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("buff_duration")

	caster:AddNewModifier(caster, self, "modifier_ironblood_potion", {Duration=duration})
end

modifier_ironblood_potion = class({})

function modifier_ironblood_potion:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return func
end

function modifier_ironblood_potion:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")
end

function modifier_ironblood_potion:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_ironblood_potion:GetEffectName()
	return "particles/items/ironblood_potion.vpcf"
end