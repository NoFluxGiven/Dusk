neith_inspire = class({})

LinkLuaModifier("modifier_inspire","lua/abilities/neith_inspire",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_inspire_buff","lua/abilities/neith_inspire",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_inspire_buff_display","lua/abilities/neith_inspire",LUA_MODIFIER_MOTION_NONE)

function neith_inspire:GetIntrinsicModifierName()
	return "modifier_inspire"
end

modifier_inspire = class({})

function modifier_inspire:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_inspire:OnAbilityExecuted(params)
	if IsServer() then
		local p = self:GetParent()
		if self:GetParent():PassivesDisabled() then return end
		if p == params.unit then
			local ability = params.ability
			local manacost = ability:GetManaCost(ability:GetLevel()) --[[Returns:int
			No Description Set
			]]

			if manacost <= 0 then return end

			if ability:IsItem() then return end

			local radius = self:GetAbility():GetSpecialValueFor("radius")
			local damage = self:GetAbility():GetSpecialValueFor("attack_damage")
			local damage_creep = self:GetAbility():GetSpecialValueFor("attack_damage_creep")
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			local bonus = p:FindTalentValue("special_bonus_neith_1") or 0

			duration = duration+bonus

			local ent = FindEntities(p,p:GetAbsOrigin(),radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY)

			for k,v in pairs(ent) do
				local stacks
				if not v:IsHero() then
					stacks = damage_creep
				else
					stacks = damage
				end
				v:AddNewModifier(p, self:GetAbility(), "modifier_inspire_buff", {Duration=duration, stacks=stacks}) --[[Returns:void
				No Description Set
				]]
				v:AddNewModifier(p, self:GetAbility(), "modifier_inspire_buff_display", {Duration=duration, stacks=1})
			end
		end
	end
end

function modifier_inspire:IsHidden()
	return true
end

modifier_inspire_buff = class({})

function modifier_inspire_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_inspire_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_inspire_buff:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stacks)
	end
end

function modifier_inspire_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end


function modifier_inspire_buff:OnDestroy()
	if IsServer() then
		local mod = self:GetParent():FindModifierByName("modifier_inspire_buff_display")
		if mod then
			mod:SetStackCount(mod:GetStackCount()-1)
		end
	end
end

function modifier_inspire_buff:IsHidden()
	return true
end

modifier_inspire_buff_display = class({})

function modifier_inspire_buff_display:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stacks)
	end
end

function modifier_inspire_buff_display:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+kv.stacks)
	end
end