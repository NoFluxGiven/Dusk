function phantom_shadowstep(event)
  local caster = event.caster
  local hp = caster:GetHealth()
  local point = caster:GetCursorPosition()
  local point_up = point+Vector(0,0,100)
  
--  local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
--  ParticleManager:SetParticleControl(pp, 0, point_up)
--  local ppp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
--  ParticleManager:SetParticleControl(ppp, 0, caster:GetAbsOrigin()+Vector(0,0,100))

  event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadowstep", {}) --[[Returns:void
  No Description Set
  ]]

  caster:AddNoDraw()

  Timers:CreateTimer(0.50,function()
      local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
      ParticleManager:SetParticleControl(pp, 0, point_up)
    end)

  Timers:CreateTimer(1,function()
      ProjectileManager:ProjectileDodge(caster)
  
      FindClearSpaceForUnit(caster,point,true)

      caster:RemoveModifierByName("modifier_shadowstep")

      caster:RemoveNoDraw()

      local pppp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep.vpcf",PATTACH_POINT,caster)
      ParticleManager:SetParticleControl(pppp, 0, point_up)
      ParticleManager:SetParticleControl(pppp, 1, point_up)

      EmitSoundOn("Hero_Medusa.ManaShield.On",caster)
    end)

end

function phantom_shadowstep2(event)
  local caster = event.caster

  local duration = event.duration
  
--  local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
--  ParticleManager:SetParticleControl(pp, 0, point_up)
--  local ppp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
--  ParticleManager:SetParticleControl(ppp, 0, caster:GetAbsOrigin()+Vector(0,0,100))

  --caster:AddNewModifier(caster, nil, "modifier_bloodseeker_thirst", { duration = 2.5 })



  event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadowstep2", {}) --[[Returns:void
  No Description Set
  ]]

  local pp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep2.vpcf",PATTACH_ROOTBONE_FOLLOW,caster)
  --ParticleManager:SetParticleControl(pp, 0, caster:GetAbsOrigin()+Vector(0,0,100))

  Timers:CreateTimer(duration*0.05,function()
    --caster:AddNoDraw()  
    caster:SetRenderMode(1)
    caster:SetRenderAlpha(40)
    caster:SetRenderColor(0, 0, 0) --[[Returns:void
    SetRenderColor( r, g, b ): Sets the render color of the entity.
    ]]
  end)

  Timers:CreateTimer(duration*0.95,function()
    --caster:RemoveNoDraw()
    caster:SetRenderColor(255, 255, 255) --[[Returns:void
    SetRenderColor( r, g, b ): Sets the render color of the entity.
    ]]
    caster:SetRenderAlpha(255)
  end)

  Timers:CreateTimer(duration,function()

      caster:RemoveModifierByName("modifier_shadowstep2")

      

      ParticleManager:DestroyParticle(pp,false)

      EmitSoundOn("Hero_Medusa.ManaShield.On",caster)
    end)
  
  

end

function phantom_shadowstep_start_up(event)
  local caster = event.caster
  local point = caster:GetCursorPosition()
  local point_up = point+Vector(0,0,80)
  
  local p = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep.vpcf",PATTACH_POINT,caster)
  ParticleManager:SetParticleControl(p, 0, caster:GetAbsOrigin()+Vector(0,0,80))
  ParticleManager:SetParticleControl(p, 1, point_up)
  local ppp = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf",PATTACH_POINT,caster)
  ParticleManager:SetParticleControl(ppp, 0, caster:GetAbsOrigin()+Vector(0,0,80))
end

function phantom_nightmare(event)
  local attacker = event.attacker
  local unit = event.target

  if attacker:PassivesDisabled() then return end
  
  local pct = event.pct/100

  local radius = event.radius
  
  local attack_damage = event.damage
  print("ATTACK'S DAMAGE: "..attack_damage)

  local stack_damage = event.damage_per_stack/100
  
  local enemy_found = FindUnitsInRadius( attacker:GetTeamNumber(),
                              unit:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                FIND_CLOSEST,
                                false)
  attacker:EmitSound("Phantom.NightmareHit")
  for k,v in pairs(enemy_found) do

      event.ability:ApplyDataDrivenModifier(attacker, v, "modifier_nightmare_stacks", {}) --[[Returns:void
      No Description Set
      ]]
      local mod = v:FindModifierByName("modifier_nightmare_stacks")
      if mod:GetStackCount() < 10 then
        if not attacker:IsIllusion() then mod:SetStackCount(mod:GetStackCount()+1) end
      end

      local pct_bonus = mod:GetStackCount()*stack_damage

      local unit_pct = pct+pct_bonus

      local damage = unit_pct*attack_damage

      print("CLEAVE DAMAGE ON "..v:GetName()..": "..damage)
      print("PERCENTAGE CLEAVE "..unit_pct)
      print("STACKS: "..mod:GetStackCount())

      local damage_table = {
      victim = v,
      attacker = attacker,
      damage = damage,
      damage_type = DAMAGE_TYPE_PURE,
      ability = event.ability
      } 
      ApplyDamage(damage_table)
      local  p = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_cleave.vpcf",PATTACH_POINT_FOLLOW,v)
      ParticleManager:SetParticleControl(p, 0, v:GetAbsOrigin()+Vector(0,0,75))
      ParticleManager:SetParticleControl(p, 1, Vector(0,0,0))
  end
end

function phantom_crit(event)
  local caster = event.caster
  local target = event.target
  local hp = target:GetHealth()
  local maxhp = target:GetMaxHealth()
  local sdmg = event.bonus_damage/100
  local dmg = (maxhp-hp)*sdmg
  
  if CheckClass(target, "npc_dota_building") then dmg = 0 end
  if caster:PassivesDisabled() then return end

  if dmg ~= 0 then PopupSpecDamage(target, math.ceil(dmg)) end
  
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_crit.vpcf",PATTACH_POINT_FOLLOW,target)
  ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin()+Vector(0,0,75))
  ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  local damage_table = {
      victim = target,
      attacker = caster,
      damage = dmg,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = event.ability
      } 
      ApplyDamage(damage_table)
  print("Dealt "..dmg)
end

function phantom_nightmare_attack(keys)
  local caster = keys.attacker
  local owner = keys.caster
  local target = keys.unit or keys.target

  if caster:PassivesDisabled() then return end
  if not caster:HasModifier("phantom_nightmare_attk_mod") then return end
  if caster ~= owner then return end

  local stacks = target:FindModifierByName("modifier_nightmare_stacks"):GetStackCount()

  local damage_per_stack = keys.damage_per_stack

  local damage_bonus = damage_per_stack*stacks

  DealDamage(target,caster,damage_bonus,DAMAGE_TYPE_PURE)

  if not target:IsAlive() then return end

  local mod = target:FindModifierByName("modifier_nightmare_stacks")

  mod:Destroy()
end

