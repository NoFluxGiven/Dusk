function summon(keys)
  local caster = keys.caster
  local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                1500,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_BUILDING,
                                DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                                FIND_CLOSEST,
                                false)
  local number = keys.summon_number or 1
  local item_name = "item_summoning_stone_green"
  local summon = "npc_dota_unit_boss_natures_guardian"
  local summon2 = ""
  local summon3 = ""
  local sound = "Hero_Nevermore.RequiemOfSoulsCast"
  local delay = 1

  switch_table = {
    [1] = function()
            item_name = "item_summoning_stone_green"
            summon = "npc_dota_unit_boss_natures_guardian"
          end,
    [2] = function()
            item_name = "item_summoning_stone_teal"
            summon = "npc_dota_unit_boss_zeus"
          end,
    [3] = function()
            item_name = "item_summoning_stone_blue"
            summon = "npc_dota_unit_boss_siren"
          end,
    [4] = function()
            item_name = "item_summoning_stone_beige"
            summon = "npc_dota_unit_boss_sand_golem"
          end,
    [5] = function()
            item_name = "item_summoning_stone_red"
            summon = "npc_dota_unit_boss_romulus"
            summon2 = "npc_dota_unit_boss_remus"
          end,
    [6] = function()
            item_name = "item_summoning_stone_gold"
            summon = "npc_dota_unit_boss_greed"
          end,
    [7] = function()
            item_name = "item_summoning_stone_white"
            summon = "npc_dota_unit_boss_seraphim"
          end,
    [8] = function()
            item_name = "item_summoning_stone_purple"
            summon = "npc_dota_unit_boss_grimoire_guardian"
          end,
    [9] = function()
            item_name = "item_summoning_stone_black"
            summon = "npc_dota_unit_boss_darkness"
            sound = "Boss_Darkness.Summon"
            delay = 3
          end,
    [10] = function()
            item_name = "item_summoning_stone_orange"
            summon = "npc_dota_unit_fire_elemental"
          end,
  }

  switch_table[number]()

  if not caster:IsPositionInRange(Vector(4253,-1520,0), 900) then return 0 end

  caster:EmitSound(sound)
  Timers:CreateTimer("summon_unit",{
  endTime = delay,
  callback = function()
  local unit = CreateUnitByName(summon, Vector(4253,-1520,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
  local unit2, unit3 = {}, {}
  if summon2 ~= "" then unit2 = CreateUnitByName(summon2, keys.caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS) end
  if summon3 ~= "" then unit3 = CreateUnitByName(summon3, keys.caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS) end
    for i=0,5 do
      local item = caster:GetItemInSlot(i)
      
      if item ~= nil then
        if item:GetName() == item_name then
          caster:RemoveItem(item)
        end
      end
    end
  end})
end