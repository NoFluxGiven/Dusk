shard_magus_iceheart = class({})

LinkLuaModifier("modifier_iceheart","lua/abilities/shard_magus_iceheart",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_iceheart_slow","lua/abilities/shard_magus_iceheart",LUA_MODIFIER_MOTION_NONE)

function shard_magus_iceheart:GetIntrinsicModifierName()
	return "modifier_iceheart"
end

function shard_magus_iceheart:OnProjectileHit(t,l)
	local damage = self:GetSpecialValueFor("damage")
	local modifier = "modifier_iceheart_slow"
	local duration = self:GetSpecialValueFor("duration")
	if t then
		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		t:AddNewModifier(self:GetCaster(), self, modifier, {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/iceheart_unit.vpcf", PATTACH_ABSORIGIN_FOLLOW, t) --[[Returns:int
		Creates a new particle effect
		]]
		return false
	end
end

modifier_iceheart = class({})

function modifier_iceheart:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_iceheart:IsHidden()
	return true
end

function modifier_iceheart:OnAbilityExecuted(params)
	if IsServer() then
		local p = self:GetParent()
		if self:GetParent():PassivesDisabled() then return end
		if p == params.unit then
			local ability = params.ability
			local manacost = ability:GetManaCost(ability:GetLevel()) --[[Returns:int
			No Description Set
			]]

			local caster = p

			if manacost <= 0 then return end
			if ability:IsItem() then return end

			local t_health_restore = p:FindTalentValue("special_bonus_shard_magus_2")

			if t_health_restore then
				local hp = caster:GetMaxHealth()
				local pct = t_health_restore/100

				local heal = hp*pct

				caster:Heal(heal, caster)
			end

			local d = self:GetParent():GetForwardVector()
			local speed = 900
			local range = self:GetAbility():GetSpecialValueFor("range")
			local radius = self:GetAbility():GetSpecialValueFor("radius")

			local start_radius,end_radius = radius,radius

			local sound = "Hero_Lich.ChainFrostImpact.LF"
			local particle = "particles/units/heroes/hero_shard_magus/iceheart_wave.vpcf"

			local data = {
				Ability = self:GetAbility(),
				Source = caster,
				EffectName = particle,
				vSpawnOrigin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_HITLOCATION),
				vVelocity = d * speed,
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				bHasFrontalCone = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				iUnitTargetFlags = 0,
				bProvidesVision = false,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iVisionRadius = 0,
				bDrawsOnMinimap = false,
				bVisibleToEnemies = true,
				fExpireTime = GameRules:GetGameTime()+10,
				bDeleteOnHit = false
			}

			caster:EmitSound(sound)

			ProjectileManager:CreateLinearProjectile(data)
		end
	end
end

function modifier_iceheart:IsHidden()
	return true
end

modifier_iceheart_slow = class({})

function modifier_iceheart_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_iceheart_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_iceheart_slow:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("attack_slow")
end

function modifier_iceheart_slow:GetModifierTurnRate_Percentage()
	return -self:GetAbility():GetSpecialValueFor("turnrate_slow")
end