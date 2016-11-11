--[[ ============================================================================================================
  Author: Rook
  Date: February 1, 2015
  Called when a unit with Abyssal Blade lands an attack.  Calculates whether a stun should occur, and applies one
  if so.
  Additional parameters: keys.BashChanceMelee and keys.BashChanceRanged
================================================================================================================= ]]
function fenrir_bash(keys)
  if not keys.caster:HasModifier("bash_cooldown_modifier") then
    local random_int = RandomInt(1, 100)
    local is_ranged_attacker = keys.caster:IsRangedAttacker()

    local target = keys.target
    
    if (is_ranged_attacker and random_int <= keys.BashChanceRanged) or (not is_ranged_attacker and random_int <= keys.BashChanceMelee) then
      if not CheckClass(target, "npc_dota_building") then
        keys.target:EmitSound("DOTA_Item.SkullBasher")
        keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "fenrir_bash_mod", nil)
        
        --Give the caster a generic "bash cooldown" modifier so they cannot bash in the next couple of seconds due to any item.
        keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "bash_cooldown_modifier", nil)
      end
    end
  end
end


--[[ ============================================================================================================
  Author: Rook
  Date: February 1, 2015
  Called when Abyssal Blade is cast.  Stuns the target unit.
================================================================================================================= ]]
function fenrir_stun(keys)
  keys.target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
  keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "fenrir_active_mod", nil)
  ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
end