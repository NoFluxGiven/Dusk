function replica(event)
	print("Conjure Image")
	local caster = event.caster
	local target = event.target or event.unit
	local player = caster:GetPlayerID()
	local ability = event.ability
	local aghs = event.aghs == 1
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(200)
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming", ability:GetLevel() - 1 )

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

function reshape2(keys)
	local caster = keys.caster
	local target = keys.target

	local thp = target:GetHealthPercent() / 100
	local tmp = target:GetManaPercent() / 100

	local tmhp = target:GetMaxHealth()
	local tmmp = target:GetMaxMana()

	local swap_hp = tmmp * tmp
	local swap_mana = tmhp * thp

	target:ModifyHealth(swap_hp, keys.ability, false, 0)
	target:SetMana(swap_mana)
end

function naturalise(keys)
	local caster = keys.caster
	local target = keys.target

	-- Removes the target's bonus attributes temporarily.

	local t_str = target:GetBaseStrength()
	local t_int = target:GetBaseIntellect()
	local t_agi = target:GetBaseAgility()

	local t_str_add = target:GetStrength() - t_str
	local t_int_add = target:GetIntellect() - t_int
	local t_agi_add = target:GetAgility() - t_agi

	local main_att = target:GetPrimaryAttribute() -- 0 str 1 agi 2 int

	local str_mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_reshape_str_removal", {})
	local int_mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_reshape_int_removal", {})
	local agi_mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_reshape_agi_removal", {})

	str_mod:SetStackCount(t_str_add)
	agi_mod:SetStackCount(t_agi_add)
	int_mod:SetStackCount(t_int_add)
end

function naturalise2(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()
	local heal = keys.heal
	local dmg = keys.damage

	local team = 0 -- 0 enemy 1 ally

	local duration = keys.duration

	local radius = keys.radius

	

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(),
                      target,
                      nil,
                        250,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                        FIND_CLOSEST,
                        false)

	for k,v in pairs(enemies) do
		Timers:CreateTimer(k*0.15,function()
			ParticleManager:CreateParticle("particles/units/heroes/hero_artificer/naturalise.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]

			local mod = keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_naturalise_damage_slow", {Duration=duration}) --[[Returns:void
			No Description Set
			]]

			DealDamage(v,caster,dmg,DAMAGE_TYPE_MAGICAL)

			v:EmitSound("Hero_Treant.LeechSeed.Target")
		end)
	end

end

function naturaliseDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local dmg = keys.damage or 5

	DealDamage(target,caster,dmg/3,DAMAGE_TYPE_MAGICAL)
end

function reshape(keys)
	local caster = keys.caster
	local target = keys.target

	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	disablePropsOnUnit(target)
	
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		target:AddNewModifier(caster, ability, "modifier_reshape_lua", {duration = duration})
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_reshape_particle_fx", {Duration = duration+0.1}) --[[Returns:void
		No Description Set
		]]
	end
end

function unmakingTick(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage / 100
	-- if EntityHasTalent(caster,"bonus_artificer_unmaking2") then
	-- 	damage = damage+(6/100)
	-- 	print("EXTRA DAMAGE")
	-- end

	local damage_type = DAMAGE_TYPE_MAGICAL
	if caster:HasTalent("special_bonus_artificer_unmaking2") then
		damage_type = DAMAGE_TYPE_PURE
	end

	local thp = target:GetHealth()

	local damage = math.ceil(damage*thp)

	DealDamage(target,caster,damage,damage_type)
	PopupSpecDamage(target,damage)

	target:EmitSound("Hero_Treant.LeechSeed.Tick") --[[Returns:void
	 
	]]
end


function unmakingHit(keys)
	local caster = keys.caster
	local target = keys.target

	local damage = keys.damage

	local damage_type = DAMAGE_TYPE_MAGICAL

	if caster:HasTalent("special_bonus_artificer_unmaking") then
		damage = damage+30
	end

	if caster:HasTalent("special_bonus_artificer_unmaking2") then
		damage_type = DAMAGE_TYPE_PURE
	end

	DealDamage(target,caster,damage,damage_type)
end

function replicaAghs(keys)
	local caster = keys.caster
	if caster:HasScepter() then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_replica_aghanims_fx", {}) --[[Returns:void
		No Description Set
		]]
	else
		caster:RemoveModifierByName("modifier_replica_aghanims_fx") --[[Returns:void
		Removes a modifier
		]]
	end
end