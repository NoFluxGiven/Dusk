function elementalist_trinity(event)
  local caster = event.caster
  
  local ab1 = caster:FindAbilityByName("elementalist_fire_bolt")
  local ab2 = caster:FindAbilityByName("elementalist_electric_bolt")
  local ab3 = caster:FindAbilityByName("elementalist_ice_bolt")

  local duration = event.duration
  
  ab1:ApplyDataDrivenModifier(caster,caster,"elementalist_fire_trinity_mod",{Duration=duration})
  ab2:ApplyDataDrivenModifier(caster,caster,"elementalist_electric_trinity_mod",{Duration=duration})
  ab3:ApplyDataDrivenModifier(caster,caster,"elementalist_ice_trinity_mod",{Duration=duration})
  if caster:HasScepter() then
  	event.ability:ApplyDataDrivenModifier(caster,caster,"elementalist_scepter_mod",{Duration=duration})
  else
  	event.ability:ApplyDataDrivenModifier(caster, caster, "elementalist_trinity_effect_mod", {Duration=duration})
  end

  caster:EmitSound("Hero_Invoker.Alacrity")
end