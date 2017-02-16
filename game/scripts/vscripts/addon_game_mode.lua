-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('duskdota')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See duskDota:PostLoadPrecache() in duskdota.lua for more information
  ]]

  DebugPrint("[DUSKDOTA] Performing pre-load precache")

-- Particles can be precached individually or by folder
    -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
    PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
    PrecacheResource("particle", "particles/items/holding_orb_reflect.vpcf", context)
    PrecacheResource("particle", "particles/items/holding_orb_shield.vpcf", context)
    PrecacheResource("particle_folder", "particles/test_particle", context)

    -- Models can also be precached by folder or individually
    -- PrecacheModel should generally used over PrecacheResource for individual models
    PrecacheResource("model_folder", "particles/heroes/antimage", context)
    --PrecacheResource("model_folder", "particles/heroes/juggernaut", context)
    PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
    PrecacheResource("model_folder", "models/heroes/rubick", context)
    PrecacheResource("model_folder", "models/heroes/phantom_lancer", context)
    PrecacheResource("model_folder", "models/heroes/drow", context)
    PrecacheResource("model_folder", "models/items/phantom_lancer", context)
    PrecacheResource("model_folder", "models/items/drow", context)
    PrecacheResource("model", "models/items/terrorblade/dotapit_s3_fallen_light_metamorphosis/dotapit_s3_fallen_light_metamorphosis.vmdl", context)
    PrecacheResource("model", "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl", context)
    PrecacheResource("model", "models/courier/smeevil_bird/smeevil_bird.vmdl", context)
    PrecacheResource("model", "models/items/courier/bookwyrm/bookwyrm.vmdl", context)
    PrecacheResource("model", "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl", context)
    PrecacheResource("model", "models/items/necrolyte/tenplagues_necrolyte_head/tenplagues_necrolyte_head.vmdl", context)
    PrecacheResource("model", "models/items/warlock/ceaseless/ceaseless.vmdl", context)
    PrecacheResource("model", "models/props_structures/statue_mystical001.vmdl", context)
    PrecacheResource("model","models/creeps/lane_creeps/creep_radiant_hulk/creep_radiant_ancient_hulk.vmdl",context)
    PrecacheResource("model","models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl",context)
    
    
    PrecacheModel("models/heroes/viper/viper.vmdl", context)
    -- PrecacheModel("models/heroes/juggernaut/juggernaut.mdl", context)
    -- PrecacheModel("models/heroes/juggernaut/jugg_sword.mdl", context)
    -- PrecacheModel("models/heroes/juggernaut/jugg_cape.mdl", context)
    -- PrecacheModel("models/heroes/juggernaut/jugg_bracers.mdl", context)
    -- PrecacheModel("models/heroes/juggernaut/juggernaut_pants.mdl", context)
    PrecacheModel("models/heroes/lone_druid/spirit_bear.mdl", context)
    PrecacheModel("models/items/warlock/archivist_golem/archivist_golem.mdl",context)

    -- Sounds can precached here like anything else
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_greevils.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_invoker.vsndevts", context)

    -- Entire items can be precached by name
    -- Abilities can also be precached in this way despite the name
    PrecacheItemByNameSync("example_ability", context)
    PrecacheItemByNameSync("item_example_item", context)
    PrecacheItemByNameSync("item_sword_of_greed", context)
    PrecacheItemByNameSync("item_fenrir", context)
    PrecacheItemByNameSync("item_thunderbolt", context)
    PrecacheItemByNameSync("item_dust_enhanced", context)
    PrecacheItemByNameSync("item_turins_scepter", context)
    PrecacheItemByNameSync("item_vagrant_dagger", context)
    PrecacheItemByNameSync("item_vajra", context)
    PrecacheItemByNameSync("item_bulwark", context)
    PrecacheItemByNameSync("item_regal_sigil", context)
    PrecacheItemByNameSync("item_summoning_stone", context)
    PrecacheItemByNameSync("item_holdingorb", context)
    PrecacheItemByNameSync("item_grim_gauntlet", context)

    -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
    -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
    PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
    PrecacheUnitByNameSync("npc_dota_hero_juggernaut", context)
    PrecacheUnitByNameSync("npc_dota_hero_night_stalker", context)
    PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
    PrecacheUnitByNameSync("npc_dota_unit_avatar_dark",context)
    PrecacheUnitByNameSync("npc_dota_unit_blood_fiend",context)
    PrecacheUnitByNameSync("npc_dota_unit_vassal_blue",context)
    PrecacheUnitByNameSync("npc_dota_unit_vassal_green",context)
    PrecacheUnitByNameSync("npc_dota_unit_vassal_red",context)
    PrecacheUnitByNameSync("npc_dota_unit_sentinel_1",context)
    PrecacheUnitByNameSync("npc_dota_unit_sentinel_precache",context)
    PrecacheUnitByNameSync("npc_dota_unit_forcefield",context)
    PrecacheUnitByNameSync("npc_dota_unit_cloakfield",context)
    PrecacheUnitByNameSync("npc_dota_unit_tesla_coil",context)
    PrecacheUnitByNameSync("npc_dota_unit_sand_puppet_warrior",context)
    PrecacheUnitByNameSync("npc_dota_unit_sand_puppet_archer",context)
    PrecacheUnitByNameSync("npc_dota_unit_axial_1",context)

end

if duskDota == nil then
    duskDota = class({})
end

-- Create the game mode when we activate
function Activate()
  GameRules.duskDota = duskDota()
  --GameRules.duskDota:_InitduskDota()
  --GameRules.duskDota = MOTA()
  GameRules.duskDota:Init()
end

function duskDota:Init()
    self.n_players_radiant = 0
    self.n_players_dire = 0

    self.mode = GameRules:GetGameModeEntity()
    self.mode:SetBotThinkingEnabled( true )
    
    --GameRules:SetCustomGameSetupTimeout( 30 )
    --GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
    --GameRules:EnableCustomGameSetupAutoLaunch( false )
    --GameRules:SetPreGameTime( 30 )
    --GameRules:SetHeroSelectionTime( 30 )
    --GameRules:SetStrategyTime( 30 )
    --GameRules:SetCustomGameEndDelay( 0 )
    --GameRules:SetCustomVictoryMessageDuration( 20 )
  
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( duskDota, 'OnGameStateChanged' ), self )
end

function duskDota:OnGameStateChanged( keys )
    local state = GameRules:State_Get()

    if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        SendToServerConsole("sv_cheats 0")
        local used_hero_name = "npc_dota_hero_luna"
        print("Checking players...")
        
        for playerID=0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayer(playerID) then
                print("PlayedID:", playerID)
                
                if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
                    self.n_players_radiant = self.n_players_radiant + 1
                elseif PlayerResource:GetTeam(playerID) == DOTA_TEAM_BADGUYS then
                    self.n_players_dire = self.n_players_dire + 1
                end

                -- Random heroes for people who have not picked
                if PlayerResource:HasSelectedHero(playerID) == false then
                    print("Randoming hero for:", playerID)
                    PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection()
                    print("Randomed:", PlayerResource:GetSelectedHeroName(playerID))
                end
                
                used_hero_name = PlayerResource:GetSelectedHeroName(playerID)
            end
        end
        
        print("Number of players:", self.n_players_radiant + self.n_players_dire)
        print("Radiant:", self.n_players_radiant)
        print("Radiant:", self.n_players_dire)
        
        -- Enable bots and fill empty slots
        if GameRules:IsCheatMode() then
            print("Cheats are enabled")
            
            if IsServer() and self.n_players_radiant + self.n_players_dire < 10 then
                print("Adding bots in empty slots")
                
                local next_playerID = self.n_players_radiant + self.n_players_dire

                for i=self.n_players_radiant, 5 - 1 do
                    print('Adding radiant bot', next_playerID)
                    Tutorial:AddBot(used_hero_name, '', 'hard', true)
                    
                    --PlayerResource:SetCustomTeamAssignment(next_playerID, DOTA_TEAM_GOODGUYS)
                    --next_playerID = next_playerID + 1
                end
                
                for i=self.n_players_dire, 5 - 1 do
                    print('Adding dire bot', next_playerID)
                    Tutorial:AddBot(used_hero_name, '', 'hard', false)
                    
                    --PlayerResource:SetCustomTeamAssignment(next_playerID, DOTA_TEAM_BADGUYS)
                    --next_playerID = next_playerID + 1
                end
                
                GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
                --SendToServerConsole("dota_bot_populate")
                --SendToServerConsole("dota_bot_set_difficulty 2")
            end
        end
--  elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
--      for i=0, DOTA_MAX_TEAM_PLAYERS do`
--          print(i)
--          if PlayerResource:IsFakeClient(i) then
--              print(i)
--              PlayerResource:GetPlayer(i):GetAssignedHero():SetBotDifficulty(2)
--          end
--      end
    end
end