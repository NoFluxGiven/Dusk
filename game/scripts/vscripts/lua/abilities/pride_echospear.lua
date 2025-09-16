pride_echospear = class({})

LinkLuaModifier("modifier_echospear","lua/abilities/pride_echospear",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_echospear_target","lua/abilities/pride_echospear",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_echospear_target_cooldown","lua/abilities/pride_echospear",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_echospear_damage_reduction","lua/abilities/pride_echospear",LUA_MODIFIER_MOTION_NONE)

function pride_echospear:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():RemoveModifierByName("modifier_echospear_damage_reduction")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_echospear", {
		Duration=duration
	})
end

modifier_echospear = class({})

function modifier_echospear:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_echospear:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target or params.unit

	if attacker ~= self:GetParent() then return end

	if attacker:HasModifier("modifier_echospear_damage_reduction") then return end

	local duration = self:GetAbility():GetSpecialValueFor("debuff_duration")

	target:AddNewModifier(attacker, self:GetAbility(), "modifier_echospear_target", {
		Duration=duration
	})

	target:AddNewModifier(attacker, self:GetAbility(), "modifier_echospear_target_cooldown", {
		Duration=1.5
	})
end

modifier_echospear_target = class({})

function modifier_echospear_target:OnCreated(kv)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
end

function modifier_echospear_target:OnRefresh(kv)
	local max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self:IncrementStackCount()

	if self:GetStackCount() > max_stacks then
		self:SetStackCount( max_stacks )
	end
end

function modifier_echospear_target:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_echospear_target_cooldown") then return end
	
	local mod = self:GetAbility():GetCaster():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_echospear_damage_reduction", {})
	self:GetAbility():GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)
	-- particle
	local p = CreateParticleHitloc( self:GetAbility():GetCaster(), "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf" )
	self:GetAbility():GetCaster():RemoveModifierByName("modifier_echospear_damage_reduction")
	ParticleManager:SetParticleControl(p, 2, Vector(1,1,1))
	ParticleManager:SetParticleControlEnt(p,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetCenter(),true)
	if self:GetStackCount() == 0 then
		self:Destroy()
		return
	end

	self:DecrementStackCount()
end

modifier_echospear_damage_reduction = class({})

function modifier_echospear_damage_reduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_echospear_damage_reduction:GetModifierBaseDamageOutgoing_Percentage(event)
	return - (100 - self:GetAbility():GetSpecialValueFor("base_damage"))
end

modifier_echospear_target_cooldown = class({})