if not Talents then
    Talents = {
      unitData={}, 
      gameKV= LoadKeyValues('scripts/npc/npc_heroes_custom.txt') or {},
      overrideKV= LoadKeyValues('scripts/npc/npc_heroes_override.txt') or {},
      maxNumTalentFiles = 20,
      currTalentFile = 1,
      application_item = CreateItem("item_talent_modifier", nil,nil),
      talentsKV = LoadKeyValues('scripts/npc/npc_talents.txt')
    }

    TalentsInit = true
else
    TalentsInit = false
end
-- Actual Code
function Talents.UnitPrototype_HasTalent(self, talentName)
    return Talents.unitData[self].learnedTalents[talentName]
end

function Talents.ApplyTalent(unit, talentName, talentTable)
    _G["desiredModifierName"] = unit:GetUnitName() .. "_talent_" .. talentName
    _G["modifierTable"] = talentTable

    Talents.currTalentFile = Talents.currTalentFile + 1
    if Talents.currTalentFile > Talents.maxNumTalentFiles then
        Talents.currTalentFile = 1
    end

    CustomNetTables:SetTableValue("talent_manager", "last_learned_talent_" .. Talents.currTalentFile, {v = desiredModifierName})
    CustomNetTables:SetTableValue("talent_manager", "server_to_lua_talent_properties_" ..  desiredModifierName, modifierTable)
    LinkLuaModifier(desiredModifierName, "talents/modifier_queue/modifier_talents_" .. Talents.currTalentFile .. ".lua", LUA_MODIFIER_MOTION_NONE)

    local mod = unit:AddNewModifier(unit, Talents.application_item, desiredModifierName, {})

    print(mod:GetStackCount().." STACKS!")
    Talents.unitData[unit].learnedTalents[talentName] = true
    if talentTable.Ability then
        if unit:HasAbility(talentTable.Ability) then
            unit:FindAbilityByName(talentTable.Ability):UpgradeAbility(true)
        else
            local abil = unit:AddAbility(talentTable.Ability)
            abil:SetLevel(1)
        end

        Timers:CreateTimer(2, function()
            for i=0,17 do
                local abil = unit:GetAbilityByIndex(i)
                if abil then
                    print("TALENTS1199 "..abil:GetAbilityName())
                end
            end
        end)

        --[[
        if talentTable.Index and false then

            --swap abiliteis
            abil:SetAbilityIndex(talentTable.Index)
        else
            if abil:IsAttributeBonus() then
                abil:SetAbilityIndex(9)
            else
                --push all abilities back by 1
                for i=3,17 do
                    local a = unit:GetAbilityByIndex(i)
                    if a then
                        a:SetAbilityIndex(i+1)
                    else
                        break
                    end
                end
                abil:SetAbilityIndex(0)
            end
        end]]

    end
end

--Event Listeners

function Talents.OnLearnTalent(playerId, keys)
    local unit = EntIndexToHScript(keys.unit)
    local talentRow = keys.row
    local talentName = keys.index --0 = left, 1 = right
    local talentData = unit.talentsKVTable.Talents["" .. talentRow][talentName]

    local x = Talents.unitData[unit].kv["Talents"]
    local y = x[""..talentRow]
    y.selected = talentName

    print("TALENT LEARNED: "..talentName.." | "..talentData.name)
    
    CustomNetTables:SetTableValue("talent_manager", "unit_talent_data_" .. unit:GetEntityIndex(), {levels = Talents.unitData[unit].kv["TalentLevels"] or Talents.talentsKV.DefaultTalentLevels or "10 15 20 25", data = Talents.unitData[unit].kv["Talents"]})
    Talents.ApplyTalent(unit, talentData.name, talentData)

end


function Talents.DeepCopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Talents.DeepCopyTable(orig_key)] = Talents.DeepCopyTable(orig_value)
        end
        setmetatable(copy, Talents.DeepCopyTable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function Talents.GetHeroTable(hero)
    for k,v in pairs(Talents.gameKV) do
        if v["override_hero"] == hero:GetUnitName() or k == hero:GetUnitName() then
            return v
        end
    end
    for k,v in pairs(Talents.overrideKV) do
        if v["override_hero"] == hero:GetUnitName() or k == hero:GetUnitName() then
            return v
        end
    end
end


function Talents.GetFirstTalentIndex(hero)

    for i =1,17 do
        if hero:GetAbilityByIndex(i) and string.find(hero:GetAbilityByIndex(i):GetAbilityName(), "special_") then
            return i
        end
    end
end

function Talents.OnUnitCreate(unit)
    unit.HasTalent = Talents.UnitPrototype_HasTalent
    Talents.unitData[unit] = {}
    Talents.unitData[unit].learnedTalents = {}
    local unitTable = Talents.GetHeroTable(unit) or {}
    Talents.unitData[unit].kv = Talents.DeepCopyTable(unitTable)
    unit.talentsKVTable = Talents.unitData[unit].kv

    local defaultLevels = Talents.talentsKV.DefaultTalentLevels or "10 15 20 25"
    local talentSet = {}
    local first = Talents.GetFirstTalentIndex(unit)

    if Talents.talentsKV.DefaultTalentSet then
        --use default talent set
        talentSet = Talents.DeepCopyTable(Talents.talentsKV.DefaultTalentSet["Talents"])

    elseif first then
        --generate based on DotA talent set
        --ability indexes 10-17
        for i =5,8 do
            local left = unit:GetAbilityByIndex(i*2 - (10 - first))
            local right = unit:GetAbilityByIndex(i*2 +1 - (10 - first))

            talentSet["" .. (i-4)] = {}
            talentSet["" .. (i-4)].left = {name = left:GetAbilityName(), Ability = left:GetAbilityName()}
            talentSet["" .. (i-4)].right = {name = right:GetAbilityName(), Ability = right:GetAbilityName()}
        end
    end

    if unitTable["Talents"] then
        for k,v in pairs(unitTable["Talents"]) do
            --k == 1,2,3,4 v = left,right
            talentSet[k]["left"] = v["left"] or talentSet[k]["left"]
            talentSet[k]["right"] = v["right"] or talentSet[k]["right"]
        end
    end

    unit.talentsKVTable.talentSet = talentSet
    unit.talentsKVTable.Talents = Talents.DeepCopyTable(talentSet)
    unit.talentsKVTable.levels = unitTable["TaleantLevels"] or defaultLevels

    CustomNetTables:SetTableValue("talent_manager", "unit_talent_data_" .. unit:GetEntityIndex(), {levels = unitTable["TalentLevels"] or defaultLevels, data = talentSet})


    for i = first, first+7 do
        if unit:GetAbilityByIndex(i) then --always use 10 because once 10 is removed 11 is moved into 10
            --unit:RemoveAbility(unit:GetAbilityByIndex(i):GetAbilityName())
        end
    end
end

function Talents.OnRequestData(keys)
    --wth does this function even do it's all nettable data
end

if TalentsInit then
    --first time
    --CDota_BaseNPC.HasTalent = Talents.UnitPrototype_HasTalent
    CustomGameEventManager:RegisterListener("talent_manager_choose_talent", Dynamic_Wrap(Talents, "OnLearnTalent"))
else
    --reload
end

--Helper functions

function Talents:GetLevelIndex(string, lvl)

end
