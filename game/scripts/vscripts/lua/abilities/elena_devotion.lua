elena_devotion = class({})

LinkLuaModifier("modifier_devotion","lua/abilities/elena_devotion",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_devotion_effect","lua/abilities/elena_devotion",LUA_MODIFIER_MOTION_NONE)

function elena_devotion:GetIntrinsicModifierName()
	return "modifier_devotion"
end

modifier_devotion = class({})

function modifier_devotion:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_devotion:OnAbilityFullyCast(params)
	local unit = params.unit
	local par = self:GetParent()
	local ability = params.ability

	if ability:IsItem() then return end

	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	if unit ~= par then return end

	local f = FindAllies(unit,unit:GetAbsOrigin(),radius)

	for k,v in pairs(f) do
		v:AddNewModifier(unit, self:GetAbility(), "modifier_devotion_effect", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
	end
end

function modifier_devotion:IsHidden()
	return true
end

modifier_devotion_effect = class({})

function modifier_devotion_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_devotion_effect:GetEffectName()
	return "particles/units/heroes/hero_elena/devotion_aura.vpcf"
end

function modifier_devotion_effect:GetModifierConstantHealthRegen()
	local regen = self:GetAbility():GetSpecialValueFor("hp_regen")
	local stack = self:GetStackCount()

	return regen * stack
end

function modifier_devotion_effect:GetModifierPhysicalArmorBonus()
	local bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_elena_1") or 0
	local stack = self:GetStackCount()

	return bonus * stack
end

function modifier_devotion_effect:GetModifierMagicalResistanceBonus()
	local bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_elena_2") or 0
	local stack = self:GetStackCount()

	return bonus * stack
end

if IsServer() then

	function modifier_devotion_effect:OnCreated()
		self:SetStackCount(1)
	end

	function modifier_devotion_effect:OnRefresh()
		self:IncrementStackCount()
	end

end