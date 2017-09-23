lupin_finisher = class({})

LinkLuaModifier("modifier_finisher_slow","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)

function lupin_finisher:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local damage = self:GetSpecialValueFor("damage")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")

	local duration = self:GetSpecialValueFor("slow_duration")

	local t_duration_bonus = self:GetCaster():FetchTalent("special_bonus_lupin_3") or 0

	duration = duration + t_duration_bonus

	local particle = "particles/units/heroes/hero_lupin/lupin_finisher_normal.vpcf"
	local sound = "Lupin.Finisher"

	if target:IsStunned() then
		particle = "particles/units/heroes/hero_lupin/lupin_finisher_crit.vpcf"
		sound = "Lupin.Finisher.Crit"
		damage = damage+bonus_damage
	end

	CreateParticleHitloc(target,particle)
	target:EmitSound(sound)

	self:InflictDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
	target:AddNewModifier(caster, self, "modifier_finisher_slow", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_finisher_slow = class({})

function modifier_finisher_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_finisher_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_finisher_slow:IsPurgable()
	return true
end