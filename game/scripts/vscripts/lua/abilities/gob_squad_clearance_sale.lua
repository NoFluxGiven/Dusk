gob_squad_clearance_sale = class({})

LinkLuaModifier("modifier_clearance_sale","lua/abilities/gob_squad_clearance_sale",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_clearance_sale_slow","lua/abilities/gob_squad_clearance_sale",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_clearance_sale_passive","lua/abilities/gob_squad_clearance_sale",LUA_MODIFIER_MOTION_NONE)

function gob_squad_clearance_sale:OnSpellStart()
	local c = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	c:AddNewModifier(c, self, "modifier_clearance_sale", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

function gob_squad_clearance_sale:GetIntrinsicModifierName()
	return "modifier_clearance_sale_passive"
end

function gob_squad_clearance_sale:CreateBomb(caster)
		local radius = self:GetSpecialValueFor("radius")

		local damage = self:GetAbilityDamage()
		local stun = self:GetSpecialValueFor("stun")

		local pos = caster:GetAbsOrigin()

		local bomb_pos = pos+RandomVector(RandomInt(200,475)) --[[Returns:Vector
		Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
		]]

		local ability = self

		local unit = FastDummy(pos,caster:GetTeam(),2.4,250)
		local dunit = FastDummy(bomb_pos,caster:GetTeam(),0.1,0)

		local r = RandomInt(1, 10) --[[Returns:int
		Get a random ''int'' within a range
		]]
		unit.bomb_type = DAMAGE_TYPE_MAGICAL
		unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb.vpcf"
		unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion.vpcf"
		unit.explosion_sound = "Hero_TemplarAssassin.Trap.Explode"

		if r <= 3 then
			unit.bomb_type = DAMAGE_TYPE_PHYSICAL
			unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_physical.vpcf"
			unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_physical.vpcf"
			unit.explosion_sound = "Hero_Techies.RemoteMine.Detonate"
		end
		if r >= 9 then
			unit.bomb_type = DAMAGE_TYPE_PURE
			unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_pure.vpcf"
			unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_pure.vpcf"
			unit.explosion_sound = "Hero_Techies.StasisTrap.Stun"
		end

		local bp = ParticleManager:CreateParticle(unit.bomb_particle, PATTACH_ABSORIGIN_FOLLOW, unit)

		local distance = unit:GetRangeToUnit(dunit) --[[Returns:float
		No Description Set
		]]
		local direction = (unit:GetAbsOrigin() - bomb_pos):Normalized()

		Physics:Unit(unit)
	  	unit:SetPhysicsFriction(0)
	  	unit:PreventDI(true)
	  	-- To allow going through walls / cliffs add the following:
	  	unit:FollowNavMesh(false)
	  	unit:SetAutoUnstuck(false)
	  	unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	  	unit:SetPhysicsVelocity(direction * distance)
	  	unit:AddPhysicsVelocity(Vector(0,0,800))
	  
	  	unit:SetPhysicsAcceleration(Vector(0,0,-(1800)))
	  	unit:EmitSound("Hero_ChaosKnight.idle_throw")

		Timers:CreateTimer(1,function()
			local p = ParticleManager:CreateParticle(unit.explosion_particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			ParticleManager:DestroyParticle(bp,false)
			unit:EmitSound(unit.explosion_sound) --[[Returns:void
			 
			]]
			ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              unit:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

			local ally_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              unit:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

			for k,v in pairs(enemy_found) do
				ability:InflictDamage(v,caster,damage,unit.bomb_type)
				if unit.bomb_type == DAMAGE_TYPE_PURE then
					v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
					No Description Set
					]]
				end
				if unit.bomb_type == DAMAGE_TYPE_PHYSICAL then
					v:AddNewModifier(caster, ability, "modifier_clearance_sale_slow", {Duration=2}) --[[Returns:void
					No Description Set
					]]
				end
			end

			--[[for k,v in pairs(ally_found) do
				if v == caster then
					ability:InflictDamage(v,caster,damage*0.33,unit.bomb_type)
				end
			end]]
		end)
end

modifier_clearance_sale = class({})

function modifier_clearance_sale:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end
end

function modifier_clearance_sale:OnIntervalThink()
	if IsServer() then
		self:GetAbility():CreateBomb(self:GetParent())
	end
end

function modifier_clearance_sale:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()

		--if not caster:HasScepter() then return end

		local radius = self:GetAbility():GetSpecialValueFor("end_bomb_radius")

		local damage = self:GetAbility():GetSpecialValueFor("end_bomb_damage")

		local ability = self:GetAbility()

		local pos = caster:GetAbsOrigin()

		local bomb_pos = pos+RandomVector(RandomInt(10,50)) --[[Returns:Vector
		Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
		]]

		local unit = FastDummy(pos,caster:GetTeam(),5,250)
		local dunit = FastDummy(bomb_pos,caster:GetTeam(),0.1,0)

		unit.bomb_type = DAMAGE_TYPE_MAGICAL
		unit.bomb_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_bomb_aghs.vpcf"
		unit.explosion_particle = "particles/units/heroes/hero_gob_squad/clearance_sale_explosion_aghs.vpcf"
		unit.explosion_sound = "Hero_Gyrocopter.CallDown.Damage"

		local bp = ParticleManager:CreateParticle(unit.bomb_particle, PATTACH_ABSORIGIN_FOLLOW, unit)

		local distance = unit:GetRangeToUnit(dunit) --[[Returns:float
		No Description Set
		]]
		local direction = (unit:GetAbsOrigin() - bomb_pos):Normalized()

		Physics:Unit(unit)
	  	unit:SetPhysicsFriction(0)
	  	unit:PreventDI(true)
	  	-- To allow going through walls / cliffs add the following:
	  	unit:FollowNavMesh(false)
	  	unit:SetAutoUnstuck(false)
	  	unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	  	unit:SetPhysicsVelocity(direction * distance)
	  	unit:AddPhysicsVelocity(Vector(0,0,1700))
	  
	  	unit:SetPhysicsAcceleration(Vector(0,0,-(1800)))
	  	unit:EmitSound("Hero_ChaosKnight.idle_throw")

		Timers:CreateTimer(2,function()
			local p = ParticleManager:CreateParticle(unit.explosion_particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			ParticleManager:DestroyParticle(bp,false)
			unit:EmitSound(unit.explosion_sound) --[[Returns:void
			 
			]]
			ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              unit:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

			local ally_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              unit:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

			for k,v in pairs(enemy_found) do
				ability:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
			end

			--[[for k,v in pairs(ally_found) do
				if v == caster then
					ability:InflictDamage(v,caster,damage*0.33,DAMAGE_TYPE_MAGICAL)
				end
			end]]
		end)
	end
end

modifier_clearance_sale_slow = class({})

function modifier_clearance_sale_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_clearance_sale_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_clearance_sale_slow:IsDebuff()
	return true
end

modifier_clearance_sale_passive = class({})

function modifier_clearance_sale_passive:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end

function modifier_clearance_sale_passive:OnAbilityFullyCast(params)
	if params.unit == self:GetParent() then
		if not params.ability:IsItem() then
			local t_bombs = self:GetAbility():GetCaster():FetchTalent("special_bonus_gob_squad_3")
			if t_bombs then
				for i=1,t_bombs do
					self:GetAbility():CreateBomb(self:GetParent())
				end
			end
		end
	end
end

function modifier_clearance_sale_passive:IsHidden()
	return true
end