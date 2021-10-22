bahamut_mega_flare = class({})

LinkLuaModifier("modifier_mega_flare","lua/abilities/bahamut_mega_flare",LUA_MODIFIER_MOTION_NONE)

function bahamut_mega_flare:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

  local t_damage_bonus = caster:FetchTalent("special_bonus_bahamut_3") or 0

	local r = self:GetSpecialValueFor("radius_inner")
	local dmg = self:GetSpecialValueFor("damage_inner")
	local r2 = self:GetSpecialValueFor("radius_outer")
	local dmg2 = self:GetSpecialValueFor("damage_outer")

  dmg = dmg * (1+t_damage_bonus/100)
  dmg2 = dmg2 * (1+t_damage_bonus/100)

	if self:GetCaster():GetHasTalent("special_bonus_bahamut_mega_flare") then dmg = dmg*1.4 dmg2 = dmg2*1.4 end

	local min = 350

	local d = (target - caster:GetAbsOrigin()):Normalized()

	local s = self:GetSpecialValueFor("speed")

	local unit = FastDummy(caster:GetAbsOrigin()+Vector(0,0,350),caster:GetTeamNumber(),8,400)
	local distance_unit = FastDummy(target,caster:GetTeamNumber(),1,0)
	local distance = unit:GetRangeToUnit(distance_unit)
	if distance < min then
		distance = min
		target = caster:GetAbsOrigin()+(d*min)
	end
	local t = distance/s

	unit:EmitSound("Hero_Phoenix.SuperNova.Cast")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/mega_flare_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]


	Physics:Unit(unit)
	  unit:SetPhysicsFriction(0)
	  unit:PreventDI(true)
	    -- To allow going through walls / cliffs add the following:
	  unit:FollowNavMesh(false)
	  unit:SetAutoUnstuck(false)
  	  unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)

  	unit:SetPhysicsVelocity(s * d)
  	unit:AddPhysicsVelocity(Vector(0,0,(-250/t)))

  	Timers:CreateTimer(t-0.45,function()
  		unit:EmitSound("Hero_Warlock.RainOfChaos_buildup")
  		unit:EmitSound("Hero_Dark_Seer.Surge")
  		end)

  	Timers:CreateTimer(t,function()
  		unit:EmitSound("Hero_Techies.StasisTrap.Stun")
  		unit:StopSound("Hero_Phoenix.SuperNova.Cast")
  		unit:ForceKill(true)
  		unit:SetPhysicsVelocity(Vector(0,0,0))
  		ParticleManager:DestroyParticle(p,false)
  		local enemy_inner = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        r,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        0,
                        FIND_CLOSEST,
                        false)
  		local enemy_outer = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        r2,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        0,
                        FIND_CLOSEST,
                        false)

  		for k,v in pairs(enemy_inner) do
  			DealDamage(v,caster,dmg,DAMAGE_TYPE_MAGICAL)
  		end
  		for k,v in pairs(enemy_outer) do
  			DealDamage(v,caster,dmg2,DAMAGE_TYPE_MAGICAL)
  		end

  		ScreenShake(caster:GetCenter(), 2400, 170, 2, 1200, 0, true)
  	end)
end