reus_stoneblast = class({})

function reus_stoneblast:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Earthshaker.Whoosh")
	return true
end

function reus_stoneblast:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local d = caster:GetForwardVector()
	local speed = self:GetSpecialValueFor("speed")
	local range = self:GetSpecialValueFor("range")
	local radius = self:GetSpecialValueFor("radius")

	local start_radius,end_radius = radius,radius

	local sound = "Hero_EarthSpirit.BoulderSmash.Target"
	local particle = "particles/units/heroes/hero_reus/reus_stoneblast.vpcf"

	local data = {
		Ability = self,
		Source = caster,
		EffectName = particle,
		vSpawnOrigin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1),
		vVelocity = d * speed,
		fDistance = range,
		fStartRadius = radius,
		fEndRadius = radius,
		bHasFrontalCone = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = 0,
		bProvidesVision = false,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = 0,
		bDrawsOnMinimap = false,
		bVisibleToEnemies = true,
		fExpireTime = GameRules:GetGameTime()+10,
		bDeleteOnHit = false
	}

	caster:EmitSound(sound)

	ProjectileManager:CreateLinearProjectile(data)
end

function reus_stoneblast:OnProjectileHit(t,l)
	if t then
		local stun = self:GetSpecialValueFor("stun")

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_reus_3") or 0
		local damage = self:GetSpecialValueFor("damage") + t_damage_bonus
		t:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration=stun})
		self:InflictDamage(t,self:GetCaster(),damage,DAMAGE_TYPE_PHYSICAL)
		t:EmitSound("Hero_EarthSpirit.BoulderSmash.Damage")
	end
end