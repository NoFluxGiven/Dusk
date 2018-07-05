fury_bloodsport = class({})

LinkLuaModifier("modifier_bloodsport_passive","lua/abilities/fury_bloodsport",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodsport","lua/abilities/fury_bloodsport",LUA_MODIFIER_MOTION_NONE)

function fury_bloodsport:GetIntrinsicModifierName()
	return "modifier_bloodsport_passive"
end

modifier_bloodsport_passive = class({})

function modifier_bloodsport_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

-- ONATTACK
function modifier_bloodsport_passive:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target

	local duration = self:GetAbility():GetSpecialValueFor("bleed_duration")

	if attacker ~= self:GetParent() then return end
	if target:IsBuilding() then return end
	if attacker:IsIllusion() then return end
	if attacker:PassivesDisabled() then return end

	local stack_bonus = 0

	--if attacker:HasModifier("modifier_berserk") then stack_bonus = 1 else stack_bonus = 0 end

	target:AddNewModifier(attacker, self:GetAbility(), "modifier_bloodsport", {Duration=duration, stack=1+stack_bonus}) --[[Returns:void
	No Description Set
	]]
end

function modifier_bloodsport_passive:IsHidden()
	return true
end

modifier_bloodsport = class({})

function modifier_bloodsport:OnCreated(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:StartIntervalThink(1.0)
		self:SetStackCount(stack)
	end
end

function modifier_bloodsport:OnRefresh(kv)
	if IsServer() then
		local stack = kv.stack or 1
		self:SetStackCount(self:GetStackCount()+stack)
	end
end

function modifier_bloodsport:OnIntervalThink()
	local t = self:GetParent()
	local damage = self:GetAbility():GetSpecialValueFor("bleed") * self:GetStackCount()

	self:GetAbility():InflictDamage(t,self:GetAbility():GetCaster(), damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)
end

function modifier_bloodsport:IsPurgable()
	return true
end

function modifier_bloodsport:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end