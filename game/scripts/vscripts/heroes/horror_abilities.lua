function horror_alone(keys)
	local caster = keys.caster
	local duration = keys.ability:GetLevelSpecialValueFor("duration",keys.ability:GetLevel()-1)
	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetAbsOrigin(),
                          nil,
                            99999,
                            DOTA_UNIT_TARGET_TEAM_BOTH,
                            DOTA_UNIT_TARGET_ALL,
                            DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,
                            false)
	local caster_mod = "modifier_horror_caster"

	if caster:HasScepter() then
		caster_mod = "modifier_horror_caster_scepter"
	end

	EmitGlobalSound("Hero_Nightstalker.Darkness") --[[Returns:void
	Play named sound for all players
	]]

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_horror/horror_alone_start.vpcf", PATTACH_POINT, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, caster:GetCenter()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	keys.ability:ApplyDataDrivenModifier(caster, caster, caster_mod,{Duration=duration}) --[[Returns:void
	No Description Set
	]]
	caster:AddNewModifier(caster, nil, "modifier_bloodseeker_thirst", {Duration=duration, IsHidden=true}) --[[Returns:void
	No Description Set
	]]

	for k,v in pairs(enemy_found) do
		local invuln = false

		if v ~= caster then
			if v:IsInvulnerable() then
				v:RemoveModifierByName("modifier_invulnerable") --[[Returns:void
				Removes a modifier
				]]
				invuln = true
			end
			keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_horror_alone_eff", {Duration=duration}) --[[Returns:void
			No Description Set
			]]
			if v:IsRealHero() then
				if caster:HasScepter() then
					keys.ability:CreateVisibilityNode(v:GetAbsOrigin(), 500, duration) --[[Returns:void
					No Description Set
					]]
					local ab = caster:FindAbilityByName("horror_terrify")
					ab:ApplyDataDrivenModifier(caster, v, "modifier_horror_terrify_eff_scepter", {}) --[[Returns:void
					No Description Set
					]]
				end
			end
			if invuln then
				v:AddNewModifier(v, nil, "modifier_invulnerable", {}) --[[Returns:void
				No Description Set
				]]
			end
		end
	end
end

function horror_terrify(keys)
	local caster = keys.caster
	local target = keys.target

	local dir = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()

	if target:GetRangeToUnit(caster) > 240 then return end --[[Returns:float
	No Description Set
	]]

	if target:HasModifier("modifier_horror_terrify_command") then target:RemoveModifierByName("modifier_horror_terrify_command") end

	local newOrder = {
                UnitIndex = target:entindex(),
                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                -- TargetIndex = entToAttack:entindex(), --Optional.  Only used when targeting units
                --AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = target:GetAbsOrigin()+dir*150, --Optional.  Only used when targeting the ground
        }
 
		ExecuteOrderFromTable(newOrder)
	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_horror_terrify_command", {}) --[[Returns:void
	No Description Set
	]]
end

function horror_shadowclone(event)
	local caster = event.caster
	local target = event.target
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin() + RandomVector(125)
	local facing = caster:GetForwardVector()
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 ) or 10
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage", ability:GetLevel() - 1 ) or 100
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming", ability:GetLevel() - 1 ) or 200

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_horror/horror_shadowclone.vpcf", PATTACH_POINT, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, origin) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)

	illusion:EmitSound("Hero_Terrorblade.Reflection")
	
	-- Level Up the unit to the casters level
	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end

	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	event.ability:ApplyDataDrivenModifier(caster, illusion, "modifier_shadowclone", {}) --[[Returns:void
	No Description Set
	]]

	illusion:SetForwardVector(facing)
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	if not illusion:IsIllusion() then illusion:MakeIllusion() illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage }) end
end

function track_damage(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.unit

	local damage = keys.attack_damage

	if attacker.damage_table then
		local ins = {
			target = target,
			damage = damage
		}

		table.insert(attacker.damage_table,ins)
	else
		attacker.damage_table = {}
		local ins = {
			target = target,
			damage = damage
		}

		table.insert(attacker.damage_table,ins)
	end
end

function reverse(keys)
	local caster = keys.caster
	local target = keys.target
	print("healing")
	if target.damage_table then
		for k,v in pairs(target.damage_table) do
			if IsValidEntity(v.target) then
				keys.ability:ApplyDataDrivenModifier(caster, v.target, "modifier_shadowclone_regen", {}) --[[Returns:void
				No Description Set
				]]
				local stacks = v.target:GetModifierStackCount("modifier_shadowclone_regen",caster)
				v.target:SetModifierStackCount("modifier_shadowclone_regen",caster,stacks+v.damage)
			end
		end
	end
end

function deathmark_tick(keys)
	local caster = keys.caster
	local target = keys.target
	local stacks = target:GetModifierStackCount("modifier_deathmark",caster)



	if stacks < 8 then
		target:SetModifierStackCount("modifier_deathmark",caster,stacks+1)
	end
end

function deathmark(keys)
	local caster = keys.caster
	local target = keys.target

	

	if target:IsIllusion() then
		target:Kill(keys.ability,caster)
		return
	end

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_deathmark", {}) --[[Returns:void
	No Description Set
	]]

	target:SetModifierStackCount("modifier_deathmark",caster,1)
end

function deathmark_activate(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local unit = keys.target
	local damage = keys.damage
	local stack = unit:GetModifierStackCount("modifier_deathmark",caster)

	if attacker == caster then

		ParticleManager:CreateParticle("particles/units/heroes/hero_horror/horror_deathmark_hit.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
		Creates a new particle effect
		]]

		unit:EmitSound("Hero_Nightstalker.Void")

		keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_deathmarksilence", {Duration=stack/2}) --[[Returns:void
		No Description Set
		]]

		DealDamage(unit,caster,damage*stack,DAMAGE_TYPE_PHYSICAL)

		unit:RemoveModifierByName("modifier_deathmark")

	end
end

function AlonePassive(keys)
	local caster = keys.caster

	local team = caster:GetTeam()

	local oteam = 0

	if team == DOTA_TEAM_GOODGUYS then
		oteam = DOTA_TEAM_BADGUYS
	else
		oteam = DOTA_TEAM_GOODGUYS
	end

	local checker = caster.check_fow_vision_entity

	if caster:IsIllusion() then return end

	if not checker then
		caster.check_fow_vision_entity = FastDummy(caster:GetAbsOrigin(),oteam,6000,0)
	end

	if caster.check_fow_vision_entity:CanEntityBeSeenByMyTeam(caster) and not caster:HasModifier("modifier_horror_caster") then
		-- apply removal modifier if we don't already have it
		if not caster:HasModifier("modifier_alone_remove") then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_alone_remove", {}) --[[Returns:void
			No Description Set
			]]
			caster:RemoveModifierByNameAndCaster("modifier_bloodseeker_thirst",caster) --[[Returns:void
			Removes a modifier
			]]
		end
	else
		-- apply modifier
		if not caster:HasModifier("modifier_alone_remove") then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_alone_passive_eff", {}) --[[Returns:void
			No Description Set
			]]
			caster:AddNewModifier(caster, nil, "modifier_bloodseeker_thirst", {}) --[[Returns:void
			No Description Set
			]]
		end
	end
end