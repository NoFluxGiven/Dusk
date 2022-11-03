hero_freedom_strike = class({})

LinkLuaModifier("modifier_freedom_strike","lua/abilities/hero_freedom_strike",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freedom_strike_slow","lua/abilities/hero_freedom_strike",LUA_MODIFIER_MOTION_NONE)

function hero_freedom_strike:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FindTalentValue("special_bonus_hero_2") or 0
	return base_cooldown - t_cooldown_reduction
end

function hero_freedom_strike:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_EarthSpirit.PreAttack")
	return true
end

function hero_freedom_strike:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_freedom_strike", {Duration=1})
end

modifier_freedom_strike = class({})

function modifier_freedom_strike:OnCreated(kv)
	if IsServer() then
		local caster = self:GetParent()
		local p = self:GetParent()
		local facing = caster:GetForwardVector()
		local heroic_soul_buff = 1

		if (caster:HasModifier("modifier_heroic_soul") and caster:HasScepter()) then
			heroic_soul_buff = 2
		end

		local distance = self:GetAbility():GetSpecialValueFor("charge") * heroic_soul_buff

		local damage = self:GetAbility():GetSpecialValueFor("damage") * heroic_soul_buff

		local duration = self:GetAbility():GetSpecialValueFor("duration") * heroic_soul_buff

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		Physics:Unit(p)
		p:SetPhysicsFriction(0)
		p:PreventDI(true)
		-- To allow going through walls / cliffs add the following:
		p:FollowNavMesh(false)
		p:SetAutoUnstuck(false)
		p:SetNavCollisionType(PHYSICS_NAV_NOTHING)

		p:SetPhysicsVelocity(facing * distance * (1/0.4))
		p:AddPhysicsVelocity(Vector(0,0,distance*1.4))

		p:SetPhysicsAcceleration(Vector(0,0,-(distance*10)))

		Timers:CreateTimer(0.4,function()
			p:SetPhysicsVelocity(Vector(0,0,0))
			--    FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)
			p:PreventDI(false)
		end
		)
		Timers:CreateTimer(0.43,function()
			GridNav:DestroyTreesAroundPoint(p:GetCenter(), radius, false)

			local enemy = FindUnitsInRadius( p:GetTeamNumber(),
	                              p:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

			local part = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN_FOLLOW, p) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControl(part, 1, Vector(radius,0,0)) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			p:EmitSound("Hero_Brewmaster.ThunderClap")
			for k,v in pairs(enemy) do
				self:GetAbility():InflictDamage(v,p,damage,DAMAGE_TYPE_MAGICAL)
				v:AddNewModifier(caster, self:GetAbility(), "modifier_freedom_strike_slow", {Duration=duration}) --[[Returns:void
				No Description Set
				]]
			end
			FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)

			self:Destroy()
		end
		)
	end
end

function modifier_freedom_strike:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
	return state
end

modifier_freedom_strike_slow = class({})

function modifier_freedom_strike_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_freedom_strike_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end