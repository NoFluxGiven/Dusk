fate_realign = class({})

function fate_realign:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("shock_radius")

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_fate_3") or 0

		local damage = self:GetSpecialValueFor("damage")

		local enemies = FindEnemies(caster,caster:GetAbsOrigin(),radius)
		local allies = FindAllies(caster,caster:GetAbsOrigin(),radius)

		for k,v in pairs(enemies) do
			Timers:CreateTimer(k*0.1,function()
				v:EmitSound("Fate.Realign.Target")
				self:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
				CreateParticleHitloc(v,"particles/units/heroes/hero_fate/fate_realign.vpcf")
			end)
		end

		for k,v in pairs(allies) do
			Timers:CreateTimer(k*0.1,function()
				v:EmitSound("Fate.Realign.Target")
				v:Heal(damage, caster)
				CreateParticleHitloc(v,"particles/units/heroes/hero_fate/fate_realign.vpcf")
			end)
		end
	end
end