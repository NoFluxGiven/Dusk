baal_compress = class({})

LinkLuaModifier("modifier_compress","lua/abilities/baal_compress",LUA_MODIFIER_MOTION_NONE)

function baal_compress:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end
	target:TriggerSpellReflect(self)

	local duration = self:GetSpecialValueFor("duration")

	local ab1 = self
	local ab2 = caster:FindAbilityByName("baal_fire")

	target.compress_follow = caster

	target:EmitSound("Hero_Dark_Seer.Vacuum")

	if caster.compress_active then
		table.insert(caster.compress_active,target)
	else
		caster.compress_active = {
			target
		}
	end

	target:Interrupt()

	target:AddNewModifier(caster, self, "modifier_compress", {Duration = duration}) --[[Returns:void
	No Description Set
	]]

	local info = 
	  {
	  Target = caster,
	  Source = target,
	  Ability = self,
	  EffectName = "particles/units/heroes/hero_baal/baal_compress_projectile2.vpcf",
	  vSpawnOrigin = target:GetAbsOrigin(),
	  fDistance = 2500,
	  fStartRadius = 64,
	  fEndRadius = 64,
	  bHasFrontalCone = false,
	  bReplaceExisting = false,
	  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
	  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	  iUnitTargetType = DOTA_UNIT_TARGET_ALL,
	  fExpireTime = GameRules:GetGameTime() + 10.0,
	  bDeleteOnHit = true,
	  iMoveSpeed = 950,
	  bProvidesVision = false,
	  iVisionRadius = 0,
	  iVisionTeamNumber = caster:GetTeamNumber(),
	  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	  }

	ab1:SetHidden(true)
	ab2:SetHidden(false)
	ab2:SetLevel(ab1:GetLevel())

	ProjectileManager:CreateTrackingProjectile(info) --[[Returns:int
	Creates a linear projectile and returns the projectile ID
	]]
end

function baal_compress:CastFilterResultTarget( hTarget )
	if self:GetCaster():GetTeam() ~= hTarget:GetTeam() then
		return UF_FAIL_CUSTOM
	end

	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
 
	return UF_SUCCESS
end
 
function baal_compress:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster():GetTeam() ~= hTarget:GetTeam() then
		return "#dota_hud_error_cant_cast_on_enemies"
	end

	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
 
	return ""
end

function baal_compress:GetCastRange()
	if IsServer() then
		local bonus = 0
		if self:GetCaster():GetHasTalent("special_bonus_baal_compress") then
			bonus = 175
		end
		return 275 + bonus
	end
end

modifier_compress = class({})

function modifier_compress:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
	return state
end

function modifier_compress:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetAbility():GetCaster()

		target:AddNoDraw()

		self:StartIntervalThink(0.03)
	end
end

function modifier_compress:OnIntervalThink()
	if IsServer() then
		local target = self:GetParent()
		if target.compress_follow then
			target:SetAbsOrigin(target.compress_follow:GetAbsOrigin())
		end
	end
end

function modifier_compress:OnDestroy()
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetAbility():GetCaster()

		local ab1 = self:GetAbility()
		local ab2 = self:GetAbility():GetCaster():FindAbilityByName("baal_fire")

		local max_d = self:GetAbility():GetSpecialValueFor("radius")

		local o = self:GetParent():GetAbsOrigin() + caster:GetForwardVector() * max_d

		ab1:SetHidden(false)
		ab2:SetHidden(true)

		ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_compress_explosion_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]

		FindClearSpaceForUnit(target, o, true)

		target:EmitSound("Hero_Dark_Seer.Wall_of_Replica_Start")

		target:RemoveNoDraw()

		target.compress_follow = nil
		caster.compress_active = nil
	end
end