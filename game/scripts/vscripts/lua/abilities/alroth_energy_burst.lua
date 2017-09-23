alroth_energy_burst = class({})

function alroth_energy_burst:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_alroth_2") or 0
	return base_cooldown - t_cooldown_reduction
end

function alroth_energy_burst:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		local damage = self:GetSpecialValueFor("damage") --[[Returns:table
		No Description Set
		]]
		local radius = self:GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]

		caster:EmitSound("Alroth.EnergyBurst")

		local p = CreateParticleHitloc(caster,"particles/units/heroes/hero_alroth/blast.vpcf")
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		local found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

		for k,v in pairs(found) do
			self:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end

		local self_damage = damage/2

		if caster:GetHealth() < self_damage then
			self_damage = caster:GetHealth() - 1
			if self_damage < 1 then
				self_damage = 1
			end
		end

		self:InflictDamage(caster,caster,self_damage,DAMAGE_TYPE_MAGICAL)
	end
end