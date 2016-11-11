function fury_rend_atk(event)
  local caster = event.caster
  local target = event.target
  local max_stack = event.max_stack
  local damage = event.dmg
  local reset_time = event.ability:GetLevelSpecialValueFor("bonus_reset_time",event.ability:GetLevel()-1)
  local reset_rosh = event.ability:GetLevelSpecialValueFor("bonus_reset_time_roshan",event.ability:GetLevel()-1)
  local duration = 1
  
  --if CheckClass(target,"npc_dota_roshan") then duration = reset_rosh else duration = reset_time end

  --if caster:PassivesDisabled() then return end

  duration = reset_time
  
  if caster:HasModifier("fury_rampage_mod") or caster:HasModifier("fury_berserk_mod") then max_stack = 9999 end

  if CheckClass(target,"npc_dota_building") then return end

  if target:HasModifier("fury_rend_damage_mod") then
    event.ability:ApplyDataDrivenModifier(caster,target,"fury_rend_damage_mod",{Duration=duration})
    event.ability:ApplyDataDrivenModifier(caster,caster,"modifier_fury_rend_damage",{Duration=duration})
    local stacks = target:GetModifierStackCount("fury_rend_damage_mod",event.ability)
    if stacks < max_stack then
      target:SetModifierStackCount("fury_rend_damage_mod",event.ability,stacks+1)
      caster:SetModifierStackCount("modifier_fury_rend_damage",event.ability,stacks+1)
    else
      target:SetModifierStackCount("fury_rend_damage_mod",event.ability,max_stack)
      caster:SetModifierStackCount("modifier_fury_rend_damage",event.ability,max_stack)
    end
    -- local damage_table = {
    --   victim = target,
    --   attacker = caster,
    --   damage = damage*stacks,
    --   damage_type = DAMAGE_TYPE_PHYSICAL,
    --   }
    -- ApplyDamage(damage_table)
    PopupFuryDamage(target, math.ceil(damage*stacks))
    -- fury_bloodsport_lifesteal_exception(caster,target,damage*stacks)
  else
    event.ability:ApplyDataDrivenModifier(caster,target,"fury_rend_damage_mod",{Duration=duration})
    event.ability:ApplyDataDrivenModifier(caster,caster,"modifier_fury_rend_damage",{Duration=duration})
    target:SetModifierStackCount("fury_rend_damage_mod",event.ability,1)
    caster:SetModifierStackCount("modifier_fury_rend_damage",event.ability,1)
    -- local damage_table = {
    --   victim = target,
    --   attacker = caster,
    --   damage = damage,
    --   damage_type = DAMAGE_TYPE_PHYSICAL,
    --   }
    -- ApplyDamage(damage_table)
    return
  end
end

function fury_rend_preatk(keys)
  local caster = keys.caster
  local target = keys.target

  if target:HasModifier("fury_rend_damage_mod") then
    local stacks = target:GetModifierStackCount("fury_rend_damage_mod",keys.ability)
    caster:SetModifierStackCount("modifier_fury_rend_damage",keys.ability,stacks)
  else
    caster:RemoveModifierByName("modifier_fury_rend_damage")
  end
end

function fury_bloodsport_lifesteal_exception(caster, target, dmg) -- applies lifesteal to other damage without incrementing stacks
  local ab = caster:FindAbilityByName("fury_bloodsport")
  local lifesteal = ab:GetLevelSpecialValueFor("lifesteal",ab:GetLevel()-1)
  local stacks = caster:GetModifierStackCount("fury_bloodsport_lifesteal_mod",ab)
  
  if lifesteal == nil then return end
  
  if CheckClass(target,"npc_dota_building") then return end
  
  ab:ApplyDataDrivenModifier(caster,caster,"fury_bloodsport_count_mod",{})
  
  if caster:HasModifier("fury_rampage_mod") or caster:HasModifier("fury_berserk_mod") then return end
  
  local lifesteal = lifesteal/100
  
  local heal = dmg*(lifesteal*(stacks+1))
  
  print("STEALING "..heal.." LIFE FROM TG EXCEPTION VERSION")
  
  caster:Heal(heal,caster)
  
  ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
   
end

function fury_bloodsport_lifesteal(event)
  local caster = event.caster
  local target = event.target
  local stacks = caster:GetModifierStackCount("fury_bloodsport_lifesteal_mod",event.ability)
  local max_stack = event.max_stack
  local damage = event.dmg
  
  if CheckClass(target,"npc_dota_building") then return end
  
  event.ability:ApplyDataDrivenModifier(caster,caster,"fury_bloodsport_count_mod",{})
  event.ability:ApplyDataDrivenModifier(caster,caster,"fury_bloodsport_effect_mod",{Duration=stacks})
  
  if caster:HasModifier("fury_rampage_mod") or caster:HasModifier("fury_berserk_mod") then return end
  
  if stacks < max_stack then
    caster:SetModifierStackCount("fury_bloodsport_lifesteal_mod",event.ability,stacks+1)
  else
    caster:SetModifierStackCount("fury_bloodsport_lifesteal_mod",event.ability,max_stack)
  end
  
  local lifesteal = event.lifesteal/100
  
  local heal = damage*(lifesteal*(stacks))
  
  print("STEALING "..heal.." LIFE FROM TG")
  
  caster:Heal(heal,caster)
  
  ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
   
end

function fury_bloodsport_lifesteal_red(event)
  local caster = event.caster
  local stacks = caster:GetModifierStackCount("fury_bloodsport_lifesteal_mod",event.ability)
  
  if stacks > 1 then caster:SetModifierStackCount("fury_bloodsport_lifesteal_mod",event.ability,stacks-1) event.ability:ApplyDataDrivenModifier(caster,caster,"fury_bloodsport_count_mod",{}) end
end

function fury_rampage(event)
  local caster = event.caster
  local caster_hp = 110-caster:GetHealthPercent()

  caster:SetModifierStackCount("fury_rampage_mod",event.ability,caster_hp)
  caster:SetModifierStackCount("fury_berserk_mod",event.ability,caster_hp)

  --caster:Purge(false,true,false,true,false)
end

function fury_berserk(event)
  local caster = event.caster
  local caster_health = caster:GetHealth()
  local attacker = event.attacker
  local dmg = event.dmg
  local current_scale = 1
  
  local n = current_scale

  --caster:Purge(false,true,false,true,false)
  
  if dmg > caster_health then
    caster:EmitSound("Hero_Ursa.Enrage")
    for i=1,10 do -- grow
      Timers:CreateTimer(i/10,function()
        caster:SetModelScale(current_scale+i*0.05)
      end)
    end
    event.ability:ApplyDataDrivenModifier(caster,caster,"fury_berserk_mod",{})
    event.ability:ApplyDataDrivenModifier(caster,caster,"fury_berserk_bat_mod",{})
    caster:RemoveModifierByName("fury_rampage_mod")
    caster:RemoveModifierByName("fury_rampage_bat_mod")
    Timers:CreateTimer(6,function()
      for i=1,10 do -- shrink
        Timers:CreateTimer(i/10,function()
          caster:SetModelScale(1.9-i*0.05)
        end)
      end
    end)
    Timers:CreateTimer(7.1,function()
      caster:SetModelScale(0.8)
      caster:Kill(event.ability,attacker)
    end)
  end
end

function newBloodsportStackControl(keys)
  local caster = keys.caster
  local target = keys.target

  if CheckClass(target,"npc_dota_building") then return end
  if caster:PassivesDisabled() then return end

  ParticleManager:CreateParticle("particles/units/heroes/hero_fury/fury_bloodsport_strike_particle.vpcf", PATTACH_ABSORIGIN, target) --[[Returns:int
  Creates a new particle effect
  ]]

  keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bloodsport_bleed_tgt", {}) --[[Returns:void
  No Description Set
  ]]

  local stacks = target:GetModifierStackCount("modifier_bloodsport_bleed_tgt",keys.ability)
  target:SetModifierStackCount("modifier_bloodsport_bleed_tgt",keys.ability,stacks+1)

end

function newBloodsportBleedDamage(keys)
  local caster = keys.caster
  local target = keys.target

  local damage = keys.damage

  local stacks = target:GetModifierStackCount("modifier_bloodsport_bleed_tgt",keys.ability)

  DealDamage(target,caster,damage*stacks,DAMAGE_TYPE_PHYSICAL)
end