ice_wyrm_winters_breath = class({})

LinkLuaModifier("modifier_winters_breath","lua/abilities/ice_wyrm_winters_breath",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_winters_breath_dps","lua/abilities/ice_wyrm_winters_breath",LUA_MODIFIER_MOTION_NONE)

function ice_wyrm_winters_breath:GetIntrinsicModifierName()
	return "modifier_winters_breath"
end

modifier_winters_breath = class({})

function modifier_winters_breath:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_winters_breath:IsHidden()
	return true
end

function modifier_winters_breath:OnAttackLanded(params)
	local t = params.target
	local a = params.attacker

	if a ~= self:GetParent() then return end

	local t_damage_bonus = a:FindTalentValue("special_bonus_shard_magus_5") or 0

	local d = self:GetAbility():GetSpecialValueFor("bonus_damage")+t_damage_bonus
	local r = self:GetAbility():GetSpecialValueFor("radius")
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/winters_breath_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, t) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 1, Vector(r,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	t:EmitSound("Hero_Lich.ChainFrostImpact.Creep")

	local f = FindEnemies(a,t:GetAbsOrigin(),r)

	for k,v in pairs(f) do
		v:AddNewModifier(a, self:GetAbility(), "modifier_winters_breath_dps", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		self:GetAbility():InflictDamage(v,a,d,DAMAGE_TYPE_MAGICAL)
	end
end

modifier_winters_breath_dps = class({})

if IsServer() then

	function modifier_winters_breath_dps:OnCreated()
		self:StartIntervalThink(1.0)
	end

	function modifier_winters_breath_dps:OnIntervalThink()
		local t = self:GetParent()
		local a = self:GetAbility():GetCaster()
		local dps = self:GetAbility():GetSpecialValueFor("damage_over_time")

		self:GetAbility():InflictDamage(t,a,dps,DAMAGE_TYPE_MAGICAL)
	end

end