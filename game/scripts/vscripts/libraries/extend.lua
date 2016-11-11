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

function CDOTA_BaseNPC:GetDamageBeforeReductions(damageAmount,damageType)
	local unit = self
	local damage = damageAmount
	local dtype = damageType

	local armor = unit:GetPhysicalArmorValue()
	local magic_res = unit:GetMagicalArmorValue()
end