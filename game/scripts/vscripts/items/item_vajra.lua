--function add_secondary(keys)
--  local caster = keys.caster
--  
--  caster:RemoveAbility("vajra_proj")
--  caster:AddAbility("vajra_proj")
--end
--
--function remove_secondary(keys)
--  local caster = keys.caster
--  caster:RemoveAbility("vajra_proj")
--end

function check_melee(keys)
  local caster = keys.caster
  if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
    if not caster:HasModifier("modifier_vajra_cleave_atk") then keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_vajra_cleave_atk",{}) end    
    return
  else
    caster:RemoveModifierByName("modifier_vajra_cleave_atk")
    return
  end
end

function burn_mana(keys)
  local caster = keys.caster
  local target = keys.target
  local burn = keys.mana_burn
  local mana = keys.target:GetMana()
  if target:IsMagicImmune() then return end
  local damage = burn
  if damage > mana then damage = mana end
  if target:HasModifier("modifier_vajra_active_orb") then damage = damage * 2 end
  -- particle effect
  target:ReduceMana(damage)
  DealDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
end

function projectile(keys)
  local caster = keys.attacker
  local target = keys.target
  local radius = keys.radius
  
  print("[Item.Vajra] FIRING PROJECTILES EVERYWHERE :D")
  
  local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
  
  for k,v in pairs(found) do
  local info = 
  {
    Target = v,
    Source = target,
    Ability = keys.ability,  
    EffectName = "particles/items/vajra_projectile.vpcf",
    vSpawnOrigin = target:GetAbsOrigin(),
    fDistance = 2000,
    fStartRadius = 64,
    fEndRadius = 64,
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    fExpireTime = GameRules:GetGameTime() + 10.0,
    bDeleteOnHit = true,
    iMoveSpeed = 2000,
    bProvidesVision = false,
    iVisionRadius = 1000,
    iVisionTeamNumber = caster:GetTeamNumber()
  }
  local projectile = ProjectileManager:CreateTrackingProjectile(info)
  end
end

--function orb(keys)
--  local caster = keys.caster
--  local distance = keys.distance
--  local target = caster:GetCursorPosition()
--  
--  print("[Item.Vajra] FIRING THE ORB OF DOOOOOOOM")
--  
--  if caster:HasAbility("vajra_proj") then print("Ability is had by unit") end
--  
--  local info = 
--  {
--  Ability = keys.ability,
--  EffectName = "particles/items/vajra_orb_illusory_orb.vpcf",
--  vSpawnOrigin = caster:GetAbsOrigin(),
--  fDistance = distance,
--  fStartRadius = 90,
--  fEndRadius = 90,
--  Source = caster,
--  bHasFrontalCone = false,
--  bReplaceExisting = false,
--  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
--  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
--  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--  fExpireTime = GameRules:GetGameTime() + 10.0,
--  vVelocity = caster:GetForwardVector() * 1600,
--  bProvidesVision = true,
--  iVisionRadius = 600,
--  iVisionTeamNumber = caster:GetTeamNumber()
--  }
--  local projectile = ProjectileManager:CreateLinearProjectile(info)
--end

function orb_hit(keys)
  print("[Item.Vajra] ABILITY HIT THE PERSON THING!!")
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local damage = ability:GetLevelSpecialValueFor("damage",ability:GetLevel()-1)
  local stack = ability:GetLevelSpecialValueFor("stack",ability:GetLevel()-1)
  
  local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              target:GetCenter(),
                              nil,
                                400,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
                                
  for k,v in pairs(enemy_found) do
    DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
    ability:ApplyDataDrivenModifier(caster,v,"modifier_vajra_active_orb",{})
    ability:ApplyDataDrivenModifier(caster,v,"modifier_vajra_active_orb_mres",{})
    v:SetModifierStackCount("modifier_vajra_active_orb",ability,stack)
    v:Purge(true,false,false,false,false)
  end
  
end

function interval(keys)
  local caster = keys.caster
  local target = keys.target
  
  local stack = target:GetModifierStackCount("modifier_vajra_active_orb",keys.ability)
  
  if stack <= 1 then target:RemoveModifierByName("modifier_vajra_active_orb") target:RemoveModifierByName("modifier_vajra_active_orb_mres") end
  
  target:SetModifierStackCount("modifier_vajra_active_orb",keys.ability,stack-1)
end