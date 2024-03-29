gemini_extraplanar_pact = class({})

LinkLuaModifier("modifier_extraplanar_pact_oog","lua/abilities/gemini_extraplanar_pact",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extraplanar_pact","lua/abilities/gemini_extraplanar_pact",LUA_MODIFIER_MOTION_NONE)

function gemini_extraplanar_pact:OnSpellStart()
	local mod = "modifier_extraplanar_pact_oog"
	local mod2 = "modifier_extraplanar_pact"

	local oog_dur = self:GetSpecialValueFor("out_of_game_duration")
	local dur = self:GetSpecialValueFor("duration")

	local part = "particles/units/heroes/hero_gemini/gemini_extraplanar_pact_oog.vpcf"

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local health_restore = self:GetSpecialValueFor("health_regen")
	local mana_restore = self:GetSpecialValueFor("mana_regen")

	local t_regen_bonus = self:GetCaster():FindTalentValue("special_bonus_gemini_2") or 0

	local hp = target:GetMaxHealth()
	local mp = target:GetMaxMana()

	local hp_amt = health_restore + t_regen_bonus --* hp
	local mp_amt = mana_restore + t_regen_bonus --* mp

	target:AddNewModifier(caster, self, mod, {Duration = oog_dur}) --[[Returns:void
	No Description Set
	]]

	target:EmitSound("Voidwalker.ExtraplanarEmpowerment")

	Timers:CreateTimer(0.25,function()

		target:AddNoDraw()

		target:AddNewModifier(caster, self, mod2, {Duration = dur}) --[[Returns:void
		No Description Set
		]]

		target:Heal(hp_amt,caster)
		target:GiveMana(mp_amt)

	end)

	local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),oog_dur+1,175)

	local p = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	Timers:CreateTimer(oog_dur,function()
		ParticleManager:DestroyParticle(p,false)
		target:RemoveNoDraw()
	end)
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_extraplanar_pact = class({})

function modifier_extraplanar_pact:DeclareFunctions()
	local func = {
		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
		-- MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK
	}
	return func
end
	
-- function modifier_extraplanar_pact:GetModifierConstantHealthRegen()
-- 	local t_regen_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_gemini_2") or 0
-- 	return self:GetAbility():GetSpecialValueFor("health_regen") + t_regen_bonus
-- end

-- function modifier_extraplanar_pact:GetModifierConstantManaRegen()
-- 	local t_regen_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_gemini_2") or 0
-- 	return self:GetAbility():GetSpecialValueFor("mana_regen") + t_regen_bonus
-- end

-- function modifier_extraplanar_pact:GetModifierMagical_ConstantBlock()
	-- return self:GetAbility():GetSpecialValueFor("magic_block")
-- end

function modifier_extraplanar_pact:GetEffectName()
	local part = "particles/units/heroes/hero_gemini/gemini_extraplanar_pact_unit.vpcf"

	return part
end

function modifier_extraplanar_pact:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_extraplanar_pact_oog = class({})

function modifier_extraplanar_pact_oog:DeclareFunctions()
	local func = {

	}
	
	return func
end

function modifier_extraplanar_pact_oog:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}

	return state
end