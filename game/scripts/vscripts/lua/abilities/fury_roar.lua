fury_roar = class({})

LinkLuaModifier("modifier_roar","lua/abilities/fury_roar",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roar_enemy","lua/abilities/fury_roar",LUA_MODIFIER_MOTION_NONE)

function fury_roar:OnSpellStart()
	local c = self:GetCaster()
	local range = self:GetSpecialValueFor("range")

	c:EmitSound("Fury.Roar")

	local d = (self:GetCursorPosition() - c:GetAbsOrigin()):Normalized()

	-- local d = self:GetCaster():GetForwardVector()
	local speed = 3000
	local start_radius = 75

	local data = {
			Ability = self,
			Source = c,
			vSpawnOrigin = c:GetCenter()+Vector(0,0,50),
			vVelocity = d * speed,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = start_radius*5,
			bHasFrontalCone = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = 0,
			bProvidesVision = true,
			iVisionTeamNumber = c:GetTeamNumber(),
			iVisionRadius = 230,
			bDrawsOnMinimap = false,
			bVisibleToEnemies = true,
			fExpireTime = GameRules:GetGameTime()+10,
			bDeleteOnHit = false
	}

	ProjectileManager:CreateLinearProjectile(data)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", PATTACH_POINT_FOLLOW, c)
	ParticleManager:SetParticleControl(p, 0, c:GetCenter())
	ParticleManager:SetParticleControl(p, 1, c:GetCenter()+d*range)

	-- local cone_prec = 0.10 -- the precision of the cone; lower numbers = higher precision
	-- local cone_n = 1/cone_prec
	-- local cone_swidth
end

function fury_roar:OnProjectileHit(target)
	local dmg = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local stack = 1

	if not target then return end

	if self:GetCaster():HasModifier("modifier_berserk") then
		dmg = dmg*2
		stack = stack*2
	end

	self:InflictDamage(target, self:GetCaster(), dmg, DAMAGE_TYPE_MAGICAL)

	target:AddNewModifier(self:GetCaster(), self, "modifier_roar_enemy", {Duration=duration, stack=stack})

	--if target:IsRealHero() them

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_roar", {Duration=duration, stack=stack}) --[[Returns:void
		No Description Set
		]]

	--end

	return false
end

modifier_roar = class({})

function modifier_roar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_roar:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_roar:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+kv.stack)
	end
end

function modifier_roar:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	local stack = self:GetStackCount()
	return stack * bonus
end

function modifier_roar:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
	local stack = self:GetStackCount()
	return stack * bonus
end

function modifier_roar:GetModifierPreAttack_BonusDamage()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	local stack = self:GetStackCount()
	return stack * bonus
end

modifier_roar_enemy = class({})

function modifier_roar_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_roar_enemy:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_roar_enemy:OnRefresh(kv)
	if IsServer() then
		if kv.stack > self:GetStackCount() then
			self:SetStackCount(kv.stack)
		end
	end
end

function modifier_roar_enemy:GetModifierMoveSpeedBonus_Percentage()
	local stack = self:GetStackCount()
	local t_slow_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_fury_1") or 0
	return -( self:GetAbility():GetSpecialValueFor("slow") + t_slow_bonus ) * stack
end