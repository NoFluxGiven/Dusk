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
	print("DIFFUSION: "..damage.." damage")
	local amt = self:GetAbility():GetSpecialValueFor("per")
	local dmg = damage
	local total = math.floor(dmg)
	print("STACKS: "..total)
	local duration = self:GetAbility():GetSpecialValueFor("spell_amp_duration")

	if total <= 0 then return end

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
			local total = math.floor(stack * self:GetAbility():GetSpecialValueFor("spell_amp")/100)

			self:SetStackCount(total)
		else
			self:SetStackCount(0)
			self:SetDuration(-1,true)
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
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_diffusion_stack:GetModifierSpellAmplify_Percentage()
	if self:GetParent():PassivesDisabled() then return end
	return self:GetAbility():GetSpecialValueFor("spell_amp") * (self:GetStackCount()/100)
end

function modifier_diffusion_stack:GetModifierProcAttack_BonusDamage_Magical()
end

function modifier_diffusion_stack:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if params.target:IsBuilding() then return end
		if self:GetParent():PassivesDisabled() then return end
		local damage = math.floor(self:GetAbility():GetSpecialValueFor("bonus_magical_damage") * (self:GetStackCount()/100))
		self:GetAbility():InflictDamage(self:GetParent(), params.target, damage, DAMAGE_TYPE_MAGICAL)
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_ouroboros/diffusion_attacks.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(p,0,params.target,PATTACH_POINT_FOLLOW,"attach_hitloc",params.target:GetCenter(),true)
	end
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