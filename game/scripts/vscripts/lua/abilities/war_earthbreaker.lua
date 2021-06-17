war_earthbreaker = class({})

-- LinkLuaModifier("modifier_earthbreaker","lua/abilities/war_earthbreaker",LUA_MODIFIER_MOTION_NONE)

function war_earthbreaker:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_war_4") or 0
	return base_cooldown - t_cooldown_reduction
end

function war_earthbreaker:OnSpellStart()
	local caster = self:GetCaster()
	local offset = caster:GetForwardVector()*150
	local extra_offset = caster:GetForwardVector()*450
	local start = caster:GetAbsOrigin()

	local max_count = 3

	local damage = self:GetAbilityDamage()

	local t_radius_bonus = caster:FetchTalent("special_bonus_war_2") or 0

	local radius = self:GetSpecialValueFor("radius") + t_radius_bonus
	local stun = self:GetSpecialValueFor("stun")
	local initial = true

	self:Slam(caster, start, offset, extra_offset, damage, t_radius_bonus, radius, stun, initial, 0, max_count)
end

function war_earthbreaker:Slam(caster, start, offset, extra_offset, damage, t_radius_bonus, radius, stun, initial, count, max_count)
	-- local unit = FastDummy(start + offset + extra_offset * count,caster:GetTeam(),2,0)
	local unit = FastDummy(start + offset,caster:GetTeam(),2,0)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_war/earthbreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0))

	local dmg = damage

	if not initial then dmg = damage / 2 end

	unit:EmitSound("War.Earthbreaker")
	--unit:EmitSoundParams("War.Earthbreaker", 1, volume, 0)

	local enemy_found = FindEnemies(caster,unit:GetAbsOrigin(),radius)

	ScreenShake(unit:GetCenter(), 1000, 3, 0.75, 1500, 0, true)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			DealDamage(v,caster,dmg,DAMAGE_TYPE_PHYSICAL)
			v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun * (1 - v:GetStatusResistance())})
		end
	end

	if #enemy_found > 0 then 
		count = count+1
		if count < max_count then
			-- earthquake sound effect here
			-- earthquake particle effect here
			local warning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_war/earthbreaker_warning.vpcf", PATTACH_WORLDORIGIN, nil)

			-- ParticleManager:SetParticleControl(warning_particle, 0, start + offset + extra_offset * count)
			ParticleManager:SetParticleControl(warning_particle, 0, start + offset)

			Timers:CreateTimer(2.50,
			function()
				self:Slam(
				caster,
				start,
				offset,
				extra_offset,
				damage, t_radius_bonus, radius, stun,
				count == 0 and true or false,
				count, max_count)
				ParticleManager:DestroyParticle(warning_particle, false)
			end)
		end
	end
end