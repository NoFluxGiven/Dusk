baal_superposition2 = class({})

LinkLuaModifier("modifier_superposition","lua/abilities/baal_superposition2",LUA_MODIFIER_MOTION_NONE)

function baal_superposition2:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	local bonus = 0
	if caster:GetHasTalent("special_bonus_baal_superposition") then
		bonus = 4
	end

	duration = duration + bonus

	caster:AddNewModifier(caster, self, "modifier_superposition", {Duration = duration}) --[[Returns:void
	No Description Set
	]]

	self:ParticleEffect()
end

function baal_superposition2:ParticleEffect()
	if IsServer() then
		local caster = self:GetCaster()
		local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),1,0)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_otherworld_start_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControlEnt(p,0,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetCenter(),true)
	end
end

modifier_superposition = class({})

function modifier_superposition:OnCreated()
	if IsServer() then
		local caster = self:GetParent()
		local player = caster:GetPlayerID()
		player = PlayerResource:GetPlayer(player) --[[Returns:handle
		No Description Set
		]]

		caster.otherworld_particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_baal/baal_otherworld_screen_effect.vpcf", PATTACH_ABSORIGIN, caster, player) --[[Returns:int
		Creates a new particle effect that only plays for the specified player
		]]
	end
end

function modifier_superposition:OnDestroy()
	local caster = self:GetAbility():GetCaster()

	self:GetAbility():ParticleEffect()
	ParticleManager:DestroyParticle(caster.otherworld_particle,false)
end

function modifier_superposition:CheckState()
	local states = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
	if self:GetAbility():GetCaster():IsStunned() then
		states[MODIFIER_STATE_INVISIBLE] = false
		states[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false
	end
	return states
end

function modifier_superposition:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_superposition:GetEffectName()
	return "particles/units/heroes/hero_baal/baal_superposition2.vpcf"
end

function modifier_superposition:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_superposition:StatusEffectPriority()
	return 10
end

function modifier_superposition:GetModifierPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_superposition:GetAbsoluteNoDamagePhysical()
	return true
end

function modifier_superposition:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end