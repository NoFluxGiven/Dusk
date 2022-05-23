paragon_cleanse = class({})

LinkLuaModifier("modifier_cleanse_heal_amp","lua/abilities/paragon_cleanse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleanse_heal_amp_display","lua/abilities/paragon_cleanse",LUA_MODIFIER_MOTION_NONE)
if IsServer() then

  function paragon_cleanse:CastFilterResultTarget( hTarget )
    local t_target_buildings = self:GetCaster():FindTalentValue("special_bonus_paragon_7")
    local caster = self:GetCaster()

    if ( hTarget:IsBuilding() ) then
        if ( t_target_buildings ) then
          return UF_SUCCESS
        else
          return UF_FAIL_CUSTOM
        end
    end
   
    local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber() )
    return nResult
  end
   
  function paragon_cleanse:GetCustomCastErrorTarget( hTarget )
    local t_target_buildings = self:GetCaster():FindTalentValue("special_bonus_paragon_7")
    if ( hTarget:IsBuilding() ) then
        if ( t_target_buildings ) then
          return ""
        else
          return "#dota_hud_error_cant_cast_on_building"
        end
    end
   
    return ""
  end

end

function paragon_cleanse:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  local cteam = caster:GetTeam()
  local tteam = target:GetTeam()
  local dmg = self:GetSpecialValueFor("heal")
  local radius = self:GetSpecialValueFor("radius")
  local sdmg = self:GetSpecialValueFor("secondary")

  local p = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_POINT_FOLLOW, target) --[[Returns:int
  Creates a new particle effect
  ]]
  ParticleManager:SetParticleControl(p, 1, Vector(radius,radius,radius)) --[[Returns:void
  Set the control point data for a control on a particle effect
  ]]
  target:EmitSound("Hero_Omniknight.Purification")

  local t_stacking_heal_amp = self:GetCaster():FindTalentValue("special_bonus_paragon_1")

  local t_purge_debuffs = self:GetCaster():FindTalentValue("special_bonus_paragon_5")

  local t_target_buildings = self:GetCaster():FindTalentValue("special_bonus_paragon_7")

  local a = FindAllies(caster,target:GetAbsOrigin(),radius)

  for k,v in pairs(a) do
  	if v ~= target then
  		v:Heal(sdmg,caster)
  	end
  end

  if target:IsBuilding() and t_target_buildings then dmg = dmg*(t_target_buildings/100) end
  
  if cteam == tteam then
    target:Heal(dmg,caster)
    if t_purge_debuffs then
      target:Purge(false, true, false, false, false)
    end
    if t_stacking_heal_amp then
      target:AddNewModifier(caster, self, "modifier_cleanse_heal_amp", {Duration=45})
      target:AddNewModifier(caster, self, "modifier_cleanse_heal_amp_display", {Duration=45})
    end
    return
  end
  	
  self:InflictDamage(target,caster,dmg,DAMAGE_TYPE_PURE)
end

modifier_cleanse_heal_amp_display = class({})

function modifier_cleanse_heal_amp_display:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_cleanse_heal_amp_display:OnDestroy()
  if IsServer() then
    local mod = self:GetParent():FindModifierByName("modifier_cleanse_heal_amp")
    if mod then
      mod:SetStackCount(mod:GetStackCount()-1)
      if mod:GetStackCount() <= 0 then
        mod:Destroy()
      end
    end
  end
end

function modifier_cleanse_heal_amp_display:IsHidden()
  return true
end

modifier_cleanse_heal_amp = class({})

function modifier_cleanse_heal_amp:OnCreated()
  self:SetStackCount(1)
end

function modifier_cleanse_heal_amp:OnRefresh()
  local t_target_buildings = self:GetAbility():GetCaster():FindTalentValue("special_bonus_paragon_7")

  if IsServer() then
    self:IncrementStackCount()
  end
end

function modifier_cleanse_heal_amp:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE
  }
  return funcs
end

function modifier_cleanse_heal_amp:GetModifierHealAmplify_Percentage()
  return self:GetAbility():GetCaster():FindTalentValue("special_bonus_paragon_1") * self:GetStackCount()
end
