item_soul_vial = class({})

LinkLuaModifier("modifier_soul_vial","lua/items/item_soul_vial",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_vial_empower","lua/items/item_soul_vial",LUA_MODIFIER_MOTION_NONE)

function item_soul_vial:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local empower_time = self:GetSpecialValueFor("duration")
		local mod = caster:FindModifierByName("modifier_soul_vial")

		if mod then
			local stack = mod:GetStackCount()
			caster:AddNewModifier(caster, self, "modifier_soul_vial_empower", {Duration=empower_time,stack=stack})

			mod:SetStackCount(0)
			self:SetCurrentCharges(0)
		end
	end
end

function item_soul_vial:GetIntrinsicModifierName()
	return "modifier_soul_vial"
end

function item_soul_vial:OnUnequip()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_soul_vial")
end

modifier_soul_vial = class({})

function modifier_soul_vial:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_DEATH
	}
	return func
end

function modifier_soul_vial:OnDeath(params)
	if IsServer() then
		local attacker = params.attacker
		local unit = params.unit or params.target

		local charges = 1

		if attacker == self:GetParent() then
			if unit:IsRealHero() then
				charges = 8
			end
			self:AddCharges(charges)
			self:SyncCharges()
		end

		if unit == self:GetParent() then -- if owner dies
			self:AddCharges(0,true)
			self:SyncCharges()
		end
	end
end

function modifier_soul_vial:AddCharges(amt,reset)
	if IsServer() then
		if reset then c_charges,amt = 0,0 end
		local max = self:GetAbility():GetSpecialValueFor("max_charges")
		local c_charges = self:GetAbility():GetCurrentCharges()
		if c_charges+amt < max then
			self:GetAbility():SetCurrentCharges(c_charges+amt)
		else
			self:GetAbility():SetCurrentCharges(max)
		end
	end
end

function modifier_soul_vial:SyncCharges()
	if IsServer() then
		local c_charges = self:GetAbility():GetCurrentCharges()
		self:SetStackCount(c_charges)
	end
end

function modifier_soul_vial:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(0)
		self:SyncCharges()
	end
end

function modifier_soul_vial:IsHidden()
	return true
end

modifier_soul_vial_empower = class({})

function modifier_soul_vial_empower:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_soul_vial_empower:OnRefresh(kv)
	if IsServer() then
		if self:GetStackCount() < kv.stack then
			self:SetStackCount(kv.stack)
		end
	end
end

function modifier_soul_vial_empower:GetEffectName()
	return "particles/items/soul_vial.vpcf"
end

function modifier_soul_vial_empower:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return func
end

function modifier_soul_vial_empower:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_charge") * self:GetStackCount()
end

function modifier_soul_vial_empower:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("restore_per_charge") * self:GetStackCount()
end