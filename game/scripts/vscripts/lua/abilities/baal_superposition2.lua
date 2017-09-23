baal_superposition2 = class({})

LinkLuaModifier("modifier_superposition","lua/abilities/baal_superposition2",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_superposition_reveal","lua/abilities/baal_superposition2",LUA_MODIFIER_MOTION_NONE)

function baal_superposition2:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	duration = duration

	caster:AddNewModifier(caster, self, "modifier_superposition", {Duration = duration}) --[[Returns:void
	No Description Set
	]]

	caster:EmitSound("Baal.Otherworld.Enter")
	caster:EmitSound("Baal.Otherworld")

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

		caster:EmitSound("Baal.Otherworld.Enter")
		caster:EmitSound("Baal.Otherworld")

		caster.otherworld_particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_baal/baal_otherworld_screen_effect.vpcf", PATTACH_ABSORIGIN, caster, player) --[[Returns:int
		Creates a new particle effect that only plays for the specified player
		]]
	end
end

function modifier_superposition:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()

		self:GetAbility():ParticleEffect()
		if caster.otherworld_particle then 
			ParticleManager:DestroyParticle(caster.otherworld_particle,false)
		end

		caster:EmitSound("Baal.Otherworld.Exit")
		caster:StopSound("Baal.Otherworld")
	end
end

function modifier_superposition:CheckState()
	local states = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false
	}

	local t_free_pathing = self:GetAbility():GetCaster():FetchTalent("special_bonus_baal_6")

	if self:GetAbility():GetCaster():IsStunned() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_superposition_reveal", {Duration=1}) --[[Returns:void
		No Description Set
		]]
	end
	if self:GetParent():HasModifier("modifier_superposition_reveal") then
		states[MODIFIER_STATE_INVISIBLE] = false
		states[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false
	end
	if t_free_pathing then
		states[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
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
	local t_movespeed_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_baal_4") or 0
	return self:GetAbility():GetSpecialValueFor("bonus_ms") + t_movespeed_bonus
end

modifier_superposition_reveal = class({})

function modifier_superposition_reveal:IsHidden()
	return true
end