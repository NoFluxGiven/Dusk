ouroboros_searing_flame = class({})

LinkLuaModifier("modifier_searing_flame","lua/abilities/ouroboros_searing_flame",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_flame_scepter_dot","lua/abilities/ouroboros_searing_flame",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_flame_scepter_dot_display","lua/abilities/ouroboros_searing_flame",LUA_MODIFIER_MOTION_NONE)

function ouroboros_searing_flame:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local t_cast_range_bonus = self:GetCaster():FetchTalent("special_bonus_ouroboros_5") or 0
	local range = self:GetSpecialValueFor("range") + t_cast_range_bonus
	local d = (point - caster:GetAbsOrigin()):Normalized()
	local start_radius = self:GetSpecialValueFor("start_radius")
	local end_radius = self:GetSpecialValueFor("end_radius")
	local speed = self:GetSpecialValueFor("speed")

	local particle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	local sound = "Hero_DragonKnight.BreathFire"

	local data = {
		Ability = self,
		Source = caster,
		EffectName = particle,
		vSpawnOrigin = caster:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1),
		vVelocity = d * speed,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		bHasFrontalCone = true,
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

function ouroboros_searing_flame:GetCastRange()
	local cast_range = self.BaseClass.GetCastRange(self, self:GetCaster():GetAbsOrigin(), self:GetCaster())
	local t_cast_range_bonus = FetchTalent("special_bonus_ouroboros_5") or 0
	return cast_range + t_cast_range_bonus
end

function ouroboros_searing_flame:OnProjectileHit(t,l)
	if IsServer() then
		local caster = self:GetCaster()
		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_ouroboros_3") or 0
		local damage = self:GetSpecialValueFor("damage")+t_damage_bonus
		local dtype = self:GetAbilityDamageType()
		local slow_duration = self:GetSpecialValueFor("slow_duration")

		if t then
			self:InflictDamage(t,caster,damage,dtype)
			t:AddNewModifier(caster, self, "modifier_searing_flame", {Duration = slow_duration}) --[[Returns:void
			No Description Set
			]]
			if caster:HasScepter() then
				local dot_duration = self:GetSpecialValueFor("scepter_dot_duration")
				t:AddNewModifier(caster, self, "modifier_searing_flame_scepter_dot", {Duration = dot_duration})
			end
			return false
		end
	end
end

modifier_searing_flame = class({})

function modifier_searing_flame:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_searing_flame:GetModifierMoveSpeedBonus_Percentage()
	local val = "slow"
	if self:GetAbility():GetCaster():HasScepter() then val = "scepter_slow" end
	return -self:GetAbility():GetSpecialValueFor(val)
end

modifier_searing_flame_scepter_dot = class({})

function modifier_searing_flame_scepter_dot:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_searing_flame_scepter_dot:IsHidden()
	return true
end

function modifier_searing_flame_scepter_dot:IsPurgable()
	return true
end

if IsServer() then

	function modifier_searing_flame_scepter_dot:OnCreated()
		self:StartIntervalThink(0.5)
		local mod = self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_searing_flame_scepter_dot_display", {Duration=self:GetDuration()})

		if mod then
			mod:IncrementStackCount()
		end
	end

	function modifier_searing_flame_scepter_dot:OnDestroy()
		local mod = self:GetParent():FindModifierByName("modifier_searing_flame_scepter_dot_display")

		if mod then
			mod:SetStackCount(mod:GetStackCount()-1)
			if mod:GetStackCount() <= 0 then
				mod:Destroy()
			end
		end
	end

	function modifier_searing_flame_scepter_dot:OnIntervalThink()
		local damage = self:GetAbility():GetSpecialValueFor("scepter_dot")*0.5 --[[Returns:table
		No Description Set
		]]
		local parent = self:GetParent()

		self:GetAbility():InflictDamage(parent,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	end

end

modifier_searing_flame_scepter_dot_display = class({})