aether_monolith = class({})

LinkLuaModifier("modifier_monolith_speed_area","lua/abilities/aether_monolith",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monolith_slow_area","lua/abilities/aether_monolith",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monolith_speed_unit","lua/abilities/aether_monolith",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monolith_slow_unit","lua/abilities/aether_monolith",LUA_MODIFIER_MOTION_NONE)

function aether_monolith:CastFilterResultLocation( loc )
	if IsServer() then
		local min_radius = self:GetSpecialValueFor("min_placement_radius_buffer_scepter") --[[Returns:table
		No Description Set
		]]
		local found = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
			                              loc,
			                              nil,
		                                min_radius,
		                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		                                DOTA_UNIT_TARGET_ALL,
		                                DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		                                FIND_ANY_ORDER,
		                                false)

		for k,v in pairs(found) do
			if v:HasModifier("modifier_monolith_slow_area") then
				return UF_FAIL_CUSTOM
			end
		end

		return UF_SUCCESS
	end
end

function aether_monolith:GetCustomCastErrorLocation( loc )

	local min_radius = self:GetSpecialValueFor("min_placement_radius_buffer_scepter") --[[Returns:table
	No Description Set
	]]
	local found_2 = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
		                              loc,
		                              nil,
	                                min_radius,
	                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                                DOTA_UNIT_TARGET_ALL,
	                                DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	                                FIND_ANY_ORDER,
	                                false)

	for k,v in pairs(found_2) do
		if v:HasModifier("modifier_monolith_slow_area") then
			return "#dusk_hud_error_monolith_min_radius"
		end
	end

	return ""

end

function aether_monolith:GetCooldown()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	end
	return self.BaseClass.GetCooldown( self, self:GetLevel() )
end

function aether_monolith:CreateMonolith( pos )
	-- Handles creation of Monoliths and removal of old Monoliths
	local caster = self:GetCaster()
	local target = pos

	local time = self:GetSpecialValueFor("monolith_time")

	local max_monolith = 1

	if caster:HasScepter() then
		max_monolith = 3
	end

	if not caster.monolith_table then
		caster.monolith_table = {}
	end

	local unit = FastDummy(target+Vector(0,0,60),caster:GetTeam(),time,350)

	table.insert(caster.monolith_table,unit)

	if #caster.monolith_table > max_monolith then
		local dest = table.remove(caster.monolith_table,1)

		if IsValidEntity(dest) then
			dest:ForceKill(true)
			dest:RemoveSelf()
		end
	end

	unit:SetOwner(caster)

	caster:EmitSound("Hero_Wisp.Spirits.Cast")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_aether/aether_monolith.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, unit:GetAbsOrigin()+Vector(0,0,250)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_aether/aether_monolith_start.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p2, 0, unit:GetAbsOrigin()+Vector(0,0,250)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	unit:AddNewModifier(caster, self, "modifier_monolith_speed_area", {}) --[[Returns:void
	No Description Set
	]]
	unit:AddNewModifier(caster, self, "modifier_monolith_slow_area", {}) --[[Returns:void
	No Description Set
	]]

	unit:AddAbility("aether_disrupt")

	unit:FindAbilityByName("aether_disrupt"):SetLevel(caster:FindAbilityByName("aether_disrupt"):GetLevel()+1)
end

function aether_monolith:OnSpellStart()
	self:CreateMonolith( self:GetCaster():GetCursorPosition() )
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_monolith_speed_area = class({})

function modifier_monolith_speed_area:IsAura()
	return true
end

function modifier_monolith_speed_area:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("monolith_effect_radius")
end

function modifier_monolith_speed_area:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_monolith_speed_area:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_monolith_speed_area:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_monolith_speed_area:GetModifierAura()
	return "modifier_monolith_speed_unit"
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_monolith_speed_unit = class({})

function modifier_monolith_speed_unit:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return func
end

function modifier_monolith_speed_unit:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("monolith_speed")
end

function modifier_monolith_speed_unit:GetModifierConstantManaRegen()
	local t_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_aether_4") or 0
	return self:GetAbility():GetSpecialValueFor("monolith_manaregen")+t_bonus
	
end

function modifier_monolith_speed_unit:GetModifierConstantHealthRegen()
	local t_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_aether_4") or 0
	return self:GetAbility():GetSpecialValueFor("monolith_healthregen")+t_bonus
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_monolith_slow_area = class({})

function modifier_monolith_slow_area:IsAura()
	return true
end

function modifier_monolith_slow_area:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("monolith_effect_radius")
end

function modifier_monolith_slow_area:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_monolith_slow_area:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_monolith_slow_area:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_monolith_slow_area:GetModifierAura()
	return "modifier_monolith_slow_unit"
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_monolith_slow_unit = class({})

function modifier_monolith_slow_unit:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return func
end

function modifier_monolith_slow_unit:GetModifierMovespeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("monolith_slow")
end

function modifier_monolith_slow_unit:GetModifierConstantManaRegen()
	local t_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_aether_4") or 0
	return -(self:GetAbility():GetSpecialValueFor("monolith_manaregen")+t_bonus)
	
end

function modifier_monolith_slow_unit:GetModifierConstantHealthRegen()
	local t_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_aether_4") or 0
	return -(self:GetAbility():GetSpecialValueFor("monolith_healthregen")+t_bonus)
end