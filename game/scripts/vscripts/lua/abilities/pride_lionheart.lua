pride_lionheart = class({})

LinkLuaModifier("modifier_lionheart","lua/abilities/pride_lionheart",LUA_MODIFIER_MOTION_NONE)

function pride_lionheart:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lionheart", {Duration=duration})
end

modifier_lionheart = class({})

function modifier_lionheart:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return func
end

function modifier_lionheart:GetModifierAttackSpeedBonus_Constant()
	local value = self:GetAbility():GetSpecialValueFor("bonus_attack_speed") * self:GetStackCount()
	return value
end

function modifier_lionheart:GetModifierMoveSpeedBonus_Percentage()
	local value = self:GetAbility():GetSpecialValueFor("bonus_movespeed") * self:GetStackCount()
	return value
end

function modifier_lionheart:GetModifierIncomingDamage_Percentage()
	local value = -self:GetAbility():GetSpecialValueFor("damage_reduction") * self:GetStackCount()
	return value
end

function modifier_lionheart:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pride/lionheart.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
end

function modifier_lionheart:OnDestroy(kv)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
	end
end

function modifier_lionheart:OnIntervalThink(kv)
	if IsServer() then
		local radius = 700 --self:GetAbility():GetSpecialValueFor("radius")
		local enemies = FindEnemies(self:GetAbility():GetCaster(),
			self:GetAbility():GetCaster():GetAbsOrigin(),
			radius,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSION)

		local n = #enemies

		self:SetStackCount(n+1)

		ParticleManager:SetParticleControl(self.particle, 1, Vector(n,0,0))
	end
end