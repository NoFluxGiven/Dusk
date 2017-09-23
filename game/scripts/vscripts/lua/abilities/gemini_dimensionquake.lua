gemini_dimensionquake = class({})

function gemini_dimensionquake:OnSpellStart()
	local c = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun = self:GetSpecialValueFor("stun")

	local f = FindEnemies(c,c:GetAbsOrigin(),radius)

	for k,v in pairs(f) do
		self:InflictDamage(v,c,damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(c,self,"modifier_stunned",{Duration=stun})
	end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_gemini/dimensionquake.vpcf", PATTACH_ABSORIGIN_FOLLOW, c)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))
	ScreenShake(c:GetAbsOrigin(), 1200, 170, 6, 1200, 0, true)
end