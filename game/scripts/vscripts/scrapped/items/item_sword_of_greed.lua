function sword_of_greed_start(keys)
  local caster = keys.caster
  
  if caster.greed_deaths == nil then
  
    caster.greed_deaths = 0
  
  end
end

function sword_of_greed_transmute(keys)
  
  keys.caster:ModifyGold(keys.gold, true, 0)  --Give the player a flat amount of reliable gold.
  keys.caster:AddExperience(keys.target:GetDeathXP() * keys.XPMultiplier, false, false)
  
  local player = PlayerResource:GetPlayer(keys.caster:GetPlayerID())
  
  --Start the particle and sound.
  keys.target:EmitSound("DOTA_Item.Hand_Of_Midas")
  local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)  
  ParticleManager:SetParticleControlEnt(midas_particle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), false)
  
  PopupGoldGain(keys.target,keys.gold,player)

  keys.target:SetDeathXP(0)
  keys.target:SetMinimumGoldBounty(0)
  keys.target:SetMaximumGoldBounty(0)
  keys.target:Kill(keys.ability, keys.caster) --Kill the creep.  This increments the caster's last hit counter.
end

function sword_of_greed_kill_gold(keys)
  local caster = keys.caster
  local gold = keys.gold
  local target = keys.unit
  local player = PlayerResource:GetPlayer(caster:GetPlayerID())
  local reliable = false
  
  if target:IsRealHero() then gold = gold*8 reliable = true end
  if target:IsIllusion() then return end
  
  keys.caster:ModifyGold(gold, reliable, 0)  --Give the player a flat amount of reliable gold.
  local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"   
  local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
  ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
  ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )
  
  -- Message Particle, has a bunch of options
  -- Similar format to the popup library by soldiercrabs: http://www.reddit.com/r/Dota2Modding/comments/2fh49i/floating_damage_numbers_and_damage_block_gold/
  local symbol = 0 -- "+" presymbol
  local color = Vector(255, 200, 33) -- Gold
  local lifetime = 2
  local digits = string.len(gold) + 1
  local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
  local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
  ParticleManager:SetParticleControl(particle, 1, Vector(symbol, gold, symbol))
  ParticleManager:SetParticleControl(particle, 2, Vector(lifetime, digits, 0))
  ParticleManager:SetParticleControl(particle, 3, color)
end

function sword_of_greed_tick(keys)
  local gold = keys.gold
  keys.caster:ModifyGold(gold, false, 0)  --Give the player a flat amount of unreliable gold.
end

function sword_of_greed_death(keys)
  local caster = keys.caster
  local attacker = keys.attacker

  if caster:IsIllusion() then return end

  if attacker:IsOwnedByAnyPlayer() then

    local player = PlayerResource:GetPlayer(attacker:GetPlayerID())

  end

  local lvl = keys.ability:GetLevel()

  local gold_loss = keys.loss

  local g = caster:GetGold()

  local l = caster:GetLevel()*gold_loss

  if l > g then l = g end
  
  if caster.greed_deaths == nil then caster.greed_deaths = 0 end
  
  caster:SpendGold(l,0)

  attacker:ModifyGold(l,false,0)

  -- Message Particle, has a bunch of options
  -- Similar format to the popup library by soldiercrabs: http://www.reddit.com/r/Dota2Modding/comments/2fh49i/floating_damage_numbers_and_damage_block_gold/
  local symbol = 0 -- "+" presymbol
  local color = Vector(255, 200, 33) -- Gold
  local lifetime = 2
  local digits = string.len(l) + 1
  local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
  local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, target, player )
  ParticleManager:SetParticleControl(particle, 1, Vector(symbol, l, symbol))
  ParticleManager:SetParticleControl(particle, 2, Vector(lifetime, digits, 0))
  ParticleManager:SetParticleControl(particle, 3, color)

  if lvl < 5 then
    keys.ability:SetLevel(lvl+1)
  end
end