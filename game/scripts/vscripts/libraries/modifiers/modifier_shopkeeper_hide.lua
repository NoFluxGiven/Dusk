modifier_shopkeeper_hide = class({})

function modifier_shopkeeper_hide:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
    }

    return funcs
end

function modifier_shopkeeper_hide:CheckState()

  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
  }

  return state
end

function modifier_shopkeeper_hide:IsHidden()
    return false--true
end
