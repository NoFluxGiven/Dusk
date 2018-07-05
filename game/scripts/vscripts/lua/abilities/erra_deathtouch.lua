erra_deathtouch = class({})

LinkLuaModifier("modifier_deathtouch_dot","lua/abilities/erra_deathtouch",LUA_MODIFIER_MOTION_NONE)

function erra_deathtouch:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Erra.DeathtouchPrecast")
	return true
end

function erra_deathtouch:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local damage = self:GetAbilityDamage()
	local dtype = self:GetAbilityDamageType()
	local duration = self:GetSpecialValueFor("dot_duration")

	caster:EmitSound("Erra.Deathtouch")

	--caster:FadeGesture("ACT_DOTA_CAST_ABILITY_4")

	target:AddNewModifier(caster, self, "modifier_deathtouch_dot", {Duration=duration}) --[[Returns:void
	No Description Set
	]]

	ParticleManager:CreateParticle("particles/units/heroes/hero_erra/deathtouch.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
end

modifier_deathtouch_dot = class({})

function modifier_deathtouch_dot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_deathtouch_dot:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_deathtouch_dot:OnIntervalThink()
	if IsServer() then
		local dot = self:GetAbility():GetSpecialValueFor("dot_amount") * 0.25
		local hp_miss = (100 - self:GetParent():GetHealthPercent())/100

		local mult = 1 + hp_miss

		dot = dot * mult

		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),dot,DAMAGE_TYPE_MAGICAL)
	end
end

function modifier_deathtouch_dot:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetCaster():FetchTalent("special_bonus_erra_4") or 0
	return -slow
end

function modifier_deathtouch_dot:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_deathtouch_dot:GetEffectName()
	return "particles/units/heroes/hero_erra/deathtouch_unit.vpcf"
end