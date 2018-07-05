mifune_bushido = class({})

LinkLuaModifier("modifier_bushido","lua/abilities/mifune_bushido",LUA_MODIFIER_MOTION_NONE)

function mifune_bushido:OnSpellStart()
	local caster = self:GetCaster()
	local mod = "modifier_bushido"
	local duration = self:GetSpecialValueFor("duration")

	-- Sound

	caster:AddNewModifier(caster, self, mod, {Duration=duration})
end

modifier_bushido = class({})

function modifier_bushido:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT
		-- MODIFIER_EVENT_ON_ATTACKED
	}

	return funcs
end

function modifier_bushido:GetEffectName()
	return "particles/units/heroes/hero_mifune/bushido_unit.vpcf"
end

function modifier_bushido:GetModifierMoveSpeedBonus_Percentage()
	local t_bonus = self:GetParent():FetchTalent("special_bonus_mifune_2") or 0
	return t_bonus
end

function modifier_bushido:GetModifierEvasion_Constant()
	if self:GetParent():HasScepter() then
		return self:GetAbility():GetSpecialValueFor("scepter_evasion")
	end
end

if IsServer() then

	function modifier_bushido:OnCreated()
		local agi = self:GetParent():GetAgility()
		local pct = self:GetAbility():GetSpecialValueFor("percent")/100

		self:SetStackCount(math.floor(agi*pct))
	end

	function modifier_bushido:OnAttackFail(params)
		local p = self:GetParent()
		local a = params.attacker
		local t = params.target

		if t ~= p then return end
		if not p:HasScepter() then return end

		a:EmitSound("Hero_Juggernaut.OmniSlash")
		-- Particle

		p:PerformAttack(
			a,
			true,
			true,
			true,
			false,
			false,
			false,
			true
		)
	end

end

function modifier_bushido:GetModifierBonusStats_Agility()
	if self:GetStackCount() > 0 then
		return self:GetStackCount()
	end
end

-- function modifier_bushido:GetModifierBaseAttackTimeConstant()
-- 	return self:GetAbility():GetSpecialValueFor("base_attack_time")
-- end

function modifier_bushido:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end