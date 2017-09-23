bloodwarrior_blood_madness = class({})

LinkLuaModifier("modifier_blood_madness","lua/abilities/bloodwarrior_blood_madness",LUA_MODIFIER_MOTION_NONE)

function bloodwarrior_blood_madness:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")

		local pct = self:GetSpecialValueFor("health_removal")/100
		local hp = caster:GetMaxHealth()
		local damage = hp * pct
		local chp = caster:GetHealth()

		caster:ModifyHealth(chp-damage, self, false, 0)
		caster:AddNewModifier(caster, self, "modifier_blood_madness", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		caster:EmitSound("Bloodwarrior.BloodMadness")
	end
end

modifier_blood_madness = class({})

function modifier_blood_madness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_blood_madness:GetModifierPreAttack_BonusDamage()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	local t_damage = self:GetAbility():GetCaster():FetchTalent("special_bonus_bloodwarrior_4") or 0
	return bonus + t_damage
end

function modifier_blood_madness:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	return bonus
end

function modifier_blood_madness:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	return bonus
end

function modifier_blood_madness:OnTooltip()
	local lifesteal = self:GetAbility():GetSpecialValueFor("bonus_lifesteal")/100
	local extra = self:GetAbility():GetSpecialValueFor("lifesteal_increase")/100

	extra = extra * self:GetStackCount()
	lifesteal = lifesteal+extra

	return lifesteal
end

function modifier_blood_madness:GetEffectName()
	return "particles/units/heroes/hero_bloodwarrior/blood_madness.vpcf"
end

if IsServer() then

	function modifier_blood_madness:OnCreated()
		self:SetStackCount(1)
	end

	function modifier_blood_madness:OnAttackLanded(params)
		local attacker = params.attacker
		local target = params.target

		local damage = params.damage

		if attacker ~= self:GetParent() then return end

		if target:IsBuilding() then return end

		local lifesteal = self:GetAbility():GetSpecialValueFor("bonus_lifesteal")/100

		local extra = self:GetAbility():GetSpecialValueFor("lifesteal_increase")/100

		extra = extra * self:GetStackCount()

		lifesteal = lifesteal+extra

		local amt = damage*lifesteal

		attacker:Heal(amt, attacker)

		GenericParticle(attacker,"LIFESTEAL")
	end

	function modifier_blood_madness:OnDeath(params)
		local attacker = params.attacker
		local unit = params.unit

		if attacker == self:GetParent() and unit:IsRealHero() then

			local d = self:GetRemainingTime()
			local db = self:GetAbility():GetSpecialValueFor("bonus_duration")
			self:SetDuration(d+db,true)

			self:IncrementStackCount()

		end
	end

end