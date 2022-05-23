reus_magnitude = class({})

LinkLuaModifier("modifier_magnitude","lua/abilities/reus_magnitude",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnitude_slow","lua/abilities/reus_magnitude",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnitude_slow_ally","lua/abilities/reus_magnitude",LUA_MODIFIER_MOTION_NONE)

function reus_magnitude:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Earthshaker.Whoosh")
	return true
end

function reus_magnitude:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	local t_interval_bonus = self:GetCaster():FindTalentValue("special_bonus_reus_4") or 0
	local interval = self:GetSpecialValueFor("quake_interval") + t_interval_bonus
	
	local slow_duration = self:GetSpecialValueFor("slow_duration")

	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_reus_1") or 0
	local damage = self:GetSpecialValueFor("damage") + t_damage_bonus

	CreateModifierThinker( caster, self,
		"modifier_magnitude", {Duration=duration+slow_duration+0.4, aoe=radius, interval=interval, slow_duration=slow_duration, damage=damage}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
end

modifier_magnitude = class({})

function modifier_magnitude:OnCreated(kv)
	if IsServer() then
		self.aoe = kv.aoe
		self.interval = kv.interval
		self.slow_duration = kv.slow_duration
		self.damage = kv.damage

		self:StartIntervalThink(self.interval)
		self:Quake()

		self:GetParent():EmitSound("Hero_Earthshaker.Fissure")

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_reus/reus_magnitude.vpcf", PATTACH_WORLDORIGIN, nil ) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin()) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:SetParticleControl(particle, 1, Vector(self.aoe*1.15,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		Timers:CreateTimer(self:GetDuration()+self.slow_duration,function()
			ParticleManager:DestroyParticle(particle,false)
		end)
	end
end

function modifier_magnitude:Quake()
	if IsServer() then
		if self.aoe then
			local entities = FindEntities(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),self.aoe)

			-- local slow = self:GetAbility():GetSpecialValueFor("slow")
			local duration = self.slow_duration

			local damage = self.damage

			ScreenShake(self:GetParent():GetAbsOrigin(), 500, 5, 1, 1000*1.5, 0, true)

			self:GetParent():EmitSound("Hero_ElderTitan.EarthSplitter.Cast")

			for k,v in pairs(entities) do
				if not v:IsMagicImmune() then
					if v:GetTeam() == self:GetAbility():GetCaster():GetTeam() then
						v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_magnitude_slow_ally", {Duration=duration})
					else
						self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
						v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_magnitude_slow", {Duration=duration})
					end
				end
			end
		end
	end
end

function modifier_magnitude:OnIntervalThink()
	if IsServer() then
		self:Quake()
	end
end

modifier_magnitude_slow = class({})

function modifier_magnitude_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_magnitude_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_magnitude_slow:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

modifier_magnitude_slow_ally = class({})

function modifier_magnitude_slow_ally:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_magnitude_slow_ally:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("ally_slow")
end

function modifier_magnitude_slow_ally:GetModifierAttackSpeedBonus_Constant()
	return -self:GetAbility():GetSpecialValueFor("ally_slow")
end