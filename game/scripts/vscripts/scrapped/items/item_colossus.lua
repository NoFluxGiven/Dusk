
--[[ ============================================================================================================
  Author: Rook
  Date: January 28, 2015
  Called when the unit takes damage.  Puts the Heart(s) in the player's inventory on cooldown, with a duration
  dependant on whether the unit is melee or ranged.
  Additional parameters: keys.CooldownMelee
================================================================================================================= ]]
function colossus_stop_regen(keys)

  local owner = keys.attacker:GetOwner() or false
  if owner then
    if not owner:IsPlayer() then
      owner = owner:IsRealHero()
    else
      owner = true
    end
  end

  if keys.attacker:IsRealHero() or CheckName(keys.attacker,{"npc_dota_roshan","npc_dota_unit_avatar_dark"}) or owner then
    keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))
  end
  
  if keys.caster:HasModifier("colossus_heal_visible_mod") then
    keys.caster:RemoveModifierByNameAndCaster("colossus_heal_visible_mod", keys.caster)
  end
end


--[[ ============================================================================================================
  Author: Rook
  Date: January 28, 2015
  Called regularly while one or more Heart of Tarrasques are in the unit's inventory.  Heals them if the item is
  off cooldown, and displays an icon on the caster's modifier bar.
  Additional parameters: keys.HealthRegenPercentPerSecond and keys.HealInterval
================================================================================================================= ]]
function colossus_regen(keys)
  if keys.ability:IsCooldownReady() and keys.caster:IsRealHero() then
    keys.caster:Heal(keys.caster:GetMaxHealth() * (keys.HealthRegenPercentPerSecond / 100) * keys.HealInterval, keys.caster)
    if not keys.caster:HasModifier("colossus_heal_visible_mod") then
      keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "colossus_heal_visible_mod", {duration = -1})
    end
  elseif keys.caster:HasModifier("colossus_heal_visible_mod") then  --This is mostly a failsafe.
    keys.caster:RemoveModifierByNameAndCaster("colossus_heal_visible_mod", keys.caster)
  end
end


--[[ ============================================================================================================
  Author: Rook
  Date: January 28, 2015
  Called when Heart of Tarrasque is dropped or sold or something.  Removes the visible modifier from the modifier bar.
================================================================================================================= ]]
function colossus_cancel_regen(keys)
  keys.caster:RemoveModifierByNameAndCaster("colossus_heal_visible_mod", keys.caster)
end