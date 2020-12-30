balthasar_doomflame = class({})

LinkLuaModifier("modifier_doomflame_aura","lua/abilities/balthasar_doomflame",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomflame_buff","lua/abilities/balthasar_doomflame",LUA_MODIFIER_MOTION_NONE)

function balthasar_doomflame:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local particle = "particles/units/heroes/hero_balthasar/doomflame_proj.vpcf"
		local radius = self:GetSpecialValueFor("radius")
		local speed = self:GetSpecialValueFor("proj_speed")
		local duration = self:GetSpecialValueFor("duration")
		local point = self:GetCursorPosition()
		local caster_pos = caster:GetAbsOrigin()
		local distance = self:GetSpecialValueFor("range")
		local direction = (point - caster_pos):Normalized()
		local segments = 6

		local segment_gap = distance / segments

		distance = distance

		for i=0,segments do
			local pos = caster:GetAbsOrigin() + direction * i * segment_gap
			local thinker = CreateModifierThinker( caster, self, "modifier_doomflame_aura",
			{Duration=duration},
			pos, caster:GetTeamNumber(), false)	

			GridNav:DestroyTreesAroundPoint( pos, radius, false )

			if i == math.floor(segments/2) then
				thinker:EmitSound("Balthasar.Doomflame.Ground")
			end
		end

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
		caster:EmitSound("Balthasar.Doomflame.Projectile")
	end
end

function balthasar_doomflame:OnProjectileHit(t, l)
	if IsServer() then
		if t then -- a target has been hit
			local damage = self:GetSpecialValueFor("damage")

			self:InflictDamage(t, self:GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
		end
	end
end

modifier_doomflame_aura = class({})

function modifier_doomflame_aura:OnCreated(kv)
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_balthasar/doomflame_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle( p, false, false, 10, false, false )
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_doomflame_aura:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("damage_over_time") * 0.25
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local enemies = FindEnemies(self:GetAbility():GetCaster(), self:GetParent():GetAbsOrigin(), radius)

	for k,v in pairs(enemies) do
		self:GetAbility():InflictDamage(v, self:GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
	end
end

function modifier_doomflame_aura:IsAura()
	return true
end

function modifier_doomflame_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_doomflame_aura:GetAuraSearchFlags()
	return 0
end

function modifier_doomflame_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_doomflame_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_doomflame_aura:GetAuraDuration()
	return 0.1
end

function modifier_doomflame_aura:GetModifierAura()
	return "modifier_doomflame_buff"
end

function modifier_doomflame_aura:IsPurgable()
	return false
end

function modifier_doomflame_aura:IsHidden()
	return true
end

modifier_doomflame_buff = class({})

function modifier_doomflame_buff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}
	return func
end

function modifier_doomflame_buff:GetModifierMoveSpeed_Absolute()
	if self:GetParent() == self:GetAbility():GetCaster() then
		return self:GetAbility():GetSpecialValueFor("movespeed")
	end
end

function modifier_doomflame_buff:GetModifierMoveSpeed_Max()
	if self:GetParent() == self:GetAbility():GetCaster() then
		return self:GetAbility():GetSpecialValueFor("movespeed")
	end
end

function modifier_doomflame_buff:CheckState()
	local t_freepathing = self:GetParent():FetchTalent("special_bonus_balthasar_2")

	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false
	}

	if t_freepathing then state.MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY = true end

	return state
end