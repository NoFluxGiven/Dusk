modifier_haste_aura_effect = class({})

function modifier_haste_aura_effect:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return func
end

function modifier_haste_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("speed_boost") --[[Returns:table
	No Description Set
	]]
	return bonus
end

function modifier_haste_aura_effect:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetSpecialValueFor("speed_boost") --[[Returns:table
	No Description Set
	]]
	return bonus
end

function modifier_haste_aura_effect:OnAbilityExecuted( params )
	local reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")/100 --[[Returns:table
	No Description Set
	]]
	local chance = self:GetAbility():GetSpecialValueFor("chance")

	print(params.unit:GetName())

	print(self:GetParent():GetName())

	if params.unit ~= self:GetParent() then return end

	local ab = params.ability

	print(ab:GetName())

	local r = RandomInt(1, 100)

	print(r)

	if r < chance then
		local mult = 1 - reduction
		Timers:CreateTimer(0.06, function()
			local cd = ab:GetCooldownTimeRemaining()
			ab:EndCooldown()
			ab:StartCooldown(cd*mult)
			print(cd*mult.." orig cooldown: "..cd)
		end)

		ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/haste_aura_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]

		self:GetParent():EmitSound("Timekeeper.HasteAura")
	end
end

function modifier_haste_aura_effect:IsHidden()
	return false
end