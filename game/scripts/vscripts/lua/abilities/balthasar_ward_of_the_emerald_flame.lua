balthasar_ward_of_the_emerald_flame = class({})

LinkLuaModifier("modifier_ward_of_the_emerald_flame_aura","lua/abilities/balthasar_ward_of_the_emerald_flame",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ward_of_the_emerald_flame_buff","lua/abilities/balthasar_ward_of_the_emerald_flame",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ward_of_the_emerald_flame_truesight_aura","lua/abilities/balthasar_ward_of_the_emerald_flame",LUA_MODIFIER_MOTION_NONE)

function balthasar_ward_of_the_emerald_flame:OnSpellStart()
	if IsServer() then

		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local t_radius_bonus = caster:FindTalentValue("special_bonus_balthasar_3") or 0
		local duration = self:GetSpecialValueFor("duration")
		local pos = self:GetCursorPosition()
		local caster_pos = caster:GetAbsOrigin()

		local offset = Vector(0,0,170)

		radius = radius + t_radius_bonus

		pos = pos + offset

		local thinker = CreateModifierThinker( caster, self, "modifier_ward_of_the_emerald_flame_aura",
			{Duration=duration},
			pos, caster:GetTeamNumber(), false)

		thinker:AddNewModifier(caster, self, "modifier_ward_of_the_emerald_flame_truesight_aura", {Duration=duration})

		AddFOWViewer( caster:GetTeamNumber(), thinker:GetAbsOrigin(), radius, duration, false )

		GridNav:DestroyTreesAroundPoint( pos, radius/2, false )

		thinker:EmitSound("Balthasar.Ward.Ambience")
	end
end

modifier_ward_of_the_emerald_flame_aura = class({})

function modifier_ward_of_the_emerald_flame_aura:OnCreated(kv)
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_balthasar/ward_of_the_emerald_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle( p, false, false, 10, false, false )
end

function modifier_ward_of_the_emerald_flame_aura:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Balthasar.Ward.Ambience")
	end
end

function modifier_ward_of_the_emerald_flame_aura:IsAura()
	return true
end

function modifier_ward_of_the_emerald_flame_aura:GetAuraRadius()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local t_radius_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_balthasar_3") or 0

	radius = radius + t_radius_bonus

	return radius
end

function modifier_ward_of_the_emerald_flame_aura:GetAuraSearchFlags()
	return 0
end

function modifier_ward_of_the_emerald_flame_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ward_of_the_emerald_flame_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_ward_of_the_emerald_flame_aura:GetAuraDuration()
	return 1.0
end

function modifier_ward_of_the_emerald_flame_aura:GetModifierAura()
	return "modifier_ward_of_the_emerald_flame_buff"
end

function modifier_ward_of_the_emerald_flame_aura:IsPurgable()
	return false
end

function modifier_ward_of_the_emerald_flame_aura:IsHidden()
	return true
end

modifier_ward_of_the_emerald_flame_truesight_aura = class({})

function modifier_ward_of_the_emerald_flame_truesight_aura:IsAura()
	return true
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetAuraRadius()
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local t_radius_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_balthasar_3") or 0

	radius = radius + t_radius_bonus

	return radius
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetAuraSearchFlags()
	return 0
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetAuraDuration()
	return 1.0
end

function modifier_ward_of_the_emerald_flame_truesight_aura:GetModifierAura()
	return "modifier_truesight"
end

function modifier_ward_of_the_emerald_flame_truesight_aura:IsPurgable()
	return false
end

function modifier_ward_of_the_emerald_flame_truesight_aura:IsHidden()
	return true
end

modifier_ward_of_the_emerald_flame_buff = class({})

function modifier_ward_of_the_emerald_flame_buff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_ward_of_the_emerald_flame_buff:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_ward_of_the_emerald_flame_buff:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("damage")

	self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
end

function modifier_ward_of_the_emerald_flame_buff:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	if not self:GetParent():IsInvisible() then
		slow = slow/4
	end
	return -slow
end

