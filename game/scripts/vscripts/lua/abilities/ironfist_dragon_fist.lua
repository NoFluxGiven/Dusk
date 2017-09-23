ironfist_dragon_fist = class({})

if IsServer() then

	function ironfist_dragon_fist:OnAbilityPhaseStart()
		self.start_up_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ironfist/ironfist_dragon_fist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster()) --[[Returns:int
		Creates a new particle effect
		]]
		self.start_up_particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_ironfist/ironfist_dragon_fist_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self:GetCaster():EmitSound("Ironfist.DragonFist.StartUp")
		return true
	end

	function ironfist_dragon_fist:OnAbilityPhaseInterrupted()
		if self.start_up_particle then
			ParticleManager:DestroyParticle(self.start_up_particle,false)
			ParticleManager:DestroyParticle(self.start_up_particle2,false)
		end
		self:GetCaster():StopSound("Ironfist.DragonFist.StartUp")
		return true
	end

	function ironfist_dragon_fist:OnSpellStart()
			local c = self:GetCaster()
			local t = self:GetCursorTarget()
			local d = self:GetSpecialValueFor("damage")

			if talent then d = d + talent end

			local dtype = self:GetAbilityDamageType()
			local s = self:GetSpecialValueFor("stun")

			local focus_mod = c:FindModifierByName("modifier_focus")

			local stack
			if focus_mod then
				stack = focus_mod:GetStackCount()
				if stack > 0 then
					local dbonus = stack * focus_mod:GetAbility():GetSpecialValueFor("damage_bonus")
					d = d + dbonus
				end
			end

			self:InflictDamage(t,c,d,dtype)
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_ironfist/ironfist_dragon_fist_caster_end.vpcf", PATTACH_POINT_FOLLOW, c) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleAttachPoint(p,c,"attach_hitloc")
			local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_ironfist/ironfist_dragon_fist_target.vpcf", PATTACH_POINT_FOLLOW, t) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleAttachPoint(p2,t,"attach_hitloc")
			ParticleManager:SetParticleControl(p2, 1, c:GetCenter()) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			ScreenShake(t:GetCenter(), 1000, 3, 0.75, 1500, 0, true)
			t:EmitSound("Ironfist.DragonFist.Strike")
			t:AddNewModifier(c,self,"modifier_stunned",{Duration=s})
	end

	function ironfist_dragon_fist:OnUpgrade()
		local linkedAbilities = {
			-- "ironfist_dragon_fist",
			"ironfist_lightning_strike",
			"ironfist_quake"
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