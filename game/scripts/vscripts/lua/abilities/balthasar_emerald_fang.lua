balthasar_emerald_fang = class({})

LinkLuaModifier("modifier_emerald_fang_passive","lua/abilities/balthasar_emerald_fang",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_emerald_fang","lua/abilities/balthasar_emerald_fang",LUA_MODIFIER_MOTION_NONE)

function balthasar_emerald_fang:GetIntrinsicModifierName()
	return "modifier_emerald_fang_passive"
end

modifier_emerald_fang_passive = class({})

function modifier_emerald_fang_passive:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_emerald_fang_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then

			local duration = self:GetAbility():GetSpecialValueFor("duration")
			local t_duration_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_balthasar_1") or 0

			if params.target:IsBuilding() then return end

			params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_emerald_fang", {Duration=duration})
		end
	end
end

function modifier_emerald_fang_passive:IsHidden()
	return true
end

modifier_emerald_fang = class({})

function modifier_emerald_fang:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.5)
		-- Sound
	end
end

function modifier_emerald_fang:OnIntervalThink()
	local caster = self:GetAbility():GetCaster()
	local attack_damage = caster:GetAverageTrueAttackDamage(caster)
	local pct = self:GetAbility():GetSpecialValueFor("damage_over_time") / 100
	local damage = attack_damage * pct * 0.5
	local damage_type = self:GetAbility():GetAbilityDamageType()

	self:GetAbility():InflictDamage(self:GetParent(), caster, damage, DAMAGE_TYPE_MAGICAL)
end

function modifier_emerald_fang:GetEffectName()
	return "particles/units/heroes/hero_balthasar/emerald_fire.vpcf"
end