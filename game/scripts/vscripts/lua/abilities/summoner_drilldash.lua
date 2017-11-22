summoner_drilldash = class({})

LinkLuaModifier("modifier_drilldash","lua/abilities/ptomely_drilldash",LUA_MODIFIER_MOTION_NONE)

function summoner_drilldash:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	local dir = ( target - caster:GetAbsOrigin() ):Normalized()
	local distance = 500
	local dash_time = 0.4

	caster:AddNewModifier(caster, self, "modifier_drilldash", {Duration=dash_time-0.1})

	Physics:Unit(caster)
  	caster:SetPhysicsFriction(0)
	caster:PreventDI(true)
	  -- To allow going through walls / cliffs add the following:
	caster:FollowNavMesh(false)
	caster:SetAutoUnstuck(false)
	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	  
	caster:SetPhysicsVelocity(dir * distance / dash_time)
	  -- caster:AddPhysicsVelocity(Vector(0,0,distance/8))
	  
	caster:SetPhysicsAcceleration(Vector(0,0,-(distance*2)))

	Timers:CreateTimer(dash_time,function()
		caster:SetPhysicsVelocity(Vector(0,0,0))
	end)
end

modifier_drilldash = class({})

function modifier_drilldash:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return func
end

function modifier_drilldash:GetOverrideAnimation()
	return ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP
end

function modifier_drilldash:CheckState()
	local state = {
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true
		[MODIFIER_STATE_ROOTED] = true
	}
end