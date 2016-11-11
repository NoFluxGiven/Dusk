function apply_vision_to_unit(keys)
  local caster = keys.caster
  local target = keys.target
  
  if not caster:IsAlive() then return end
  
  keys.ability:CreateVisibilityNode(target:GetAbsOrigin(), 200, 0.06) -- Works fine if the item is spawned directly, but when it's picked up as a drop, does not.
--  local dummy = CreateUnitByName("npc_dummy_unit", target:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
--  dummy:SetDayTimeVisionRange(200)
--  dummy:SetNightTimeVisionRange(200)
--  dummy:AddNewModifier(caster, nil, "modifier_kill", {Duration=0.06})
end

function remove(keys)
  local caster = keys.caster
  
  caster:AddAbility("watcher_curse")
  caster:FindAbilityByName("watcher_curse"):SetLevel(1)
  caster:FindAbilityByName("watcher_curse"):ApplyDataDrivenModifier(caster,caster,"watcher_curse_effects_mod",{})
  
  for i=0,5 do
    local item = caster:GetItemInSlot(i)
    
    if item ~= nil then
      if item:GetName() == "item_watchers_eye" then
        caster:RemoveItem(item)
      end
    end
  end
end

function drop(keys)
  local caster = keys.caster
  
  local attacker = keys.attacker
  
  local found = FindUnitsInRadius( attacker:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                FIND_UNITS_EVERYWHERE,
                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                DOTA_UNIT_TARGET_HERO,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
                                
  for k,v in pairs(found) do
    v:ModifyGold(500,true,0)
    v:AddExperience(1000,false,false)
  end
  
  local item = CreateItem("item_watchers_eye_inactive",nil,nil)
  CreateItemOnPositionSync(caster:GetAbsOrigin(),item)

end

function vision(keys)
  local caster = keys.caster
  
  keys.ability:CreateVisibilityNode(caster:GetAbsOrigin(), 1400, 0.06)
end

function activate(keys)
  local caster = keys.caster
  for i=0,5 do
    local item = caster:GetItemInSlot(i)
    
    if item ~= nil then
      if item:GetName() == "item_watchers_eye_inactive" then
        caster:RemoveItem(item)
      end
    end
  end
  local item_created = CreateItem("item_watchers_eye",caster,caster)
  caster:AddItem(item_created)
end

function check_hero(keys)
  local caster = keys.caster
  local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                1000,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
  if found[1] == nil then
    if caster.timeout ~= nil then caster.timeout = caster.timeout else caster.timeout = 0 end
    caster.timeout = caster.timeout+1
    if caster.timeout > 17 then caster:RemoveSelf() end
  end
end