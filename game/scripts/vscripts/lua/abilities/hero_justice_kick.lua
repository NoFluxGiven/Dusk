hero_justice_kick = class({})

LinkLuaModifier("modifier_justice_kick","lua/abilities/hero_justice_kick",LUA_MODIFIER_MOTION_NONE)

function hero_justice_kick:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if caster == target then
		return false
	end

	return true
end

function hero_justice_kick:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local mod = "modifier_justice_kick"

	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_hero_3") or 0

	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
	local duration = self:GetSpecialValueFor("duration")

	target:EmitSound("Hero.JusticeKick")
	ParticleManager:CreateParticle("particles/units/heroes/hero_hero/hero_justice_kick.vpcf", PATTACH_ROOTBONE_FOLLOW, target)

	if target:GetTeam() ~= caster:GetTeam() then
		self:InflictDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
	end

	target:AddNewModifier(caster, self, mod, {Duration=duration})
end

modifier_justice_kick = class({})

function modifier_justice_kick:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return func
end

function modifier_justice_kick:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_justice_kick:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_justice_kick:OnCreated(kv)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local p = self:GetParent()
		local facing = caster:GetForwardVector()

		local heroic_soul_buff = 1

		if (caster:HasModifier("modifier_heroic_soul") and caster:HasScepter()) then
			heroic_soul_buff = 2
		end
		
		local distance = self:GetAbility():GetSpecialValueFor("distance") * heroic_soul_buff
		local radius = self:GetAbility():GetSpecialValueFor("landing_radius")
		local damage = self:GetAbility():GetSpecialValueFor("landing_damage") * heroic_soul_buff
		local stun = self:GetAbility():GetSpecialValueFor("landing_stun")

		Physics:Unit(p)
		p:SetPhysicsFriction(0)
		p:PreventDI(true)
		-- To allow going through walls / cliffs add the following:
		p:FollowNavMesh(false)
		p:SetAutoUnstuck(false)
		p:SetNavCollisionType(PHYSICS_NAV_NOTHING)

		p:SetPhysicsVelocity(facing * distance * (1/0.4))
		p:AddPhysicsVelocity(Vector(0,0,distance*2))

		p:SetPhysicsAcceleration(Vector(0,0,-(distance*10)))

		Timers:CreateTimer(0.4,function()
			p:SetPhysicsVelocity(Vector(0,0,0))
			--    FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)
			p:PreventDI(false)
		end
		)
		Timers:CreateTimer(0.43,function()
			local enemies = FindEnemies(caster,p:GetAbsOrigin(),radius)

			ParticleManager:CreateParticle("particles/units/heroes/hero_hero/hero_justice_kick_land.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
			p:EmitSound("Hero_Rubick.Telekinesis.Target.Land")

			for k,v in pairs(enemies) do
				if v == p then goto continue end
				DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL,self,0)
				v:Stun( caster, ability, stun )
				::continue::
			end

			FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)
			self:Destroy()
		end
		)
	end
end

function modifier_justice_kick:CheckState()
	local state = {
		--[MODIFIER_STATE_STUNNED] = true
	}
	return state
end