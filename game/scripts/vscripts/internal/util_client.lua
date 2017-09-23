function ToolsPrint(...)
  if IsInToolsMode() then
    print(...)
  end
end

function FetchTalentValue(talent_name,val) -- grabs the value of the Talent or nil if not found
  local val = val or "value"

  if TALENTS[talent_name] == nil then return nil end

  local v = TALENTS[talent_name][val]
  if v then return v else return 0 end -- since if the talent entry exists, and values dont, it's probably a boolean

  return nil
end