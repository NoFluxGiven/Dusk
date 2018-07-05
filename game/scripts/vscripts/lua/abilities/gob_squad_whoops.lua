gob_squad_whoops = class({})

LinkLuaModifier("modifier_whoops","lua/abilities/gob_squad_whoops",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_whoops_thinker","lua/abilities/gob_squad_whoops",LUA_MODIFIER_MOTION_NONE)

function gob_squad_whoops:GetIntrinsicModifierName()
	return "modifier_whoops"
end

modifier_whoops = class({})

function modifier_whoops:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_whoops:OnDeath(kv)
	local c = self:GetAbility():GetCaster()
	local u = kv.unit
	if u ~= self:GetParent() then return end
	CreateModifierThinker( c,
			self:GetAbility(),
			"modifier_whoops_thinker", {Duration = 1},
			c:GetAbsOrigin(),
			c:GetTeamNumber(),
			false )
end

function modifier_whoops:IsHidden()
	return true
end

modifier_whoops_thinker = class({})

function modifier_whoops_thinker:OnCreated()
	if IsServer() then
		local c = self:GetAbility():GetCaster()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local en = FindEnemies(c,c:GetAbsOrigin(),radius)
		local damage = self:GetAbility():GetAbilityDamage()
		local stun = self:GetAbility():GetSpecialValueFor("stun")

		stun = stun

		ScreenShake(self:GetParent():GetCenter(), 1000, 3, 0.75, 1500, 0, true)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_gob_squad/whoops_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		c:EmitSound("Hero_Techies.Suicide")

		for k,v in pairs(en) do
			self:GetAbility():InflictDamage(v,c,damage,DAMAGE_TYPE_MAGICAL)
			v:AddNewModifier(c, self:GetAbility(), "modifier_stunned", {Duration=stun}) --[[Returns:void
			No Description Set
			]]
		end
	end
end