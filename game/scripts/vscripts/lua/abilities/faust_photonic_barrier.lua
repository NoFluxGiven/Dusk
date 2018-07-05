faust_photonic_barrier = class({})

LinkLuaModifier("modifier_photonic_barrier","lua/abilities/faust_photonic_barrier",LUA_MODIFIER_MOTION_NONE)

-- function faust_photonic_barrier:GetCooldown(level)
-- 	local base_cooldown = self.BaseClass.GetCooldown(self, level)
-- 	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_faust_3") 
-- 	if t_cooldown_reduction then return 0 end
-- 	return base_cooldown
-- end

function faust_photonic_barrier:OnSpellStart()
	local caster = self:GetCaster()

	-- if target:TriggerSpellAbsorb(self) then return end
	-- target:TriggerSpellReflect(self)

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	local damage = self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("truesight_radius")
	local knockback = self:GetSpecialValueFor("knockback_distance")

	-- if self:GetCaster():GetHasTalent("special_bonus_faust_photonic_barrier") then damage = damage+80 end

	caster:AddNewModifier(caster, self, "modifier_photonic_barrier", {Duration = duration, dmg = damage, rds = radius, kbk = knockback}) --[[Returns:void
	No Description Set
	]]
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_photonic_barrier = class({})

function modifier_photonic_barrier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_photonic_barrier:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return func
end

function modifier_photonic_barrier:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_photonic_barrier:OnCreated( kv )

	if IsServer() then

		self.damage = kv.dmg
		self.radius = kv.rds
		self.knockback = kv.kbk

		local p = "particles/units/heroes/hero_faust/photonic_barrier.vpcf"

		self:GetParent():EmitSound("Faust.PhotonicBarrier")
		self.p_index = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(self.p_index,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)
		ParticleManager:SetParticleControl(self.p_index, 1, Vector(self.radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),self.radius)
		for k,v in pairs(enemies) do
			self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),self.damage,self:GetAbility():GetAbilityDamageType())
		end
	end

end

function modifier_photonic_barrier:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Faust.Photonic_barrier.End")
		-- local p = "particles/units/heroes/hero_lupin/quickdraw2.vpcf"
		-- self.p_index_2 = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		-- Creates a new particle effect
		-- ]]
		-- ParticleManager:SetParticleControlEnt(self.p_index_2,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)
		ParticleManager:DestroyParticle(self.p_index,false)
	end
end

function modifier_photonic_barrier:IsAura()
	return true
end

function modifier_photonic_barrier:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("truesight_radius")
end

function modifier_photonic_barrier:GetAuraSearchFlags()
	return 0
end

function modifier_photonic_barrier:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_photonic_barrier:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_photonic_barrier:GetAuraDuration()
	return 1.25
end

function modifier_photonic_barrier:GetModifierAura()
	return "modifier_truesight"
end

function modifier_photonic_barrier:IsPurgable()
	return true
end

function modifier_photonic_barrier:IsHidden()
	return true
end