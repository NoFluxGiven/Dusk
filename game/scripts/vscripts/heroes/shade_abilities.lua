function shade_isolation(event)
  local caster = event.caster
  local target = event.target
  local dmg = event.dmg
  local decrease = event.decrease
  local hp = target:GetMaxHealth()
  local isolation_bonus = (event.isolation_bonus/100)*hp
  local dayvision_base = target:GetBaseDayTimeVisionRange()
  local nightvision_base = target:GetBaseNightTimeVisionRange()
  local vision_reduction = 1-(event.ability:GetSpecialValueFor("vision") / 100)
  local dayvision_changed = dayvision_base*vision_reduction
  local nightvision_changed = nightvision_base*vision_reduction
  local duration = event.duration

  
  
  local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                400,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
  local n = -1
  for k,v in pairs(enemy_found) do
    n = n+1
  end



  --local dmgminus = n*decrease

  --if dmgminus > dmg*0.75 then dmgminus = dmg*0.75 end
  
  if n >= 1 then
    dmg = math.ceil(dmg/2)
    isolation_bonus = math.ceil(isolation_bonus/2)
    duration = duration/2
  end

  dmg = dmg + isolation_bonus
  EmitSoundOn("Dusk.shadeIsolation",target)
  local currentTime = GameRules:GetTimeOfDay()
  GameRules:SetTimeOfDay(10.0)
  local particle  = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  target:AddNewModifier(caster,nil,"modifier_silence",{Duration=duration})
  event.ability:ApplyDataDrivenModifier(caster, target, "modifier_isolation", {Duration=duration}) --[[Returns:void
  No Description Set
  ]]
  -- target:SetDayTimeVisionRange(dayvision_changed)
  -- target:SetNightTimeVisionRange(nightvision_changed)
  Timers:CreateTimer(duration,function()
    GameRules:SetTimeOfDay(currentTime)
    -- target:SetDayTimeVisionRange(dayvision_base)
    -- target:SetNightTimeVisionRange(nightvision_base)
  end)
  EmitSoundOn("Hero_BountyHunter.Jinada",target)

  print("damage "..dmg)
  local dmgTable = {
    attacker = caster,
    victim = target,
    damage = dmg,
    damage_type = DAMAGE_TYPE_PHYSICAL,
    ability = event.ability,
    flags = DOTA_DAMAGE_FLAG_BYPASSES_MAGIC_IMMUNITY
    }
    ApplyDamage(dmgTable) 
end

function Venomous(keys)
  local caster = keys.caster or keys.attacker
  local target = keys.target or keys.unit

  if caster:PassivesDisabled() then return end
  if CheckClass(target,"npc_dota_building") then return end

  keys.ability:ApplyDataDrivenModifier(caster, target, "shade_venomous_dmg_slow_mod", {}) --[[Returns:void
  No Description Set
  ]]
end