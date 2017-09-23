ABILITY_KV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt") --[[Returns:table
Creates a ''table'' from the specified keyvalues text file
]]

if IsClient() then print("RUNNING FOR CLIENT") end
if IsServer() then print("RUNNING FOR SERVER") end

if IsServer() then 
	TALENTS = {}
	for k,v in pairs(ABILITY_KV) do
		if string.find(k,"special_bonus") then
			local talent = v
			if not TALENTS[k] then
				TALENTS[k] = {learned=false}
			end
			for K,V in pairs(talent.AbilitySpecial) do
				-- print("["..k.."] ".."AbilitySpecial Index: "..K)
				for KK,VV in pairs(V) do
					if KK ~= "var_type" and KK ~= "LinkedSpecialBonus" then
						TALENTS[k][KK] = VV
					end
				end
			end
		end
	end
	print("TALENTS TABLE INITIALISED ON SERVER")
end

if IsServer() then
	require("libraries/extend")
	require("internal/util")
end

-- if IsClient() then
-- 	TALENTS = {}
-- 	for k,v in pairs(ABILITY_KV) do
-- 		if string.find(k,"special_bonus") then
-- 			local talent = v
-- 			if not TALENTS[k] then
-- 				TALENTS[k] = {learned=false}
-- 			end
-- 			for K,V in pairs(talent.AbilitySpecial) do
-- 				-- print("["..k.."] ".."AbilitySpecial Index: "..K)
-- 				for KK,VV in pairs(V) do
-- 					if KK ~= "var_type" and KK ~= "LinkedSpecialBonus" then
-- 						TALENTS[k][KK] = VV
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- 	print("TALENTS TABLE INITIALISED ON CLIENT")
-- end

if IsClient() then
	require("libraries/extend_client")
	require("internal/util_client")
end