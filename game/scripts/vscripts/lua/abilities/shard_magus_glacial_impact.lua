shard_magus_glacial_impact = class({})

function shard_magus_glacial_impact:OnSpellStart()

	local pos = self:GetCursorPosition()

	local t_stun_duration_bonus = self:GetCaster():FetchTalent("special_bonus_shard_magus_5") or 0

	local duration = self:GetSpecialValueFor("stun_duration")
	local b_duration = self:GetSpecialValueFor("stun_duration") * t_stun_duration_bonus
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
	{Duration=0.6},
	t, self:GetCaster():GetTeamNumber(), false)

	u:EmitSound("ShardMagus.GlacialImpact")
	u:EmitSound("Hero_Earthshaker.Fissure")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/glacial_impact.vpcf", PATTACH_WORLDORIGIN, u)
	ParticleManager:SetParticleControl(p, 0, pos)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	local f = FindEnemies(self:GetCaster(),t,radius)

	local bf = {}

	if b_duration > 0 then
		bf = FindEnemies(self:GetCaster(),t,radius,DOTA_UNIT_TARGET_BUILDING)
	end



	for k,v in pairs(f) do
		if not v:IsMagicImmune() then
			self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
			v:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=duration})
		end
	end

	if bf then
		for k,b in pairs(bf) do
			self:InflictDamage(b,self:GetCaster(),damage * 0.5,DAMAGE_TYPE_MAGICAL)
			b:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=b_duration})
		end
	end

			

end