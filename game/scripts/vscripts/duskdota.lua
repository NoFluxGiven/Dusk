-- This is the primary duskdota duskdota script and should be used to assist in initializing your game mode
DUSKDOTA_VERSION = "1.98"

-- Set this to true if you want to see a complete debug output of all events/processes done by duskdota
-- You can also change the cvar 'duskdota_spew' at any time to 1 or 0 for output/no output
DUSKDOTA_DEBUG_SPEW = false

HEX_COLOR_AQUA = "#C3D6D6"
HEX_COLOR_BLUE = ""
HEX_COLOR_GREEN = ""
HEX_COLOR_PURPLE = "#39316d"
HEX_COLOR_RED = "#992E2E"
HEX_COLOR_GOLD = "#FFD700"

if duskDota == nil then
    DebugPrint( '[DUSKDOTA] creating duskdota game mode' )
    _G.duskDota = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
--require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')
-- This library provides a simple way to change cosmetics
require('libraries/cosmeticlib')
-- This library provides a simple way to change cosmetics
require('libraries/popup')
-- This library provides a simple way to change cosmetics
require('libraries/worldpanels')

-- Extend functionality
require('libraries/extend')

require('internal/util') -- to initialise client functionality

-- These internal libraries set up duskdota's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/duskdota')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core duskdota files.
--require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core duskdota files.
require('events')

require('talents/talents')

require('addon_init')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function duskDota:PostLoadPrecache()
  DebugPrint("[DUSKDOTA] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

function CreateShop(ii)
  local sItems = {}
  local prices = {}
  local stocks = {}

  for _,i in ipairs(ii) do
    item = CreateItem(i[1], unit, unit)
    local index = item:GetEntityIndex()
    sItems[#sItems+1] = item
    if i[2] ~= nil then prices[index] = i[2] end
    if i[3] ~= nil then stocks[index] = i[3] end
  end

  return sItems, prices, stocks
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitduskDota() but needs to be done before everyone loads in.
]]
function duskDota:OnFirstPlayerLoaded()
  DebugPrint("[DUSKDOTA] First Player has loaded")
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(duskDota,"FilterExecuteOrder"), self )
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(duskDota,"FilterTakeDamage"), self )
  GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(duskDota,"FilterAbility"), self )
  GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(duskDota,"FilterGold"), self )
  GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(duskDota,"FilterExperience"), self )
  GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(duskDota,"FilterRuneSpawn"), self )

  populateHeroIDS()

  populateLearnValues()

  populateSkillValues()

  LinkLuaModifier("modifier_soul_vial_damage_lua","libraries/modifiers/modifier_soul_vial_damage_lua.lua",LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_shopkeeper_always_show","libraries/modifiers/modifier_shopkeeper_always_show.lua",LUA_MODIFIER_MOTION_NONE)

  print("[SHOPS] Spawning shop units")

  -- Shop Oddities

  oItems,oPrices,oStocks = CreateShop({
      -- {"item_arcanite_shards"},
      {"item_pendulum_fragment"},
      -- {"item_rage_potion"},
      -- {"item_ironblood_potion"}
      --{"item_glowing_jewel",1800}
    })

  -- Radiant Fountain: [   VScript              ]: Vector 0000000002256860 [-7422.263184 -6588.763672 512.000000] Vector 0000000002256890 [0.910255 -0.414048 -0.000000]

  ob_shop_rad = CreateUnitByName("npc_dummy_blank", Vector(-7422,-6588,512), false, nil, nil, DOTA_TEAM_GOODGUYS)
  ob_shop_rad:AddNewModifier(ob_shop_rad, nil, "modifier_shopkeeper", {})
  ob_shop_rad:RemoveModifierByName("dummy_unit")
  ob_shop_rad:SetModel("models/items/courier/blotto_and_stick/blotto.vmdl")
  ob_shop_rad:SetOriginalModel("models/items/courier/blotto_and_stick/blotto.vmdl")
  ob_shop_rad:SetUnitName("Ob")
  ob_shop_rad:StartGesture(ACT_DOTA_IDLE)
  ob_shop_rad:SetForwardVector(Vector(0.91,-0.41,0))
  ob_shop_rad:SetModelScale(1.25)

  ParticleManager:CreateParticle("particles/world/shop_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, ob_shop_rad) --[[Returns:int
        Creates a new particle effect
        ]]

  radOShop = Containers:CreateShop({
    layout =      {4,4,4},
    skins =       {},
    headerText =  "Ob's Oddities",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      ob_shop_rad,
    items =       oItems,
    prices =      oPrices,
    stocks =      oStocks,
    closeOnOrder= true,
    range =       350,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  -- Dire Fountain: [   VScript              ]: Vector 0000000002B2B550 [6520.288086 6467.559082 512.000000]  Vector 0000000002B2B580 [0.470518 -0.882390 -0.000000]

  ob_shop_dir = CreateUnitByName("npc_dummy_blank", Vector(6520,6467,512), false, nil, nil, DOTA_TEAM_BADGUYS)
  ob_shop_dir:AddNewModifier(ob_shop_dir, nil, "modifier_shopkeeper", {})
  ob_shop_dir:RemoveModifierByName("dummy_unit")
  ob_shop_dir:SetModel("models/items/courier/blotto_and_stick/blotto.vmdl")
  ob_shop_dir:SetOriginalModel("models/items/courier/blotto_and_stick/blotto.vmdl")
  ob_shop_dir:SetUnitName("Ob")
  ob_shop_dir:StartGesture(ACT_DOTA_IDLE)
  ob_shop_dir:SetForwardVector(Vector(0.47,-0.88,0))
  ob_shop_dir:SetModelScale(1.25)

  ParticleManager:CreateParticle("particles/world/shop_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, ob_shop_dir) --[[Returns:int
        Creates a new particle effect
        ]]

  dirOShop = Containers:CreateShop({
    layout =      {4,4,4},
    skins =       {},
    headerText =  "Ob's Oddities",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      ob_shop_dir,
    items =       oItems,
    prices =      oPrices,
    stocks =      oStocks,
    closeOnOrder= true,
    range =       350,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  -- Shop Regal

  contShopRadEnt = CreateUnitByName("npc_dummy_blank", Vector(2834,-2009,0), false, nil, nil, DOTA_TEAM_NEUTRALS)
  --contShopRadEnt:RemoveAbility("dummy_unit")
  contShopRadEnt:AddNewModifier(contShopRadEnt, nil, "modifier_shopkeeper", {})
  contShopRadEnt:AddNewModifier(contShopRadEnt, nil, "modifier_shopkeeper_hide", {})
  contShopRadEnt:RemoveModifierByName("dummy_unit")
  contShopRadEnt:SetModel("models/courier/smeevil_bird/smeevil_bird.vmdl")
  contShopRadEnt:SetOriginalModel("models/courier/smeevil_bird/smeevil_bird.vmdl")
  contShopRadEnt:SetUnitName("The Shopkeeper")
  contShopRadEnt:StartGesture(ACT_DOTA_IDLE)
  contShopRadEnt:SetForwardVector(Vector(-0.71,-0.7,0))
  contShopRadEnt:SetModelScale(1.75)

  ParticleManager:CreateParticle("particles/world/shop_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEnt) --[[Returns:int
        Creates a new particle effect
        ]]

  sItems,prices,stocks = CreateShop({
    {"item_regal_sigil"},
    {"item_essence_of_agility",850},
    {"item_essence_of_strength",850},
    {"item_essence_of_intelligence",850},
  })

  --sItems[3]:SetCurrentCharges(2)

  contRadiantShop = Containers:CreateShop({
    layout =      {1,3},
    skins =       {},
    headerText =  "Dark Materials",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      contShopRadEnt,
    items =       sItems,
    prices =      prices,
    stocks =      stocks,
    closeOnOrder= true,
    range =       450,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  -- Shop Details

  contShopRadEntD = CreateUnitByName("npc_dummy_blank", Vector(2975,-2096,0), false, nil, nil, DOTA_TEAM_NEUTRALS)
  --contShopRadEntD:RemoveAbility("dummy_unit")
  contShopRadEntD:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper", {})
  contShopRadEntD:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper_hide", {})
  contShopRadEntD:RemoveModifierByName("dummy_unit")
  contShopRadEntD:SetModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntD:SetOriginalModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntD:SetUnitName("Grimoire Keeper")
  contShopRadEntD:StartGesture(ACT_DOTA_IDLE)
  contShopRadEntD:SetForwardVector(Vector(-0.71,-0.69,0))
  contShopRadEntD:SetModelScale(1.25)

  ParticleManager:CreateParticle("particles/world/info_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEntD) --[[Returns:int
        Creates a new particle effect
        ]]

  SynthesisItems = CreateShop({
    {"item_mjollnir"},
    {"item_greater_crit"},
    {"item_heart"},
    {"item_sheepstick"},
    {"item_hand_of_midas"},
    {"item_octarine_core"},
    {"item_satanic"},
    {"item_mekansm"},
    {"item_blink"},

    {"item_synthesis"},

    {"item_thunderbolt"},
    {"item_fenrir"},
    {"item_colossus"},
    {"item_turins_scepter"},
    {"item_sword_of_greed"},
    {"item_charged_octarine_core"},
    {"item_demonfire"},
    {"item_talos"},
    {"item_vagrant_dagger"}
  })
  SynthesisLayout = {9,1,9}

  --sItems[3]:SetCurrentCharges(2)

  contRadiantShopD = Containers:CreateContainer({
    layout =      SynthesisLayout,
    skins =       {},
    headerText =  "Exalted Transformations",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      contShopRadEntD,
    items =       SynthesisItems,
    draggable =   false,
    closeOnOrder= true,
    range =       0,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  -- Shop Details
  -- Fountain Shop 1
  --[-7144.460449 -6151.389648 512.000000]  Vector 00000000031ACD58 [0.548053 -0.836443 -0.000000]

  contShopRadEntRadF = CreateUnitByName("npc_dummy_blank", Vector(-7144,-6151,512), false, nil, nil, DOTA_TEAM_GOODGUYS)
  --contShopRadEntRadF:RemoveAbility("dummy_unit")
  contShopRadEntRadF:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper", {})
  --contShopRadEntRadF:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper_hide", {})
  contShopRadEntRadF:RemoveModifierByName("dummy_unit")
  contShopRadEntRadF:SetModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntRadF:SetOriginalModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntRadF:SetUnitName("Grimoire Keeper")
  contShopRadEntRadF:StartGesture(ACT_DOTA_IDLE)
  contShopRadEntRadF:SetForwardVector(Vector(0.54,-0.83,0))
  contShopRadEntRadF:SetModelScale(1.25)

  ParticleManager:CreateParticle("particles/world/info_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEntRadF) --[[Returns:int
        Creates a new particle effect
        ]]

  contRadiantShopRadF = Containers:CreateContainer({
    layout =      SynthesisLayout,
    skins =       {},
    headerText =  "Exalted Transformations",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      contShopRadEntRadF,
    items =       SynthesisItems,
    draggable =   false,
    closeOnOrder= true,
    range =       0,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
          container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  -- Shop Details
  -- Fountain Shop 2
  --[7568.775391 6351.226563 512.000000] Vector 0000000002C9CC90 [-0.978313 -0.207133 -0.000000]

  contShopRadEntDireF = CreateUnitByName("npc_dummy_blank", Vector(7568,6351,512), false, nil, nil, DOTA_TEAM_BADGUYS)  
  --contShopRadEntDireF:RemoveAbility("dummy_unit")
  contShopRadEntDireF:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper", {})
  --contShopRadEntDireF:AddNewModifier(contShopRadEntD, nil, "modifier_shopkeeper_hide", {})
  contShopRadEntDireF:RemoveModifierByName("dummy_unit")
  contShopRadEntDireF:SetModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntDireF:SetOriginalModel("models/items/courier/bookwyrm/bookwyrm.vmdl")
  contShopRadEntDireF:SetUnitName("Grimoire Keeper")
  contShopRadEntDireF:StartGesture(ACT_DOTA_IDLE)
  contShopRadEntDireF:SetForwardVector(Vector(-0.97,-0.20,0))
  contShopRadEntDireF:SetModelScale(1.25)

  ParticleManager:CreateParticle("particles/world/info_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEntDireF) --[[Returns:int
        Creates a new particle effect
        ]]

  contRadiantShopDireF = Containers:CreateContainer({
    layout =      SynthesisLayout,
    skins =       {},
    headerText =  "Exalted Transformations",
    pids =        {},
    position =    "entity", --"1000px 300px 0px",
    entity =      contShopRadEntDireF,
    items =       SynthesisItems,
    draggable =   false,
    closeOnOrder= true,
    range =       0,
    --OnCloseClickedJS = "ExampleCloseClicked",
    OnSelect  =   function(playerID, container, selected)
      print("Selected", selected:GetUnitName())
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
          container:Open(playerID)
      end
    end,
    OnDeselect =  function(playerID, container, deselected)
      print("Deselected", deselected:GetUnitName())
      container:Close(playerID)
    end,
    OnEntityOrder=function(playerID, container, unit, target)
      print("ORDER ACTION radiant shop", playerID)
      if not PlayerResource:GetSelectedHeroEntity(playerID):IsStunned() then
        container:Open(playerID)
      end
      unit:Stop()
    end,
  })

  --[-6935.864258 -6027.422852 512.000000]  Vector 00000000035EFAE8 [0.291898 -0.956449 -0.000000]
  helperRadiant = CreateUnitByName("npc_dummy_hints", Vector(-6935,-6027,512), false, nil, nil, DOTA_TEAM_GOODGUYS)
  helperRadiant:SetForwardVector(Vector(0.29,-0.95,0)) --[[Returns:void
  Set the orientation of the entity to have this forward ''forwardVec''
  ]]
  helperRadiant:SetModel("models/items/courier/coco_the_courageous/coco_the_courageous.vmdl") --[[Returns:void
  No Description Set
  ]]
  helperRadiant:SetOriginalModel("models/items/courier/coco_the_courageous/coco_the_courageous.vmdl")
  helperRadiant:SetUnitName("Helper")
  helperRadiant:StartGesture(ACT_DOTA_IDLE)
  helperRadiant:AddNewModifier(helperRadiant, nil, "modifier_shopkeeper_always_show", {}) --[[Returns:void
  No Description Set
  ]]
  local ab = helperRadiant:FindAbilityByName("hints_attack_me_not")
  ab:SetLevel(1)
  --[   VScript              ]: Vector 0000000002D8DF58 [6944.843750 6725.806641 512.000000]  Vector 0000000002D7FA78 [0.165808 -0.986158 -0.000000]
  helperDire = CreateUnitByName("npc_dummy_hints", Vector(6944,6725,512), false, nil, nil, DOTA_TEAM_BADGUYS)
  helperDire:SetForwardVector(Vector(0.16,-0.98,0)) --[[Returns:void
  Set the orientation of the entity to have this forward ''forwardVec''
  ]]
  helperDire:SetModel("models/items/courier/coco_the_courageous/coco_the_courageous.vmdl") --[[Returns:void
  No Description Set
  ]]
  helperDire:SetOriginalModel("models/items/courier/coco_the_courageous/coco_the_courageous.vmdl")
  helperDire:SetUnitName("Helper")
  helperDire:StartGesture(ACT_DOTA_IDLE)
  helperDire:AddNewModifier(helperDire, nil, "modifier_shopkeeper_always_show", {}) --[[Returns:void
  No Description Set
  ]]
  local ab = helperDire:FindAbilityByName("hints_attack_me_not")
  ab:SetLevel(1)

  duskDota.spawnDarkShop = false
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function duskDota:OnAllPlayersLoaded()
  DebugPrint("[DUSKDOTA] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function duskDota:OnHeroInGame(hero)
  DebugPrint("[DUSKDOTA] Hero spawned in game for first time -- " .. hero:GetUnitName())

  Talents.OnUnitCreate(hero)
  local prefix = "npc_dota_hero_"

  -- Replace the following heroes with default sets, usually due to colour changes

  local defaultList = {
    "rubick",
    "ember_spirit",
    "dragon_knight"
  }

  for k,v in pairs(defaultList) do
    local name = prefix..v

    if hero:GetUnitName() == name then
      CosmeticLib:ReplaceDefault(hero, name)
    end
  end

  -- if hero:GetUnitName() == "npc_dota_hero_rubick" then
  --     CosmeticLib:ReplaceDefault(hero,"npc_dota_hero_rubick")
  -- end

  if hero:GetUnitName() == "npc_dota_hero_dragon_knight" then 
    CosmeticLib:RemoveFromSlot(hero, "weapon")
    CosmeticLib:ReplaceWithSlotName( hero, "weapon", 4125 )
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

  if hero:GetUnitName() == "npc_dota_hero_rattletrap" then
    local ab = hero:FindAbilityByName("summoner_summon_blue_vassal")
    ab:SetLevel(1)
  end

  if hero:GetUnitName() == "npc_dota_hero_abaddon" then
      CosmeticLib:ReplaceDefault(hero, "npc_dota_hero_abaddon")
      CosmeticLib:RemoveFromSlot(hero, "weapon")
      CosmeticLib:RemoveFromSlot(hero, "back")
      attachPropToUnit(hero, "attach_attack1", "models/items/phantom_lancer/sunspear/sunspear.vmdl", 1.2,"odin_spear")
  end

  if hero:GetUnitName() == "npc_dota_hero_lone_druid" then
    CosmeticLib:ReplaceDefault(hero, "npc_dota_hero_lone_druid")
    CosmeticLib:RemoveFromSlot(hero, "weapon")
    CosmeticLib:RemoveFromSlot(hero, "back")
    CosmeticLib:RemoveFromSlot(hero, "arms")
    CosmeticLib:RemoveFromSlot(hero, "head")
    CosmeticLib:ReplaceWithSlotName( hero, "arms", 4660 )
    CosmeticLib:ReplaceWithSlotName( hero, "back", 8870 )
    attachPropToUnit(hero,"attach_mouth","models/items/necrolyte/tenplagues_necrolyte_head/tenplagues_necrolyte_head.vmdl",1.2,"artificer_head")
    attachPropToUnit(hero,"attach_hitloc","models/items/warlock/ceaseless/ceaseless.vmdl",0.8,"artificer_back")
  end

  if hero:GetUnitName() == "npc_dota_hero_techies" then
    Timers:CreateTimer(0.06, function()
      hero:RemoveAbility("techies_land_mines")
      hero:RemoveAbility("techies_stasis_trap")
      hero:RemoveAbility("techies_suicide")
      hero:RemoveAbility("techies_focused_detonate")
      hero:RemoveAbility("techies_minefield_sign")
      hero:RemoveAbility("techies_remote_mines")
      hero:AddAbility("gob_squad_rocket_blast")
      hero:AddAbility("gob_squad_kamikaze")
      hero:AddAbility("gob_squad_whoops")
      hero:AddAbility("gob_squad_clearance_sale")
    end)
  end

  Timers:CreateTimer(0.06,function()-- check if illusion
    if hero:IsIllusion() and hero.hero_attachments then
      print("Illusion has been created, and illusion has attachments")
      print("Making sure its attachments are removed upon death")
      hero.remove_attachments_on_death = true
    end
  end)

end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function duskDota:OnGameInProgress()
  DebugPrint("[DUSKDOTA] The game has officially begun")

  -- local contrib_table = {}
  -- local start = "The following players are community contributors to Dusk:"
  -- local c = 0
  -- local endcap = "Thanks for your additions to our community everyone!"

  -- table.insert(contrib_table,start)

  -- for i=0,1,9 do
  --   if playerIsContributor(i) then
  --     local name = PlayerResource:GetPlayerName(i) --[[Returns:string
  --     No Description Set
  --     ]]
  --     local col_pre = "<font color='"
  --     local col = HEX_COLOR_AQUA
  --     local col_pre2 = "'>"
  --     local col_suf = "</font>"
  --     local show_particle = "particles/special/contributor.vpcf"

  --     print("Player "..i.." is a contributor.")

  --     if playerIsCreator(i) then
  --       print("Player "..i.." is the creator.")
  --       show_particle = "particles/special/creator.vpcf"
  --       col = HEX_COLOR_GOLD
  --       col_pre = "<b><font color='"
  --       col_suf = "</font></b>"
  --     elseif playerIsMajorContributor(i) then
  --       print("Player "..i.." is a major contributor.")
  --       show_particle = "particles/special/contributor_major.vpcf"
  --       col = HEX_COLOR_PURPLE
  --       col_pre = "<font color="
  --       col_suf = "</font>"
  --     end

  --     print("Name is '"..name.."'.")
  --     print("Name "..name.." added to contributor list.")
  --     c = c+1
  --     local str = col_pre..col..col_pre2..name..col_suf

  --     print(str)

  --     table.insert(contrib_table,str)

  --     local hero = PlayerResource:GetSelectedHeroEntity(i) --[[Returns:handle
  --     No Description Set
  --     ]]
  --     if hero then
  --       ParticleManager:CreateParticle(show_particle, PATTACH_OVERHEAD_FOLLOW, hero) --[[Returns:int
  --       Creates a new particle effect
  --       ]]
  --       -- EmitSoundOnClient("Game.Thanks", PlayerResource:GetPlayer(i))
  --       hero:EmitSound("Game.Thanks") --[[Returns:void
  --       Play named sound only on the client for the passed in player
  --       ]]
  --     end

  --   end
  -- end

  -- table.insert(contrib_table,endcap)

  -- if c > 0 then
  --   local s = ""
  --   for k,v in pairs(contrib_table) do
  --     print(k..": "..v)
  --     GameRules:SendCustomMessage(v, 0, 0) --[[Returns:void
  --     Displays a line of text in the left textbox (where usually deaths/denies/buysbacks are announced). This function takes restricted HTML as input! (&lt;br&gt;,&lt;u&gt;,&lt;font&gt;)
  --     ]]
  --   end
  -- end

  duskDota.forts = Entities:FindAllByClassname("npc_dota_fort") --[[Returns:table
  Finds all entities by class name. Returns an array containing all the found entities.
  ]]

  duskDota.towers = Entities:FindAllByClassname("npc_dota_tower")

  local forts = duskDota.forts
  local towers = duskDota.towers

  for k,v in pairs(towers) do
    Timers:CreateTimer(0.1,
    function()
      local max_health = v:GetMaxHealth()*0.90
      v:SetBaseMaxHealth(max_health)
      v:SetMaxHealth(max_health)
      v:SetHealth(max_health)
      local damage_min = v:GetBaseDamageMin()*1.10
      local damage_max = v:GetBaseDamageMax()*1.10
      v:SetBaseDamageMin(damage_min) --[[Returns:void
      Sets the minimum base damage.
      ]]
      v:SetBaseDamageMax(damage_max) --[[Returns:void
      Sets the minimum base damage.
      ]]
    end)
    local ab = v:AddAbility("tower_frenzy")
    ab:SetLevel(1)
  end

  for k,v in pairs(forts) do
    Timers:CreateTimer(0.1,
    function()
      local max_health = v:GetMaxHealth()*0.80
      v:SetBaseMaxHealth(max_health)
      v:SetMaxHealth(max_health)
      v:SetHealth(max_health)
    end)
  end

  Timers:CreateTimer(1200,function()
    duskDota.spawnDarkShop = true
    Notifications:TopToAll({text="The Dark Materials Shop is open for business!", duration=4.0, style={color="green"}})
    Notifications:TopToAll({item="item_regal_sigil", continue=true})
    GameRules:SendCustomMessage("<font color='#dd3f4e'>Dark Materials Shop</font> is now open and available at the bottom rune during nighttime.", DOTA_TEAM_NEUTRALS, 0)
    GameRules:SendCustomMessage("<font color='#dd3f4e'>Regal Sigils</font>, purchased from here, can be used to upgrade some items to their Exalted variants.", DOTA_TEAM_NEUTRALS, 0)
    EmitAnnouncerSound("sounds/vo/announcer/ann_custom_new_shop_01.vsnd")
  end)

  Timers:CreateTimer(0, -- Start this timer immediately
    function()
      DebugPrint("This function is called immediately after the game begins, and every 15 seconds thereafter")
      if GameRules:IsDaytime() then
        contShopRadEnt:AddNewModifier(contShopRadEnt, nil, "modifier_shopkeeper_hide", {}) --[[Returns:void
        No Description Set
        ]]
        contShopRadEntD:AddNewModifier(contShopRadEnt, nil, "modifier_shopkeeper_hide", {}) --[[Returns:void
        No Description Set
        ]]
      else
        if contShopRadEnt:HasModifier("modifier_shopkeeper_hide") and duskDota.spawnDarkShop then
          contShopRadEnt:RemoveModifierByName("modifier_shopkeeper_hide")
          contShopRadEntD:RemoveModifierByName("modifier_shopkeeper_hide")
          ParticleManager:CreateParticle("particles/world/shop_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEnt) --[[Returns:int
          Creates a new particle effect
          ]]
          ParticleManager:CreateParticle("particles/world/info_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, contShopRadEntD) --[[Returns:int
          Creates a new particle effect
          ]]
        end
      end
      return 15.0 -- Rerun this timer every 30 game-time seconds 
    end)
  Timers:CreateTimer(4,
    function()

      showHint(helperRadiant)
      
      showHint(helperDire)

      Timers:CreateTimer(10,function()
        hideHint(helperRadiant)
        hideHint(helperDire)
      end)
      
      return 12.0
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function duskDota:InitduskDota()
  duskDota = self
  DebugPrint('[DUSKDOTA] Starting to load duskDota duskdota...')

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(duskDota, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  Convars:RegisterCommand( "print_player_data", Dynamic_Wrap(duskDota, 'PrintPlayerData'), "Prints the player's data", 0 )

  print("[EXTEND] Initialising PData table")

  PlayerResource:InitPDataTable()

  DebugPrint('[DUSKDOTA] Done loading duskDota duskdota!\n\n')

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

  self.normalItemTable = {
    "item_mjollnir",
    "item_greater_crit",
    "item_heart",
    "item_sheepstick",
    "item_hand_of_midas",
    "item_octarine_core",
    "item_satanic",
    "item_mekansm",
    "item_blink",
    "item_rapier"
  }
  self.exaltedItemTable = {
    "item_thunderbolt",
    "item_fenrir",
    "item_colossus",
    "item_turins_scepter",
    "item_sword_of_greed",
    "item_charged_octarine_core",
    "item_demonfire",
    "item_talos",
    "item_vagrant_dagger",
    "item_soul_reaver"
  }
end

-- FILTERS

function duskDota:FilterExecuteOrder( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Order: "..k.." "..tostring(v))
  -- end

  --DebugPrintTable(filterTable)
  local order_type = filterTable["order_type"]
  local user = filterTable["issuer_player_id_const"]
  local player = PlayerResource:GetPlayer(user) --[[Returns:handle
  No Description Set
  ]]
  local target = EntIndexToHScript(filterTable["entindex_target"])
  local hero = PlayerResource:GetSelectedHeroEntity(user)
  local ability = nil
  if filterTable["endindex_ability"] then
    ability = EntIndexToHScript(filterTable["entindex_ability"])
  end

  -- BOTS

  -- if user:IsFakeClient() then -- are they a bot?
  --   print(order_type)
  --   return false
  -- end

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
      print("ABILITY IS "..ability:GetName())
    end

    if ability then
    -- Set last ability
      -- ENCORE
      if hero:HasModifier("modifier_trickster_encore") then
        if hero.last_ability_used then
          print("last ability used is not nil")
          print("last ability was "..hero.last_ability_used:GetName().." and used ability was "..ability:GetName())
          if ability ~= hero.last_ability_used then
            return false
          end
        end
      end
    hero.last_ability_used = ability
    print("ABILITY SET TO "..ability:GetName().." LOL")
    print("LE DEBUG CHECK: "..hero.last_ability_used:GetName())
    end
  end

  if order_type == DOTA_UNIT_ORDER_CAST_TARGET then

  -- Unit Target Order Filters

  -- START Ptomely Spell Reflect
  -- Proof of concept, too OP
  -- if target ~= nil then
  --   if target:HasModifier("modifier_spell_reflect") then
  --     if ability then
  --       if hero then
  --         print("BUMS")
  --         --if hero:GetTeam() ~= target:GetTeam() then
  --           local ab_name = ability:GetName()
  --           local ab_level = ability:GetLevel()
  --           print("POOS")

  --           print("Adding ability "..ab_name.." at level "..ab_level.." to "..target:GetUnitName())

  --           local ab = target:AddAbility(ab_name)
  --           ab:SetLevel(ab_level)

  --           print("Casting spell on "..hero:GetUnitName())

  --           target:SetCursorCastTarget(hero)
  --           ab:OnSpellStart()

  --           target:RemoveAbility(ab:GetName())
  --         --end
  --       end
  --     end
  --   end
  -- end
  -- END Ptomely Spell Reflect

  -- START Timekeeper Echoes
    -- if IsValidEntity(hero.parallels_unit) then
    --   if hero.parallels_unit ~= nil then
    --     if target ~= 0 then
    --       local found = FindUnitsInRadius( hero:GetTeamNumber(),
    --                       hero.parallels_unit:GetCenter(),
    --                       nil,
    --                         450,
    --                         DOTA_UNIT_TARGET_TEAM_BOTH,
    --                         DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
    --                         DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
    --                         FIND_CLOSEST,
    --                         false)
    --       for k,v in pairs(found) do
    --         if v == target and v ~= hero then
    --           hero.parallels_unit:SetCursorCastTarget(v) --[[Returns:void
    --           No Description Set
    --           ]]
    --           -- EXCEPTIONS (Casting from Hero)
    --           local cfromhero = {
    --             "timekeeper_chronoshift",
    --             "item_diffusal_blade",
    --             "item_diffusal_blade_2",
    --             "timekeeper_futurestrike",
    --             "item_force_staff",
    --             "baal_compress"
    --           }
    --           if CheckTable(cfromhero,ability:GetName()) then
    --             hero:SetCursorCastTarget(v)
    --             ability:OnSpellStart()
    --           else
    --             -- DEFAULT
    --             local ab = hero.parallels_unit:AddAbility(ability:GetName())
    --             local lvl = ability:GetLevel()
    --             ab:SetLevel(lvl)
    --             ab:OnSpellStart()
    --             hero.parallels_unit:RemoveAbility(ab:GetName())
    --           end
    --           -- use resources
    --           ability:UseResources(true, false, true)
    --           hero:Stop()
    --           -- ability:StartCooldown(GetCooldown(ability:GetLevel()))
    --           -- ability:PayManaCost()
    --         end
    --       end
    --     end
    --   end
    -- end
  -- END Timekeeper Echoes
  end
  return true
end

function duskDota:FilterTakeDamage( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Damage: "..k.." "..tostring(v))
  -- end
  
  local attacker = EntIndexToHScript(filterTable["entindex_attacker_const"])
  local defender = EntIndexToHScript(filterTable["entindex_victim_const"])
  local dtype = filterTable["damagetype_const"] -- constant integer
  local damage = filterTable["damage"] -- float

  if IsValidEntity(attacker) then

    -- TRANQUIL SEAL
    if attacker:HasModifier("paragon_tranquil_seal_mod_ally") or defender:HasModifier("paragon_tranquil_seal_mod_ally") or attacker:HasModifier("paragon_tranquil_seal_mod_enemy") or defender:HasModifier("paragon_tranquil_seal_mod_enemy") then
      return false
    end

  end

  -- ENTHRALL
  if defender:HasModifier("modifier_enthralled") or defender:HasModifier("modifier_enthralled_ally") then
    if dtype == DAMAGE_TYPE_PHYSICAL then
      if defender:IsEthereal() then
        print("Target is immune to the base damage, dealing none")
      end
      print("damage type is "..dtype.." converting to "..DAMAGE_TYPE_MAGICAL)
      local damageb = defender:GetDamageBeforeReductions(damage,dtype)
      print("Damage is "..damage..", before reduction is "..damageb)
      DealDamage(defender,attacker,damageb,DAMAGE_TYPE_MAGICAL)
      return false
    end
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
    print("GUARDIAN: "..reduction)

    -- filterTable["damage"] = damage*reduction
    -- filterTable["entindex_victim_const"] = guardian:entindex()
    -- filterTable["damagetype_const"] = DAMAGE_TYPE_MAGICAL
    DealDamageThroughMagicImmunity(guardian,attacker,damage*reduction,DAMAGE_TYPE_PURE)
    print("GUARDIAN: "..guardian:entindex())
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
        local amt = math.abs(stacks-damage)

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

    if defender.displace_last_damage then if damage > defender.displace_last_damage then defender.displace_attacker = attacker end end

    defender.displace_last_damage = damage

    return false
  end

  --FUTURE SIGHT
  if defender:HasModifier("modifier_precognition") then
    local r = RandomInt(1,100) --[[Returns:int
    Get a random ''int'' within a range
    ]]

    local mod = defender:FindModifierByName("modifier_precognition")



    if r < 50 then
      ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, defender) --[[Returns:int
      Creates a new particle effect
      ]]
      return false
    end
    return true
  end

  --HOLDING ORB
  if defender:HasModifier("modifier_holding_orb_block") then
    if dtype == DAMAGE_TYPE_MAGICAL then
      local stacks = math.ceil(damage/50)
      local mod = defender:FindModifierByName("modifier_holding_orb_bide")
      local stacknow = mod:GetStackCount()

      if stacknow < 25 then mod:SetStackCount(stacknow+stacks) end
      if mod:GetStackCount() > 25 then mod:SetStackCount(25) end

      local p = ParticleManager:CreateParticle("particles/items/holding_orb_reflect.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, defender) --[[Returns:int
      Creates a new particle effect
      ]]
      ParticleManager:SetParticleControlEnt(p, 0, defender, PATTACH_POINT_FOLLOW, "attach_hitloc", defender:GetAbsOrigin(), true) --[[Returns:void
      No Description Set
      ]]

      return false
    end
  end

  --BLOOD CURSE

  if defender:HasModifier("modifier_blood_curse_passive") then
    if damage >= defender:GetHealth() and defender:FindAbilityByName("bloodwarrior_blood_curse"):IsCooldownReady() == true then
    if defender.hasBeenSummoned == nil or defender.hasBeenSummoned == false then
      defender.summonBloodFiend = true
      defender.bloodfiendKiller = attacker
      return false
    else
      defender.hasBeenSummoned = false
      return true
    end
    end
  end

  -- ARCANITE SHARDS
  
  if attacker:HasModifier("modifier_arcanite_shards") and defender:IsHero() then
    print("Arcanite Shards detected on attacker.")
    local mod = attacker:FindModifierByName("modifier_arcanite_shards")

    local ab = mod:GetAbility()

    local min_damage = ab:GetSpecialValueFor("minimum_dmg") --[[Returns:table
    No Description Set
    ]]

    local bonus_damage = ab:GetSpecialValueFor("dmg")

    local cooldown = ab:GetCooldown(ab:GetLevel())

    if damage > min_damage
    and ab:IsCooldownReady()
    and dtype == DAMAGE_TYPE_MAGICAL then
      DealDamage(defender,attacker,bonus_damage,DAMAGE_TYPE_MAGICAL)
      ab:StartCooldown(cooldown)
      ab:SetCurrentCharges(ab:GetCurrentCharges()-1)
      if ab:GetCurrentCharges() <= 0 then
        ab:RemoveSelf()
      end
    end
  end

  -- FIGHT ME!

  if attacker:HasModifier("modifier_fight_me") and defender:HasModifier("modifier_fight_me_regen") then
    if damage > 0 then
      defender:Heal(damage, defender) --[[Returns:void
      Heal this unit.
      ]]
    end
    ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me_life_gain.vpcf", PATTACH_ABSORIGIN_FOLLOW, defender) --[[Returns:int
    Creates a new particle effect
    ]]
    return false
  end

  if defender:HasModifier("modifier_fight_me") then
    return false
  end


return true

end

function duskDota:FilterAbility( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Ability: "..k.." "..tostring(v)) 
  -- end

  -- filterTable["value"] = filterTable["value"]*5
  -- return true

  return false
end

function duskDota:FilterGold( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Gold: "..k.." "..tostring(v)) 
  -- end

  return true
end

function duskDota:FilterExperience( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Experience: "..k.." "..tostring(v)) 
  -- end

  return true
end

function duskDota:FilterRuneSpawn( filterTable )
  -- for k,v in pairs( filterTable ) do
  --   print("Rune: "..k.." "..tostring(v)) 
  -- end

  return true
end

-- -- This is an example console command
-- function duskDota:ExampleConsoleCommand()
--   print( '******* Example Console Command ***************' )
--   local cmdPlayer = Convars:GetCommandClient()
--   if cmdPlayer then
--     local playerID = cmdPlayer:GetPlayerID()
--     if playerID ~= nil and playerID ~= -1 then
--       -- Do something here for the player who called this command
--       PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
--     end
--   end

--   print( '*********************************************' )
-- end

function duskDota:PrintPlayerData(pid)
  print("Player data printing for "..pid)
  --PlayerResource:PrintPData(pid)

  local t = PlayerResource.PDataTable[pid]

  for k,v in pairs(t) do
    print(k..": "..v)
  end
end