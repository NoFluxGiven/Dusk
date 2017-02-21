modifier_extraplanar_pact_oog = class({})

function modifier_extraplanar_pact_oog:DeclareFunctions()
	local func = {

	}
	
	return func
end

function modifier_extraplanar_pact_oog:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}

	return state
end