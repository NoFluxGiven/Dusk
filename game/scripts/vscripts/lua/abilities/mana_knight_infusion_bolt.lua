mana_knight_infusion_bolt = class({})

function mana_knight_infusion_bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local spawn_origin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)

	local info = 
	  {
	  Target = target,
	  Source = caster,
	  Ability = self,  
	  EffectName = "particles/units/heroes/hero_mana_knight/infusion_bolt.vpcf",
	  vSpawnOrigin = spawn_origin,
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
	  iMoveSpeed = 750,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber(),
	  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	  }
  
  	local projectile = ProjectileManager:CreateTrackingProjectile(info)

  	caster:EmitSound("Hero_ChaosKnight.ChaosBolt.Cast")
end

function mana_knight_infusion_bolt:OnProjectileHit(t,l)
	if t then

		if t:TriggerSpellAbsorb(self) then return end

		local pct_damage = self:GetSpecialValueFor("damage") / 100
		local max_damage = self:GetSpecialValueFor("max_damage")
		local min_damage = self:GetSpecialValueFor("min_damage")

		local t_stun_bonus = self:GetCaster():FindTalentValue("special_bonus_mana_knight_4") or 0

		local stun = self:GetSpecialValueFor("stun") + t_stun_bonus

		local missing_mana = t:GetMaxMana() - t:GetMana()

		local damage = math.max(math.min(max_damage, pct_damage * missing_mana),min_damage)

		t:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

		t:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=stun})
	end
end
