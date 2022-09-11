function ToolsPrint(...)
  if IsInToolsMode() then
    print(...)
  end
end

function FetchTalentValue(talent_name,val) -- grabs the value of the Talent or nil if not found
  local val = val or "value"

  local talent_value = CustomNetTables:GetTableValue("talent_data", talent_name)

  print("[FetchTalentValue] Fetching talent value for "..talent_name)

  if talent_value == nil then
    print("[FetchTalentValue] Nil")
    return nil
  end

  if talent_value then
  	local v = talent_value[val]
  	if v then
      print("[FetchTalentValue] Value is "..v)
  		return v
  	else
      print("[FetchTalentValue] Value is a table and is empty. Returning a table with value: 0")
  		return {value = 0}
  	end
  end

  print("[FetchTalentValue] After all that, value is nil.")

  return nil
end

function HeroParticle(hero, name)
  return "particles/units/heroes/hero_"..hero:lower().."/"..name:lower()..".vpcf"
end