modifier_haste_aura_effect_act = class({})

function modifier_haste_aura_effect_act:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return func
end

function modifier_haste_aura_effect_act:OnAbilityExecuted( params )
	local reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")/100 --[[Returns:table
	No Description Set
	]]
	--local chance = self:GetAbility():GetSpecialValueFor("chance")

	reduction = reduction * 2

	if params.unit ~= self:GetParent() then return end

	local ab = params.ability

	local mult = 1 - reduction
	Timers:CreateTimer(0.06, function()
		local cd = ab:GetCooldownTimeRemaining()
		ab:EndCooldown()
		ab:StartCooldown(cd*mult)
		-- print(cd*mult.." orig cooldown: "..cd)
	end)

	ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/haste_aura_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
	Creates a new particle effect
	]]

	self:GetParent():EmitSound("Timekeeper.HasteAura")

	self:Destroy()

end

function modifier_haste_aura_effect_act:IsHidden()
	return false
end

function modifier_haste_aura_effect_act:GetEffectName()
	return "particles/units/heroes/hero_timekeeper/haste_aura_act_proc.vpcf"
end