rai_arc_twister = class({})

LinkLuaModifier("modifier_arc_twister","lua/abilities/rai_arc_twister",LUA_MODIFIER_MOTION_NONE)

function rai_arc_twister:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_rai_6") or 0
	return base_cooldown - t_cooldown_reduction
end

function rai_arc_twister:CastFilterResultLocation( vLocation )
 
	if self:GetCaster():IsRooted() then
		return UF_FAIL_CUSTOM
	end
 
	return UF_SUCCESS
end
 
function rai_arc_twister:GetCustomCastErrorLocation( vLocation )
	if self:GetCaster():IsRooted() then
		return "Cannot use while Rooted"
	end
 
	return ""
end

function rai_arc_twister:OnSpellStart()
	local delay = self:GetSpecialValueFor("delay")
	local damage = self:GetSpecialValueFor("damage")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_twister", {Duration=delay}) --[[Returns:void
	No Description Set
	]]

	local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_rai_3") or 0

	damage = t_damage_bonus + damage

	local c = self:GetCaster()

	local loc = self:GetCursorPosition()

	c:AddNoDraw()

	c:EmitSound("Hero_Leshrac.Lightning_Storm")

	Timers:CreateTimer(delay,function()
		c:RemoveNoDraw()
		c:RemoveModifierByName("modifier_arc_twister") --[[Returns:void
		Removes a modifier
		]]
		FindClearSpaceForUnit(c, loc, true) --[[Returns:void
		Place a unit somewhere not already occupied.
		]]
	end)

	local found = FindUnitsInLine(c:GetTeamNumber(), c:GetAbsOrigin(), loc, c, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0)

	for k,v in pairs(found) do
		DealDamage(v,c,damage,DAMAGE_TYPE_MAGICAL)
	end

	local unit = CreateModifierThinker( c, self, "modifier_stunned", {Duration=1}, loc, c:GetTeam(), false )

	unit:AddNoDraw()

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/arc_twister_bolt.vpcf", PATTACH_WORLDORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, c:GetCenter()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, unit:GetAbsOrigin()+Vector(0,0,100)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end

modifier_arc_twister = class({})

function modifier_arc_twister:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
	return state
end

function modifier_arc_twister:IsHidden()
	return true
end