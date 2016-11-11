modifier_shopkeeper_always_show = class({})

function modifier_shopkeeper_always_show:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end

function modifier_shopkeeper_always_show:CheckState()

  local state = {
    --[MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ATTACK_IMMUNE] = false,
    [MODIFIER_STATE_INVULNERABLE] = false,
    --[MODIFIER_STATE_NIGHTMARED] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = false,
    [MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
  }

  return state
end

function modifier_shopkeeper_always_show:GetAbsoluteNoDamageMagical()
  return 1
end

function modifier_shopkeeper_always_show:GetAbsoluteNoDamagePhysical()
  return 1
end

function modifier_shopkeeper_always_show:GetAbsoluteNoDamagePure()
  return 1
end

function modifier_shopkeeper_always_show:GetMinHealth()
  return 1
end

function modifier_shopkeeper_always_show:IsHidden()
    return false--true
end
