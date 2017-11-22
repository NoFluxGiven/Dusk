shard_magus_glacial_impact = class({})

function shard_magus_glacial_impact:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")

	local t_stun_duration_bonus = self:GetCaster():FetchTalent("special_bonus_shard_magus_5") or 0

	local duration = self:GetSpecialValueFor("stun_duration") + t_stun_duration_bonus
	local radius = self:GetSpecialValueFor("radius")
	local t = self:GetCursorPosition()

	local damage = self:GetSpecialValueFor("damage")
	local base_damage = self:GetSpecialValueFor("base_damage")

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
	{Duration=delay*2},
	t, self:GetCaster():GetTeamNumber(), false)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/glacial_impact_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)

	u:EmitSound("ShardMagus.WyrmRites.Start")

	Timers:CreateTimer(delay, function()

		local f = FindEnemies(self:GetCaster(),t,radius)

		local mult = 1

		for k,v in pairs(f) do
			-- Timers:CreateTimer(0.1*k,function()
				local iradius = self:GetSpecialValueFor("impact_radius")
				local ff = FindEnemies(self:GetCaster(),v:GetAbsOrigin(),iradius)
				local pos = v:GetAbsOrigin()

				if v:IsRealHero() then mult = mult+1 else mult = mult + 0.5 end

				self:InflictDamage(v,self:GetCaster(),base_damage,DAMAGE_TYPE_MAGICAL)

				for kk,vv in pairs(ff) do
					self:InflictDamage(vv,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
					vv:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=duration * mult})
				end

				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/glacial_impact.vpcf", PATTACH_WORLDORIGIN, u)
				ParticleManager:SetParticleControl(p, 0, pos)
				ParticleManager:SetParticleControl(p, 1, Vector(iradius,0,0))
			-- end)
		end

		if mult > 1 then
			u:EmitSound("ShardMagus.GlacialImpact")
			u:EmitSound("Hero_Earthshaker.Fissure")
		end
	end)

end