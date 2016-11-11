function thunderbolt_lightning(event)
  local caster = event.caster
  local radius = 700
  local damage = event.damage

  local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
  caster:EmitSound("Hero_Zuus.LightningBolt")
  for k,v in pairs(enemy_found) do
    local targetmod = v:GetAbsOrigin()+Vector(0,0,800)
    local boltparticle  = ParticleManager:CreateParticle("particles/units/heroes/hero_lightning/thunder_wave_lightning_bolt.vpcf", PATTACH_ABSORIGIN, v)
    ParticleManager:SetParticleControl(boltparticle,0,v:GetAbsOrigin()+Vector(0,0,-50))
    ParticleManager:SetParticleControl(boltparticle,1,targetmod)
    v:EmitSound("Hero_Zuus.ArcLightning.Target")
    local damage_table = {
      victim = v,
      attacker = caster,
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = event.ability
      } 
      ApplyDamage(damage_table)
      if v:IsRealHero() then PopupDamage(v, damage) end
    event.ability:ApplyDataDrivenModifier(caster,v,"modifier_item_thunderbolt_slow",{})
  end
end

function ChainLightning( event )

  local hero = event.caster
  local target = event.target
  local ability = event.ability
  
  if CheckClass(target,"npc_dota_building") then return end -- don't want it to activate on buildings

  if not hero:IsRealHero() then return end

  local damage = 120
  local bounces = 5
  local bounce_range = 600
  local decay = 0.15
  local time_between_bounces = 0.10

  local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_CUSTOMORIGIN, hero)
  ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z )) 
  ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 
  --ParticleManager:SetParticleControlEnt(lightningBolt, 1, target, 1, "attach_hitloc", target:GetAbsOrigin(), true)

  EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)  
  ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

  -- Every target struck by the chain is added to a list of targets struck, And set a boolean inside its index to be sure we don't hit it twice.
  local targetsStruck = {}
  target.struckByChain = true
  table.insert(targetsStruck,target)

  local dummy = nil
  local units = nil

  Timers:CreateTimer(DoUniqueString("ChainLightning"), {
    endTime = time_between_bounces,
    callback = function()
  
      -- unit selection and counting
      units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetOrigin(), target, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

      -- particle and dummy to start the chain
      targetVec = target:GetAbsOrigin()
      targetVec.z = target:GetAbsOrigin().z + target:GetBoundingMaxs().z
      if dummy ~= nil then
        dummy:RemoveSelf()
      end
      dummy = CreateUnitByName("npc_dummy_unit", targetVec, false, hero, hero, hero:GetTeam())
      dummy:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
      dummy:AddNewModifier(hero, nil, "modifier_kill", {Duration=5})

      -- Track the possible targets to bounce from the units in radius
      local possibleTargetsBounce = {}
      for _,v in pairs(units) do
        if not v.struckByChain then
          table.insert(possibleTargetsBounce,v)
        end
      end

      -- Select one of those targets at random
      target = possibleTargetsBounce[math.random(1,#possibleTargetsBounce)]
      if target then
        target.struckByChain = true
        table.insert(targetsStruck,target)    
      else
        -- There's no more targets left to bounce, clear the struck table and end
        for _,v in pairs(targetsStruck) do
            v.struckByChain = false
            v = nil
        end
          print("End Chain, no more targets")
        return  
      end


      local lightningChain = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_CUSTOMORIGIN, dummy)
      ParticleManager:SetParticleControl(lightningChain,0,Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,dummy:GetAbsOrigin().z + dummy:GetBoundingMaxs().z ))  
      
      -- damage and decay
      damage = damage - (damage*decay)
      ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
      PopupDamage(target,math.floor(damage))
      print("Bounce "..bounces.." Hit Unit "..target:GetEntityIndex().. " for "..damage.." damage")

      -- play the sound
      target:EmitSoundParams("Item.Maelstrom.Chain_Lightning.Jump",0.25,0.15,1)

      -- make the particle shoot to the target
      ParticleManager:SetParticleControl(lightningChain,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
  
      -- decrement remaining spell bounces
      bounces = bounces - 1

      -- fire the timer again if spell bounces remain
      if bounces > 0 then
        return time_between_bounces
      else
        for _,v in pairs(targetsStruck) do
            v.struckByChain = false
            v = nil
        end
        dummy:RemoveSelf()
        print("End Chain, no more bounces")
      end
    end
  })
end