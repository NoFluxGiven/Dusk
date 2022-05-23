tek_skycrack = class({})

LinkLuaModifier("modifier_skycrack","lua/abilities/tek_skycrack",LUA_MODIFIER_MOTION_NONE)

function tek_skycrack:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local s = self:GetCaster():HasScepter()
	local cooldown = base_cooldown
	if s then cooldown = self:GetSpecialValueFor("scepter_cooldown") end
	return cooldown
end

function tek_skycrack:OnSpellStart()
	local caster = self:GetCaster()
	local rng = self:GetSpecialValueFor("range")

	local particle = "particles/units/heroes/hero_tek/skycrack.vpcf"

	local pos = caster:GetCenter()
	local target = pos+ caster:GetForwardVector() * rng + Vector(0,0,80) -- position
	local start = pos+ caster:GetForwardVector() * 40 + Vector(0,0,80)

	caster:EmitSound("Hero_Leshrac.Lightning_Storm")

	local p = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 0, start) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, target) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/skycrack_eff.vpcf", PATTACH_ROOTBONE_FOLLOW, caster)

	local info = 
	{
		Ability = self,
    	vSpawnOrigin = pos,
    	fDistance = rng-30,
    	fStartRadius = 80,
    	fEndRadius = 80,
    	Source = caster,
    	bHasFrontalCone = false,
    	bReplaceExisting = false,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * rng * 6,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(info) --[[Returns:int
	Creates a linear projectile and returns the projectile ID
	]]
end

function tek_skycrack:OnProjectileHit(t,l)
	local c = self:GetCaster()
	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_tek_1") or 0
	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
	local slow_duration = self:GetSpecialValueFor("duration")
	if t then
		if c:HasScepter() then
			local mana_burn = self:GetSpecialValueFor("scepter_burn")/100
			t:ReduceMana(mana_burn*damage)
		end
		self:InflictDamage(t,c,damage,DAMAGE_TYPE_MAGICAL)
		t:AddNewModifier(c, self, "modifier_skycrack", {Duration=slow_duration})
	end
end

modifier_skycrack = class({})

function modifier_skycrack:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_skycrack:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end