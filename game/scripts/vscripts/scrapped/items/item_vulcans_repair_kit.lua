function useOnTowerNow(keys)
	local caster = keys.caster
	local target = keys.target
	local FindClearSpace = true
	local player = caster:GetPlayerID()
	local origin = target:GetAbsOrigin() - (300*target:GetForwardVector()) --[[Returns:Vector
	Get a random 2D ''vector''. Argument (''float'') is the minimum length of the returned vector.
	]]

	local v = CreateUnitByName("npc_dota_unit_vassal_green", origin, FindClearSpace, caster, caster, caster:GetTeamNumber())
	--v:SetPlayerID(caster:GetPlayerID())
	--v:SetControllableByPlayer(player, false)

	Timers:CreateTimer(0.03,function()
		v:CastAbilityOnTarget(target, v:FindAbilityByName("vassal_repair"), player) --[[Returns:void
		Cast an ability on a target entity.
		]]
		v.buddy = target
		v.owner = caster
	end)

	

	
 
end

function AI(keys)
	local caster = keys.caster
	local search_radius = 500
	local threshold = 99 -- if the health of the structure is larger than or equal to this, we hide
	local retreat_threshold = 5 -- if our structure's health drops below this amount, run away and find another building
	local target = caster.buddy
	local player = caster.owner:GetPlayerID()
	local moving = false
	local movevector = Vector(0,0,0)

	if not IsValidEntity(target) then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
	            DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)

		for k,v in pairs(units) do
			if v:GetHealthPercent() < retreat_threshold or v:GetHealthPercent() >= threshold then
				table.remove(units,k)
			end
		end

		if #units > 0 then

			caster.buddy = units[1]

			target = caster.buddy

			moving = true

			movevector = target:GetAbsOrigin() - (300*target:GetForwardVector())

		end
	end

	if target:GetHealthPercent() < retreat_threshold then

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
	            DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)

		for k,v in pairs(units) do
			if v:GetHealthPercent() < retreat_threshold or v:GetHealthPercent() >= threshold then
				table.remove(units,k)
			end
		end

		caster.buddy = units[1]

		target = caster.buddy

		moving = true

		movevector = target:GetAbsOrigin() - (300*target:GetForwardVector())

	end

	if not moving then

		if target:GetHealthPercent() < threshold then
			if not caster:FindAbilityByName("vassal_repair"):IsChanneling() then

				caster:CastAbilityOnTarget(target, caster:FindAbilityByName("vassal_repair"), player) --[[Returns:void
				Cast an ability on a target entity.
				]]

		 	end
		else
			print("HEALTH IS FULL FINDING OTHER")
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		            DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)

			for k,v in pairs(units) do
				if v:GetHealthPercent() < retreat_threshold or v:GetHealthPercent() >= threshold then
					table.remove(units,k)
					print("removed entry "..k.." from units")
				end
			end

			if #units > 0 then
				print("UNITS LARGER THAN 0")
				caster.buddy = units[1]

				target = caster.buddy

				moving = true

				movevector = target:GetAbsOrigin() - (300*target:GetForwardVector())

			end
		end
	else
		if caster:IsPositionInRange(movevector,10) then
			moving = false
		else
			caster:MoveToPosition(movevector) --[[Returns:void
		Issue a Move-To command
		]]
		end

	end

end