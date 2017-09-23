gob_squad_rocket_blast = class({})

LinkLuaModifier("modifier_rocket_blast_thinker","lua/abilities/gob_squad_rocket_blast",LUA_MODIFIER_MOTION_NONE)

function gob_squad_rocket_blast:OnSpellStart()
	if IsServer() then
		local c = self:GetCaster()
		local p = self:GetCursorPosition()
		local d = c:GetForwardVector()
		local speed = self:GetSpecialValueFor("speed")
		local range = self:GetSpecialValueFor("range")

		local data = {
			Ability = self,
			Source = c,
			EffectName = "particles/units/heroes/hero_gob_squad/rocket_blast.vpcf",
			vSpawnOrigin = c:GetCenter()+Vector(0,0,50),
			vVelocity = d * speed,
			fDistance = range,
			fStartRadius = 80,
			fEndRadius = 80,
			bHasFrontalCone = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING,
			iUnitTargetFlags = 0,
			bProvidesVision = true,
			iVisionTeamNumber = c:GetTeamNumber(),
			iVisionRadius = 230,
			bDrawsOnMinimap = false,
			bVisibleToEnemies = true,
			fExpireTime = GameRules:GetGameTime()+10,
			bDeleteOnHit = true
		}

		ProjectileManager:CreateLinearProjectile(data)

		c:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud") --[[Returns:void
		 
		]]
	end
end

function gob_squad_rocket_blast:OnProjectileThink( l )
	local c = self:GetCaster()
	local t_ride_the_rocket_blast = self:GetCaster():FetchTalent("special_bonus_gob_squad_4")

	if t_ride_the_rocket_blast then
		local groundpos = GetGroundPosition(l, c) + Vector(0,0,65)
		c:SetAbsOrigin( groundpos )
		c:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.3,IsHidden=true}) --[[Returns:void
		No Description Set
		]]
	end
end

function gob_squad_rocket_blast:OnProjectileHit(t, l)
	if IsServer() then
		local c = self:GetCaster()
		local r = self:GetSpecialValueFor("radius")
		local t_damage_bonus = c:FetchTalent("special_bonus_gob_squad_1") or 0
		local d = self:GetAbilityDamage() + t_damage_bonus

		local t_ride_the_rocket_blast = self:GetCaster():FetchTalent("special_bonus_gob_squad_4")

		if t_ride_the_rocket_blast then
			FindClearSpaceForUnit(c, l, true)
			GridNav:DestroyTreesAroundPoint( l, 250, false ) 
		end		

		if t then
			local ent = FindEntities(c,
				l,
				r,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_BUILDING)

			CreateModifierThinker( c,
				self,
				"modifier_rocket_blast_thinker", {Duration = 1},
				l,
				c:GetTeamNumber(),
				false )

			ScreenShake(l, 1000, 3, 0.75, 1500, 0, true)

			for k,v in pairs(ent) do
				if CheckClass(v,"npc_dota_building") then
					self:InflictDamage(v,c,d*0.20,DAMAGE_TYPE_PURE)
				else
					self:InflictDamage(v,c,d,DAMAGE_TYPE_MAGICAL)
				end
			end
			return true
		end
	end
end

modifier_rocket_blast_thinker = class({})

function modifier_rocket_blast_thinker:OnCreated()
	if IsServer() then
		local r = self:GetAbility():GetSpecialValueFor("radius")
		self:GetParent():EmitSound("Hero_Techies.Suicide")
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_gob_squad/rocket_blast_explosion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,75)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(r,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
	end
end