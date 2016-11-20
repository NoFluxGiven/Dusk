-- This file contains all duskdota-registered events and has already set up the passed-in parameters for your use.

RESPAWN_TIME_MULTIPLIER = 0.75

-- Cleanup a player when they leave
function duskDota:OnDisconnect(keys)
  DebugPrint('[DUSKDOTA] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

  -- check if the player has left during the game, and if they did it of their own accord
  -- if they did, play the ragequit sound

end
-- The overall game state has changed
function duskDota:OnGameRulesStateChange(keys)
  DebugPrint("[DUSKDOTA] GameRules State Changed")
  DebugPrintTable(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function duskDota:OnNPCSpawned(keys)
  DebugPrint("[DUSKDOTA] NPC Spawned")
  DebugPrintTable(keys)

  local npc = EntIndexToHScript(keys.entindex)
  local name = npc:GetUnitName()

  -- if name == "npc_dota_goodguys_siege" or name == "npc_dota_goodguys_siege_upgraded" or name == "npc_dota_goodguys_siege_upgraded_mega" then
  --   if duskDota.siegeCounterRadiant then
  --     duskDota.siegeCounterRadiant = duskDota.siegeCounterRadiant+1
  --   else
  --     duskDota.siegeCounterRadiant = 1
  --   end

  --   print("Siege counter now checked...")
  --   print("Radiant: "..duskDota.siegeCounterRadiant)

  --   if duskDota.siegeCounterRadiant > 6 then
  --     print("Siege cart spawn...")
  --     local lane = "none"
  --     local midtower = nil
  --     local toptower = nil
  --     local bottower = nil

  --     for k,v in pairs(duskDota.towers) do
  --       if v:GetUnitName() == "npc_dota_goodguys_tower3_mid" then
  --         midtower = v
  --         if midtower then print("MID TOWER: "..midtower:GetName()) else print("Mid tower not found.") end
  --       end
  --       if v:GetUnitName() == "npc_dota_goodguys_tower3_top" then
  --         toptower = v
  --         if toptower then print("TOP TOWER: "..toptower:GetName()) else print("Top tower not found.") end
  --       end
  --       if v:GetUnitName() == "npc_dota_goodguys_tower3_bot" then
  --         bottower = v
  --         if bottower then print("BOT TOWER: "..bottower:GetName()) else print("Bot tower not found.") end
  --       end
  --     end

  --     print("Getting radiant range to mid tower")
  --     if npc:GetRangeToUnit(midtower) < 750 then lane = "mid" print("Closest to mid.") end
  --     print("Getting radiant range to top tower")
  --     if npc:GetRangeToUnit(toptower) < 750 then lane = "top" print("Closest to top.") end
  --     print("Getting radiant range to bot tower")
  --     if npc:GetRangeToUnit(bottower) < 750 then lane = "bot" print("Closest to bot.") end

  --     print("Lane is "..lane..", spawning Titan creep for team"..npc:GetTeam())

  --     if lane == "none" then return true end

  --     local titan = CreateUnitByName("npc_dota_creep_goodguys_titan", npc:GetAbsOrigin(), true, npc:GetOwner(), npc:GetOwner(), DOTA_TEAM_GOODGUYS) --[[Returns:handle
  --     Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
  --     ]]
  --     local path_corner = Entities:FindByName(nil,"lane_"..lane.."_pathcorner_goodguys_1")
  --     if duskDota.siegeCounterRadiant >= 9 then duskDota.siegeCounterRadiant = 0 end
  --     titan:SetInitialGoalEntity(path_corner)
  --     titan:FindAbilityByName("titan_command_aura"):SetLevel(1)
  --     titan:FindAbilityByName("titan_demolisher"):SetLevel(1)
  --   end
  -- end

  -- if name == "npc_dota_badguys_siege" or name == "npc_dota_badguys_siege_upgraded" or name == "npc_dota_badguys_siege_upgraded_mega" then
  --   if duskDota.siegeCounterDire then
  --     duskDota.siegeCounterDire = duskDota.siegeCounterDire+1
  --   else
  --     duskDota.siegeCounterDire = 1
  --   end

  --   print("Dire: "..duskDota.siegeCounterDire)

  --   if duskDota.siegeCounterDire > 6 then
  --     print("Siege cart spawn...")
  --     local lane = "mid"
  --     local midtower = nil
  --     local toptower = nil
  --     local bottower = nil

  --     for k,v in pairs(duskDota.towers) do
  --       if v:GetUnitName() == "npc_dota_badguys_tower3_mid" then
  --         midtower = v
  --       end
  --       if v:GetUnitName() == "npc_dota_badguys_tower3_top" then
  --         toptower = v
  --       end
  --       if v:GetUnitName() == "npc_dota_badguys_tower3_bot" then
  --         bottower = v
  --       end
  --     end

  --     print("Getting dire range to mid tower")
  --     if npc:GetRangeToUnit(midtower) < 500 then lane = "mid" end
  --     print("Getting dire range to top tower")
  --     if npc:GetRangeToUnit(toptower) < 500 then lane = "top" end
  --     print("Getting dire range to bot tower")
  --     if npc:GetRangeToUnit(bottower) < 500 then lane = "bot" end

  --     print("Lane is "..lane..", spawning Titan creep for team"..npc:GetTeam())

  --     if lane == "none" then return true end

  --     local titan = CreateUnitByName("npc_dota_creep_badguys_titan", npc:GetAbsOrigin(), true, npc:GetOwner(), npc:GetOwner(), DOTA_TEAM_BADGUYS) --[[Returns:handle
  --     Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber )
  --     ]]
  --     local path_corner = Entities:FindByName(nil,"lane_"..lane.."_pathcorner_badguys_1")
  --     if duskDota.siegeCounterDire >= 9 then duskDota.siegeCounterDire = 0 end
  --     titan:SetInitialGoalEntity(path_corner)
  --     titan:FindAbilityByName("titan_command_aura"):SetLevel(1)
  --     titan:FindAbilityByName("titan_demolisher"):SetLevel(1)
  --   end
  -- end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function duskDota:OnEntityHurt(keys)
  --DebugPrint("[DUSKDOTA] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function duskDota:OnItemPickedUp(keys)
  DebugPrint( '[DUSKDOTA] OnItemPickedUp' )
  DebugPrintTable(keys)

  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end

  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function duskDota:OnPlayerReconnect(keys)
  DebugPrint( '[DUSKDOTA] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function duskDota:OnItemPurchased( keys )
  DebugPrint( '[DUSKDOTA] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function duskDota:OnAbilityUsed(keys)
  DebugPrint('[DUSKDOTA] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function duskDota:OnNonPlayerUsedAbility(keys)
  DebugPrint('[DUSKDOTA] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function duskDota:OnPlayerChangedName(keys)
  DebugPrint('[DUSKDOTA] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function duskDota:OnPlayerLearnedAbility( keys)
  DebugPrint('[DUSKDOTA] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  --[[local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname

  local hero = PlayerResource:GetSelectedHeroEntity(player:GetPlayerID())

  local ablvl = hero:FindAbilityByName(abilityname):GetLevel()

  local event_data = {
    ability = abilityname,
    level = ablvl,
    hero_entity = hero,
    player_entity = player
  }
  
  CustomGameEventManager:Send_ServerToPlayer( player, "event_skillbuild_levelled_ability",  event_data)
  ]]
end

-- A channelled ability finished by either completing or being interrupted
function duskDota:OnAbilityChannelFinished(keys)
  DebugPrint('[DUSKDOTA] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function duskDota:OnPlayerLevelUp(keys)
  DebugPrint('[DUSKDOTA] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function duskDota:OnLastHit(keys)
  DebugPrint('[DUSKDOTA] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)

  if killedEnt:GetName() == "npc_dota_roshan" then
    print("Roshan killed.")
    
  end
end

-- A tree was cut down by tango, quelling blade, etc
function duskDota:OnTreeCut(keys)
  DebugPrint('[DUSKDOTA] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function duskDota:OnRuneActivated (keys)
  DebugPrint('[DUSKDOTA] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function duskDota:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[DUSKDOTA] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function duskDota:OnPlayerPickHero(keys)
  DebugPrint('[DUSKDOTA] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function duskDota:OnTeamKillCredit(keys)
  DebugPrint('[DUSKDOTA] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function duskDota:OnEntityKilled( keys )
  DebugPrint( '[DUSKDOTA] OnEntityKilled Called' )
  DebugPrintTable( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  if killedUnit.remove_attachments_on_death == true then
    local s = removePropFromUnit(killedUnit,"all")
    if s then
      print("Removed props from unit.")
    else
      print("No props to remove on unit.")
    end
  end

  if killedUnit:IsRealHero() then 
    print( '[BAREBONES] OnEntityKilled Called' )
    PrintTable( keys )
    print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
    if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
      self.lastRadiantKill = {attacker = killerEntity, victim = killedUnit}
      self.nRadiantKills = self.nRadiantKills + 1
      -- if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
      --   GameRules:SetSafeToLeave( true )
      --   GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
      -- end
    elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
      self.lastDireKill = {attacker = killerEntity, victim = killedUnit}
      self.nDireKills = self.nDireKills + 1
      -- if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
      --   GameRules:SetSafeToLeave( true )
      --   GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
      -- end
    end
    
    -- Set respawn time based on a variety of factors
  if not killedUnit:IsReincarnating() then
   local hero = killedUnit
   local level = hero:GetLevel()
   local respawn_time = level * 2.75 + 4
   local buyback_penalty = 1.10
   local respawn_multiplier = 1

   if hero:GetBuybackCooldownTime() > 0 then
    respawn_time = respawn_time * buyback_penalty
   end

   if hero:HasAbility("gob_squad_whoops") and hero:FindAbilityByName("gob_squad_whoops"):GetLevel() > 0 then
    print("Gob Squad")
    local ab = hero:FindAbilityByName("gob_squad_whoops")
    local respawn_reduction_level = ab:GetLevel()
    respawn_multiplier = 1-ab:GetLevelSpecialValueFor("respawn", respawn_reduction_level)/100
   end

   respawn_time = respawn_time * respawn_multiplier

   hero:SetTimeUntilRespawn(respawn_time) --[[Returns:void
   No Description Set
   ]]
  end

    -- if SHOW_KILLS_ON_TOPBAR then
    --   GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
    --   GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
    -- end
  end
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function duskDota:PlayerConnect(keys)
  DebugPrint('[DUSKDOTA] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function duskDota:OnConnectFull(keys)
  DebugPrint('[DUSKDOTA] OnConnectFull')
  DebugPrintTable(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()

  PlayerResource:PopulatePData(playerID)
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function duskDota:OnIllusionsCreated(keys)
  DebugPrint('[DUSKDOTA] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function duskDota:OnItemCombined(keys)
  DebugPrint('[DUSKDOTA] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function duskDota:OnAbilityCastBegins(keys)
  DebugPrint('[DUSKDOTA] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function duskDota:OnTowerKill(keys)
  DebugPrint('[DUSKDOTA] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function duskDota:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[DUSKDOTA] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function duskDota:OnNPCGoalReached(keys)
  DebugPrint('[DUSKDOTA] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function duskDota:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end

function duskDota:On_dota_player_update_hero_selection(data)
  print("[DUSKDOTA] dota_player_update_hero_selection")
  PrintTable(data)
end