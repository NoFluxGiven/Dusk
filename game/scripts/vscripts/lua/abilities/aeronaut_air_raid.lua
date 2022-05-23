aeronaut_air_raid = class({})

LinkLuaModifier("modifier_air_raid","lua/abilities/aeronaut_air_raid",LUA_MODIFIER_MOTION_NONE)

function aeronaut_air_raid:OnSpellStart()
	local caster = self:GetCaster()

	local mod = "modifier_air_raid"
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_air_raid", {Duration=duration})
end

modifier_air_raid = class({})

-- function modifier_air_raid:DeclareFunctions()
-- 	local func = {
-- 		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
-- 	}
-- 	return func
-- end

-- function modifier_air_raid:GetModifierDamageOutgoing_Percentage()
-- 	return -self:GetAbility():GetSpecialValueFor("damage_reduction")
-- end

function modifier_air_raid:OnCreated(kv)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		local t_interval_bonus = self:GetParent():FindTalentValue("special_bonus_aeronaut_4") or 0
		self.interval = self:GetAbility():GetSpecialValueFor("interval") + t_interval_bonus
		
		self:StartIntervalThink(self.interval)

		self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage")
		--Particle
	end
end

function modifier_air_raid:OnIntervalThink()
	if IsServer() then
		local enemies = FindEnemiesRandom(self:GetParent(),self:GetParent():GetAbsOrigin(),self.radius,nil,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE)

		if self:GetParent():IsDisarmed() or self:GetParent():IsStunned() then
			return
		end

		local v = enemies[1]

		if v then

			self:GetParent():EmitSound("Hero_Gyrocopter.FlackCannon")

			self:GetParent():PerformAttack( v,
						true,
						true,
						true,
						true,
						true,
						false,
						false )

		end

		-- for k,v in pairs(enemies) do
				
		-- end
	end
end

function modifier_air_raid:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_IDLE_RARE)
	end
end