aeronaut_dashy_dashy = class({})

LinkLuaModifier("modifier_dashy_dashy","lua/abilities/aeronaut_dashy_dashy",LUA_MODIFIER_MOTION_NONE)

function aeronaut_dashy_dashy:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")

	local dash_time = 0.3

	caster:AddNewModifier(caster, self, "modifier_dashy_dashy", {Duration=dash_time})
end

modifier_dashy_dashy = class({})

function modifier_dashy_dashy:OnCreated(kv)
	if IsServer() then

		local p = self:GetParent()

		local point = self:GetAbility():GetCursorPosition()

		local dir = ( point - p:GetAbsOrigin() ):Normalized()

		self.dir = dir

		local t_distance_bonus = p:FindTalentValue("special_bonus_aeronaut_1") or 0

		local distance = self:GetAbility():GetSpecialValueFor("distance") + t_distance_bonus

		local dash_time = self:GetDuration()

		Physics:Unit(p)
		p:SetPhysicsFriction(0)
		p:PreventDI(true)
		-- To allow going through walls / cliffs add the following:
		p:FollowNavMesh(false)
		p:SetAutoUnstuck(false)
		p:SetNavCollisionType(PHYSICS_NAV_NOTHING)

		local vec = dir * distance * (1/dash_time)

		p:SetPhysicsVelocity(vec)

		self.part = ParticleManager:CreateParticle("particles/units/heroes/hero_aeronaut/dashy_dashy_trail_waow.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)

		ParticleManager:SetParticleControl(self.part, 1, vec)
		p:EmitSound("Aeronaut.DashyDashy")

		self:StartIntervalThink(0.03)

	end
end

function modifier_dashy_dashy:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local stun = self:GetAbility():GetSpecialValueFor("stun")

		local t_knockback_bonus = p:FindTalentValue("special_bonus_aeronaut_1") or 0
		local knockback = self:GetAbility():GetSpecialValueFor("knockback") + t_knockback_bonus

		local enemies = FindEnemies(p,p:GetAbsOrigin(),radius)

		local flying = p:HasFlyMovementCapability()

		local valid_enemies = {}

		for k,v in pairs(enemies) do
			if flying then
				if v:HasFlyMovementCapability() then
					table.insert(valid_enemies,v)
				end
			else
				if not v:HasFlyMovementCapability() then
					table.insert(valid_enemies,v)
				end
			end
		end

		local t = valid_enemies[1] -- find the closest enemy that was hit

		if t then
			local dir = self.dir

			t:AddNewModifier(p, nil, "modifier_stunned", {Duration=stun})
			self:GetAbility():InflictDamage(t,p,damage,DAMAGE_TYPE_PURE)

			t:Knockback(dir,knockback,0.25)

			ParticleManager:CreateParticle("particles/units/heroes/hero_aeronaut/dashy_dashy_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, t)
			p:EmitSound("Aeronaut.DashyDashy.Hit")

			self:Destroy()
		end
	end
end

function modifier_dashy_dashy:OnDestroy(kv)
	if IsServer() then

		local p = self:GetParent()

		FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)

		ParticleManager:DestroyParticle(self.part,false)

		p:SetPhysicsVelocity(Vector(0,0,0))
		--    FindClearSpaceForUnit(p,p:GetAbsOrigin(),true)
		p:PreventDI(false)

		p:AddNewModifier(p,nil,"modifier_phased",{Duration=1})

		p:FadeGesture(ACT_DOTA_IDLE_RARE)

	end
end

function modifier_dashy_dashy:IsHidden()
	return true
end