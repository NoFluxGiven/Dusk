bloodwarrior_red_curse = class({})

LinkLuaModifier("modifier_red_curse","lua/abilities/bloodwarrior_red_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_red_curse_caster","lua/abilities/bloodwarrior_red_curse",LUA_MODIFIER_MOTION_NONE)

function bloodwarrior_red_curse:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, self, "modifier_red_curse", {Duration=duration})
	caster:AddNewModifier(caster, self, "modifier_red_curse_caster", {Duration=duration})
end

modifier_red_curse_caster = class({})

function modifier_red_curse_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_red_curse_caster:GetModifierBonusStats_Strength()
	local time = self:GetElapsedTime()
	local targ = self:GetDuration()/2 -- it takes this amount of time to reach its maximum

	local amt = time / targ

	local t_strength_drain = self:GetAbility():GetCaster():FetchTalent("special_bonus_bloodwarrior_3") or 0

	local tbonus = self:GetAbility():GetSpecialValueFor("str_drain") + t_strength_drain

	local bonus = tbonus * amt

	if bonus > tbonus then bonus = tbonus end

	return bonus
end

if IsServer() then
	function modifier_red_curse_caster:OnCreated()
		self:StartIntervalThink(0.5)
	end

	function modifier_red_curse_caster:OnIntervalThink()
		self:GetParent():CalculateStatBonus()
	end
end

modifier_red_curse = class({})

function modifier_red_curse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_red_curse:GetModifierMoveSpeedBonus_Percentage()
	local time = self:GetElapsedTime()
	local targ = self:GetDuration()/2 -- it takes this amount of time to reach its maximum

	local amt = time / targ

	local tbonus = self:GetAbility():GetSpecialValueFor("slow")

	local bonus = tbonus * amt

	if bonus > tbonus then bonus = tbonus end

	return -bonus
end

function modifier_red_curse:GetModifierBonusStats_Strength()
	local time = self:GetElapsedTime()
	local targ = self:GetDuration()/2 -- it takes this amount of time to reach its maximum

	local amt = time / targ

	local t_strength_drain = self:GetAbility():GetCaster():FetchTalent("special_bonus_bloodwarrior_3") or 0

	local tbonus = self:GetAbility():GetSpecialValueFor("str_drain") + t_strength_drain

	local bonus = tbonus * amt

	if bonus > tbonus then bonus = tbonus end

	return -bonus
end

function modifier_red_curse:GetModifierDamageOutgoing_Percentage()
	local time = self:GetElapsedTime()
	local targ = self:GetDuration()/2 -- it takes this amount of time to reach its maximum

	local amt = time / targ

	local tbonus = self:GetAbility():GetSpecialValueFor("damage_reduction")

	local bonus = tbonus * amt

	if bonus > tbonus then bonus = tbonus end

	return -bonus
end

if IsServer() then

	function modifier_red_curse:OnDeath(params)
		local attacker = params.attacker
		local unit = params.unit

		local mod = self:GetAbility():GetCaster():FindModifierByName("modifier_red_curse_caster")

		if attacker ~= self:GetParent() then return end

		if mod then
			mod:Destroy()
		end
		self:Destroy()
	end

	function modifier_red_curse:OnCreated()
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/red_curse.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle( p, false, false, 10, false, false )

		self:StartIntervalThink(0.5)
		self:GetParent():EmitSound("Bloodwarrior.RedCurse")
	end

	function modifier_red_curse:OnIntervalThink()
		self:GetParent():CalculateStatBonus()
	end

end