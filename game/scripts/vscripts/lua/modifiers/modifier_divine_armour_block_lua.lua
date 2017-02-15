modifier_divine_armour_block_lua = class({})

function modifier_divine_armour_block_lua:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return func
end

function modifier_divine_armour_block_lua:GetModifierIncomingDamage_Percentage()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_divine_armour_block_lua:OnCreated()
	ParticleManager:CreateParticle("particles/units/heroes/hero_paragon/divine_armour.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent()) --[[Returns:int
	Creates a new particle effect
	]]
end

function modifier_divine_armour_block_lua:OnRefresh()
	ParticleManager:CreateParticle("particles/units/heroes/hero_paragon/divine_armour.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent()) --[[Returns:int
	Creates a new particle effect
	]]
end

function modifier_divine_armour_block_lua:IsHidden()
	return false
end

function modifier_divine_armour_block_lua:GetEffectName()
	if self:GetParent():PassivesDisabled() then return end
	return "particles/units/heroes/hero_paragon/divine_armour_block.vpcf"
end