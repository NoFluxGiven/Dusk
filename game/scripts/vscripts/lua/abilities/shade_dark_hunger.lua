shade_dark_hunger = class({})

-- Link("modifier_dark_hunger")
-- Link("modifier_dark_hunger_passive")

--LinkLuaModifier("modifier_dark_hunger_passive","lua/abilities/shade_dark_hunger",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_hunger_active","lua/abilities/shade_dark_hunger",LUA_MODIFIER_MOTION_NONE)

--[[function shade_dark_hunger:GetIntrinsicModifierName()
	return "modifier_dark_hunger_passive"
end]]

function shade_dark_hunger:OnSpellStart()
	local c = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local drain = self:GetSpecialValueFor("health_drain")
	local drain_increase = self:GetSpecialValueFor("proc_increase")
	local drain_max = self:GetSpecialValueFor("health_drain_max")

	-- Self cast

	--@TODO PARTICLE
	--@TODO SOUND

	c:AddNewModifier(c, self, "modifier_dark_hunger_active", {Duration=duration, radius=radius, drain = drain, drain_increase = drain_increase, drain_max = drain_max})
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_dark_hunger_active = class({})

function modifier_dark_hunger_active:DeclareFunctions()
	--
end


function modifier_dark_hunger_active:OnCreated(kv)
	self.caster = self:GetAbility():GetCaster()
	self.radius = kv.radius
	local interval = 0.25
	self.drain = kv.drain / ( 1 / interval )
	self.drain_increase = kv.drain_increase / ( 1 / interval )
	self.drain_max = kv.drain_max / ( 1 / interval )
	self:StartIntervalThink(interval)

	self.last_damaged = nil
end

function modifier_dark_hunger_active:OnIntervalThink()
	local enemies = FindEnemiesRandom( self.caster, self.caster:GetAbsOrigin(), self.radius )

	local target = enemies[1]

	ParticleManager:CreateParticle("particles/units/heroes/hero_shade/shade_dark_hunger_drain_unit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	--@TODO SOUND

	local damage = self.drain
	local damage_type = self:GetAbility():GetAbilityDamageType()

	self:GetAbility():InflictDamage( target, self.caster, damage, damage_type )
	self.caster:Heal(damage, self.caster)

	if self.last_damaged then
		if (target == self.last_damaged) then
			self.drain = self.drain + self.drain_increase
			if self.drain > self.drain_max then self.drain = self.drain_max end
		end
	end

	self.last_damaged = target
end

function modifier_dark_hunger_active:GetEffectName()
	return "particles/units/heroes/hero_shade/shade_dark_hunger_drain.vpcf"
end

-- --[[modifier_dark_hunger_passive = class({})

-- function modifier_dark_hunger_passive:DeclareFunctions()
-- 	local func = {
-- 		MODIFIER_EVENT_ON_TAKEDAMAGE
-- 	}
-- 	return func
-- end

-- function modifier_dark_hunger_passive:IsHidden()
-- 	return true
-- end

-- function modifier_dark_hunger_passive:OnTakeDamage( params )
-- 	if self:GetParent():PassivesDisabled() then return end
-- 	if not self:GetParent():IsAlive() then return end
-- 	local att = params.attacker
-- 	local unit = params.unit
-- 	local damage = params.damage
-- 	local heal = self:GetAbility():GetSpecialValueFor("heal")
-- 	local creep_heal = self:GetAbility():GetSpecialValueFor("creep_heal")
-- 	local tbonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_shade_3")
-- 	if tbonus then
-- 		heal = (heal + tbonus)
-- 		creep_heal = (creep_heal)
-- 	end

-- 	heal = heal/100
-- 	creep_heal = creep_heal/100

-- 	if att ~= self:GetParent() then return end

-- 	if unit:GetTeam() ~= self:GetParent():GetTeam() then
-- 		if unit:IsRealHero() then
-- 			ParticleManager:CreateParticle("particles/dark_hunger_proc_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
-- 			Creates a new particle effect
-- 			]]
-- 			--self:GetParent():EmitSound("Shade.DarkHunger.Hero")
-- 			self:GetParent():Heal(heal * damage,self:GetParent())
-- 			self:GetParent():GiveMana(heal * damage)
-- 			--self:GetParent():Purge(false,true,false,true,false)
-- 		else
-- 			ParticleManager:CreateParticle("particles/dark_hunger_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
-- 			Creates a new particle effect
-- 			]]
-- 			--self:GetParent():EmitSound("Shade.DarkHunger")
-- 			self:GetParent():Heal(creep_heal * damage,self:GetParent())
-- 			self:GetParent():GiveMana(creep_heal * damage)
-- 		end
-- 	end
-- end