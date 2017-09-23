ironfist_typhoon = class({})

LinkLuaModifier("modifier_typhoon","lua/abilities/ironfist_typhoon",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_typhoon_slow","lua/abilities/ironfist_typhoon",LUA_MODIFIER_MOTION_NONE)
if IsServer() then
	function ironfist_typhoon:OnSpellStart()
	  local caster = self:GetCaster()
	  local origin = caster:GetAbsOrigin()
	  local point = caster:GetCursorPosition()
	  local direction = (point - origin):Normalized()
	  local distance = (origin - point):Length2D()
	  local duration = self:GetSpecialValueFor("duration")
	  local radius = self:GetSpecialValueFor("radius")
	  local slow = self:GetSpecialValueFor("slow_duration")
	  local damage = self:GetAbilityDamage()
	  
	  Physics:Unit(caster)
	  caster:SetPhysicsFriction(0)
	  caster:PreventDI(true)
	  -- To allow going through walls / cliffs add the following:
	  caster:FollowNavMesh(false)
	  caster:SetAutoUnstuck(false)
	  caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	  caster:SetPhysicsVelocity(direction * distance * (1/duration))

	  caster:EmitSound("Ability.Focusfire")

	  caster:AddNewModifier(caster,self,"modifier_typhoon",{Duration=duration})

	  caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,2.5)

	  Timers:CreateTimer(duration/2,function()
	  	local found = FindUnitsInLine(caster:GetTeamNumber(),
	  		caster:GetAbsOrigin(),
	  		point,
	  		caster,
	  		radius,
	  		DOTA_UNIT_TARGET_TEAM_ENEMY,
	  		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
	  		0)
	  	for k,v in pairs(found) do
	  		self:InflictDamage(v,caster,damage,self:GetAbilityDamageType())
	  		v:AddNewModifier(caster, self, "modifier_typhoon_slow", {Duration=slow}) --[[Returns:void
	  		No Description Set
	  		]]
	  	end
	  end)
	  
	  Timers:CreateTimer(duration,function()
	    caster:SetPhysicsVelocity(Vector(0,0,0))
	--    FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
	    caster:PreventDI(false)
	    caster:RemoveGesture(ACT_DOTA_ATTACK)
	  end
	  )
	  Timers:CreateTimer(duration+0.06,function()
	    FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
	  end
	  )
	  Timers:CreateTimer(duration*2,function() caster:StopSound("Ability.Focusfire") end)
	end

	function ironfist_typhoon:OnUpgrade()
		local linkedAbilities = {
			"ironfist_reversal",
			-- "ironfist_typhoon",
			"ironfist_boulder_throw"
		}

		if self.ignoreUpgrade then return end

		for k,v in pairs(linkedAbilities) do
			local ab = self:GetCaster():FindAbilityByName(v)
			local lvl = self:GetLevel()
			if ab then
				ab.ignoreUpgrade = true
				ab:SetLevel(lvl)
				ab.ignoreUpgrade = false
			end
		end
	end
end

modifier_typhoon = class({})

function modifier_typhoon:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_typhoon:IsHidden()
	return true
end

modifier_typhoon_slow = class({})

function modifier_typhoon_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_typhoon_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_typhoon_slow:IsDebuff()
	return true
end