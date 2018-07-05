balthasar_firebolt = class({})

LinkLuaModifier("modifier_firebolt","lua/abilities/balthasar_firebolt",LUA_MODIFIER_MOTION_NONE)

function balthasar_firebolt:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_balthasar_4") or 0
	return base_cooldown - t_cooldown_reduction
end

function balthasar_firebolt:OnSpellStart()
	local c = self:GetCaster()
	local t = self:GetCursorTarget()

			local info = 
			  {
			  Target = t,
			  Source = c,
			  Ability = self,  
			  EffectName = "particles/units/heroes/hero_balthasar/will_o_wisp_base_attack.vpcf",
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
			  iMoveSpeed = 2000,
			  bProvidesVision = false,
			  iVisionRadius = 0,
			  iVisionTeamNumber = c:GetTeamNumber(),
			  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			  }
		  
		  	local projectile = ProjectileManager:CreateTrackingProjectile(info)
		  	c:EmitSound("Balthasar.Firebolt")

end

function balthasar_firebolt:OnProjectileHit(t,l)
	if t then
		local damage = self:GetSpecialValueFor("base_damage")
		local adamage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
		local pct = self:GetSpecialValueFor("attack_damage") / 100

		damage = damage

		local duration = self:GetSpecialValueFor("duration")

		self:InflictDamage(t, self:GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
		t:AddNewModifier(self:GetCaster(), self, "modifier_firebolt", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		t:EmitSound("Balthasar.Firebolt.Target")
	end
end

modifier_firebolt = class({})

function modifier_firebolt:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_firebolt:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("dot")
	local bonus = self:GetParent():FindModifierByName("modifier_emerald_fang")
	if bonus then
		bonus = bonus:GetAbility():GetSpecialValueFor("bonus_spell_damage") / 100
		damage = damage * (1+bonus)
	end
	self:GetAbility():InflictDamage(self:GetParent(), self:GetAbility():GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
end