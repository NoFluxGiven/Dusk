mifune_raigeki = class({})

LinkLuaModifier("modifier_raigeki","lua/abilities/mifune_raigeki",LUA_MODIFIER_MOTION_NONE)

function mifune_raigeki:OnAbilityPhaseStart()
	local caster = self:GetCaster()

	local cast_particle = "particles/units/heroes/hero_mifune/mifune_shockwave_cast_b.vpcf"

	CreateParticleHitloc(caster,cast_particle)

	-- Sound
	-- Wind whoosh, Japanese feel?

	return true
end

function mifune_raigeki:GetCastRange()
	local t_bonus = self:GetCaster():FindTalentValue("special_bonus_mifune_2") or 0
	return self.BaseClass.GetCastRange(self, self:GetCaster():GetAbsOrigin(), self:GetCaster()) + t_bonus
end

function mifune_raigeki:OnSpellStart()
	local caster = self:GetCaster()
	local delay = self:GetCaster():HasShard() and self:GetSpecialValueFor("shard_delay") or self:GetSpecialValueFor("delay")
	local range = self:GetCastRange(caster:GetAbsOrigin(), caster)

	local cpos = caster:GetAbsOrigin()

	local tpos = self:GetCursorPosition()

	local direction = (tpos-cpos):Normalized()

	local endpos = cpos + direction * range

	local velocity_mult = 2

	local particle = "particles/units/heroes/hero_mifune/mifune_shockwave.vpcf"

	local proj = {
		Ability = self,
    	EffectName = particle,
    	vSpawnOrigin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1),
    	fDistance = range,
    	fStartRadius = 125,
    	fEndRadius = 125,
    	Source = caster,
    	bHasFrontalCone = false,
    	bReplaceExisting = false,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = direction*range*velocity_mult,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(proj)
	caster:EmitSound("Hero_Magnataur.ShockWave.Particle")

	local unit =
			CreateModifierThinker( caster,
			self,
			"", {Duration=delay*2}, endpos, caster:GetTeamNumber(), false )

	Timers:CreateTimer(delay*0.30,function()
		unit:EmitSound("Hero_Magnataur.Empower.Target")
	end)

	Timers:CreateTimer(delay*0.90,function()
		unit:EmitSound("Hero_Magnataur.ReversePolarity.Anim")
		unit:EmitSound("Hero_Magnataur.ShockWave.Target")
	end)

	Timers:CreateTimer(delay,function()
		proj.vVelocity = direction*-range*velocity_mult
		proj.vSpawnOrigin = unit:GetAbsOrigin()

		ProjectileManager:CreateLinearProjectile(proj)
		unit:EmitSound("Hero_Magnataur.ShockWave.Particle")
	end)

	if self:GetCaster():HasShard() then
		Timers:CreateTimer(delay*1.90,function()
			unit:EmitSound("Hero_Magnataur.ReversePolarity.Anim")
			unit:EmitSound("Hero_Magnataur.ShockWave.Target")
		end)
	
		Timers:CreateTimer(delay*2.00,function()
			proj.vVelocity = direction*range*velocity_mult
			proj.vSpawnOrigin = cpos
	
			ProjectileManager:CreateLinearProjectile(proj)
			unit:EmitSound("Hero_Magnataur.ShockWave.Particle")
		end)
	end	
end

function mifune_raigeki:OnProjectileHit(t,l)
	if t then
		local c = self:GetCaster()
		local duration = self:GetSpecialValueFor("slow_duration")
		local t_bonus = c:FindTalentValue("special_bonus_mifune_1")
		local damage = self:GetSpecialValueFor("initial_damage") + t_bonus
		self:InflictDamage(t,c,damage,DAMAGE_TYPE_MAGICAL)
		t:AddNewModifier(c, self, "modifier_raigeki", {Duration=duration})
	end
end

modifier_raigeki = class({})

function modifier_raigeki:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_raigeki:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end