function Synthesise(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local pid = player:GetPlayerID()

	local rad = "the Radiant"
	local dir = "the Dire"

	local team = player:GetTeamNumber()

	print(team)

	local teamprint = ""

	if team == 2 then
		teamprint = rad
	elseif team == 3 then
		teamprint = dir
	end
	
	local hasLegendary = PlayerResource:IsPlayerExalted(pid)



	local itemList = duskDota.normalItemTable

	local replaceList = duskDota.exaltedItemTable

	local success = false

	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item then
			if not hasLegendary then
				local name = item:GetName()
				local convert = ""
				local n = CheckTable(itemList,name)
				if n then
					convert = replaceList[n]
					caster:RemoveItem(item)
					local entity = CreateItem(convert, caster, caster)
					caster:AddItem(entity)
					EmitGlobalSound("Hero_Alchemist.ChemicalRage.Cast")
					local messageinfo = {
					message = "An Exalted item has been synthesised by "..teamprint.."!",
					duration = 4
					}
					--FireGameEvent("show_center_message",messageinfo)  
					GameRules:SendCustomMessage("An <font color='#58ACFA'>Exalted</font> item has been synthesised by "..teamprint.."!", player:GetTeam(), 0)
					success = true
					break
				end
			else
				success = true
				EmitGlobalSound("Whoops")
				GameRules:SendCustomMessage("Someone on "..teamprint.." gave in to the greed and tried to synthesise ANOTHER <font color='#58ACFA'>Exalted</font> item! It didn't work...", player:GetTeam(), 0)
				break
			end
		end
	end

	if success then

		for i=0,5 do
			local item = caster:GetItemInSlot(i)
			if item then
				if item:GetName() == "item_regal_sigil" then
					caster:RemoveItem(item)
					break
				end
			end
		end

		PlayerResource:MakeExalted(pid)

	end
end