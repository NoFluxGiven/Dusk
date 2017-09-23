shade_isolation = class({})

-- Link("modifier_isolation")
-- Link("modifier_isolation_passive")

LinkLuaModifier("modifier_isolation","lua/abilities/shade_isolation",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_isolation_petrify","lua/abilities/shade_isolation",LUA_MODIFIER_MOTION_NONE)

function shade_isolation:OnSpellStart()
	local c = self:GetCaster()
	local t = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local tcheck = self:GetCaster():FetchTalent("special_bonus_shade_4")

	t:AddNewModifier(c, self, "modifier_isolation", {Duration=duration})
	if tcheck then t:AddNewModifier(c, nil, "modifier_stunned", {Duration=tcheck}) end

	local found = FindEnemies(c, t:GetAbsOrigin(), radius)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shade/shade_isolation.vpcf", PATTACH_ABSORIGIN_FOLLOW, t) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 2, Vector(radius,radius,radius)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	t:EmitSound("Shade.Isolation")

	for k,v in pairs(found) do
		if v ~= t then
			v:AddNewModifier(c, self, "modifier_isolation_petrify", {Duration=duration}) --[[Returns:void
			No Description Set
			]]
		end
	end
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_isolation = class({})

function modifier_isolation:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	return func
end

function modifier_isolation:GetModifierTotalDamageOutgoing_Percentage()
	local reduc = self:GetAbility():GetSpecialValueFor("damage_reduction")

	return -reduc
end

function modifier_isolation:CheckState()
	local states = {
		[MODIFIER_STATE_SILENCED] = true
	}
	return states
end

modifier_isolation_petrify = class({})

function modifier_isolation_petrify:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_isolation_petrify:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_isolation_petrify:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	return -slow
end

function modifier_isolation_petrify:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_BLIND] = true
	}
	return state
end