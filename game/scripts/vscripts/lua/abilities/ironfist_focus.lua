ironfist_focus = class({})

LinkLuaModifier("modifier_focus","lua/abilities/ironfist_focus",LUA_MODIFIER_MOTION_NONE)

function ironfist_focus:GetIntrinsicModifierName()
	return "modifier_focus"
end

modifier_focus = class({})

function modifier_focus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

if IsServer() then

	function modifier_focus:ShowNextStack()
		local next_interval = self:GetAbility():GetSpecialValueFor("interval")
		local stack = self:GetStackCount()
		local max = self:GetAbility():GetSpecialValueFor("max_stack")
		local scepter_max = self:GetAbility():GetSpecialValueFor("scepter_max_stack")
		local scepter_interval = self:GetAbility():GetSpecialValueFor("scepter_interval")

		if self:GetAbility():GetCaster():HasScepter() then
			max = scepter_max
			next_interval = scepter_interval
		end

		if stack < max and self:GetParent():IsAlive() then
			self:SetDuration(next_interval,true)
		else
			self:SetDuration(-1,true)
		end

		self:StartIntervalThink(-1)
		self:StartIntervalThink(next_interval)
	end

	function modifier_focus:OnCreated(kv)
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:ShowNextStack()
	end

	function modifier_focus:OnIntervalThink()
		local stack = self:GetStackCount()
		local max = self:GetAbility():GetSpecialValueFor("max_stack")
		local scepter_max = self:GetAbility():GetSpecialValueFor("scepter_max_stack")

		if self:GetAbility():GetCaster():HasScepter() then
			max = scepter_max
		end

		if stack < max and self:GetParent():IsAlive() then
			self:IncrementStackCount()
			self:ShowNextStack()
		else

		end
	end

	function modifier_focus:OnAttackLanded(params)
		local stack = self:GetStackCount()
		if params.attacker == self:GetParent() then
			if self:GetStackCount() > 0 then
				self:SetStackCount(self:GetStackCount()-1)
			end
			self:ShowNextStack()
		end
	end

end

-- STANCE CONSTANTS

GALE_M = "modifier_gale_stance"
STONEWALL_M = "modifier_stonewall_stance"
DRAGON_M = "modifier_dragon_stance"
PERFECT_M = "modifier_perfect_stance"

GALE = 0
STONEWALL = 1
DRAGON = 2
PERFECT = 3

function modifier_focus:CheckStance()
	local p = self:GetParent()

	local r
	local n = 0

	if p:HasModifier(GALE_M) then r = GALE n = n + 1 end
	if p:HasModifier(STONEWALL_M) then r = STONEWALL n = n + 1 end
	if p:HasModifier(DRAGON_M) then r = DRAGON n = n + 1 end
	if p:HasModifier(PERFECT_M) then r = PERFECT n = n + 1 end

	if n > 1 then Warning("WARNING: Parent ".. p:GetUnitName() .. " has more than one Stance modifier.") end

	-- if r == nil then ToolsPrint("STANCE IS NIL") else ToolsPrint("STANCE: "..r) end

	return r
end

function modifier_focus:GetTexture()
	local buff_icon = {
		[GALE] = "ironfist_gale_stance",
		[STONEWALL] = "ironfist_stonewall_stance",
		[DRAGON] = "ironfist_dragon_stance",
		[PERFECT] = "ironfist_perfect_stance"
	}

	local stance = self:CheckStance()

	if stance then
		return buff_icon[stance]
	else
		return buff_icon[DRAGON]
	end
end

-- ============================================================================================
-- DRAGON STANCE
-- ============================================================================================

function modifier_focus:GetModifierPreAttack_BonusDamage()
	if self:CheckStance() == DRAGON or self:CheckStance() == nil then -- our default
		local amt = self:GetAbility():GetSpecialValueFor("dragon_damage")
		local stack = self:GetStackCount()

		if stack > 0 then
			return amt * stack
		end
	end
end

-- ============================================================================================
-- STONEWALL STANCE
-- ============================================================================================

function modifier_focus:GetModifierPhysicalArmorBonus()
	if self:CheckStance() == STONEWALL then
		local amt = self:GetAbility():GetSpecialValueFor("stonewall_armor")
		local stack = self:GetStackCount()

		if stack > 0 then
			return amt * stack
		end
	end
end

function modifier_focus:GetModifierConstantHealthRegen()
	if self:CheckStance() == STONEWALL then
		local amt = self:GetAbility():GetSpecialValueFor("stonewall_regen")
		local stack = self:GetStackCount()

		if stack > 0 then
			return amt * stack
		end
	end
end

-- ============================================================================================
-- GALE STANCE
-- ============================================================================================

function modifier_focus:GetModifierMoveSpeedBonus_Percentage()
	if self:CheckStance() == GALE then
		local amt = self:GetAbility():GetSpecialValueFor("gale_movespeed")
		local stack = self:GetStackCount()

		if stack > 0 then
			return amt * stack
		end
	end
end

function modifier_focus:GetModifierEvasion_Constant()
	if self:CheckStance() == GALE then
		local amt = self:GetAbility():GetSpecialValueFor("gale_evasion")
		local stack = self:GetStackCount()

		if stack > 0 then
			return amt * stack
		end
	end
end

-- ============================================================================================
-- ALL STANCES
-- ============================================================================================

function modifier_focus:OnAbilityFullyCast(params)
	local caster = params.unit
	local ability = params.ability
	local interval = self:GetAbility():GetSpecialValueFor("interval")
	local isItem = ability:IsItem()

	local ignore = {
		"ironfist_gale_stance",
		"ironfist_dragon_stance",
		"ironfist_stonewall_stance",
		"ironfist_change_stance"
	}

	local stop

	for k,v in pairs(ignore) do
		if ability:GetName() == v then
			stop = true
		end
	end

	if stop then return end

	if isItem then return end
	if not ability then return end
	if not caster then return end

	if caster == self:GetParent() then
		-- reduce the cooldown
		local elapsed = ability:GetCooldownTimeRemaining()
		local mult = self:GetAbility():GetSpecialValueFor("reduction") / 100
		local stack = self:GetStackCount()

		if stack > 0 then
			mult = 1 - (mult * stack)

			local time = elapsed * mult

			ability:EndCooldown()
			ability:StartCooldown(time)
		end

		self:SetStackCount(0)
		self:ShowNextStack()
	end
end

function modifier_focus:DestroyOnExpire()
	return false
end

function modifier_focus:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return false
end