timekeeper_haste_aura = class({})

LinkLuaModifier("modifier_haste_aura","lua/abilities/timekeeper_haste_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste_aura_effect","lua/abilities/timekeeper_haste_aura",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_haste_aura_effect_act","lua/abilities/timekeeper_haste_aura",LUA_MODIFIER_MOTION_NONE)

function timekeeper_haste_aura:GetIntrinsicModifierName()
	return "modifier_haste_aura"
end

function timekeeper_haste_aura:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_haste_aura_effect_act", {Duration=self:GetSpecialValueFor("act_duration")}) --[[Returns:void
	No Description Set
	]]

	target:EmitSound("Timekeeper.HasteAura.Act")

end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_haste_aura = class({})

function modifier_haste_aura:DeclareFunctions()
	local func = {
		
	}
	return func
end

function modifier_haste_aura:IsAura()
	if IsServer() then
		if not self:GetAbility():IsCooldownReady() then return false end
	end
	return true
end

function modifier_haste_aura:GetModifierAura()
	return "modifier_haste_aura_effect"
end

function modifier_haste_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_haste_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_haste_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_haste_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_haste_aura:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	if not self:GetAbility():IsCooldownReady() then return end
	local reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")/100 --[[Returns:table
	No Description Set
	]]
	local chance = self:GetAbility():GetSpecialValueFor("chance")

	-- print(params.unit:GetName())

	-- print(self:GetParent():GetName())

	if params.unit ~= self:GetParent() then return end
	if params.unit:HasModifier("modifier_haste_aura_effect_act") then return end
	if params.ability:GetName() == "timekeeper_haste_aura" then return end

	local ab = params.ability

	-- print(ab:GetName())

	local r = RandomInt(1, 100)

	-- print(r)

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

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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