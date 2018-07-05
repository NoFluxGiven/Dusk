faust_forbidden_knowledge = class({})

LinkLuaModifier("modifier_forbidden_knowledge","lua/abilities/faust_forbidden_knowledge",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forbidden_knowledge_cooldown","lua/abilities/faust_forbidden_knowledge",LUA_MODIFIER_MOTION_NONE)

function faust_forbidden_knowledge:OnUpgrade()
	local caster = self:GetCaster()
	local ab1 = caster:FindAbilityByName("faust_planecracker")
	--local ab2 = caster:FindAbilityByName("faust_photonic_barrier")

	ab1:SetLevel(self:GetLevel())
	--ab2:SetLevel(self:GetLevel())
end

function faust_forbidden_knowledge:GetIntrinsicModifierName()
	return "modifier_forbidden_knowledge"
end

modifier_forbidden_knowledge = class({})

function modifier_forbidden_knowledge:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end

function modifier_forbidden_knowledge:OnAbilityFullyCast(params)

	local ability = params.ability
	local mana_cost = ability:GetManaCost(-1)
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local is_item = ability:IsItem()

	print("CHECK 1 ".. params.unit:GetName() .. " " .. self:GetParent():GetName() )

	if params.unit ~= self:GetParent() then return end

	print("CHECK 2")

	if is_item then return end

	print("CHECK 3")

	if mana_cost <= 0 then return end

	print("CHECK 4")

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_forbidden_knowledge_cooldown", {Duration=duration, stack=1}) 

end

modifier_forbidden_knowledge_cooldown = class({})

function modifier_forbidden_knowledge_cooldown:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING
	}
	return func
end

function modifier_forbidden_knowledge_cooldown:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_forbidden_knowledge_cooldown:OnRefresh(kv)
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
			self:SetStackCount(self:GetStackCount()+kv.stack)
		end
	end
end

function modifier_forbidden_knowledge_cooldown:GetModifierPercentageCooldownStacking()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("cooldown_reduction")
end