hawkeye_ricochet = class({})

LinkLuaModifier("modifier_rapidfire_damage_reduction","lua/abilities/hawkeye_ricochet",LUA_MODIFIER_MOTION_NONE)

function hawkeye_ricochet:GetCastRange()
	return self:GetCaster():Script_GetAttackRange()+75
end

function hawkeye_ricochet:OnSpellStart()
	if IsServer() then
		local t = self:GetCursorTarget()
		local c = self:GetCaster()

		local t_bonus = c:FetchTalent("special_bonus_hawkeye_2") or 0

		local n = self:GetSpecialValueFor("hits") + t_bonus

		ToolsPrint(bonus)

		if bonus then n = n + bonus end

		ToolsPrint(n)

		local interval = 0.12

		Timers:CreateTimer(0.03,function()
			c:Interrupt()
			c:Stop()
			c:Hold()
		end)

		c:AddNewModifier(c, self, "modifier_rapidfire_damage_reduction", {}) --[[Returns:void
				No Description Set
				]]

		Timers:CreateTimer(interval,function()
			n = n - 1
			if IsValidEntity(t) then
				c:PerformAttack(
					t,
					true,
					true,
					true,
					false,
					true,
					false,
					false
				)
			end
			if n > 0 then
				return interval
			end
		end)

		Timers:CreateTimer(interval*(n-1)+0.25,function()
			c:RemoveModifierByNameAndCaster("modifier_rapidfire_damage_reduction", c)
	    	Orders:IssueAttackOrder(c,t)
		end)
	end
end

modifier_rapidfire_damage_reduction = class({})

function modifier_rapidfire_damage_reduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_rapidfire_damage_reduction:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
	return state
end

function modifier_rapidfire_damage_reduction:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_rapidfire_damage_reduction:IsHidden()
	return true
end