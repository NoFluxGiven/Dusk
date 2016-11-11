function ironfist_typhoon(event)
  local caster = event.caster
  local origin = caster:GetAbsOrigin()
  local point = caster:GetCursorPosition()
  local direction = (point - origin):Normalized()
  local distance = (origin - point):Length2D()
  local duration = event.duration
  
  Physics:Unit(caster)
  caster:SetPhysicsFriction(0)
  caster:PreventDI(true)
  -- To allow going through walls / cliffs add the following:
  caster:FollowNavMesh(false)
  caster:SetAutoUnstuck(false)
  caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
  
  caster:SetPhysicsVelocity(direction * distance * (1/duration))
  
  Timers:CreateTimer(duration,function()
    caster:SetPhysicsVelocity(Vector(0,0,0))
--    FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
    caster:PreventDI(false)
  end
  )
  Timers:CreateTimer(duration+0.06,function()
    FindClearSpaceForUnit(caster,caster:GetAbsOrigin(),true)
  end
  )
end

function ironfist_typhoon_check(event)
  local caster = event.caster
  local radius = event.radius
  local stun = event.stun
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
                                
  for k,v in pairs(enemy_found) do
    if not v:HasModifier("ironfist_typhoon_stop_mod") then
      --v:AddNewModifier(v,nil,"modifier_stunned",{Duration=stun})
      event.ability:ApplyDataDrivenModifier(caster,v,"ironfist_typhoon_stop_mod",{})
      local damage_table = {
      victim = v,
      attacker = caster,
      damage = damage,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      ability = event.ability
      } 
      ApplyDamage(damage_table)
    end
  end
end

function ironfist_quake(event)
  local caster = event.caster
  local radius = event.radius
  
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
  ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
end

function ironfist_switchup(event)
  local caster = event.caster
  local ab1 = caster:FindAbilityByName("ironfist_gale_stance")
  local ab2 = caster:FindAbilityByName("ironfist_stonewall_stance")
  local lvl1 = ab1:GetLevel()
  local lvl2 = ab2:GetLevel()
  local hissatsu = caster:FindAbilityByName("ironfist_hissatsu")
  local typhoon = caster:FindAbilityByName("ironfist_typhoon")
  local quake = caster:FindAbilityByName("ironfist_quake")
  local reversal = caster:FindAbilityByName("ironfist_reversal")
  local hissatsu_lvl = hissatsu:GetLevel()
  local typhoon_lvl = typhoon:GetLevel()
  local quake_lvl = quake:GetLevel()
  local reversal_lvl = reversal:GetLevel()
  local crab = event.ability
  
  if crab == ab2 then
  
    ab1:SetHidden(false)
    ab2:SetHidden(true)
    
    ab1:SetLevel(lvl2)
    
    caster:RemoveModifierByName("ironfist_stonewall_stance_mod")
    ab1:ApplyDataDrivenModifier(caster,caster,"ironfist_gale_stance_mod",{})
    
        --HIDE
    quake:SetHidden(true)
    reversal:SetHidden(true)
    --SHOW
    hissatsu:SetHidden(false)
    typhoon:SetHidden(false)
    
    typhoon:SetLevel(quake_lvl)
    hissatsu:SetLevel(reversal_lvl)

    ab1:EndCooldown()
    ab2:EndCooldown()
    
    ab1:StartCooldown(12)
    ab2:StartCooldown(12)
  end
  
  if crab == ab1 then

    ab1:SetHidden(true)
    ab2:SetHidden(false)
    
    ab2:SetLevel(lvl1)
    
    caster:RemoveModifierByName("ironfist_gale_stance_mod")
    ab2:ApplyDataDrivenModifier(caster,caster,"ironfist_stonewall_stance_mod",{})
    
    --SHOW
    quake:SetHidden(false)
    reversal:SetHidden(false)
    --HIDE
    hissatsu:SetHidden(true)
    typhoon:SetHidden(true)
    
    quake:SetLevel(typhoon_lvl)
    reversal:SetLevel(hissatsu_lvl)

    ab1:EndCooldown()
    ab2:EndCooldown()
    
    ab1:StartCooldown(12)
    ab2:StartCooldown(12)
  end
  
  
end

function ironfist_focus_increase(event)
  local caster = event.caster
  local target = event.target
  local attacker = event.attacker
  
  local red = event.red
  local green = event.green
  local blue = event.blue
  
  local startup = event.startup or 0
  
  if startup == 0 then if not attacker:IsRealHero() then return end end
  
  local mana_drain = event.mana_burn
  
  local stacks = 0
  
  if startup == 1 then
    local ab = {}
    ab[1] = caster:FindAbilityByName("ironfist_focus_red")
    ab[2] = caster:FindAbilityByName("ironfist_focus_green")
    ab[3] = caster:FindAbilityByName("ironfist_focus_blue")
    local i = 1
    if event.ability == ab[1] then i = 1 end
    if event.ability == ab[2] then i = 2 end
    if event.ability == ab[3] then i = 3 end
    
    i = i+1
    
    if i > 3 then i = 1 end
    
    ab[1]:SetHidden(true)
    ab[2]:SetHidden(true)
    ab[3]:SetHidden(true)
    
    print("NUMBER IS "..i)
    
    ab[1]:SetLevel(event.ability:GetLevel())
    ab[2]:SetLevel(event.ability:GetLevel())
    ab[3]:SetLevel(event.ability:GetLevel())
    
    ab[i]:SetHidden(false)
    
    if caster:HasScepter() then
      if caster.castcount == nil then caster.castcount = 0 end
      caster.castcount = caster.castcount+1
      if caster.castcount < 3 then
        ab[1]:EndCooldown()
        ab[2]:EndCooldown()
        ab[3]:EndCooldown()
      else
        caster.castcount = 0
      end
    end
  end
  
  if red == 1 then
    stacks = target:GetModifierStackCount("ironfist_focus_red_mod",event.ability)
    target:SetModifierStackCount("ironfist_focus_red_mod",event.ability,stacks+1)
    target:CalculateStatBonus()
    if attacker == caster then
      event.ability:ApplyDataDrivenModifier(caster,attacker,"ironfist_focus_red_monk_mod",{})
    end
  end
  if green == 1 then
    stacks = target:GetModifierStackCount("ironfist_focus_green_mod",event.ability)
    target:SetModifierStackCount("ironfist_focus_green_mod",event.ability,stacks+1)
    target:CalculateStatBonus()
    if attacker == caster then
      event.ability:ApplyDataDrivenModifier(caster,attacker,"ironfist_focus_green_monk_mod",{})
    end
  end
  if blue == 1 then
    stacks = target:GetModifierStackCount("ironfist_focus_blue_mod",event.ability)
    target:SetModifierStackCount("ironfist_focus_blue_mod",event.ability,stacks+1)
    target:ReduceMana(mana_drain)
    target:CalculateStatBonus()
    local damage_table = {
      victim = target,
      attacker = caster,
      damage = mana_drain,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      }
    ApplyDamage(damage_table)
    if attacker == caster then
      attacker:GiveMana(mana_drain)
    end
  end
end

function ironfist_focus_level_sync(event)
  local caster = event.caster
  local upgrade = event.ability
  local lvl = upgrade:GetLevel()
  print("LEVEL OF ABILITY IS "..lvl)
end