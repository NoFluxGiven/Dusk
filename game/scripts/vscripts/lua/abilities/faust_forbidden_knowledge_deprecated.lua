faust_forbidden_knowledge_deprecated = class({})

LinkLuaModifier("modifier_forbidden_knowledge_deprecated","lua/abilities/faust_forbidden_knowledge_deprecated",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forbidden_knowledge_deprecated_buff","lua/abilities/faust_forbidden_knowledge_deprecated",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forbidden_knowledge_deprecated_debuff","lua/abilities/faust_forbidden_knowledge_deprecated",LUA_MODIFIER_MOTION_NONE)

function faust_forbidden_knowledge_deprecated:OnUpgrade()
	local caster = self:GetCaster()
	local ab1 = caster:FindAbilityByName("faust_planecracker")
	--local ab2 = caster:FindAbilityByName("faust_photonic_barrier")

	ab1:SetLevel(self:GetLevel())
	--ab2:SetLevel(self:GetLevel())
end

function faust_forbidden_knowledge_deprecated:GetIntrinsicModifierName()
	return "modifier_forbidden_knowledge_deprecated"
end

modifier_forbidden_knowledge_deprecated = class({})

function modifier_forbidden_knowledge_deprecated:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
	return func
end

function modifier_forbidden_knowledge_deprecated:GetModifierProcAttack_BonusDamage_Magical(params)
	PrintTable(params)
	if params.target:IsBuilding() then return end
	ParticleManager:CreateParticle("particles/units/heroes/hero_faust/forbidden_knowledge_deprecated_on_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target) --[[Returns:int
	Creates a new particle effect
	]]
	local dmg = self:GetAbility():GetSpecialValueFor("bonus_damage")
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	local attack_dmg = 0--params.original_damage

	dmg = dmg + attack_dmg

	if params.target:IsHero() then

		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_forbidden_knowledge_deprecated_debuff", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_forbidden_knowledge_deprecated_buff", {Duration=duration})

	end

	-- local mana_drain = dmg*0.50
	-- local target_mana = params.target:GetMana()
	-- if target_mana < mana_drain then
	-- 	mana_drain = target_mana
	-- end
	-- params.target:ReduceMana(mana_drain)
	-- params.attacker:GiveMana(mana_drain)
	return dmg
end

modifier_forbidden_knowledge_deprecated_debuff = class({})

function modifier_forbidden_knowledge_deprecated_debuff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_forbidden_knowledge_deprecated_debuff:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("magic_res_reduction")
end

function modifier_forbidden_knowledge_deprecated_debuff:GetModifierSpellAmplify_Percentage()
	return -self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_forbidden_knowledge_deprecated_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_forbidden_knowledge_deprecated_debuff:GetEffectName()
	return "particles/units/heroes/hero_faust/forbidden_knowledge_deprecated_on_attack_debuff.vpcf"
end

modifier_forbidden_knowledge_deprecated_buff = class({})

function modifier_forbidden_knowledge_deprecated_buff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_forbidden_knowledge_deprecated_buff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("magic_res_reduction")
end

function modifier_forbidden_knowledge_deprecated_buff:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_forbidden_knowledge_deprecated_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_forbidden_knowledge_deprecated_buff:GetEffectName()
	return "particles/units/heroes/hero_faust/forbidden_knowledge_deprecated_on_attack_buff.vpcf"
end