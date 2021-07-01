-- EXTEND

-- Extends various resources with extra functionality.

require("../internal/methods/Server_CBaseAbility")

-- ===================================================== NPC =====================================================

function CDOTA_BaseNPC:AddSRModifier( caster, ability, modifier_name, duration, kv )
	local sr = caster:GetStatusResistance()

	local modified_duration = (1 - (sr / 100)) * duration
	
	kv.Duration = modified_duration

	self:AddNewModifier(caster, ability, modifier_name, kv)
end

function CDOTA_BaseNPC:Stun( caster, ability, duration )
	self:AddSRModifier( caster, ability, "modifier_stunned", duration, {} )
end

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

	local armor = unit:GetPhysicalArmorValue(false)
	local magic_res = unit:GetMagicalArmorValue()

	local reduction_amount = 0

	if dtype == DAMAGE_TYPE_PHYSICAL then
		reduction_amount = 1 - 0.06 * armor / (1 + 0.06 * armor)
	elseif dtype == DAMAGE_TYPE_MAGICAL then
		reduction_amount = 1-magic_res -- /100?
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

-- Returns true if the Talent is skilled, false if not, nil if the Talent doesn't exist
function CDOTA_BaseNPC:GetHasTalent(talent_string)
	local name = self:GetUnitName()
	local interim = "_talent_"

	local str = name .. interim .. talent_string

	return self:HasModifier(str)
	
	-- self.HasTalent(self,talent_string)
end

-- Returns the handle of the Talent ability if (and only if) the Talent is skilled, otherwise returns nil
function CDOTA_BaseNPC:GetLearnedTalent(talent_string)
  if self:HasAbility(talent_string) then
  	local ab = self:FindAbilityByName(talent_string)
  	if ab then
  		if ab:GetLevel() > 0 then return ab end
  	end
  end
  return nil
end

-- Returns the handle of the Talent ability, or nil if it doesn't exist
function CDOTA_BaseNPC:GetTalent(talent_string)
  if self:HasAbility(talent_string) then
  	local ab = self:FindAbilityByName(talent_string)
  	return ab
  end
end

function CDOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = self:GetAbilityKeyValues()
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName then 
		local talent = self:GetCaster():FindAbilityByName(talentName)
		if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
	end
	return base
end

function CDOTABaseAbility:InflictDamage(target,attacker,damage,damage_type,flags)

	local flags = flags or 0

	local final_amount = ApplyDamage({
	    victim = target,
	    attacker = attacker,
	    damage = damage,
	    damage_type = damage_type,
	    damage_flags = flags,
	    ability = self
  	})

  	if not self then return end

  	print("INFLICT: ","ABILITY: "..self:GetName(),"DAMAGE/TYPE: "..damage.." / "..damage_type.." (FINAL DAMAGE: "..final_amount..")")
  	if flags ~= 0 then
  		print("FLAGS: "..flags)
  	end

  	return final_amount

end

function CDOTABaseAbility:IsSubability()

	local subAbilities = {
	    "baal_otherworld_exit",
	    "baal_port_out",
	    "gemini_planar_trickery_activate",
	    "hero_hyper_kick",
	    "ironfist_change_stance",
	    "ironfist_gale_stance",
	    "ironfist_stonewall_stance",
	    "ironfist_dragon_stance",
	    "switch_scarab_targets",
	    "timekeeper_chronoshift_end"
  	}

	local name = self:GetName()

	if CheckTable(subAbilities,name) then
		return true
	end

	return false
end

function CDOTABaseAbility:FetchTalentDep(handle,suffix)
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
		local mod = handle:FindModifierByName(str)
		local stack = 0
		if mod then
			stack = mod:GetStackCount()
		end

		if math.abs(stack) > 0 then
			return mod:GetStackCount()
		end

		-- Ends here if stacks are found, otherwise we do the more expensive operation (hopefully only once)

		local t = CustomNetTables:GetTableValue("talent_manager","unit_talent_data_"..unit_entity_index)

		for i=1,4 do
			local ltalent = t["data"][i..""]["left"]
			local rtalent = t["data"][i..""]["right"]

			if ltalent["name"] == talent_string then
				local v = ltalent["v"]
				if type(v) == "string" then v = tonumber(v) end
				mod:SetStackCount(v)
				-- print("TALENT VALUE: "..mod:GetStackCount().." Stack, "..v.." Main")
				if v ~= 0 then -- if v is zero, it's most likely a "toggle" (do this when skilled etc)
					return v 
				else
					return true
				end
			elseif rtalent["name"] == talent_string then
				local v = rtalent["v"]
				if type(v) == "string" then v = tonumber(v) end
				mod:SetStackCount(v)
				-- print("TALENT VALUE: "..mod:GetStackCount().." Stack, "..v.." Main")
				if v ~= 0 then
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

function CDOTA_Buff:WasPurged()
	-- call this function in OnDestroy() to determine if the modifier was purged or not
	local rt = self:GetRemainingTime()
	if rt > 0 then
		return true
	end
	return false
end

function CDOTA_Buff:CreateSubModifier(modifier_name,kv)
	-- Creates a modifier linked to this modifier on the modifier's parent
	-- Call "DestroySubModifiers" in OnDestroy event

	local modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_name, kv)

	if self.submodifiers then
		table.insert(self.submodifiers,modifier)
	else
		self.submodifiers = {modifier}
	end

end

function CDOTA_Buff:DestroySubModifiers()
	-- Destroys all linked submodifiers for the modifier
	
	if self.submodifiers then
		for k,v in pairs(self.submodifiers) do
			if v then
				if not v:IsNull() then
					v:Destroy()
				end
			end
		end

		self.submodifiers = nil
	end
end

function CDOTA_BaseNPC:FetchTalent(talent_name,val) -- returns the value attached to the Talent if it is learned, nil if not
  local ei = self:GetEntityIndex()
  local t = CustomNetTables:GetTableValue("learned_abilities", tostring(ei))
  local val = val or "value"

  local v = nil

  if t then
  	v = t[talent_name]

  	if type(v) == "table" then
  		v = v[val]
  	end
  end

  return v
end

function CDOTA_BaseNPC:IsRoshan()
	if self:GetName() == "npc_dota_roshan" then
		return true
	end
	return false
end

function CDOTA_BaseNPC:Knockback(direction,distance,time)
	local p = self

	Physics:Unit(p)
	p:SetPhysicsFriction(0)
	p:PreventDI(true)
	-- To allow going through walls / cliffs add the following:
	p:FollowNavMesh(false)
	p:SetAutoUnstuck(false)
	p:SetNavCollisionType(PHYSICS_NAV_NOTHING)

	p:SetPhysicsVelocity(direction * distance * (1/time))

	Timers:CreateTimer(time,function()
		p:SetPhysicsVelocity(0,0,0)
		p:PreventDI(false)
	end)
end

-- function CDOTA_BaseNPC:FetchTalent(talent_name,val) -- returns the value attached to the Talent if it is learned, nil if not
--   if self:HasTalent(talent_name) then
--   	return FetchTalentValue(talent_name,val)
--   end
-- end

-- function CDOTA_BaseNPC:HasTalent(talent_name)
-- 	if self:FindAbilityByName(talent_name) then
-- 		return true
-- 	end

-- 	return false
-- end