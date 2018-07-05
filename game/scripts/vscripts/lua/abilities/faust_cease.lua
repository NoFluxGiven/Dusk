faust_cease = class({})

LinkLuaModifier("modifier_cease_root","lua/abilities/faust_cease",LUA_MODIFIER_MOTION_NONE)

function faust_cease:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local particle = "particles/units/heroes/hero_faust/cease_proj.vpcf"
		local radius = self:GetSpecialValueFor("radius")
		local speed = self:GetSpecialValueFor("speed")
		local point = self:GetCursorPosition()
		local caster_pos = caster:GetAbsOrigin()
		local distance = 1250
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
		caster:EmitSound("Faust.Cease.Projectile")
	end
end

function faust_cease:OnProjectileHit(t, l)
	if IsServer() then
		if t then -- a target has been hit
			local damage = self:GetSpecialValueFor("damage")
			local root = self:GetSpecialValueFor("root")
			t:AddNewModifier(self:GetCaster(), self, "modifier_cease_root", {Duration=root})
			t:EmitSound("Faust.Cease")
		end
	end
end

modifier_cease_root = class({})

function modifier_cease_root:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_cease_root:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_cease_root:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

function modifier_cease_root:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end

function modifier_cease_root:OnIntervalThink()
	local t = self:GetParent()
	local damage_total = self:GetAbility():GetSpecialValueFor("damage")
	local duration = self:GetDuration()
	local interval = 0.25
	local procs = duration/interval

	local damage = damage_total / procs
	self:GetAbility():InflictDamage(t, self:GetAbility():GetCaster(), damage, DAMAGE_TYPE_MAGICAL)
end

function modifier_cease_root:GetEffectName()
	return "particles/units/heroes/hero_faust/cease_debuff.vpcf"
end