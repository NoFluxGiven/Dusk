siegfried_hell_bent = class({})

LinkLuaModifier("modifier_hell_bent","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hell_bent_steal","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hell_bent_display","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hell_bent_buff","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hell_bent_buff_display","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)

function siegfried_hell_bent:GetIntrinsicModifierName()
	return "modifier_hell_bent"
end

modifier_hell_bent = class({})

function modifier_hell_bent:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_hell_bent:OnAttackLanded(params)
	if IsServer() then
		if params.attacker ~= self:GetParent() then return end
		local duration = self:GetAbility():GetSpecialValueFor("duration") --[[Returns:table
		No Description Set
		]]
		local target = params.target or params.unit
		if not target:IsHero() then ToolsPrint("Not a Hero.") return end
		target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_hell_bent_steal", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_hell_bent_display", {Duration=duration, stacks = 1}) --[[Returns:void
		No Description Set
		]]
		self:GetAbility():GetCaster():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_hell_bent_buff", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		self:GetAbility():GetCaster():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_hell_bent_buff_display", {Duration=duration, stacks = 1}) --[[Returns:void
		No Description Set
		]]
	end
end

function modifier_hell_bent:IsHidden()
	return true
end

modifier_hell_bent_display = class({})

function modifier_hell_bent_display:OnCreated(kv)
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		end
	end
end

function modifier_hell_bent_display:OnRefresh(kv)
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(self:GetStackCount()+kv.stacks)
		end
	end
end

modifier_hell_bent_steal = class({})

function modifier_hell_bent_steal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_hell_bent_steal:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_hell_bent_steal:GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_hell_bent_steal:OnDestroy()
	if IsServer() then
		local mod = self:GetParent():FindModifierByName("modifier_hell_bent_display")
		if mod then
			mod:SetStackCount(mod:GetStackCount()-1)
			if mod:GetStackCount() <= 0 then mod:Destroy() end
		end
	end
end

function modifier_hell_bent_steal:IsHidden()
	return true
end

modifier_hell_bent_buff = class({})

function modifier_hell_bent_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_hell_bent_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_hell_bent_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_hell_bent_buff:OnDestroy()
	if IsServer() then
		local mod = self:GetParent():FindModifierByName("modifier_hell_bent_buff_display")
		if mod then
			mod:SetStackCount(mod:GetStackCount()-1)
			if mod:GetStackCount() <= 0 then mod:Destroy() end
		end
	end
end

function modifier_hell_bent_buff:IsHidden()
	return true
end

modifier_hell_bent_buff_display = class({})

function modifier_hell_bent_buff_display:OnCreated(kv)
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		end
	end
end

function modifier_hell_bent_buff_display:OnRefresh(kv)
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(self:GetStackCount()+kv.stacks)
		end
	end
end