ouroboros_diffusion = class({})

LinkLuaModifier("modifier_diffusion","lua/abilities/ouroboros_diffusion",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_diffusion_stack","lua/abilities/ouroboros_diffusion",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_diffusion_mult","lua/abilities/ouroboros_diffusion",LUA_MODIFIER_MOTION_NONE)

function ouroboros_diffusion:GetIntrinsicModifierName()
	return "modifier_diffusion"
end

modifier_diffusion = class({})

function modifier_diffusion:ApplyDiffusionStacks(damage)
	if self:GetParent():PassivesDisabled() then return end
	local amt = self:GetAbility():GetSpecialValueFor("per")
	local dmg = damage
	local total = math.floor(dmg)
	local duration = self:GetAbility():GetSpecialValueFor("duration")

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_diffusion_stack", {Duration=duration, stack=total})
	self:SetDuration(duration,true)
end

function modifier_diffusion:DestroyOnExpire()
	return false
end

if IsServer() then

	function modifier_diffusion:OnCreated()
		self:StartIntervalThink(0.1)
	end

	function modifier_diffusion:OnIntervalThink()
		local mod = self:GetParent():FindModifierByName("modifier_diffusion_stack")
		if mod then
			local stack = mod:GetStackCount()
			local amt = self:GetAbility():GetSpecialValueFor("per")
			local total = math.floor( stack/amt )

			self:SetStackCount(total)
		else
			self:SetStackCount(0)
			self:SetDuration(-1,true)
		end

	end

end

function modifier_diffusion:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return func
end

function modifier_diffusion:OnTakeDamage(params)
	local unit = params.unit or params.target

	if unit == self:GetParent() then
		local dtype = params.damage_type

		if dtype == DAMAGE_TYPE_MAGICAL then
			local stack = self:GetStackCount()
			local t_max_stacks_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_ouroboros_2") or 0
			local max = self:GetAbility():GetSpecialValueFor("max_stacks") + t_max_stacks_bonus
			local per = self:GetAbility():GetSpecialValueFor("per")

			local current = stack * per

			local max_damage = (max * per) - current

			local damage = params.damage

			if damage > max_damage then damage = max_damage end

			if damage < 0 then damage = 0 end

			self:ApplyDiffusionStacks(damage)
		end
	end
end

function modifier_diffusion:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

modifier_diffusion_stack = class({})

function modifier_diffusion_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_diffusion_stack:GetModifierMagicalResistanceBonus()
	local amt = self:GetAbility():GetSpecialValueFor("per")
	local bonus = self:GetAbility():GetSpecialValueFor("magic_res")

	return (self:GetStackCount() / amt) * bonus
end

function modifier_diffusion_stack:GetModifierConstantManaRegen()
	local amt = self:GetAbility():GetSpecialValueFor("per")
	local bonus = self:GetAbility():GetSpecialValueFor("mana_regen")

	return (self:GetStackCount() / amt) * bonus
end

function modifier_diffusion_stack:GetModifierConstantHealthRegen()
	local amt = self:GetAbility():GetSpecialValueFor("per")
	local bonus = self:GetAbility():GetSpecialValueFor("health_regen")

	return (self:GetStackCount() / amt) * bonus
end

if IsServer() then

	function modifier_diffusion_stack:OnCreated(kv)
		if kv.stack then
			self:SetStackCount(kv.stack)
		else
			self:IncrementStackCount()
		end
	end

	function modifier_diffusion_stack:OnRefresh(kv)
		if kv.stack then
			self:SetStackCount(self:GetStackCount()+kv.stack)
		else
			self:IncrementStackCount()
		end
	end

end

function modifier_diffusion_stack:IsHidden()
	return true
end