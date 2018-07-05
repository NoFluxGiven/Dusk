fury_rend = class({})

LinkLuaModifier("modifier_rend_passive","lua/abilities/fury_rend",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rend_hp","lua/abilities/fury_rend",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rend","lua/abilities/fury_rend",LUA_MODIFIER_MOTION_NONE)

function fury_rend:GetIntrinsicModifierName()
	return "modifier_rend_passive"
end

modifier_rend_passive = class({})

function modifier_rend_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

-- ONATTACK
function modifier_rend_passive:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target

	local duration = self:GetAbility():GetSpecialValueFor("reset_time")
	local rosh_duration = self:GetAbility():GetSpecialValueFor("reset_time_roshan")

	if attacker ~= self:GetParent() then return end
	if attacker:IsIllusion() then return end
	if target:IsBuilding() then return end
	if not target:IsHero() then return end
	if attacker:PassivesDisabled() then return end
	-- if target:IsRoshan() then duration = rosh_duration end

	local stack_bonus = 0

	--if attacker:HasModifier("modifier_berserk") then stack_bonus = 1 else stack_bonus = 0 end

	target:AddNewModifier(attacker, self:GetAbility(), "modifier_rend", {Duration=duration, stack=1+stack_bonus}) --[[Returns:void
	No Description Set
	]]
end

function modifier_rend_passive:IsHidden()
	return true
end

modifier_rend = class({})

function modifier_rend:OnCreated(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:SetStackCount(stack)
		self:GetParent():RemoveModifierByName("modifier_rend_hp")
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(),
			"modifier_rend_hp",
			{Duration=self:GetDuration(), stack=self:GetStackCount()})
	end
end

function modifier_rend:OnRefresh(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:SetStackCount(self:GetStackCount()+stack)
		self:GetParent():RemoveModifierByName("modifier_rend_hp")
		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(),
			"modifier_rend_hp",
			{Duration=self:GetDuration(), stack=self:GetStackCount()})
	end
end

function modifier_rend:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"
end

function modifier_rend:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOw
end

modifier_rend_hp = class({})

function modifier_rend_hp:OnCreated(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:SetStackCount(stack)
	end
end

function modifier_rend_hp:OnRefresh(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:SetStackCount(stack)
	end
end

function modifier_rend_hp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
	return funcs
end

function modifier_rend_hp:GetModifierHealthBonus()
	local s = self:GetStackCount()

	local t_hp_removal_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_fury_2") or 0

	local a = self:GetAbility():GetSpecialValueFor("max_hp_removal_per_stack") + t_hp_removal_bonus

	print(-(s*a))

	return -(s*a)
end

function modifier_rend_hp:IsHidden()
	return true
end