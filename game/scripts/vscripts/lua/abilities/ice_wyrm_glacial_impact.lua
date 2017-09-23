ice_wyrm_glacial_impact = class({})

function ice_wyrm_glacial_impact:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")
	local duration = self:GetSpecialValueFor("stun_duration")
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")

	Timers:CreateTimer(delay, function()

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
	end)

end