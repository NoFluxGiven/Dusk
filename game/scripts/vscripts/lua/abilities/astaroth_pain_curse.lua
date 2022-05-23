astaroth_pain_curse = class({})

LinkLuaModifier("modifier_astaroth_pain_curse","lua/abilities/astaroth_pain_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astaroth_pain_curse_debuff","lua/abilities/astaroth_pain_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astaroth_pain_curse_grace","lua/abilities/astaroth_pain_curse",LUA_MODIFIER_MOTION_NONE)

function astaroth_pain_curse:OnSpellStart()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	if target:TriggerSpellAbsorb(self) then return end
	target:TriggerSpellReflect(self)

	target:AddNewModifier(self:GetCaster(), self, "modifier_astaroth_pain_curse", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_astaroth_pain_curse = class({})

function modifier_astaroth_pain_curse:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_astaroth_pain_curse:GetEffectName()
	return "particles/units/heroes/hero_astaroth/astaroth_pain_transferral.vpcf"
end

function modifier_astaroth_pain_curse:OnTakeDamage(params)
	if IsServer() then
		if params.unit ~= self:GetParent() then return end
		if params.damage < 1 then return end
		local duration = self:GetAbility():GetSpecialValueFor("slow_duration")
		local cooldown = self:GetAbility():GetSpecialValueFor("cooldown")

		local t_damage_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_astaroth_1") or 0

		local damage = self:GetAbility():GetSpecialValueFor("damage") + t_damage_bonus

		if not self:GetParent():HasModifier("modifier_astaroth_pain_curse_grace") then
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_astaroth_pain_curse_debuff", {Duration=duration}) --[[Returns:void
			No Description Set
			]]
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_astaroth_pain_curse_grace", {Duration=cooldown}) --[[Returns:void
			No Description Set
			]]
			DealDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

			ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_pain_transferral_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
			Creates a new particle effect
			]]
		end
	end
end

modifier_astaroth_pain_curse_debuff = class({})

function modifier_astaroth_pain_curse_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_astaroth_pain_curse_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

modifier_astaroth_pain_curse_grace = class({})

function modifier_astaroth_pain_curse_grace:IsHidden()
	return true
end