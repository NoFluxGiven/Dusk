phantom_nightmare = class({})

LinkLuaModifier("modifier_nightmare","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nightmare_caster","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)

function phantom_nightmare:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	local t_aoe = caster:FetchTalent("special_bonus_phantom_3")

	local enemies

	if t_aoe then
		enemies = FindEnemies( caster, target:GetAbsOrigin(), t_aoe )
	else
		enemies = {[0] = target}
	end

	for k,v in pairs(enemies) do
		v:AddNewModifier(caster, self, "modifier_nightmare", {Duration=duration})
		CreateParticleHitloc(v,"particles/units/heroes/hero_phantom/nightmare.vpcf")
	end

	caster:AddNewModifier(caster, self, "modifier_nightmare_caster", {Duration=duration})
	-- Sound

end

modifier_nightmare = class({})

function modifier_nightmare:GetEffectName()
	return "particles/units/heroes/hero_phantom/nightmare_unit.vpcf"
end

modifier_nightmare_caster = class({})