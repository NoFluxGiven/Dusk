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
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return func
end

function modifier_dark_hunger_passive:IsHidden()
	return true
end

function modifier_dark_hunger_passive:OnTakeDamage( params )
	if self:GetParent():PassivesDisabled() then return end
	if not self:GetParent():IsAlive() then return end
	local att = params.attacker
	local unit = params.unit
	local damage = params.damage
	local heal = self:GetAbility():GetSpecialValueFor("heal")
	local creep_heal = self:GetAbility():GetSpecialValueFor("creep_heal")
	local tbonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_shade_3")
	if tbonus then
		heal = (heal + tbonus)
		creep_heal = (creep_heal)
	end

	heal = heal/100
	creep_heal = creep_heal/100

	if att ~= self:GetParent() then return end

	if unit:GetTeam() ~= self:GetParent():GetTeam() then
		if unit:IsRealHero() then
			ParticleManager:CreateParticle("particles/dark_hunger_proc_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
			Creates a new particle effect
			]]
			--self:GetParent():EmitSound("Shade.DarkHunger.Hero")
			self:GetParent():Heal(heal * damage,self:GetParent())
			self:GetParent():GiveMana(heal * damage)
			--self:GetParent():Purge(false,true,false,true,false)
		else
			ParticleManager:CreateParticle("particles/dark_hunger_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
			Creates a new particle effect
			]]
			--self:GetParent():EmitSound("Shade.DarkHunger")
			self:GetParent():Heal(creep_heal * damage,self:GetParent())
			self:GetParent():GiveMana(creep_heal * damage)
		end
	end
end