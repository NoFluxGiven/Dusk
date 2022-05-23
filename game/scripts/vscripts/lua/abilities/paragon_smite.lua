paragon_smite = class({})

LinkLuaModifier("modifier_smite","lua/abilities/paragon_smite",LUA_MODIFIER_MOTION_NONE)

function paragon_smite:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  self:Strike(caster,target,1)
end

function paragon_smite:Strike(caster,target,damage_mod,opt_particle,opt_sound)
  local dmg = self:GetSpecialValueFor("damage")
  local scepter_dmg = self:GetSpecialValueFor("scepter_damage")
  local particle = opt_particle or "smite"
  local sound = opt_sound or "Hero_Zuus.GodsWrath"

  local scepter_dmg_bonus = self:GetSpecialValueFor("scepter_damage_bonus")

  if caster:HasScepter() then
    dmg = scepter_dmg
    if caster:GetTeam() == DOTA_TEAM_GOODGUYS then
      if target == duskDota.lastDireKill.attacker then dmg = dmg + scepter_dmg_bonus end
    else
      if target == duskDota.lastRadiantKill.attacker then dmg = dmg + scepter_dmg_bonus end
    end
  end

  if not target:IsAlive() then self:RefundManaCost() self:EndCooldown() return end

  dmg = dmg * damage_mod

  local targetmod = target:GetAbsOrigin()+Vector(0,0,800)
  local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),2,750)
  local boltparticle  = ParticleManager:CreateParticle("particles/units/heroes/hero_paragon/"..particle..".vpcf", PATTACH_ABSORIGIN, unit)
  ParticleManager:SetParticleControl(boltparticle,0,target:GetCenter())
  ParticleManager:SetParticleControl(boltparticle,1,targetmod)
  EmitGlobalSound(sound)

  ScreenShake(target:GetCenter(), 500, 2, 0.3, 70000, 0, true)

  target:Interrupt()

  self:InflictDamage(target,caster,dmg,DAMAGE_TYPE_PURE)

  if not target:IsAlive() then
    target:AddNoDraw()
    ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, unit)
    ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_ABSORIGIN, unit)
    ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN, unit)
    EmitGlobalSound("Hero_Phoenix.SuperNova.Explode")
  end
end

function paragon_smite:GetIntrinsicModifierName()
  return "modifier_smite"
end

modifier_smite = class({})

function modifier_smite:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_DEATH
  }
  return funcs
end

function modifier_smite:IsHidden()
  return true
end

function modifier_smite:OnDeath(params)
  local tcheck = self:GetAbility():GetCaster():FindTalentValue("special_bonus_paragon_4")
  if not tcheck then return end

  local unit = params.unit
  local attacker = params.attacker

  if attacker:IsRealHero() and unit:GetTeam() == self:GetParent():GetTeam() and unit:IsRealHero() and self:GetParent():IsAlive() then
    self:GetAbility():Strike(unit,attacker,0.50,"minismite","Hero_Zuus.LightningBolt")
  end
end