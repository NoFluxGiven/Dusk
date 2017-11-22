alroth_solwave = class({})

LinkLuaModifier("modifier_solwave","lua/abilities/alroth_solwave",LUA_MODIFIER_MOTION_NONE)

function alroth_solwave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		local duration = self:GetSpecialValueFor("duration")

		caster:AddNewModifier(caster, self, "modifier_solwave", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
	end
end

modifier_solwave = class({})

if IsServer() then

	function modifier_solwave:OnCreated()
		local caster = self:GetParent()
		local radius = self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]
		self.p = CreateParticleHitloc(caster,"particles/units/heroes/hero_alroth/alroth_solwave.vpcf")

		ParticleManager:SetParticleControl(self.p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:StartIntervalThink(0.1)

		caster:EmitSound("Alroth.Solcharge")
	end

	function modifier_solwave:OnIntervalThink()
		local caster = self:GetParent()
		local damage = self:GetAbility():GetSpecialValueFor("damage_per_second") --[[Returns:table
		No Description Set
		]]
		local radius = self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]

		local found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

		for k,v in pairs(found) do
			self:GetAbility():InflictDamage(v,caster,damage/10,DAMAGE_TYPE_MAGICAL)
		end

		self:GetAbility():InflictDamage(caster,caster,damage/20,DAMAGE_TYPE_MAGICAL)
	end

	function modifier_solwave:OnDestroy()
		local caster = self:GetParent()

		caster:StopSound("Alroth.Solcharge")

		if self.p then
			ParticleManager:DestroyParticle(self.p,false)
			self.p = nil
		end
	end

end