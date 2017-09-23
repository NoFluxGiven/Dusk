elena_starlight = class({})

function elena_starlight:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local d = (point-caster:GetAbsOrigin()):Normalized()

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_elena_3") or 0

		local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
		local delay = self:GetSpecialValueFor("delay")

		local heal_percentage = self:GetSpecialValueFor("heal_percentage")/100

		local range = self:GetSpecialValueFor("range")

		local startpoint = caster:GetAbsOrigin()
		local endpoint = startpoint+(d*range)

		endpoint = endpoint + Vector(0,0,55)
		startpoint = startpoint + Vector(0,0,55)

		local charge_particle = "particles/units/heroes/hero_elena/starlight_target_line.vpcf"
		local particle = "particles/units/heroes/hero_elena/starlight.vpcf"

		local unit = CreateModifierThinker( caster, self, "modifier_truesight", {Duration=delay*4}, startpoint, caster:GetTeamNumber(), false )
		local unit2 = CreateModifierThinker( caster, self, "modifier_truesight", {Duration=delay*4}, startpoint, caster:GetOpposingTeamNumber(), false )

		local p = ParticleManager:CreateParticleForTeam(charge_particle, PATTACH_ABSORIGIN_FOLLOW, unit, caster:GetTeamNumber()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, endpoint) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		local p_en = ParticleManager:CreateParticleForTeam(charge_particle, PATTACH_ABSORIGIN_FOLLOW, unit2, caster:GetOpposingTeamNumber()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p_en, 1, endpoint) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		unit:EmitSound("Elena.Starlight.Charge")

		local n = 0

		Timers:CreateTimer(delay,function()
			ParticleManager:DestroyParticle(p,false)
			ParticleManager:DestroyParticle(p_en,false)

			unit:EmitSound("Elena.Starlight")

			local p2 = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(p2, 1, endpoint) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]

			local p2_en = ParticleManager:CreateParticleForTeam(particle, PATTACH_ABSORIGIN_FOLLOW, unit2, caster:GetOpposingTeamNumber()) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(p2_en, 1, endpoint) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			local fen = FindUnitsInLine(caster:GetTeamNumber(),
				startpoint,
				endpoint,
				caster,
				120,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				0)
			local fal = FindUnitsInLine(caster:GetTeamNumber(),
				startpoint,
				endpoint,
				caster,
				120,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				0)

			for k,v in pairs(fen) do
				if v:IsRealHero() then
					n = n+1
				end
			end
			for k,v in pairs(fal) do
				if v:IsRealHero() then
					n = n+1
				end
			end

			local t_hero_damage_bonus = self:GetCaster():FetchTalent("special_bonus_elena_5") or 0

			local bonus = (self:GetSpecialValueFor("damage_bonus")+t_hero_damage_bonus)*n
			damage = damage+bonus

			for k,v in pairs(fen) do
				self:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
				ParticleManager:CreateParticle("particles/units/heroes/hero_elena/starlight_hit_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
				Creates a new particle effect
				]]
			end
			for k,v in pairs(fal) do
				v:Heal(damage*heal_percentage,caster)
				ParticleManager:CreateParticle("particles/units/heroes/hero_elena/starlight_hit_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
				Creates a new particle effect
				]]
			end
		end)
	end
end