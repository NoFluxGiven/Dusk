timekeeper_dilation = class({})

LinkLuaModifier("modifier_dilation","lua/abilities/timekeeper_dilation",LUA_MODIFIER_MOTION_NONE)

function timekeeper_dilation:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_timekeeper_1") or 0
	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus

	target:AddNewModifier(caster, self, "modifier_dilation", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_dilation = class({})

function modifier_dilation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
	return funcs
end

function modifier_dilation:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_dilation:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_dilation:GetModifierTurnRate_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_dilation:GetEffectName()
	return "particles/units/heroes/hero_timekeeper/timekeeper_dilation.vpcf"
end

if IsServer() then

	function modifier_dilation:OnCreated()
		local target = self:GetParent()

		target:EmitSound("Timekeeper.Dilation")

		self:StartIntervalThink(0.03)
	end

	function modifier_dilation:OnIntervalThink()
		local target = self:GetParent()
		for i=0,target:GetAbilityCount()-1 do
			local ab = target:GetAbilityByIndex(i) --[[Returns:handle
			Retrieve an ability by index from the unit.
			]]
			if ab ~= nil then
				if ab:GetLevel() > 0 then
					if not ab:IsCooldownReady() then
						local tr = ab:GetCooldownTimeRemaining()
						ab:EndCooldown()
						ab:StartCooldown(tr+0.06)
					end
				end
			end
		end
	end

end