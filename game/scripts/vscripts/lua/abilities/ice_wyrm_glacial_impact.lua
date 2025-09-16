LinkLuaModifier("modifier_glacial_impact","lua/abilities/ice_wyrm_glacial_impact",LUA_MODIFIER_MOTION_NONE)

ice_wyrm_glacial_impact = class({})

function ice_wyrm_glacial_impact:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")

	local t_stun_bonus = self:GetCaster():FindTalentValue("special_bonus_shard_magus_5") or 0
	local duration = self:GetSpecialValueFor("stun_duration") + t_stun_bonus
	local debuff_duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")

	local f = FindEnemies(self:GetCaster(),t,radius)

	for k,v in pairs(f) do
		self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration=duration})
		v:AddNewModifier(self:GetCaster(), self, "modifier_glacial_impact", {Duration=40})
	end

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
	{Duration=2.25},
	t, self:GetCaster():GetTeamNumber(), false)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/glacial_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	u:EmitSound("ShardMagus.GlacialImpact")

end

modifier_glacial_impact = class({})

function modifier_glacial_impact:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_glacial_impact:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("movement_slow")
end