shade_dark_hunger = class({})

-- Link("modifier_dark_hunger")
-- Link("modifier_dark_hunger_passive")

LinkLuaModifier("modifier_dark_hunger_passive","lua/abilities/shade_dark_hunger",LUA_MODIFIER_MOTION_NONE)

function shade_dark_hunger:GetIntrinsicModifierName()
	return "modifier_dark_hunger_passive"
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_dark_hunger_passive = class({})

function modifier_dark_hunger_passive:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_DEATH
	}
	return func
end

function modifier_dark_hunger_passive:IsHidden()
	return true
end

function modifier_dark_hunger_passive:OnDeath( params )
	if self:GetParent():PassivesDisabled() then return end
	if not self:GetParent():IsAlive() then return end
	local att = params.attacker
	local unit = params.unit
	local heal = self:GetAbility():GetSpecialValueFor("heal")
	local creep_heal = self:GetAbility():GetSpecialValueFor("creep_heal")
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local tbonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_shade_3")
	if tbonus then
		heal = heal + tbonus
		creep_heal = creep_heal + math.floor(tbonus/10)
	end

	if unit:GetRangeToUnit(self:GetParent()) <= radius then
		if unit:GetTeam() ~= self:GetParent():GetTeam() then
			if unit:IsRealHero() then
				ParticleManager:CreateParticle("particles/dark_hunger_proc_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
				Creates a new particle effect
				]]
				self:GetParent():EmitSound("Shade.DarkHunger.Hero")
				self:GetParent():Heal(heal,self:GetParent())
				self:GetParent():Purge(false,true,false,true,false)
			else
				ParticleManager:CreateParticle("particles/dark_hunger_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
				Creates a new particle effect
				]]
				self:GetParent():EmitSound("Shade.DarkHunger")
				self:GetParent():Heal(creep_heal,self:GetParent())
			end
		end
	end
end