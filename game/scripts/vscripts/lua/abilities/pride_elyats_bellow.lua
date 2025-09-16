pride_elyats_bellow = class({})

LinkLuaModifier("modifier_elyats_bellow_silence","lua/abilities/pride_elyats_bellow",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elyats_bellow_mute","lua/abilities/pride_elyats_bellow",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elyats_bellow_disarm","lua/abilities/pride_elyats_bellow",LUA_MODIFIER_MOTION_NONE)

function pride_elyats_bellow:OnSpellStart()
	local point = self:GetCursorPosition()
	
	local effect_particle = "particles/units/heroes/hero_pride/elyats_bellow.vpcf"
	
	local initial_delay = self:GetSpecialValueFor("initial_delay")
	local delay = self:GetSpecialValueFor("delay")
	
	local debuff = "modifier_elyats_bellow_silence"

	Timers:CreateTimer( initial_delay, function()
		self:Bellow( point, "modifier_elyats_bellow_silence", effect_particle )
	end )

	debuff = "modifier_elyats_bellow_mute"

	Timers:CreateTimer( delay+initial_delay, function()
		self:Bellow( point, "modifier_elyats_bellow_mute", effect_particle )
	end )

	debuff = "modifier_elyats_bellow_disarm"

	Timers:CreateTimer( delay+delay+initial_delay, function()
		self:Bellow( point, "modifier_elyats_bellow_disarm", effect_particle )
	end )
end

function pride_elyats_bellow:Bellow( point, debuff, effect_particle )
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local dur = self:GetSpecialValueFor("debuff_duration")

	local p = ParticleManager:CreateParticle(effect_particle, PATTACH_WORLDORIGIN, nil)

	ParticleManager:SetParticleControl(p, 0, point)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	local en = FindEnemies(self:GetCaster(), point, radius)

	for k,v in pairs(en) do
		self:InflictDamage(v, self:GetCaster(), damage, self:GetAbilityDamageType())
		v:AddNewModifier(self:GetCaster(),
						 self,
						 debuff,
						 {duration=dur})
		self:RefreshModifiers(v)
	end
end

function pride_elyats_bellow:RefreshModifiers( target )
	modifiers = {
		"modifier_elyats_bellow_silence",
		"modifier_elyats_bellow_mute",
		"modifier_elyats_bellow_disarm"
	}

	for _,m in pairs(modifiers) do
		if target:HasModifier(m) then
			target:FindModifierByName(m):ForceRefresh()
		end
	end
end

modifier_elyats_bellow_silence = class({})

function modifier_elyats_bellow_silence:CheckState()
	local states = {
		[MODIFIER_STATE_SILENCED] = true
	}

	return states
end

function modifier_elyats_bellow_silence:GetEffectName()
	return "particles/units/heroes/hero_pride/elyats_bellow_unit.vpcf"
end

modifier_elyats_bellow_mute = class({})

function modifier_elyats_bellow_mute:CheckState()
	local states = {
		[MODIFIER_STATE_MUTED] = true
	}

	return states
end

function modifier_elyats_bellow_mute:GetEffectName()
	return "particles/units/heroes/hero_pride/elyats_bellow_unit.vpcf"
end

modifier_elyats_bellow_disarm = class({})

function modifier_elyats_bellow_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true
	}

	return states
end

function modifier_elyats_bellow_disarm:GetEffectName()
	return "particles/units/heroes/hero_pride/elyats_bellow_unit.vpcf"
end