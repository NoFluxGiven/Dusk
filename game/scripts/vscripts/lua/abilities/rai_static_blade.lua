rai_static_blade = class({})

LinkLuaModifier("modifier_static_blade","lua/abilities/rai_static_blade",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_blade_mute","lua/abilities/rai_static_blade",LUA_MODIFIER_MOTION_NONE)

function rai_static_blade:GetIntrinsicModifierName()
	return "modifier_static_blade"
end

function rai_static_blade:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

---------------------------------------------

modifier_static_blade = class({})

function modifier_static_blade:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_static_blade:OnCreated()
	self.static_blade_damage = 0
end

function modifier_static_blade:OnAbilityFullyCast(params)
	if self:GetParent() == params.unit then
		if params.ability:IsItem() == false then
			if params.ability:IsToggle() == false then
				if (self:GetStackCount() < self:GetSpecialValueFor("max_stacks")) then
					self:GainCharges()
				end
			end
		end
	end
end

	

--[[function modifier_static_blade:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if CheckClass(params.target,"npc_dota_building") then return end
	if self:GetAbility():GetToggleState() == false then return end
	if not self:GetAbility():IsCooldownReady() then return end
	if self:GetStackCount() > 0 then
		local duration = self:GetAbility():GetSpecialValueFor("slow_duration")
		local damage = self:GetAbility():GetSpecialValueFor("damage_per_stack")

		local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())

		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_static_blade_slow", {stacks = self:GetStackCount(), Duration = duration})
		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_static_blade_cooldown", {Duration = cooldown})
		params.target:EmitSound("Hero_razor.lightning")
		self:GetAbility():InflictDamage(params.target,self:GetParent(),damage*self:GetStackCount(),DAMAGE_TYPE_MAGICAL)
		self:SetStackCount(0)
		ParticleManager:CreateParticle("particles/units/heroes/hero_rai/static_blade_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
		self:GetAbility():StartCooldown(cooldown)
	end
end

function modifier_static_blade:OnTakeDamage(params)
	if params.attacker == self:GetParent() then
		if params.damage_type == DAMAGE_TYPE_MAGICAL then
			if self.static_blade_damage then
				self.static_blade_damage = self.static_blade_damage + params.damage
			else
				self.static_blade_damage = params.damage
			end

			local threshold = self:GetAbility():GetSpecialValueFor("threshold")

			if threshold == 0 then threshold = 250	 end

			if self.static_blade_damage >= threshold then
				while self.static_blade_damage >= threshold do
					self.static_blade_damage = self.static_blade_damage - threshold
					self:GainCharges()
				end
				
			end
		end
	end
end

function modifier_static_blade:GainCharges()
	local max = 6
	local bonus = 0
	if self:GetAbility():GetCaster():FetchTalent("special_bonus_rai_1") then bonus = 1 end
	max = max + bonus
	if self:GetStackCount()+1 <= max then
		self:IncrementStackCount()
	end
end

function modifier_static_blade:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

modifier_static_blade_slow = class({})

function modifier_static_blade_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_static_blade_slow:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stacks)
		self:StartIntervalThink(0.25)
	end
end

function modifier_static_blade_slow:OnRefresh(kv)
	if IsServer() then
		if kv.stacks > self:GetStackCount() then
			self:SetStackCount(kv.stacks)
		end
	end
end

function modifier_static_blade_slow:OnIntervalThink()
	if IsServer() then
		local dot_s = self:GetAbility():GetSpecialValueFor("dot_per_stack")*0.25
		local dot = dot_s * self:GetStackCount()
		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),dot,DAMAGE_TYPE_MAGICAL)
	end
end

function modifier_static_blade_slow:GetModifierMoveSpeedBonus_Percentage()
	return -(self:GetStackCount() * self:GetAbility():GetSpecialValueFor("slow_per_stack"))
end

modifier_static_blade_cooldown = class({})

function modifier_static_blade_cooldown:IsHidden()
	return true
end ]]