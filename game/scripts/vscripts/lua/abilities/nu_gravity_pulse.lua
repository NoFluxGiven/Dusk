nu_gravity_pulse = class({})

LinkLuaModifier("modifier_gravity_pulse","lua/abilities/nu_gravity_pulse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gravity_pulse_thinker","lua/abilities/nu_gravity_pulse",LUA_MODIFIER_MOTION_NONE)

function nu_gravity_pulse:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Warlock.FatalBondsPrecast")
	return true
end

function nu_gravity_pulse:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_nu_3") or 0
	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus

	local slow_duration = self:GetSpecialValueFor("slow_duration")

	ScreenShake(target, 25, 7, 1, 1500, 0, true)

	local fx = CreateModifierThinker( caster, self, "modifier_gravity_pulse_thinker", {radius=radius,damage=damage,slow_duration=slow_duration}, target, caster:GetTeamNumber(), false )
end

modifier_gravity_pulse_thinker = class({})

function modifier_gravity_pulse_thinker:OnCreated(kv)
	if IsServer() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/gravity_pulse.vpcf", PATTACH_WORLDORIGIN, nil)
	   	ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
	   	ParticleManager:SetParticleControl(p, 1, Vector(kv.radius,0,0))

	   	self:GetParent():EmitSound("Nu.GravityPulse")

	   	local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),kv.radius)

	   	for k,v in pairs(enemies) do
	   		self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),kv.damage,DAMAGE_TYPE_PHYSICAL)
	   		v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_gravity_pulse", {Duration=kv.slow_duration})
	   	end
	end
end

modifier_gravity_pulse = class({})

function modifier_gravity_pulse:GetEffectName()
	return "particles/units/heroes/hero_nu/gravity_pulse_unit.vpcf"
end

function modifier_gravity_pulse:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_gravity_pulse:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_gravity_pulse:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("slow")
end