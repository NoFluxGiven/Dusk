print ('[BAREBONES] barebones.lua' )

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = false        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 60.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 1                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 0.5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true      -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false      -- Should we disable fog of war entirely for both teams?
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = false       -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = false             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = true-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 0         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = false           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = false             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

SHOW_RECOMMENDED_ITEMS_NOT = true          -- Should we show recommended items?

RESPAWN_TIME_MULTIPLIER = 0.75           -- Multiplies the default respawn time by this amount when a unit dies.

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if GameMode == nil then
    print ( '[BAREBONES] creating barebones game mode' )
    GameMode = class({})
end


--[[
  This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function 
  in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
  If this occurs it causes the client to never precache things configured in that block.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).
]]
function GameMode:PostLoadPrecache()
  ToolsPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
  --PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  ToolsPrint("[BAREBONES] First Player has loaded")
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode,"FilterExecuteOrder"), self )
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode,"FilterTakeDamage"), self )
  GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(GameMode,"FilterAbility"), self )
  GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode,"FilterGold"), self )
  GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode,"FilterExperience"), self )
  GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(GameMode,"FilterRuneSpawn"), self )

  -- ANCIENT ABILITIES

  local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

  ToolsPrint("BUILDINGS BEING THING STUFF")

  -- for _,building in pairs(buildings) do
  --     local building_name = building:GetName()

  --     if string.find(building_name,"tower") then
  --         local newhp = building:GetMaxHealth()*1.4
  --         building:SetMaxHealth(newhp)
  --         building:SetHealth(newhp)
    
  --     elseif string.find(building_name,"rax_melee") then
  --         -- Rax abilities
  --     elseif string.find(building_name,"rax_ranged") then
  --         -- Rax abilities
  --     elseif string.find(building_name,"fort") then
  --         -- Ancient abilities
  --         building:AddAbility("ancient_passive")
  --         local ab = building:FindAbilityByName("ancient_passive")
  --         ab:SetLevel(1)
  --     end
  -- end
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  ToolsPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  ToolsPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  --[[ Multiteam configuration, currently unfinished

  local team = "team1"
  local playerID = hero:GetPlayerID()
  if playerID > 3 then
    team = "team2"
  end
  ToolsPrint("setting " .. playerID .. " to team: " .. team)
  MultiTeam:SetPlayerTeam(playerID, team)]]

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(650, false)

  if hero:GetUnitName() == "npc_dota_hero_rubick" then
      CosmeticLib:ReplaceDefault(hero,"npc_dota_hero_rubick")
  end

  if hero:GetUnitName() == "npc_dota_hero_terrorblade" then
      CosmeticLib:RemoveAll(hero)
      local ab = hero:FindAbilityByName("bahamut_hidden_transform")
      ab:SetLevel(1)
  end
  if hero:GetUnitName() == "npc_dota_hero_doom_bringer" then
      CosmeticLib:RemoveAll(hero)
      local ab = hero:FindAbilityByName("alroth_model_change")
      ab:SetLevel(1)
  end

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_multiteam_action", hero, hero)
  --hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  ToolsPrint("[BAREBONES] The game has officially begun")
  
  Timers:CreateTimer(60*45,
  function()
    GameRules:SetGoldPerTick(GOLD_PER_TICK*5)
  end)

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
  function()
    ToolsPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
    return 30.0 -- Rerun this timer every 30 game-time seconds 
  end)
  --DEPRECATED
  -- ToolsPrint('[BAREBONES] Adding the damage check ability to all buildings')
  -- local bt = Entities:FindAllByClassname("npc_dota_building")
  -- local bt2 = Entities:FindAllByClassname("npc_dota_tower")
  -- local bt3 = Entities:FindAllByClassname("npc_dota_fort")
  
  -- for k,v in pairs(bt2) do table.insert(bt,v) end
  -- for k,v in pairs(bt3) do table.insert(bt,v) end -- merge the tables
  
  -- for k,v in pairs(bt) do
  --   v:AddAbility("main_damage")
  --   v:FindAbilityByName("main_damage"):SetLevel(1)
  --   v:FindAbilityByName("main_damage"):SetHidden(true)
  --   ToolsPrint("[BAREBONES] Added damage check ability to "..v:GetName())
  -- end
end

function GameMode:FilterExecuteOrder( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Order: "..k.." "..tostring(v))
  -- end
  local order_type = filterTable["order_type"]
  local user = filterTable["issuer_player_id_const"]
  local hero = PlayerResource:GetSelectedHeroEntity(user)
  local ability = nil

  if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
    if hero then
      if hero:HasModifier("modifier_superposition") then
        if hero.superposition_unit then
          if IsValidEntity(hero.superposition_unit) then
            local x = tonumber(filterTable["position_x"])
            local y = tonumber(filterTable["position_y"])
            local z = tonumber(filterTable["position_z"])

            local ab = hero:FindAbilityByName("baal_superposition")

            local max = ab:GetLevelSpecialValueFor("radius", ab:GetLevel()) --[[Returns:table
            No Description Set
            ]]

            local point = Vector(x,y,z)

            local unit = FastDummy(point,hero:GetTeam(),0.09,0)

            local distance = unit:GetRangeToUnit(hero.superposition_unit)

            local direction = (point - hero:GetAbsOrigin()):Normalized()


            if hero:GetRangeToUnit(hero.superposition_unit) > max then
              return true
            end

            if distance > max then
              return true
            end

            FindClearSpaceForUnit(hero, point, true) --[[Returns:void
            Place a unit somewhere not already occupied.
            ]]
            ProjectileManager:ProjectileDodge(hero) --[[Returns:void
            Makes the specified unit dodge projectiles
            ]]
            --hero:SetForwardVector(direction)

            local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_superposition_teleport.vpcf", PATTACH_ABSORIGIN, hero) --[[Returns:int
            Creates a new particle effect
            ]]
            local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_superposition_teleport.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
            Creates a new particle effect
            ]]

            return false

          end
        end
      end
    end
  end
  if order_type ==  DOTA_UNIT_ORDER_CAST_NO_TARGET -- make sure it's an ability we're using
  or order_type == DOTA_UNIT_ORDER_CAST_POSITION
  or order_type == DOTA_UNIT_ORDER_CAST_RUNE
  or order_type == DOTA_UNIT_ORDER_CAST_TARGET
  or order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
    if filterTable["entindex_ability"] > 0 then
      ability = EntIndexToHScript(filterTable["entindex_ability"])
      ToolsPrint("ABILITY IS "..ability:GetName())
    end

    if ability then
    -- Set last ability
      -- ENCORE
      if hero:HasModifier("modifier_trickster_encore") then
        if hero.last_ability_used then
          ToolsPrint("last ability used is not nil")
          ToolsPrint("last ability was "..hero.last_ability_used:GetName().." and used ability was "..ability:GetName())
          if ability ~= hero.last_ability_used then
            return false
          end
        end
      end
    hero.last_ability_used = ability
    ToolsPrint("ABILITY SET TO "..ability:GetName().." LOL")
    ToolsPrint("LE DEBUG CHECK: "..hero.last_ability_used:GetName())
    end
  end
  return true
end

function GameMode:FilterTakeDamage( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Damage: "..k.." "..tostring(v))
  -- end
  
  local attacker = EntIndexToHScript(filterTable["entindex_attacker_const"])
  local defender = EntIndexToHScript(filterTable["entindex_victim_const"])
  local dtype = filterTable["damagetype_const"] -- constant integer
  local damage = filterTable["damage"] -- float

  -- TRANQUIL SEAL
  if attacker:HasModifier("paragon_tranquil_seal_mod") or defender:HasModifier("paragon_tranquil_seal_mod") then
    return false
  end

  -- GUARDIAN
  if defender:HasModifier("paragon_guardian_mod") then
    -- Redirect the damage to Paragon with the damage reduced
    -- Grab the damage reduction first:
    local guardian = nil
    if defender.guardian then
      guardian = defender.guardian
    end
    if not defender.guardian then return true end
    if guardian:HasModifier("paragon_tranquil_seal_mod") then return true end
    if guardian:IsAlive() ~= true then return true end
    if guardian == defender then return true end

    local ab = guardian:FindAbilityByName("paragon_guardian")

    local reduction = 1-(ab:GetLevelSpecialValueFor("reduction", ab:GetLevel()-1) / 100)
    ToolsPrint("GUARDIAN: "..reduction)

    -- filterTable["damage"] = damage*reduction
    -- filterTable["entindex_victim_const"] = guardian:entindex()
    -- filterTable["damagetype_const"] = DAMAGE_TYPE_MAGICAL
    DealDamageThroughMagicImmunity(guardian,attacker,damage*reduction,DAMAGE_TYPE_PURE)
    ToolsPrint("GUARDIAN: "..guardian:entindex())
    return false
  end

  --REALMBLISTER

  if attacker:HasModifier("modifier_chronosphere_datadriven") or attacker:HasModifier("modifier_chronosphere_caster_datadriven") then
    if defender:HasModifier("modifier_chronosphere_datadriven") or defender:HasModifier("modifier_chronosphere_caster_datadriven") then
      return true
    end
    return false
  end

  if defender:HasModifier("modifier_chronosphere_datadriven") or defender:HasModifier("modifier_chronosphere_caster_datadriven") then
    if attacker:HasModifier("modifier_chronosphere_datadriven") or attacker:HasModifier("modifier_chronosphere_caster_datadriven") then
      return true
    end
    return false
  end

  --GRAVEGUARD
  if defender:HasModifier("elena_graveguard_mod_shld") then
    local stacks = defender:GetModifierStackCount("elena_graveguard_mod_shld",defender)
    defender:SetModifierStackCount("elena_graveguard_mod_shld",defender,stacks-damage)

    if stacks - damage < 0 then
        local amt = math.abs(stack-damage)

        defender:RemoveModifierByName("elena_graveguard_mod_shld") --[[Returns:void
        Removes a modifier
        ]]

        filterTable["damage"] = amt
        return true
    end
    return false
  end

  --DISPLACE
  if defender:HasModifier("modifier_displace") then
    defender.displace_damage = defender.displace_damage+damage

    if damage > defender.displace_last_damage then defender.displace_attacker = attacker end

    defender.displace_last_damage = damage

    return false
  end

  --FUTURE SIGHT
  if defender:HasModifier("modifier_precognition") then
    local r = RandomInt(1,100) --[[Returns:int
    Get a random ''int'' within a range
    ]]

    if r < 33 then
      ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, defender) --[[Returns:int
      Creates a new particle effect
      ]]
      return false
    end
    return true
  end


return true

end

function GameMode:FilterAbility( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Ability: "..k.." "..tostring(v)) 
  -- end

  -- filterTable["value"] = filterTable["value"]*5
  -- return true

  return false
end

function GameMode:FilterGold( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Gold: "..k.." "..tostring(v)) 
  -- end

  return true
end

function GameMode:FilterExperience( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Experience: "..k.." "..tostring(v)) 
  -- end

  return true
end

function GameMode:FilterRuneSpawn( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   ToolsPrint("Rune: "..k.." "..tostring(v)) 
  -- end

  return true
end


-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  ToolsPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  PrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  ToolsPrint("[BAREBONES] GameRules State Changed")
  PrintTable(keys)

  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    self.bSeenWaitForPlayers = true
  elseif newState == DOTA_GAMERULES_STATE_INIT then
    Timers:RemoveTimer("alljointimer")
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    local et = 6
    if self.bSeenWaitForPlayers then
      et = .01
    end
    Timers:CreateTimer("alljointimer", {
      useGameTime = true,
      endTime = et,
      callback = function()
        if PlayerResource:HaveAllPlayersJoined() then
          GameMode:PostLoadPrecache()
          GameMode:OnAllPlayersLoaded()
          return 
        end
        return 1
      end
      })
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    GameMode:OnGameInProgress()
  end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  -- ToolsPrint("[BAREBONES] NPC Spawned")
  -- PrintTable(keys)
  local npc = EntIndexToHScript(keys.entindex)

  npc:AddAbility("main_just_spawned") -- tell the system this unit spawned in this frame
  npc:FindAbilityByName("main_just_spawned"):SetLevel(1)

  if npc:IsRealHero() and npc.bFirstSpawned == nil then
    npc.bFirstSpawned = true
    GameMode:OnHeroInGame(npc)
  end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
--  ToolsPrint("[BAREBONES] Entity Hurt")
--  PrintTable(keys)
  local entCause = EntIndexToHScript(keys.entindex_attacker)
  local entVictim = EntIndexToHScript(keys.entindex_killed)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  print ( '[BAREBONES] OnItemPickedUp' )
  PrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname

  -- if heroEntity:FindAbilityByName("mifune_zanmato_scepter") and itemname == "item_ultimate_scepter" then
  --   local ab = heroEntity:FindAbilityByName("mifune_zanmato")
  --   local scep = heroEntity:FindAbilityByName("mifune_zanmato_scepter")
  --   ab:SetHidden(true)
  --   scep:SetHidden(false)
  --   scep:SetLevel(ab:GetLevel())
  -- end
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  print ( '[BAREBONES] OnPlayerReconnect' )
  PrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  print ( '[BAREBONES] OnItemPurchased' )
  PrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  ToolsPrint('[BAREBONES] AbilityUsed')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.PlayerID+1)
  local abilityname = keys.abilityname
  
  local hero = player:GetAssignedHero()

  
  
  -- if hero then
  --   --[BEGIN] CRIMSON: Blood Sorcery
  --   if hero:HasModifier("crimson_blood_sorcery_mod") then
  --   ToolsPrint("====[CRIMSON: Blood Sorcery]"..abilityname)
  --     local ab = hero:FindAbilityByName(abilityname)
  --     if ab == nil then -- it's probably an item
  --       for i=0,5 do
  --           -- Grab the slot item
  --           local slotItem = hero:GetItemInSlot(i)

  --           -- Was this the spell that was cast?
  --           if slotItem and slotItem:GetClassname() == abilityname then
  --               -- We found it
  --               ab = slotItem
  --               break
  --           end
  --       end
  --     end
  --     local reduc = (hero:FindAbilityByName("crimson_blood_sorcery"):GetLevelSpecialValueFor("reduction",hero:FindAbilityByName("crimson_blood_sorcery"):GetLevel()-1)/100)
  --     ToolsPrint("====[CRIMSON: Blood Sorcery] "..reduc)
  --     local cost = ab:GetManaCost(ab:GetLevel()-1)
  --     local damage = cost*reduc
  --     local remaining = cost-(damage*(1-reduc))
  --     local hp = hero:GetHealth()
      
  --     if damage < hp then
  --       hero:GiveMana(remaining)
  --       hero:SetHealth(hp-damage)
  --     end
  --   end
  --   --[END] CRIMSON: Blood Sorcery
  -- else error("Hero is nil.") end
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  ToolsPrint('[BAREBONES] OnNonPlayerUsedAbility')
  PrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  ToolsPrint('[BAREBONES] OnPlayerChangedName')
  PrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  print ('[BAREBONES] OnPlayerLearnedAbility')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  print ('[BAREBONES] OnAbilityChannelFinished')
  PrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  print ('[BAREBONES] OnPlayerLevelUp')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  print ('[BAREBONES] OnLastHit')
  PrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  print ('[BAREBONES] OnTreeCut')
  PrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  print ('[BAREBONES] OnRuneActivated')
  PrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  print ('[BAREBONES] OnPlayerTakeTowerDamage')
  PrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  print ('[BAREBONES] OnPlayerPickHero')
  PrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
--  ToolsPrint('[BAREBONES] Adding the damage check ability to newly picked hero')
--  heroEntity:AddAbility("main_damage")
--  heroEntity:FindAbilityByName("main_damage"):SetLevel(1)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  print ('[BAREBONES] OnTeamKillCredit')
  PrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  -- ToolsPrint( '[BAREBONES] OnEntityKilled Called' )
  -- PrintTable( keys )
  
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  if string.find(killedUnit:GetUnitName(),"npc_dota_unit_axial") then
    if killedUnit.p then
      ParticleManager:DestroyParticle(killedUnit.p,false)
      killedUnit:AddNoDraw()
    end
  end



  if killedUnit:IsRealHero() then 
    ToolsPrint( '[BAREBONES] OnEntityKilled Called' )
    PrintTable( keys )
    print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
    if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
      self.lastRadiantKill = {attacker = killerEntity, victim = killedUnit}
      self.nRadiantKills = self.nRadiantKills + 1
      if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
      end
    elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
      self.lastDireKill = {attacker = killerEntity, victim = killedUnit}
      self.nDireKills = self.nDireKills + 1
      if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
      end
    end
    
    -- Reduce respawn time by the respawn reduction constant
    
--    local respawn_time = killedUnit:GetTimeUntilRespawn()
--    local respawn_new = respawn_time*RESPAWN_TIME_MULTIPLIER
--    killedUnit:SetTimeUntilRespawn(respawn_new)

    if SHOW_KILLS_ON_TOPBAR then
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
    end
  end

  -- Put code here to handle when an entity gets killed
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  ToolsPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Setup rules
  GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
  GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
  GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
  GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
  GameRules:SetPreGameTime( PRE_GAME_TIME)
  GameRules:SetPostGameTime( POST_GAME_TIME )
  GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
  GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  GameRules:SetGoldPerTick(GOLD_PER_TICK)
  GameRules:SetGoldTickTime(GOLD_TICK_TIME)
  GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  --GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
  GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
  ToolsPrint('[BAREBONES] GameRules set')

  InitLogFile( "log/barebones.txt","")

  -- Event Hooks
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
  ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
  ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
  ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
  ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
  --ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)



  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )
  Convars:RegisterCommand( "kv_reload", function() GameRules:Playtesting_UpdateAddOnKeyValues() end, "Reloads all keyvalues from the disk.", 0)
  Convars:RegisterCommand( "respawn_heroes", function()
    local herotable = HeroList:GetAllHeroes()
    local player = Convars:GetCommandClient()
    if not GameRules:PlayerHasCustomGameHostPrivileges(player) then
      if PlayerResource:GetSteamAccountID(player:GetPlayerID()) ~= 26568734 then
        error("Player does not have host privileges.") return
      end
    end
    for k,v in pairs(herotable) do
      if not v:IsAlive() then
        v:SetTimeUntilRespawn(1)
      end
    end
  end, "Respawns all heroes in the game.", 0)
Convars:RegisterCommand( "spawn_debugbear", function()
    local player = Convars:GetCommandClient()
    local hero = player:GetAssignedHero()
    local db = CreateUnitByName("npc_dota_unit_debug", Vector(0,0,0), true, hero, hero, hero:GetTeam())
    if not GameRules:PlayerHasCustomGameHostPrivileges(player) then
      if PlayerResource:GetSteamAccountID(player:GetPlayerID()) ~= 26568734 then
        error("Player does not have host privileges.") return
      end
    end
    Timers:CreateTimer(.04, function()
        db:SetControllableByPlayer(hero:GetPlayerID(), true)
    end)
    ToolsPrint("PLAYER IDS: BEAR OWNER: "..db:GetPlayerOwnerID().." PLAYER'S ID: "..player:GetPlayerID())
    ToolsPrint("TEAMS: BEAR: "..db:GetTeam().." PLAYER: "..hero:GetTeam())
  end, "Immediately spawns the debugbear.", 0)
  
  -- Fill server with fake clients
  -- Fake clients don't use the default bot AI for buying items or moving down lanes and are sometimes necessary for debugging
  Convars:RegisterCommand('fake', function()
    -- Check if the server ran it
    if not Convars:GetCommandClient() then
      -- Create fake Players
      SendToServerConsole('dota_create_fake_clients')
        
      Timers:CreateTimer('assign_fakes', {
        useGameTime = false,
        endTime = Time(),
        callback = function(barebones, args)
          local userID = 20
          for i=0, 9 do
            userID = userID + 1
            -- Check if this player is a fake one
            if PlayerResource:IsFakeClient(i) then
              -- Grab player instance
              local ply = PlayerResource:GetPlayer(i)
              -- Make sure we actually found a player instance
              if ply then
                CreateHeroForPlayer('npc_dota_hero_axe', ply)
                self:OnConnectFull({
                  userid = userID,
                  index = ply:entindex()-1
                })

                ply:GetAssignedHero():SetControllableByPlayer(0, true)
              end
            end
          end
        end})
    end
  end, 'Connects and assigns fake Players.', 0)

  --[[This block is only used for testing events handling in the event that Valve adds more in the future
  Convars:RegisterCommand('events_test', function()
      GameMode:StartEventTest()
    end, "events test", 0)]]

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))

  -- Initialized tables for tracking state
  self.vUserIds = {}
  self.vSteamIds = {}
  self.vBots = {}
  self.vBroadcasters = {}

  self.vPlayers = {}
  self.vRadiant = {}
  self.vDire = {}

  self.nRadiantKills = 0
  self.nDireKills = 0
  
  self.avatar_summoned = false
  
  self.lastRadiantKill = {}
  self.lastDireKill = {}

  self.bSeenWaitForPlayers = false

  ToolsPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()        
    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled( BUYBACK_ENABLED )
    mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

    -- mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

    mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
    mode:SetRecommendedItemsDisabled( SHOW_RECOMMENDED_ITEMS_NOT )


    --GameRules:GetGameModeEntity():SetThink( "Think", self, "GlobalThink", 2 )

    self:SetupMultiTeams()
    self:OnFirstPlayerLoaded()
  end 
end

-- Multiteam support is unfinished currently
function GameMode:SetupMultiTeams()
  MultiTeam:start()
  MultiTeam:CreateTeam("team1")
  MultiTeam:CreateTeam("team2")
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  ToolsPrint('[BAREBONES] PlayerConnect')
  PrintTable(keys)
  
  if keys.bot == 1 then
    -- This user is a Bot, so add it to the bots table
    self.vBots[keys.userid] = 1
  end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  print ('[BAREBONES] OnConnectFull')
  PrintTable(keys)
  GameMode:CaptureGameMode()
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
  
  -- Update the user ID table with this user
  self.vUserIds[keys.userid] = ply

  -- Update the Steam ID table
  self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply
  
  -- If the player is a broadcaster flag it in the Broadcasters table
  if PlayerResource:IsBroadcaster(playerID) then
    self.vBroadcasters[keys.userid] = 1
    return
  end
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  ToolsPrint( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  ToolsPrint( '*********************************************' )
end

--require('eventtest')
--GameMode:StartEventTest()