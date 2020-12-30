pride_elyats_bellow = class({})

LinkLuaModifier("modifier_elyats_bellow","lua/abilities/pride_elyats_bellow",LUA_MODIFIER_MOTION_NONE)

function pride_elyats_bellow:OnSpellStart()
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local debuff = "modifier_elyats_bellow"
	local dur = self:GetSpecialValueFor("debuff_duration")
	local point = self:GetCursorPosition()

	local effect_particle = "particles/units/heroes/hero_pride/elyats_bellow.vpcf"

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
	end
end

modifier_elyats_bellow = class({})

function modifier_elyats_bellow:CheckState()
	local states = {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}

	return states
end

function modifier_elyats_bellow:GetEffectName()
	return "particles/units/heroes/hero_pride/elyats_bellow_unit.vpcf"
end