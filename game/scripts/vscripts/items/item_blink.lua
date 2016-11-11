--[[ ============================================================================================================
  Author: Rook, with help from some of Pizzalol's SpellLibrary code
  Date: January 25, 2015
  Called when Blink Dagger is cast.  Blinks the caster in the targeted direction.
  Additional parameters: keys.MaxBlinkRange and keys.BlinkRangeClamp
================================================================================================================= ]]
function item_blink_datadriven_on_spell_start(keys)
  ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
  
  local origin_point = keys.caster:GetAbsOrigin()
  local target_point = keys.target_points[1]
  local target = keys.target or nil
  local difference_vector = target_point - origin_point
  local div = 1
  
  local dummy = CreateUnitByName("npc_dummy_unit", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeam())
  dummy:AddNewModifier(keys.caster, nil, "modifier_kill", {Duration=1})
  
  ParticleManager:CreateParticle("particles/items/vagrant_dagger_start.vpcf", PATTACH_ABSORIGIN, dummy)
  dummy:EmitSound("DOTA_Item.BlinkDagger.Activate")
  
  if keys.caster:HasModifier("modifier_item_blink_datadriven_damaged") then
    div = 3
  end
  
  if target ~= nil then
    if IsValidEntity(target) then
      if target == keys.caster then
        if not keys.caster:HasModifier("modifier_item_blink_datadriven_invis") then
          keys.ability:ApplyDataDrivenModifier(keys.caster,keys.caster,"modifier_item_blink_datadriven_invis",{})
          return
        end
      end
    end
  end
  
  if difference_vector:Length2D() > (keys.MaxBlinkRange / div) then  --Clamp the target point to the BlinkRangeClamp range in the same direction,
    target_point = origin_point + (target_point - origin_point):Normalized() * (keys.BlinkRangeClamp / div)
  end
  
  --keys.caster:SetAbsOrigin(target_point)
  FindClearSpaceForUnit(keys.caster, target_point, true)
  
  ParticleManager:CreateParticle("particles/items/vagrant_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
end


--[[ ============================================================================================================
  Author: Rook
  Date: January 25, 2015
  Called when a unit with Blink Dagger in their inventory takes damage.  Puts the Blink Dagger on a brief cooldown
  if the damage is nonzero (after reductions) and originated from any player or Roshan.
  Additional parameters: keys.BlinkDamageCooldown and keys.Damage
  Known Bugs: keys.Damage contains the damage before reductions, whereas we want to compare the damage to 0 after reductions.
================================================================================================================= ]]
function modifier_item_blink_datadriven_damage_cooldown_on_take_damage(keys)
  local attacker_name = keys.attacker:GetName()

  if keys.Damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) then  --If the damage was dealt by neutrals or lane creeps, essentially.
    keys.ability:ApplyDataDrivenModifier(keys.caster,keys.caster,"modifier_item_blink_datadriven_damaged",{Duration=3})
  end
end