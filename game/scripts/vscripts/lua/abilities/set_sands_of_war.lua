set_sands_of_war = class({})

LinkLuaModifier("modifier_sands_of_war","lua/abilities/set_sands_of_war",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sands_of_war_attack_speed","lua/abilities/set_sands_of_war",LUA_MODIFIER_MOTION_NONE)

function set_sands_of_war:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local facing = (caster:GetCursorPosition()-caster:GetAbsOrigin()):Normalized()
		local distance = self:GetSpecialValueFor("range")/1.4
		local pos = caster:GetAbsOrigin()+(facing*(distance/1.5))
		local ld = QAngle(0,-125,0)
		local r = self:GetSpecialValueFor("radius")
		local rd = QAngle(0,125,0)
		local speed = distance*2
		local duration = self:GetSpecialValueFor("time")

		local ls = RotatePosition(caster:GetAbsOrigin(), ld, pos) --[[Returns:Vector
		Rotate a ''Vector'' around a point.
		]]
		local rs = RotatePosition(caster:GetAbsOrigin(), rd, pos) --[[Returns:Vector
		Rotate a ''Vector'' around a point.
		]]

		local ldir = (pos - ls):Normalized() -- The directions to point towards our crossover point
		local rdir = (pos - rs):Normalized()

		local lu = FastDummy(ls,caster:GetTeamNumber(),1,0)
		local ru = FastDummy(rs,caster:GetTeamNumber(),1,0)

		caster:EmitSound("Hero_Morphling.Waveform")

		Physics:Unit(lu)
	  	lu:SetPhysicsFriction(0)
		lu:PreventDI(true)
		  -- To allow going through walls / cliffs add the following:
		lu:FollowNavMesh(false)
		lu:SetAutoUnstuck(false)
		lu:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		  
		lu:SetPhysicsVelocity(ldir * speed)
		  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))

		lu:SetPhysicsAcceleration(Vector(0,0,-speed*4))

		Physics:Unit(ru)
	  	ru:SetPhysicsFriction(0)
		ru:PreventDI(true)
		  -- To allow going through walls / cliffs add the following:
		ru:FollowNavMesh(false)
		ru:SetAutoUnstuck(false)
		ru:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		  
		ru:SetPhysicsVelocity(rdir * speed)
		  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))

		ru:SetPhysicsAcceleration(Vector(0,0,-speed*4))

		local info = 
		  {
		  Ability = self,
		  EffectName = "particles/units/heroes/hero_set/set_sand_wave_projectile.vpcf",
		  -- EffectName = "particles/units/heroes/hero_set/set_stoneblast.vpcf",
		  vSpawnOrigin = ls,
		  fDistance = speed,
		  fStartRadius = r,
		  fEndRadius = r,
		  Source = caster,
		  bHasFrontalCone = false,	
		  bReplaceExisting = false,
		  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  fExpireTime = GameRules:GetGameTime() + 10.0,
		  vVelocity = ldir * speed,
		  bProvidesVision = false,
		  iVisionRadius = 0,
		  iVisionTeamNumber = caster:GetTeamNumber()
		  }
		  ProjectileManager:CreateLinearProjectile(info)

		local info = 
		  {
		  Ability = self,
		  EffectName = "particles/units/heroes/hero_set/set_sand_wave_projectile.vpcf",
		  -- EffectName = "particles/units/heroes/hero_set/set_stoneblast.vpcf",
		  vSpawnOrigin = rs,
		  fDistance = speed,
		  fStartRadius = r,
		  fEndRadius = r,
		  Source = caster,
		  bHasFrontalCone = false,
		  bReplaceExisting = false,
		  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  fExpireTime = GameRules:GetGameTime() + 10.0,
		  vVelocity = rdir * speed,
		  bProvidesVision = false,
		  iVisionRadius = 0,
		  iVisionTeamNumber = caster:GetTeamNumber()
		  }
		  ProjectileManager:CreateLinearProjectile(info)

		  summonList = {
		  	left = {
		  		"npc_dota_unit_sand_puppet_warrior"
		  	},
		  	right = {
		  		"npc_dota_unit_sand_puppet_archer"
		  	}
		  }

		  local t_summon_extra = self:GetCaster():FetchTalent("special_bonus_set_1")

		  if t_summon_extra then
		  	table.insert(summonList.right,"npc_dota_unit_sand_puppet_archer")
		  end

		Timers:CreateTimer(0.9,function()

			for k,v in pairs(summonList) do
				local origin_unit

				if k == "left" then
					origin_unit = lu
				end

				if k == "right" then
					origin_unit = ru
				end

				for kk,vv in pairs(v) do
					local summon = CreateUnitByName(vv, origin_unit:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())

					summon:SetControllableByPlayer(caster:GetPlayerID(), true)
					summon:AddNewModifier(caster, nil, "modifier_kill", {Duration=duration})
					summon:AddNewModifier(caster, nil, "modifier_phased", {Duration=0.4})
					summon:SetIdleAcquire(true)

					self:syncLevel(caster,summon,self:GetSpecialValueFor("mult"))

					local t_attack_speed = self:GetCaster():FetchTalent("special_bonus_set_3")

					if t_attack_speed then
						summon:AddNewModifier(caster, self, "modifier_sands_of_war_attack_speed", {Duration=duration})
					end

					WorldParticle("particles/units/heroes/hero_set/set_spawn_sand_puppet.vpcf",origin_unit:GetAbsOrigin())
				end
			end

		end)
	end
end

function set_sands_of_war:OnProjectileHit(t,l)
	if IsServer() then
		if t then
			local damage = self:GetSpecialValueFor("damage")
			local slow_duration = self:GetSpecialValueFor("duration")

			t:AddNewModifier(self:GetCaster(), self, "modifier_sands_of_war", {Duration=slow_duration})
			self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		end
	end
end

function set_sands_of_war:syncLevel(original,unit,multiplier,add)
	if IsServer() then
		local caster = self:GetCaster()
		local mult = multiplier or 0.75

		local add = add or 0

		local clvl = math.ceil(caster:GetLevel()*mult)

		local finallvl = clvl-1+add

		unit:CreatureLevelUp(finallvl)

		local ab = unit:GetAbilityByIndex(0)

		local ablvl = math.ceil(finallvl/2)

		if ablvl > 8 then
			ablvl = 8
		end

		ab:SetLevel(ablvl)
	end
end

modifier_sands_of_war = class({})

function modifier_sands_of_war:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_sands_of_war:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

modifier_sands_of_war_attack_speed = class({})

function modifier_sands_of_war_attack_speed:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_sands_of_war_attack_speed:GetModifierAttackSpeedBonus_Constant()
	local aspd = self:GetAbility():GetCaster():FetchTalent("special_bonus_set_3") or 0
	return aspd
end