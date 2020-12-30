pride_merciless = class({})

LinkLuaModifier("modifier_merciless","lua/abilities/pride_merciless",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_merciless_target","lua/abilities/pride_merciless",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_merciless_marker","lua/abilities/pride_merciless",LUA_MODIFIER_MOTION_NONE)

function pride_merciless:GetIntrinsicModifierName()
	return "modifier_merciless"
end

function pride_merciless:OnSpellStart()
	local damage = self:GetSpecialValueFor("damage")
	local debuff = "modifier_merciless_target"
	local dur = self:GetSpecialValueFor("debuff_duration")

	local effect_particle = "particles/units/heroes/hero_pride/merciless.vpcf"
	local effect_particle_arrival = "particles/units/heroes/hero_pride/merciless_arrival.vpcf"

	local enemies = FindEnemies(self:GetCaster(),self:GetCaster():GetAbsOrigin(),30000)

	local target

	for k,v in pairs(enemies) do
		if (v:HasModifier("modifier_merciless_marker")) then
			target = v
		end
	end

	if target then
		self:InflictDamage( target, self:GetCaster(), damage, self:GetAbilityDamageType() )
		target:AddNewModifier( self:GetCaster(),
			self, debuff, {Duration=dur})

		local p = ParticleManager:CreateParticle(effect_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

		ParticleManager:SetParticleControl(p, 1, target:GetCenter())


		Timers:CreateTimer(0.05,
		function()
			local loc = target:GetAbsOrigin() + RandomVector(125)
			FindClearSpaceForUnit(self:GetCaster(), loc, true)
			self:GetCaster():SetAttacking(target)
			self:GetCaster():PerformAttack(target, true, true, true, true, true, false, true)
			--[[Returns:void
			Performs an attack on a target.
			Params: Target, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis
			]]
			self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_phased", {Duration=1, IsHidden=true})
		end)

		Timers:CreateTimer(0.1,
		function()
			ParticleManager:CreateParticle(effect_particle_arrival, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:CreateParticle(effect_particle_arrival, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		end)
	end
end

modifier_merciless = class({})

function modifier_merciless:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_merciless:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target or params.unit

	local duration = self:GetAbility():GetSpecialValueFor("duration")

	if (attacker == self:GetParent()) then
		local enemies = FindEnemies(self:GetCaster(),self:GetCaster():GetAbsOrigin(),30000)

		for k,v in pairs(enemies) do
			if (v:HasModifier("modifier_merciless_marker")) then
				v:RemoveModifierByName("modifier_merciless_marker")
			end
		end

		target:AddNewModifier(attacker, self:GetAbility(), "modifier_merciless_marker", {Duration=duration})
	end
end

modifier_merciless_target = class({})

function modifier_merciless_target:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_merciless_target:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_merciless_target:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("attack_slow")
end

modifier_merciless_marker = class({})

function modifier_merciless_marker:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_merciless_marker:GetEffectName()
	return "particles/units/heroes/hero_pride/merciless_marker.vpcf"
end