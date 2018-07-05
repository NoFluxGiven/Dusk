bahamut_fulmination = class({})

LinkLuaModifier("modifier_fulmination","lua/abilities/bahamut_fulmination",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fulmination_stack","lua/abilities/bahamut_fulmination",LUA_MODIFIER_MOTION_NONE)

function bahamut_fulmination:GetIntrinsicModifierName()
	return "modifier_fulmination"
end

modifier_fulmination = class({})

function modifier_fulmination:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_fulmination:OnAttackLanded(params)
	if IsServer() then
		if params.attacker ~= self:GetParent() then return end

		local a = self:GetAbility()
		local t = params.target
		local d = a:GetSpecialValueFor("time")

		t:AddNewModifier(self:GetParent(), a, "modifier_fulmination_stack", {Duration=d}) --[[Returns:void
		No Description Set
		]]
	end
end

function modifier_fulmination:IsHidden()
	return true
end

modifier_fulmination_stack = class({})

function modifier_fulmination_stack:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return func
end

function modifier_fulmination_stack:OnCreated(kv)	
	self:SetStackCount(1)
end

function modifier_fulmination_stack:OnRefresh(kv)
	if IsServer() then
		local max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")

		if self:GetStackCount() < 1 then
			self:SetStackCount(1)
		elseif self:GetStackCount() < max_stacks then
			self:IncrementStackCount()
		end
	end
end

function modifier_fulmination_stack:OnDestroy()
	if IsServer() then
		if self:WasPurged() then return end
		local stack = self:GetStackCount()
		if stack > 0 then
			local mult = self:GetAbility():GetSpecialValueFor("increase")
			local base_damage = self:GetAbility():GetSpecialValueFor("damage")
			local m = (mult/100) * stack

			local fdamage = (base_damage * stack) * (1+m)

			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),fdamage,DAMAGE_TYPE_MAGICAL)

			if self:GetParent():IsHero() then self:GetParent():EmitSound("Hero_Oracle.PurifyingFlames.Damage") end
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
			Creates a new particle effect
			]]
			if stack >= 4 then
				ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
				Creates a new particle effect
				]]
			end
			if stack >= 8 then
				ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
				Creates a new particle effect
				]]
			end
		end
	end
end

function modifier_fulmination_stack:GetModifierPhysicalArmorBonus()
	local t_armor_reduction = self:GetAbility():GetCaster():FetchTalent("special_bonus_bahamut_2") or 0
	return -t_armor_reduction * self:GetStackCount()
end

function modifier_fulmination_stack:GetEffectName()
	return "particles/units/heroes/hero_bahamut/bahamut_fulmination_model.vpcf"
end