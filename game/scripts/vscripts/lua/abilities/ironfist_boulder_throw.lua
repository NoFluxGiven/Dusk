ironfist_boulder_throw = class({})

LinkLuaModifier("modifier_boulder_throw","lua/abilities/ironfist_boulder_throw",LUA_MODIFIER_MOTION_NONE)

if IsServer() then

	function ironfist_boulder_throw:OnSpellStart()
		local target = self:GetCursorTarget()

		if target:TriggerSpellAbsorb(self) then return end
		target:TriggerSpellReflect(self)

		target:AddNewModifier(self:GetCaster(), self, "modifier_boulder_throw", {}) --[[Returns:void
		No Description Set
		]]
	end

	function ironfist_boulder_throw:OnUpgrade()
		local linkedAbilities = {
			"ironfist_reversal",
			"ironfist_typhoon",
			-- "ironfist_boulder_throw"
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

modifier_boulder_throw = class({})

if IsServer() then
	function modifier_boulder_throw:OnCreated(kv)
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local distance = self:GetAbility():GetSpecialValueFor("distance")
		local stun = self:GetAbility():GetSpecialValueFor("stun")
		local ability = self:GetAbility()

		local r = self:GetAbility():GetSpecialValueFor("radius")

		local g = -4500

		local direction = caster:GetForwardVector()

		local ground_dest = GetGroundHeight(direction*distance,target)

		local ground = GetGroundHeight(target:GetAbsOrigin(),target)

		local ground_diff = ground_dest - ground

		local air_distance = 1650 + ground_diff

		local vi = air_distance

		local vf = 0

		local time_to_impact = (vi / math.abs(g))*2.3

		local velocity = (direction*-distance*(1/time_to_impact))

		target:EmitSound("Hero_Tiny.Toss.Target")

		Physics:Unit(target)
		  target:SetPhysicsFriction(0)
		  target:PreventDI(true)
		  -- To allow going through walls / cliffs add the following:
		  target:FollowNavMesh(false)
		  target:SetAutoUnstuck(false)
		  target:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		  
		  target:SetPhysicsVelocity(velocity+Vector(0,0,air_distance))
		  target:SetPhysicsAcceleration(Vector(0,0,g))

		  -- Timers:CreateTimer(time/4,function()
		  -- 	target:SetPhysicsVelocity(velocity+Vector(0,0,-air_distance/4))
		  -- 	end)

		  -- Timers:CreateTimer(time/2,function()
		  -- 	target:SetPhysicsVelocity(velocity+Vector(0,0,-air_distance/2))
		  -- 	end)

		 Timers:CreateTimer(time_to_impact,function()
		 	GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(),250,true)
		 	ability:InflictDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
		 	target:AddNewModifier(caster, ability, "modifier_stunned", {Duration=stun}) --[[Returns:void
		 	No Description Set
		 	]]
		 	target:SetPhysicsVelocity(Vector(0,0,0))
		 	target:PreventDI(false)

		 	local en = FindEnemies(caster,target:GetAbsOrigin(),r)

		 	for k,v in pairs(en) do
		 		if v ~= target then
		 			ability:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		 		end
		 	end

		 	target:EmitSound("Ability.TossImpact")

		 	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true) --[[Returns:void
		 	Place a unit somewhere not already occupied.
		 	-- ]]
		 	self:Destroy()
		 end)
	end
end

function modifier_boulder_throw:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_boulder_throw:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_boulder_throw:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_boulder_throw:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end