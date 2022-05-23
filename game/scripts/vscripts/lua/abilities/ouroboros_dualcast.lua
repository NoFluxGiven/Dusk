ouroboros_dualcast = class({})

LinkLuaModifier("modifier_dualcast","lua/abilities/ouroboros_dualcast",LUA_MODIFIER_MOTION_NONE)

function ouroboros_dualcast:GetIntrinsicModifierName()
	return "modifier_dualcast"
end

function ouroboros_dualcast:OnToggle()
	return
end

modifier_dualcast = class({})

function modifier_dualcast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

if IsServer() then

	function modifier_dualcast:OnAbilityFullyCast(params)
		local caster = params.unit
		local ability = params.ability
		local behav = ability:GetBehavior()

		local no_of_casts = 1

		local t_manacost = self:GetAbility():GetCaster():FindTalentValue("special_bonus_ouroboros_4") or 0

		local parent = self:GetParent()

		if caster ~= parent then return end

		local NIL_TARGET,UNIT_TARGET,POINT_TARGET,NO_TARGET = 0,1,2,3

		local delay = self:GetAbility():GetSpecialValueFor("delay")
		local cost = self:GetAbility():GetSpecialValueFor("mana_cost")/100

		local mana_cost = ability:GetManaCost(-1)
		if mana_cost <= 0 then return end

		local isItem = ability:IsItem()
		if isItem then return end

		cost = cost - t_manacost/100

		local mana_removal = cost * ability:GetManaCost(-1)

		local mana_remaining = caster:GetMana()

		local toggleState = self:GetAbility():GetToggleState()
		if not toggleState then return end

		local has_required_mana = mana_remaining >= mana_removal
		if not has_required_mana then return end

		local target,btype
		if behav then
			if bit.band(behav,DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
				target = ability:GetCursorTarget()
				btype = UNIT_TARGET
			end
			if bit.band(behav,DOTA_ABILITY_BEHAVIOR_POINT) then -- if they are both POINT and UNIT target, we override
				target = ability:GetCursorPosition()
				btype = POINT_TARGET
			elseif bit.band(behav,DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
				target = NIL_TARGET
				btype = NO_TARGET
			end
		end
		
		for i=1,no_of_casts do
			Timers:CreateTimer(delay*i,function()
				if target then
					if btype == UNIT_TARGET then
						caster:SetCursorCastTarget(target)
					elseif btype == POINT_TARGET then
						caster:SetCursorPosition(target)
					elseif btype == NO_TARGET then
						caster:SetCursorTargetingNothing(true)
					end
					caster:SpendMana(mana_removal, ability)
					ability:OnSpellStart()
				end
			end)
		end
	end

end