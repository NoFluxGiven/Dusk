-- EXTEND

-- Extends various resources with extra functionality.

-- ===================================================== PLAYER RESOURCE =====================================================

-- Initialise PDataTable:
function CDOTA_PlayerResource:InitPDataTable()
	print("[PDATA] Init.")
	self.PDataTable = {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},

		[5] = {},
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {}
	}
	for k,v in pairs(self.PDataTable) do
		v["active"] = false
		print(k.." "..tostring(v["active"]))
	end
end

function CDOTA_PlayerResource:IsPlayerActive(pid)
	return self.PDataTable[pid]["active"] == true
end

function CDOTA_PlayerResource:IsPlayerExalted(pid)
	print("Checking if Player ID "..pid.." is Exalted.")
	return self.PDataTable[pid]["exalted_item"] == true
end

--PopulatePData()
-- Adds an entry to the player data table for the player ID specified
function CDOTA_PlayerResource:PopulatePData(pid)
	print("[PDATA] Populating Player ID "..pid.." in the PData.")
	self.PDataTable[pid] = {
		["active"] = true,
		["exalted_item"] = false,
		["last_ability"] = nil
	}

end

function CDOTA_PlayerResource:MakeExalted(pid)
	self.PDataTable[pid]["exalted_item"] = true
end

--Grabs the value of a key in the PData table.
function CDOTA_PlayerResource:GetPDataKey(pid,key)
	print("[PDATA] Fetching "..key.." in PDataTable for Player ID "..pid)
	local value = self.PDataTable[key]
	if value ~= nil then
		return value
	else
		print("[PDATA] Error in GetPDataKey: resource is nil.")
		return nil
	end
end

function CDOTA_PlayerResource:SetPDataKey(key,value)
	self.PDataTable[key] = value
end

function CDOTA_PlayerResource:PrintPData(pid)
	local t = self.PDataTable[pid]
	if t == nil then print("[PDATA] Cannot print table contents: nil.") return end
	print("[PDATA] PrintPData","[PLAYER ID] ["..pid.."]")
	for k,v in pairs(t) do
		print(k..": "..v)
	end
end

function CDOTA_PlayerResource:GetPlayerList()
	-- Returns a table of players in game and fully loaded
	-- Each table element is the player's handle

	local ptable = {}

	for i=0,1,9 do
		if GetPlayer(i) then
			table.insert(ptable,GetPlayer(i))
		end
	end

	return ptable
end

function CDOTA_BaseNPC:GetDamageBeforeReductions(damageAmount,damageType)
	local unit = self
	local damage = damageAmount
	local dtype = damageType

	local armor = unit:GetPhysicalArmorValue()
	local magic_res = unit:GetMagicalArmorValue()

	local reduction_amount = 0

	if dtype == DAMAGE_TYPE_PHYSICAL then
		reduction_amount = 1 - 0.06 * armor / (1 + 0.06 * armor)
	elseif dtype == DAMAGE_TYPE_MAGICAL then
		reduction_amount = magic_res -- /100?
	else
		return damage
	end

	local damageBefore = damage * (1/reduction_amount)

	return damageBefore
end

function CDOTA_BaseNPC:IsEthereal()
	local isEthereal = false

	local ethereal_modifiers = {
		"modifier_ethereal"
	}

	for k,v in pairs(ethereal_modifiers) do
		if self:HasModifier(v) then isEthereal = true end
	end

	return isEthereal
end

function CDOTA_BaseNPC:HasTalent(talent_string)
  if self:HasAbility("special_bonus_"..talent_string) then
  	local ab = self:FindAbilityByName("special_bonus_"..talent_string)
  	if ab:GetLevel() > 0 then return true end
  end
  return false
end