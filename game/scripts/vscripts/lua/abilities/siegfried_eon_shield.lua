siegfried_eon_shield = class({})

LinkLuaModifier("modifier_eon_shield_thinker","lua/abilities/siegfried_eon_shield",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eon_shield_slow","lua/abilities/siegfried_eon_shield",LUA_MODIFIER_MOTION_NONE)

function siegfried_eon_shield:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local particle = "particles/units/heroes/hero_siegfried/eon_shield_proj.vpcf"
		local radius = self:GetSpecialValueFor("proj_radius")
		local speed = self:GetSpecialValueFor("speed")
		local point = self:GetCursorPosition()
		local caster_pos = caster:GetAbsOrigin()
		print(speed, point, caster_pos)
		local distance = math.sqrt( ( (caster_pos.x - point.x)^2 ) + ( (caster_pos.y - point.y)^2 ) )
		local direction = (point - caster_pos):Normalized()

		local proj = {
		Ability = self,
    	EffectName = particle,
    	vSpawnOrigin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1),
    	fDistance = distance,
    	fStartRadius = radius,
    	fEndRadius = radius,
    	Source = caster,
    	bHasFrontalCone = false,
    	bReplaceExisting = false,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = direction*speed,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(proj)
		caster:EmitSound("Siegfried.EonShield.Projectile")

		print(distance)
	end
end

function siegfried_eon_shield:OnProjectileHit(t, l)
	if IsServer() then
		if t then -- a target has been hit
			local damage = self:GetSpecialValueFor("proj_damage")
			local stun = self:GetSpecialValueFor("ministun")
			self:InflictDamage(t, self:GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
			--t:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=stun})
		elseif l then
			local caster = self:GetCaster()
			local delay = self:GetSpecialValueFor("delay")
			local radius = self:GetSpecialValueFor("radius")
			local t_radius_bonus = caster:FetchTalent("special_bonus_siegfried_2") or 0
			radius = radius + t_radius_bonus
			local mod = CreateModifierThinker( caster, self, "modifier_eon_shield_thinker", {Duration=delay}, l, caster:GetTeamNumber(), false )

			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/eon_shield_start_up.vpcf", PATTACH_ABSORIGIN, mod)

			ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

			self:CreateVisibilityNode( l, radius, delay + 0.8 )

			--mod:AddParticle( p, false, false, 10, false, false )

			mod:EmitSound("Siegfried.EonShield.StartUp")
			caster:StopSound("Siegfried.EonShield.Projectile")

		end
	end
end

modifier_eon_shield_thinker = class({})

function modifier_eon_shield_thinker:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local t_radius_bonus = caster:FetchTalent("special_bonus_siegfried_2") or 0
		radius = radius + t_radius_bonus
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/eon_shield.vpcf", PATTACH_WORLDORIGIN, nil)

		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetAbility():GetSpecialValueFor("area_damage")

		ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

		self:GetParent():EmitSound("Siegfried.EonShield.Explode")

		local enemies = FindEnemies( self:GetAbility():GetCaster(), self:GetParent():GetAbsOrigin(), radius )

		for k,v in pairs(enemies) do
			v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_eon_shield_slow", {Duration=duration}) --[[Returns:void
			No Description Set
			]]

			self:GetAbility():InflictDamage(v, self:GetAbility():GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
		end
	end
end

modifier_eon_shield_slow = class({})

function modifier_eon_shield_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_eon_shield_slow:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")

	return -slow
end

function modifier_eon_shield_slow:GetModifierTurnRate_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")

	return -slow
end

function modifier_eon_shield_slow:GetModifierAttackSpeedBonus_Constant()
	local slow = self:GetAbility():GetSpecialValueFor("slow")

	return -slow
end

function modifier_eon_shield_slow:GetEffectName()
	return "particles/units/heroes/hero_siegfried/eon_shield_slow.vpcf"
end