shard_magus_cryst_whorl = class({})

LinkLuaModifier("modifier_cryst_whorl","lua/abilities/shard_magus_cryst_whorl",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cryst_whorl_damage","lua/abilities/shard_magus_cryst_whorl",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cryst_whorl_slow","lua/abilities/shard_magus_cryst_whorl",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cryst_whorl_stun","lua/abilities/shard_magus_cryst_whorl",LUA_MODIFIER_MOTION_NONE)

MODE_GRACE = 0
-- MODE_DAMAGE = 0
MODE_SLOW = 1
MODE_STUN = 2

function shard_magus_cryst_whorl:GetCooldown()
	local base_cooldown = self.BaseClass.GetCooldown(self, self:GetLevel())
	local t_cd_reduc = self:GetCaster():FetchTalent("special_bonus_shard_magus_4") or 0
	return base_cooldown - t_cd_reduc
end

function shard_magus_cryst_whorl:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_shard_magus_1") or 0

	local damage = self:GetSpecialValueFor("initial_damage") + t_damage_bonus

	local f = FindEnemies(self:GetCaster(),t,radius)

	for k,v in pairs(f) do
		v:AddNewModifier(self:GetCaster(), self, "modifier_cryst_whorl", {Duration=duration})
		self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	end

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
		{Duration=2.25},
		t, self:GetCaster():GetTeamNumber(), false)

	u:EmitSound("Ability.FrostNova")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/cryst_whorl.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)

	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))
end

modifier_cryst_whorl = class({})

function modifier_cryst_whorl:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cryst_whorl:OnCreated()
	local interval = self:GetAbility():GetSpecialValueFor("interval")
	if IsServer() then
		self.mode = 0
		self:StartIntervalThink(interval)
	end
end

function modifier_cryst_whorl:OnIntervalThink()
	if IsServer() then
		-- apply modifiers in mode order

		self.mode = self.mode+1

		local duration = self:GetAbility():GetSpecialValueFor("phase_duration")

		-- if self.mode == MODE_DAMAGE then
		-- 	self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_cryst_whorl_damage", {Duration=duration})
		-- 	print("DAMAGE MODE")
		-- end
		if self.mode == MODE_SLOW then
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_cryst_whorl_slow", {Duration=duration})
			print("SLOW MODE")
		end
		if self.mode == MODE_STUN then
			self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortexCast")
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_cryst_whorl_stun", {Duration=duration})
			print("STUN MODE")
		end

		self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

		local full_duration = self:GetAbility():GetSpecialValueFor("duration")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local interval = self:GetAbility():GetSpecialValueFor("interval")

		damage = (damage / full_duration) * interval

		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

		ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/cryst_whorl_unit_next.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/cryst_whorl_unit_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

	end
end

function modifier_cryst_whorl:GetEffectName()
	return "particles/units/heroes/hero_shard_magus/cryst_whorl_unit.vpcf"
end

modifier_cryst_whorl_damage = class({})

function modifier_cryst_whorl_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cryst_whorl_damage:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.50)
	end
end

function modifier_cryst_whorl_damage:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local duration = self:GetAbility():GetSpecialValueFor("phase_duration")

	local damage = (damage/duration)*0.50

	ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/cryst_whorl_unit_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
	Creates a new particle effect
	]]

	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

	self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
end

function modifier_cryst_whorl_damage:IsHidden()
	return true
end

modifier_cryst_whorl_slow = class({})

function modifier_cryst_whorl_slow:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cryst_whorl_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_cryst_whorl_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_cryst_whorl_slow:IsHidden()
	return true
end

modifier_cryst_whorl_stun = class({})

function modifier_cryst_whorl_stun:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cryst_whorl_stun:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_cryst_whorl_stun:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_cryst_whorl_stun:IsStunDebuff()
	return true
end

function modifier_cryst_whorl_stun:IsHidden()
	return true
end