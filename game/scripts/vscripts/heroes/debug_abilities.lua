function debug_blink(event)
  local caster = event.caster
  local pos1 = caster:GetCursorPosition()
  FindClearSpaceForUnit(caster,pos1,true)
end

function debug_mass_teleport(event)
  local caster = event.caster
  local heroes = HeroList:GetAllHeroes()
  
  for k,v in pairs(heroes) do
    FindClearSpaceForUnit(v,caster:GetCursorPosition(),true)
  end
end