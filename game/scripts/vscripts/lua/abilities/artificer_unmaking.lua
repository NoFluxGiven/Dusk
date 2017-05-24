-- Leaving this one for now, as I can't really find a way to run functions to do with Orb attacks in Lua

artificer_unmaking = class({})

LinkLuaModifier("modifier_unmaking_debuff","lua/abilities/artificer_unmaking",LUA_MODIFIER_MOTION_NONE)

function artificer_unmaking:OnSpellStart()

end

-- function artificer_unmaking:GetCastRange()
-- 	local cast_range = self:GetCaster():GetAttackRange()
-- 	return cast_range
-- end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_unmaking_orb_attack = class({})

function modifier_unmaking_orb_attack:DeclareFunctions()
	local func = {

	}
end

modifier_unmaking_debuff = class({})