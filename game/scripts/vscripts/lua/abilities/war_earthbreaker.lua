war_earthbreaker = class({})

-- LinkLuaModifier("modifier_earthbreaker","lua/abilities/war_earthbreaker",LUA_MODIFIER_MOTION_NONE)

function war_earthbreaker:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()+caster:GetForwardVector()*150

	local damage = self:GetAbilityDamage()

	local t_radius_bonus = caster:FetchTalent("special_bonus_war_4") or 0

	local radius = self:GetSpecialValueFor("radius") + t_radius_bonus
	local stun = self:GetSpecialValueFor("stun")

	local unit = FastDummy(point,caster:GetTeam(),2,0)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_war/earthbreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	unit:EmitSound("War.Earthbreaker")

	local enemy_found = FindEnemies(caster,unit:GetAbsOrigin(),radius)

	ScreenShake(unit:GetCenter(), 1000, 3, 0.75, 1500, 0, true)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			DealDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
			v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
			No Description Set
			]]
		end
	end
end