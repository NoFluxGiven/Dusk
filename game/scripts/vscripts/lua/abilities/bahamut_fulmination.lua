bahamut_fulmination = class({})

LinkLuaModifier("modifier_fulmination","lua/abilities/bahamut_fulmination",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fulmination_debuff","lua/abilities/bahamut_fulmination",LUA_MODIFIER_MOTION_NONE)

-- Description: Grants 4 attacks at a fixed attack rate of 0.6s.
-- Each attack deals bonus damage and applies a stacking debuff that reduces magic resistance.
-- If all 4 attacks hit the same target, the debuff detonates, removing itself, but dealing
-- large Magical damage.


function bahamut_fulmination:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_fulmination", {Duration=duration})
end

modifier_fulmination = class({})

function modifier_fulmination:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE
	}
	return funcs
end

function modifier_fulmination:OnCreated()
	ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_start_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():EmitSound("Bahamut.Fulmination.StartUp")

	self.debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")

	local scepter_bonus = 0
	if self:GetParent():HasScepter() then
		scepter_bonus = self:GetAbility():GetSpecialValueFor("scepter_bonus_stacks")
	end
	self.stack_count = self:GetAbility():GetSpecialValueFor("stack_count") + scepter_bonus
	self:SetStackCount(self.stack_count)
end

function modifier_fulmination:OnIntervalThink()
	if not IsServer() then return end

	if self:GetAbility():IsCooldownReady() then self:SetStackCount(0) end
end

function modifier_fulmination:OnAttackStart(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() then
		self:GetParent():EmitSound("Bahamut.Fulmination.PreAttack")
	end
end

-- function modifier_fulmination:OnAttack(params)
-- 	if params.attacker == self:GetParent() then
-- 		self:GetParent():EmitSound("Bahamut.Fulmination.OnAttack")
-- 	end
-- end

function modifier_fulmination:UseStack()
	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_fulmination:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if params.target:IsMagicImmune() then return end
		if not params.target:IsBuilding() then
			-- params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_fulmination_debuff", {duration=self.debuff_duration})
			params.target:EmitSound("Bahamut.Fulmination")
			params.target:EmitSound("Bahamut.Fulmination.Damage")
		end
		self:UseStack()
	end
	
end

function modifier_fulmination:OnAttackFail(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() then
		self:UseStack()
	end
end

function modifier_fulmination:GetModifierFixedAttackRate(params)
	if params.target then
		if params.target:IsBuilding() then return nil end
		if params.target:IsMagicImmune() then return nil end
	end
	return 0.48
end

function modifier_fulmination:GetModifierOverrideAttackDamage(params)
	if params.target then
		if params.target:IsBuilding() then return nil end
		if params.target:IsMagicImmune() then return nil end
	end
	return 1
end

function modifier_fulmination:GetModifierProjectileSpeedBonus(params)
	if not IsServer() then return end
	local projectile_speed_increase = self:GetAbility():GetSpecialValueFor("projectile_speed_increase")

	if params.unit then
		if params.unit:IsBuilding() then projectile_speed_increase = 0 end
		if params.unit:IsMagicImmune() then projectile_speed_increase = 0 end
	end

	return projectile_speed_increase
end

function modifier_fulmination:GetModifierAttackRangeBonus(params)
	if not IsServer() then return end
	local t_attack_range_bonus = self:GetParent():FindTalentValue("special_bonus_bahamut_2")
	local attack_range_bonus = self:GetAbility():GetSpecialValueFor("attack_range_bonus") + t_attack_range_bonus

	if params.unit then
		if params.unit:IsBuilding() then attack_range_bonus = 0 end
		if params.unit:IsMagicImmune() then attack_range_bonus = 0 end
	end

	return attack_range_bonus
end

function modifier_fulmination:GetModifierProcAttack_BonusDamage_Magical(params)
	if params.target:IsBuilding() then return 0 end
	if params.target:IsMagicImmune() then return 0 end
	local damage_per_attack = self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetParent():GetAverageTrueAttackDamage(params.target)

	return damage_per_attack
end

function modifier_fulmination:GetModifierProjectileName(params)
	-- if params.target:IsMagicImmune() then return nil end
	return "particles/units/heroes/hero_bahamut/fulmination_attack.vpcf"
end

function modifier_fulmination:GetAttackSound()
	return "Bahamut.Fulmination.OnAttack"
end

function modifier_fulmination:GetPriority()
	return 1000
end

---------------------------------------------------------------------------------------------
-- FULMINATION DEBUFF
---------------------------------------------------------------------------------------------

modifier_fulmination_debuff = class({})

function modifier_fulmination_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_fulmination_debuff:OnCreated(kv)
	self.magic_res_reduction = self:GetAbility():GetSpecialValueFor("magic_res_reduction")
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	self.mana_burn_per_second = self:GetAbility():GetSpecialValueFor("mana_burn_per_second")

	-- self:SetStackCount(1)
	
	self:StartIntervalThink(0.5)
end

function modifier_fulmination_debuff:OnRefresh(kv)
	-- self:IncrementStackCount()
end

function modifier_fulmination_debuff:OnIntervalThink()
	if not IsServer() then return end

	-- Particle
	-- Sound

	local mana_burn = min( (self.mana_burn_per_second/100 * self:GetParent():GetMaxMana()), self:GetParent():GetMana() ) * 0.5

	self:GetParent():ReduceMana(mana_burn)
	self:GetAbility():InflictDamage(self:GetParent(), self:GetAbility():GetCaster(), mana_burn, DAMAGE_TYPE_MAGICAL)
end

function modifier_fulmination_debuff:GetModifierMagicalResistanceBonus()
	return -1 * self.magic_res_reduction
end

function modifier_fulmination_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -1 * self.move_slow
end

-- modifier_fulmination_stack = class({})

-- function modifier_fulmination_stack:DeclareFunctions()
-- 	local func = {
-- 		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
-- 	}
-- 	return func
-- end

-- function modifier_fulmination_stack:OnCreated(kv)	
-- 	self:SetStackCount(1)
-- end

-- function modifier_fulmination_stack:OnRefresh(kv)
-- 	if IsServer() then
-- 		local max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")

-- 		if self:GetStackCount() < 1 then
-- 			self:SetStackCount(1)
-- 		elseif self:GetStackCount() < max_stacks then
-- 			self:IncrementStackCount()
-- 		end
-- 	end
-- end

-- function modifier_fulmination_stack:OnDestroy()
-- 	if IsServer() then
-- 		if self:WasPurged() then return end
-- 		local stack = self:GetStackCount()
-- 		if stack > 0 then
-- 			local mult = self:GetAbility():GetSpecialValueFor("increase")
-- 			local base_damage = self:GetAbility():GetSpecialValueFor("damage")
-- 			local m = (mult/100) * stack

-- 			local fdamage = (base_damage * stack) * (1+m)

-- 			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),fdamage,DAMAGE_TYPE_MAGICAL)

-- 			if self:GetParent():IsHero() then self:GetParent():EmitSound("Hero_Oracle.PurifyingFlames.Damage") end
-- 			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
-- 			Creates a new particle effect
-- 			]]
-- 			if stack >= 4 then
-- 				ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
-- 				Creates a new particle effect
-- 				]]
-- 			end
-- 			if stack >= 8 then
-- 				ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
-- 				Creates a new particle effect
-- 				]]
-- 			end
-- 		end
-- 	end
-- end

-- function modifier_fulmination_stack:GetModifierPhysicalArmorBonus()
-- 	local t_armor_reduction = self:GetAbility():GetCaster():FindTalentValue("special_bonus_bahamut_2") or 0
-- 	return -t_armor_reduction * self:GetStackCount()
-- end

-- function modifier_fulmination_stack:GetEffectName()
-- 	return "particles/units/heroes/hero_bahamut/bahamut_fulmination_model.vpcf"
-- end