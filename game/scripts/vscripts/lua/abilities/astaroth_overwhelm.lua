astaroth_overwhelm = class({})

LinkLuaModifier("modifier_overwhelm","lua/abilities/astaroth_overwhelm",LUA_MODIFIER_MOTION_NONE)

function astaroth_overwhelm:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	local damage = self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")

	if self:GetCaster():GetHasTalent("special_bonus_astaroth_overwhelm") then damage = damage+80 end

	target:AddNewModifier(caster, self, "modifier_overwhelm", {Duration = duration, dmg = damage, rds = radius}) --[[Returns:void
	No Description Set
	]]
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_overwhelm = class({})

function modifier_overwhelm:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT+MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_overwhelm:OnCreated( kv )

	if IsServer() then

		self.damage = kv.dmg
		self.radius = kv.rds

		local p = "particles/units/heroes/hero_astaroth/le_overwhelm.vpcf"

		self:GetParent():EmitSound("Astaroth.Overwhelm.Start")
		self.p_index = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(self.p_index,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)

	end

end

function modifier_overwhelm:OnDestroy()
	if IsServer() then
		local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),self.radius)
		for k,v in pairs(enemies) do
			DealDamage(v,self:GetAbility():GetCaster(),self.damage,self:GetAbility():GetAbilityDamageType())
		end
		self:GetParent():EmitSound("Astaroth.Overwhelm.End")
		-- local p = "particles/units/heroes/hero_lupin/quickdraw2.vpcf"
		-- self.p_index_2 = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		-- Creates a new particle effect
		-- ]]
		-- ParticleManager:SetParticleControlEnt(self.p_index_2,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)
		ParticleManager:DestroyParticle(self.p_index,false)
	end
end

function modifier_overwhelm:IsDebuff()
	return true
end