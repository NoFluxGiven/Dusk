item_wand_of_yggdrasil = class({})

LinkLuaModifier("modifier_yggdrasil","lua/items/item_wand_of_yggdrasil",LUA_MODIFIER_MOTION_NONE)

function item_wand_of_yggdrasil:GetIntrinsicModifierName()
	return "modifier_yggdrasil"
end

function item_wand_of_yggdrasil:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		local caster_team = caster:GetTeam()
		local target_team = target:GetTeam()

		if target:TriggerSpellAbsorb(self) then return end

		-- local is_ally = caster_team == target_team

		local delay = self:GetSpecialValueFor("delay")

		local base_hp_drain = self:GetSpecialValueFor("hp_drain")
		local base_mp_drain = self:GetSpecialValueFor("mp_drain")

		local pct_hp_drain = self:GetSpecialValueFor("hp_percent_drain") / 100
		local pct_mp_drain = self:GetSpecialValueFor("mp_percent_drain") / 100

		local hp = target:GetMaxHealth()
		local mp = target:GetMaxMana()

		local hp_drain = base_hp_drain + ( hp * pct_hp_drain )
		local mp_drain = base_mp_drain + ( mp * pct_mp_drain )

		if target:IsRoshan() then
			hp_drain = hp_drain / 2
			mp_drain = 0
		end

		local ed = {hpd = hp_drain, mpd = mp_drain}

		-- local info = 
		--   {
		--   Target = caster,
		--   Source = target,
		--   Ability = self,  
		--   EffectName = "particles/items/yggdrasil_drain_proj.vpcf",
		--   vSpawnOrigin = target:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_HITLOCATION),
		--   fDistance = 20000,
		--   fStartRadius = 75,
		--   fEndRadius = 75,
		--   bHasFrontalCone = false,
		--   bReplaceExisting = false,
		--   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		--   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		--   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		--   fExpireTime = GameRules:GetGameTime() + 10.0,
		--   bDeleteOnHit = true,
		--   iMoveSpeed = 2000,
		--   bDodgable = false,
		--   bProvidesVision = true,
		--   iVisionRadius = 275,
		--   iVisionTeamNumber = caster:GetTeamNumber(),
		--   iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		--   ExtraData = ed
		--   }

		-- local projectile = ProjectileManager:CreateTrackingProjectile(info)

		self:InflictDamage(target,caster,hp_drain,DAMAGE_TYPE_PURE)
		target:ReduceMana(mp_drain)

		ParticleManager:CreateParticle("particles/items/yggdrasil_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		target:EmitSound("Yggdrasil.Drain.Target")

		Timers:CreateTimer(delay,function()
			caster:Heal(hp_drain,t)
			caster:GiveMana(mp_drain)

			caster:EmitSound("Yggdrasil.Drain")

			ParticleManager:CreateParticle("particles/items/improved_magic_wand.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end)
	end
end

-- function item_wand_of_yggdrasil:OnProjectileHit( t, l )
-- 	if IsServer() then
-- 		print("HIT")
-- 		if t then
-- 				local hp_drain = 100
-- 				local mp_drain = 100

-- 				t:Heal(hp_drain, t)
-- 				t:GiveMana(mp_drain)

-- 				target:EmitSound("Yggdrasil.Drain")

-- 				ParticleManager:CreateParticle("particles/items/improved_magic_wand.vpcf", PATTACH_ABSORIGIN_FOLLOW, t)
-- 		end
-- 	end
-- end

modifier_yggdrasil = class({})

function modifier_yggdrasil:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_yggdrasil:IsHidden()
	return true
end

function modifier_yggdrasil:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return func
end

function modifier_yggdrasil:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_yggdrasil:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_yggdrasil:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_yggdrasil:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_yggdrasil:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_yggdrasil:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_yggdrasil:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end