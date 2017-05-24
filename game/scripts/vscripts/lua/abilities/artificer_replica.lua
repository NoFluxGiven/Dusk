artificer_replica = class({})

LinkLuaModifier("modifier_replica_aghs_aura","lua/abilities/artificer_replica",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_replica_aghs_aura_effect","lua/abilities/artificer_replica",LUA_MODIFIER_MOTION_NONE)

function artificer_replica:OnSpellStart()
	
	self:_GenerateReplica(nil)

end

function artificer_replica:GetIntrinsicModifierName()
	return "modifier_replica_aghs_aura"
end

function artificer_replica:_GenerateReplica(aghs_unit)
	print("Conjure Image")
	local aghs = self:GetCaster():HasScepter()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local use_scepter_values = false
	if aghs and aghs_unit then
		target = aghs_unit -- set the target to the unit that died
		use_scepter_values = true
	end
	local player = caster:GetPlayerID()
	local ability = self
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(200)
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming", ability:GetLevel() - 1 )
	local scepter_duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local scepter_outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage", ability:GetLevel() - 1 )
	local scepter_incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming", ability:GetLevel() - 1 )

	if use_scepter_values then
		duration = scepter_duration
		outgoingDamage = scepter_outgoingDamage
		incomingDamage = scepter_incomingDamage
	end

	if target:IsIllusion() then target:ForceKill() return end

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)

	illusion:EmitSound("Hero_Terrorblade.Reflection")

	local particleName = "particles/units/heroes/hero_artificer/replica.vpcf"

	local particle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, illusion )
	
	-- Level Up the unit to the target's level
	local targetLevel = target:GetLevel()
	for i=1,targetLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the target
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local abilityIsUlt = ability:GetAbilityType() == DOTA_ABILITY_TYPE_ULTIMATE
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end

	-- Recreate the items of the target
	for itemSlot=0,5 do
		local item = target:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	-- Add our datadriven Metamorphosis modifier if appropiate
	-- You can add other buffs that want to be passed to illusions this way
	-- local meta_ability = caster:FindAbilityByName("mifune_genso")
	-- meta_ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_genso_illusion", nil)

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	if not illusion:IsIllusion() then illusion:MakeIllusion() illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage }) end
end

-- MODIFIERS

modifier_replica_aghs_aura = class({})

function modifier_replica_aghs_aura:IsAura()
	if self:GetAbility():GetCaster():HasScepter() then
		return true
	end
	return false
end

function modifier_replica_aghs_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("scepter_radius")
end

function modifier_replica_aghs_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_replica_aghs_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_replica_aghs_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_replica_aghs_aura:GetModifierAura()
	return "modifier_replica_aghs_aura_effect"
end

modifier_replica_aghs_aura_effect = class({})

function modifier_replica_aghs_aura_effect:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_DEATH
	}
	return func
end

function modifier_replica_aghs_aura_effect:OnDeath(params)

	if self:GetParent() == params.unit and self:GetAbility():GetCaster():HasScepter() then
		self:GetAbility():_GenerateReplica(self:GetParent())
	end
end