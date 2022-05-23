-- ALL THE BELOW DEPRECATED
-- Replace with the Modifier Talent System that imba has

function C_DOTA_BaseNPC:GetHasTalent(talent_string)
	local name = self:GetUnitName()
	local interim = "_talent_"

	local str = name .. interim .. talent_string

	return self:HasModifier(str)
end

function C_DOTA_BaseNPC:GetTalentValue2(talent_number)
	-- Talent number must be 1 to 8 
end

function C_DOTABaseAbility:FetchTalentDep(handle,suffix)
	local handle = handle or self:GetCaster()
	local suffix = suffix or ""
	suffix = "" .. suffix -- convert to string

	local ability_name = self:GetName() -- "<hero_name>_<ability_name>"
	local unit_name = handle:GetUnitName()

	local unit_entity_index = handle:GetEntityIndex()

	local talent_string = "special_bonus_"..ability_name
	local interim = "_talent_"

	local str = unit_name .. interim .. talent_string .. suffix

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

function C_DOTA_BaseNPC:FindTalentValue(talentName, key)
	local ab = self:FindAbilityByName(talentName)
	if ab then
		if ab:GetLevel() > 0 then
			local value_name = key or "value"
			return ab:GetSpecialValueFor(value_name)
		end
	end

	return 0
end

function C_DOTA_BaseNPC:HasShard()
	if self:HasModifier("modifier_item_aghanims_shard") then
		return true
	end

	return false
end

-- function C_DOTA_BaseNPC:FetchTalent(talent_name,val) -- returns the value attached to the Talent if it is learned, nil if not
--   if self:HasTalent(talent_name) then
--   	return FetchTalentValue(talent_name,val)
--   end
-- end

-- function C_DOTA_BaseNPC:HasTalent(talent_name)
-- 	if self:FindAbilityByName(talent_name) then
-- 		return true
-- 	end

-- 	return false
-- end