function turins_scepter_active_apply(keys)
  local caster = keys.caster
  local target = keys.target
  local duration = keys.duration or 6
  if not target:IsRealHero() then keys.ability:EndCooldown() keys.ability:StartCooldown(7) end
  if target:IsMagicImmune() then duration = duration/2 end
  keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_item_turins_scepter_crush",{Duration=duration})
end

function turins_scepter_tick(keys)
  local hero = keys.target
  
  local point = hero:GetAbsOrigin()+RandomVector(RandomInt(300,400))
  
  local dummy = CreateUnitByName("npc_dummy_unit", point, false, hero, hero, hero:GetTeam())
  dummy:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
  dummy:AddNewModifier(hero, nil, "modifier_kill", {Duration=1})
  
  local target = dummy
  
  EmitSoundOn("Hero_Zuus.ArcLightning.Target", hero)
  
  local lightningBolt = ParticleManager:CreateParticle("particles/items/turin_electricity.vpcf", PATTACH_CUSTOMORIGIN, hero)
  ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z )) 
  ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
  
  local damage_table = {
      victim = hero,
      attacker = keys.caster,
      damage = keys.ability_damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      } 
      ApplyDamage(damage_table)
end