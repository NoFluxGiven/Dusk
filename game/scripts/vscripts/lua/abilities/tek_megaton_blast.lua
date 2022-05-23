tek_megaton_blast = class({})

LinkLuaModifier("modifier_megaton_blast","lua/abilities/tek_megaton_blast",LUA_MODIFIER_MOTION_NONE)

function tek_megaton_blast:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		local target = self:GetCursorTarget()

		local delay = self:GetSpecialValueFor("delay")

		local mod = caster:AddNewModifier(caster, self, "modifier_megaton_blast", {Duration=delay})

		mod.info = 
			  {
			  Target = target,
			  Source = caster,
			  Ability = self,  
			  EffectName = "particles/units/heroes/hero_tek/megaton_blast.vpcf",
			  vSpawnOrigin = caster:GetCenter(),
			  fDistance = 10000,
			  fStartRadius = 32,
			  fEndRadius = 32,
			  bHasFrontalCone = false,
			  bReplaceExisting = false,
			  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			  iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
			  fExpireTime = GameRules:GetGameTime() + 10.0,
			  bDeleteOnHit = true,
			  iMoveSpeed = 2500,
			  bProvidesVision = false,
			  iVisionRadius = 0,
			  iVisionTeamNumber = caster:GetTeamNumber(),
			  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			  }

		--Particle
		caster:EmitSound("Tek.MegatonBlast.Charge")
	end
end

function tek_megaton_blast:OnProjectileHit(t,l)
	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_tek_2") or 0
	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
	local stun = self:GetSpecialValueFor("stun")
	if t then
		if t:TriggerSpellAbsorb(self) then return end
		ScreenShake(t:GetAbsOrigin(), 100, 8, 0.5, 2400, 0, true) --[[Returns:void
		Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
		]]

		if t:IsMagicImmune() then return end

		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		t:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
		t:EmitSound("Tek.MegatonBlast.Target")
	end
end

modifier_megaton_blast = class({})

function modifier_megaton_blast:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_megaton_blast:OnDestroy()
	if IsServer() then
		local caster = self.info.Source
		local target = self.info.Target

		local max_range = 4000

		ScreenShake(caster:GetAbsOrigin(), 100, 8, 0.5, 2400, 0, true)

		-- if target:GetRangeToUnit(caster) < max_range then
		  	local projectile = ProjectileManager:CreateTrackingProjectile(self.info)
		  	caster:EmitSound("Tek.MegatonBlast.Fire")
		  	self:GetAbility():CreateVisibilityNode(target:GetAbsOrigin(), 750, 4.0) --[[Returns:void
		  	No Description Set
		  	]]
	  	-- else
	  		-- caster:EmitSound("Tek.MegatonBlast.Fizzle")
	  	-- end
  	end
end