function C_DOTA_BaseNPC:GetHasTalent(talent_string)
	local name = self:GetUnitName()
	local interim = "_talent_"

	local str = name .. interim .. talent_string

	return self:HasModifier(str)
end

function C_DOTA_BaseNPC:GetTalentValue2(talent_number)
	-- Talent number must be 1 to 8 
end

function C_DOTABaseAbility:FetchTalent(handle,suffix)
	local handle = handle or self:GetCaster()
	local suffix = suffix or ""
	suffix = "" .. suffix -- convert to string

	local ability_name = self:GetName() -- "<hero_name>_<ability_name>"
	local unit_name = handle:GetUnitName()

	local unit_entity_index = handle:GetEntityIndex()

	local talent_string = "special_bonus_"..ability_name
	local interim = "_talent_"

	local str = unit_name .. interim .. talent_string

	local gotIt = handle:HasModifier(str)

	if gotIt then
		-- local mod = handle:FindModifierByName(str)
		-- local stack = 0
		-- if mod then
		-- 	stack = mod:GetStackCount()
		-- end

		-- if math.abs(stack) > 0 then
		-- 	return mod:GetStackCount()
		-- end

		-- CLIENT VERSION: We can't find modifiers on the Client, so we have to resort to the more expensive
		-- operation.

		local t = CustomNetTables:GetTableValue("talent_manager","unit_talent_data_"..unit_entity_index)

		for i=1,4 do
			local ltalent = t["data"][i..""]["left"]
			local rtalent = t["data"][i..""]["right"]

			if ltalent["name"] == talent_string then
				local v = ltalent["v"]
				-- mod:SetStackCount(v)
				-- print("TALENT VALUE: CLIENT: "..v.." Main")
				if v ~= 0 then -- if v is zero, it's most likely a "toggle" (do this when skilled etc)
					return v 
				else
					return true
				end
			elseif rtalent["name"] == talent_string then
				local v = rtalent["v"]
				-- mod:SetStackCount(v)
				-- print("TALENT VALUE: CLIENT: "..v.." Main")
				if v ~= 0 then -- if v is zero, it's most likely a "toggle" (do this when skilled etc)
					return v 
				else
					return true
				end
			end
		end
	else
		return nil
	end
end