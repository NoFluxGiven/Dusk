ironfist_quake = class({})

LinkLuaModifier("modifier_quake_hit","lua/abilities/ironfist_quake",LUA_MODIFIER_MOTION_NONE)

if IsServer() then

	function ironfist_quake:OnSpellStart()
		local caster = self:GetCaster()
		local damage = self:GetAbilityDamage()
		local pos = caster:GetAbsOrigin()
		local stun = self:GetSpecialValueFor("stun")
		local radius = self:GetSpecialValueFor("radius")
		local delay = self:GetSpecialValueFor("delay")
		local hits = self:GetSpecialValueFor("hits")

		for i=1,hits do
			Timers:CreateTimer(delay*(i-1),function()
				local found = FindEnemies(caster,pos,radius*i)

				for k,v in pairs(found) do
					self:InflictDamage(v,caster,damage,self:GetAbilityDamageType())
					v:AddNewModifier(caster,self,"modifier_quake_hit",{Duration=2})
				end

				caster:EmitSound("Hero_EarthShaker.Fissure")

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster)
  				ParticleManager:SetParticleControl(particle, 0, pos+Vector(0,0,25))
  				ParticleManager:SetParticleControl(particle, 1, Vector(radius*i,radius*i,radius*i))
			end)
		end
	end

	function ironfist_quake:OnUpgrade()
		local linkedAbilities = {
			"ironfist_dragon_fist",
			"ironfist_lightning_strike",
			-- "ironfist_quake"
		}

		if self.ignoreUpgrade then return end

		for k,v in pairs(linkedAbilities) do
			local ab = self:GetCaster():FindAbilityByName(v)
			local lvl = self:GetLevel()
			if ab then
				ab.ignoreUpgrade = true
				ab:SetLevel(lvl)
				ab.ignoreUpgrade = false
			end
		end
	end

end

modifier_quake_hit = class({})

if IsServer() then

	function modifier_quake_hit:OnCreated(kv)
		self:SetStackCount(1)

		self.stun_time = self:GetAbility():GetSpecialValueFor("stun")
	end

	function modifier_quake_hit:OnRefresh(kv)
		self:SetStackCount(self:GetStackCount()+1)
		if self:GetStackCount() >= 3 then
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {Duration=self.stun_time}) --[[Returns:void
			No Description Set
			]]
			self:Destroy()
		end
	end

end

function modifier_quake_hit:IsHidden()
	return true
end