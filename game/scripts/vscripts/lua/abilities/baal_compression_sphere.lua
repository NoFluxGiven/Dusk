baal_compression_sphere = class({})

-- LinkLuaModifier("modifier_compression_sphere_cooldown","lua/abilities/baal_compression_sphere",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_compression_sphere","lua/abilities/baal_compression_sphere",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_compression_sphere_aura","lua/abilities/baal_compression_sphere",LUA_MODIFIER_MOTION_NONE)

function baal_compression_sphere:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	local t = CreateModifierThinker( caster, self, "modifier_compression_sphere",
		{Duration=duration+0.25},
		point, caster:GetTeamNumber(), false)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_compression_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, t) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	t:EmitSound("Baal.CompressionSphere")

	t.part = p
end

modifier_compression_sphere = class({})

function modifier_compression_sphere:IsAura()
	return true
end

function modifier_compression_sphere:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_compression_sphere:GetAuraDuration()
	return 0.5
end

function modifier_compression_sphere:GetAuraSearchFlags()
	return 0
end

function modifier_compression_sphere:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_compression_sphere:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_compression_sphere:GetModifierAura()
	return "modifier_compression_sphere_aura"
end

if IsServer() then

	function modifier_compression_sphere:OnCreated()
		self:StartIntervalThink(7.90)
	end

	function modifier_compression_sphere:OnIntervalThink()
		if self:GetParent().part then
			ParticleManager:DestroyParticle(self:GetParent().part,false)
		end
	end
	
end

-- modifier_compression_sphere_cooldown = class({})
modifier_compression_sphere_aura = class({})

function modifier_compression_sphere_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
	return funcs
end

if IsServer() then

	function modifier_compression_sphere_aura:OnCreated(kv)
		self:StartIntervalThink(0.5)
	end

	function modifier_compression_sphere_aura:OnIntervalThink()
		self:IncrementStackCount()

		local t_dps = self:GetAbility():GetCaster():FindTalentValue("special_bonus_baal_5")

		if t_dps then
			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),t_dps/2,DAMAGE_TYPE_MAGICAL)
		end
	end

end

function modifier_compression_sphere_aura:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("move_slow")
	local stack = self:GetStackCount()

	return stack*bonus
end

function modifier_compression_sphere_aura:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetSpecialValueFor("attack_slow")
	local stack = self:GetStackCount()

	return stack*bonus
end

function modifier_compression_sphere_aura:GetModifierTurnRate_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("turn_slow")
	local stack = self:GetStackCount()

	return stack*bonus
end