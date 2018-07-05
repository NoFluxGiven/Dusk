ice_wyrm_glacial_impact = class({})

function ice_wyrm_glacial_impact:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")

	local t_stun_bonus = self:GetCaster():FetchTalent("special_bonus_shard_magus_5") or 0
	local duration = self:GetSpecialValueFor("stun_duration") + t_stun_bonus
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")

	local f = FindEnemies(self:GetCaster(),t,radius)

	for k,v in pairs(f) do
		self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {Duration=duration})
	end

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
	{Duration=2.25},
	t, self:GetCaster():GetTeamNumber(), false)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/glacial_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	u:EmitSound("ShardMagus.GlacialImpact")

end