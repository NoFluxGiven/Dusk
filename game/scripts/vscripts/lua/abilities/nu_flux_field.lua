nu_flux_field = class({})

LinkLuaModifier("modifier_flux_field","lua/abilities/nu_flux_field",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flux_field_aura","lua/abilities/nu_flux_field",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flux_field_thinker","lua/abilities/nu_flux_field",LUA_MODIFIER_MOTION_NONE)

function nu_flux_field:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_nu_2") or 0
	local damage = self:GetSpecialValueFor("damage_over_time") + t_damage_bonus
	local cast_damage = self:GetSpecialValueFor("damage_per_spell")
	local duration = self:GetSpecialValueFor("duration")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	local fx = CreateModifierThinker( caster, self, "modifier_flux_field_thinker", {Duration=duration,radius=radius,damage=damage,cast_damage=cast_damage,stun_duration=stun_duration}, target, caster:GetTeamNumber(), false )
	fx:EmitSound("Nu.FluxField")
end

modifier_flux_field_thinker = class({})

function modifier_flux_field_thinker:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.damage = kv.damage
		self.cast_damage = kv.cast_damage
		self.stun_duration = kv.stun_duration

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/flux_field.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius,0,0))

		self:AddParticle( self.particle, false, false, 10, false, false )
	end
end

function modifier_flux_field_thinker:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end

function modifier_flux_field_thinker:OnAbilityFullyCast(params)
	if IsServer() then
		local caster = params.unit

		if caster:HasModifier("modifier_flux_field_aura") then
			local damage = self:GetAbility():GetSpecialValueFor("damage_per_cast")
			local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),FIND_UNITS_EVERYWHERE)

			local radius = self:GetAbility():GetSpecialValueFor("radius")

			local stun = self.stun_duration

			if params.ability:GetManaCost(params.ability:GetLevel()) > 0 then

				for k,v in pairs(enemies) do
					if v:HasModifier("modifier_flux_field_aura") then
						local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nu/flux_field_cast_damage.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,25))
						ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))
						self:GetParent():EmitSound("Nu.FluxField.Cast.Damage")
						self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
						v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {Duration=stun}) 
					end
				end

				ParticleManager:DestroyParticle(self.particle, true)
				self:Destroy()

			end
		end

	end
end

function modifier_flux_field_thinker:IsAura()
	return true
end

function modifier_flux_field_thinker:GetAuraRadius()
	if IsServer() then
		return self.radius
	end
end

function modifier_flux_field_thinker:GetAuraDuration()
	return 0.1
end

function modifier_flux_field_thinker:GetAuraSearchFlags()
	return 0
end

function modifier_flux_field_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_flux_field_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_flux_field_thinker:GetModifierAura()
	return "modifier_flux_field_aura"
end

modifier_flux_field_aura = class({})

function modifier_flux_field_aura:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_flux_field_aura:OnIntervalThink()
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor("damage_over_time")
		local t_damage_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_nu_2") or 0

		damage = damage + t_damage_bonus
		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	end
end