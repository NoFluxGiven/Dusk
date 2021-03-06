astaroth_overwhelm = class({})

LinkLuaModifier("modifier_overwhelm","lua/abilities/astaroth_overwhelm",LUA_MODIFIER_MOTION_NONE)

function astaroth_overwhelm:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_astaroth_3") 
	if t_cooldown_reduction then return 0 end
	return base_cooldown
end

function astaroth_overwhelm:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if target:TriggerSpellAbsorb(self) then return end
	-- target:TriggerSpellReflect(self)

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
	return MODIFIER_ATTRIBUTE_PERMANENT
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