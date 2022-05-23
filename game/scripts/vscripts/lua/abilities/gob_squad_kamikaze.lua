gob_squad_kamikaze = class({})

LinkLuaModifier("modifier_kamikaze","lua/abilities/gob_squad_kamikaze",LUA_MODIFIER_MOTION_NONE)

function gob_squad_kamikaze:OnSpellStart()
	local c = self:GetCaster()

	local t_multiplier = c:FindTalentValue("special_bonus_gob_squad_2") or 0

	local t_multiplier = 1 + t_multiplier/100

	local duration = self:GetSpecialValueFor("duration") * t_multiplier

	c:AddNewModifier(c, self, "modifier_kamikaze", {Duration=duration}) --[[Returns:void
	No Description Set
	]]

	c:EmitSound("hero_Crystal.freezingField.explosion") --[[Returns:void
	 
	]]
end

modifier_kamikaze = class({})

function modifier_kamikaze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_kamikaze:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("reduction")
end

function modifier_kamikaze:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_kamikaze:GetEffectName()
	return "particles/units/heroes/hero_gob_squad/kamikaze_unit.vpcf"
end

function modifier_kamikaze:OnDestroy(bPurged)
	-- if self:GetElapsedTime() ~= -1 then return end
	if IsServer() then
		local caster = self:GetParent()
		local total = self:GetAbility():GetSpecialValueFor("total")/100
		local health_damage = self:GetAbility():GetSpecialValueFor("health_damage")
		local damage = self:GetAbility():GetAbilityDamage() + (caster:GetHealth()*(health_damage/100))*total

		local stun = self:GetAbility():GetSpecialValueFor("stun")

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local t_multiplier = caster:FindTalentValue("special_bonus_gob_squad_2") or 0

		local t_multiplier = 1 + t_multiplier/100

		damage = damage * t_multiplier

		if not caster:IsAlive() then return end

		-- health_damage,damage,radius = health_damage*t_multiplier,damage*t_multiplier,radius*t_multiplier

		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

		caster:ModifyHealth(caster:GetHealth()-(caster:GetMaxHealth()*(health_damage/100)), self:GetAbility(), true, 0) --[[Returns:void
		Sets the health to a specific value, with optional flags or inflictors.
		]]

		local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),1,0)

		unit:EmitSound("Hero_Techies.Suicide")

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_gob_squad/kamikaze_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		ScreenShake(unit:GetCenter(), 1000, 3, 0.50, 1500, 0, true)

		caster:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
		No Description Set
		]]

		for k,v in pairs(enemy_found) do
			self:GetAbility():InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end
	end
end