faust_agony = class({})

LinkLuaModifier("modifier_agony","lua/abilities/faust_agony",LUA_MODIFIER_MOTION_NONE)

-- function faust_agony:GetCooldown(level)
-- 	local base_cooldown = self.BaseClass.GetCooldown(self, level)
-- 	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_faust_3") 
-- 	if t_cooldown_reduction then return 0 end
-- 	return base_cooldown
-- end

function faust_agony:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	-- if target:TriggerSpellAbsorb(self) then return end
	-- target:TriggerSpellReflect(self)

	local duration = self:GetSpecialValueFor("duration") --[[Returns:table
	No Description Set
	]]
	local damage = self:GetSpecialValueFor("damage")
	local initial_damage = self:GetSpecialValueFor("initial_damage")
	local radius = self:GetSpecialValueFor("radius")

	-- if self:GetCaster():GetHasTalent("special_bonus_faust_agony") then damage = damage+80 end

	local enemies = FindEnemies(caster, caster:GetAbsOrigin(), radius)

	for k,v in pairs(enemies) do
		if v:IsHero() then
			v:AddNewModifier(caster, self, "modifier_agony", {Duration = duration, dmg = damage})
		end
		self:InflictDamage(v,caster,initial_damage,DAMAGE_TYPE_MAGICAL)
	end
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_agony = class({})

-- function modifier_agony:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT
-- end

-- function modifier_agony:DeclareFunctions()
-- 	local func = {
-- 		MODIFIER_PROPERTY_MIN_HEALTH
-- 	}
-- 	return func
-- end

-- function modifier_agony:GetMinHealth()
-- 	return 1
-- end

function modifier_agony:OnCreated( kv )

	if IsServer() then

		self.damage = kv.dmg
		self.radius = kv.rds
		self.interval = 0.1

		local p = "particles/units/heroes/hero_faust/agony.vpcf"

		self:GetParent():EmitSound("Faust.Agony.Start")
		self.p_index = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(self.p_index,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)

		self:AddParticle( self.p_index, false, false, 1, false, false )

		self:StartIntervalThink(self.interval)

		self.last_parent_pos = self:GetParent():GetAbsOrigin()
		self.parent_pos = self:GetParent():GetAbsOrigin()

	end

end

function modifier_agony:OnIntervalThink()

	if IsServer() then

		self.parent_pos = self:GetParent():GetAbsOrigin()

		if self.parent_pos ~= self.last_parent_pos then
			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),self.damage * self.interval,DAMAGE_TYPE_MAGICAL)
		end

		self.last_parent_pos = self:GetParent():GetAbsOrigin()
	end

end

function modifier_agony:IsDebuff()
	return true
end