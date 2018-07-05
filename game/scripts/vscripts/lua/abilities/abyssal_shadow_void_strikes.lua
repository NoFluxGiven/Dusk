abyssal_shadow_void_strikes = class({})

LinkLuaModifier("modifier_void_strikes","lua/abilities/abyssal_shadow_void_strikes",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_strikes_burn","lua/abilities/abyssal_shadow_void_strikes",LUA_MODIFIER_MOTION_NONE)

function abyssal_shadow_void_strikes:GetIntrinsicModifierName()
	return "modifier_void_strikes"
end

modifier_void_strikes = class({})

function modifier_void_strikes:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return func
end

-- function modifier_void_strikes:OnAttackStart(params)
-- 	if params.attacker == self:GetParent() then
-- 		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.preAttack")
-- 	end
-- end

function modifier_void_strikes:OnAttackLanded(params)
	if IsServer() then
		if params.attacker ~= self:GetParent() then return end
		if params.target:IsBuilding() then return end

		local duration = self:GetAbility():GetSpecialValueFor("duration")

		params.target:EmitSound("Hero_Terrorblade_Morphed.Attack")
		CreateParticleHitloc(params.target,"particles/units/heroes/hero_gemini/void_strikes_hit.vpcf")

		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_strikes_burn", {Duration=duration})
	end
end

function modifier_void_strikes:IsHidden()
	return true
end

modifier_void_strikes_burn = class({})

function modifier_void_strikes_burn:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return func
end

function modifier_void_strikes_burn:OnCreated()
	if IsServer() then
		local bonus_dmg = self:GetAbility():GetSpecialValueFor("damage")
		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),bonus_dmg,DAMAGE_TYPE_MAGICAL)

		self:SetStackCount(1)
	end
end

function modifier_void_strikes_burn:OnRefresh()
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
			self:SetStackCount(self:GetStackCount()+1)
		end

		local bonus_dmg = self:GetAbility():GetSpecialValueFor("damage") * self:GetStackCount()
		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),bonus_dmg,DAMAGE_TYPE_MAGICAL)
	end
end

function modifier_void_strikes:GetModifierAttackRangeBonus()
	local bonus = self:GetParent():GetOwner():FetchTalent("special_bonus_gemini_4") or 0
	return bonus
end

function modifier_void_strikes_burn:GetModifierPhysicalArmorBonus()
	if IsValidEntity(self:GetAbility()) then
		return -self:GetAbility():GetSpecialValueFor("phys_armor") * self:GetStackCount()
	end
end

function modifier_void_strikes_burn:GetModifierMagicalResistanceBonus()
	if IsValidEntity(self:GetAbility()) then
		return -self:GetAbility():GetSpecialValueFor("magic_res") * self:GetStackCount()
	end
end