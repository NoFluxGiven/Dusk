vassal_repair_module = class({})

LinkLuaModifier("modifier_repair_regen","lua/abilities/repair_module",LUA_MODIFIER_MOTION_NONE)

function vassal_repair_module:GetIntrinsicModifierName()
	return "modifier_repair_regen"
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_repair_regen = class({})

function modifier_repair_regen:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_ATTACK
	}
	return func
end

function modifier_repair_regen:GetModifierConstantHealthRegen()
	if self:GetAbility():IsCooldownReady() then
		return self:GetAbility():GetSpecialValueFor("health_recovery")
	end
end

function modifier_repair_regen:OnAttacked( params )
		if self:GetParent() == params.target then
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end
end

function modifier_repair_regen:OnAttack( params )
	-- PrintTable(params)
		if self:GetParent() == params.attacker then
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end
end

function modifier_repair_regen:GetEffectName()
	if self:GetParent():GetHealthPercent() ~= 100 then
		return "particles/units/heroes/hero_summoner/vassal_regen_module.vpcf"
	end
end

function modifier_repair_regen:IsHidden()
	if self:GetAbility():IsCooldownReady() then
		return false
	end

	return true
end