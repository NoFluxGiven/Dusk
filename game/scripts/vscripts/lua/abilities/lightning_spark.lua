lightning_spark = class({})

LinkLuaModifier("modifier_spark","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_buff","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_debuff","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_charge","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_slow","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)

function lightning_spark:GetIntrinsicModifierName()
	return "modifier_spark"
end

function lightning_spark:OnSpellStart()
	-- if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_spark_charge")

	if mod == nil then
		self:RefundManaCost()
		return
	end

	local stacks = mod:GetStackCount()
	if stacks == 0 then
		self:RefundManaCost()
		return
	end

	-- self:Spark(stacks)
end
	function lightning_spark:Spark(stacks)
		-- Find units in the radius and damage them based on the number of stacks
		-- Reduce ability cooldowns
		-- Restore Mana
		self:GetCaster():EmitSound("Lightning.Spark")

		if IsServer() then
			local radius = 300 --self:GetSpecialValueFor("radius")
			local damage_per_stack = self:GetSpecialValueFor("damage_per_stack")
			local mana_restore_per_stack = self:GetSpecialValueFor("mana_restore_per_stack")
			local cooldown_reduction_per_stack = self:GetSpecialValueFor("cooldown_reduction_per_stack")

			-- self:GetCaster():GiveMana( stacks * mana_restore_per_stack )
			self:ReduceCooldowns( stacks * cooldown_reduction_per_stack )

			local mod = self:GetCaster():FindModifierByName("modifier_spark_charge")
			if mod then
				mod:Destroy()
			end

			local buff_duration = self:GetSpecialValueFor("buff_duration")

			local b = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_spark_buff", {Duration=buff_duration})
			b:SetStackCount(stacks)

			-- local p = ParticleManager:CreateParticle("particles/units/heroes/hero_lightning/spark_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

			--ParticleManager:SetParticleControl(p, 0, c:GetAbsOrigin())
			-- ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))

			Timers:CreateTimer(0.25,function()
				ParticleManager:DestroyParticle(p,false)
			end)
			
			-- local found = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
			-- 		self:GetCaster():GetCenter(),
			-- 		nil,
			-- 		radius,
			-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,
			-- 		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
			-- 		DOTA_UNIT_TARGET_FLAG_NONE,
			-- 		FIND_CLOSEST,
			-- 		false)

			-- for _,v in pairs(found) do
			-- 	self:InflictDamage(v, self:GetCaster(), stacks * damage_per_stack, DAMAGE_TYPE_MAGICAL)
			-- end
		end
	end

function lightning_spark:ReduceCooldowns(amount)
	local abc = self:GetCaster():GetAbilityCount()

	for i=0,abc do
		local a = self:GetCaster():GetAbilityByIndex(i)
		

		if (a and a ~= self) then
			if (not a:IsCooldownReady()) then
				local cd = a:GetCooldownTimeRemaining()

				local adjusted_cd = cd - (cd * (amount / 100))

				a:EndCooldown()

				a:StartCooldown(adjusted_cd)
			end
		end
	end
end

modifier_spark = class({})

function modifier_spark:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_spark:OnCreated()
	if IsServer() then
		self.damage_total = 0
	end
end

function modifier_spark:Activate(target)
	if target ~= nil then
		print(target)
		local debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")
		local m = target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_spark_debuff", {Duration=debuff_duration})
	end
	
	local charge_duration = self:GetAbility():GetSpecialValueFor("charge_duration")
	local max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")

	local mb = self:GetParent():FindModifierByName("modifier_spark_charge")

	if not mb then
		mb = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_spark_charge", {Duration=charge_duration})
	end

	if ( mb:GetStackCount() + 1 ) <= max_stacks then
		mb:IncrementStackCount()
	end
end

if IsServer() then

	function modifier_spark:OnTakeDamage(params)
		-- if self:GetCaster():HasModifier("modifier_spark_buff") then return end
		if params.attacker ~= self:GetParent() then return end
		if params.damage_type ~= DAMAGE_TYPE_MAGICAL then return end
		
		local damage = params.original_damage
		local threshold = self:GetAbility():GetSpecialValueFor("threshold")
		local threshold_increase = self:GetAbility():GetSpecialValueFor("threshold_increase")
		local mult = 1

		if not params.unit:IsRealHero() then mult = 0.25 end
		if self:GetParent():HasModifier("modifier_spark_buff") then mult = 0.5 end

		local mod = self:GetParent():FindModifierByName("modifier_spark_charge")
		local stacks = 0

		if mod then
			stacks = mod:GetStackCount()
		end

		print(stacks)

		local threshold_total = (threshold + threshold_increase * stacks)

		self.damage_total = self.damage_total + damage * mult

		while self.damage_total >= threshold_total do
			
			print("DAMAGE TOTAL")
			print(self.damage_total)
			
			self:Activate(params.target)
			
			self.damage_total = self.damage_total - threshold_total

			print("THRESHOLD")
			print(threshold_total)

			::continue::
		end
		
	end

end

function modifier_spark:OnAbilityExecuted(params)
	if IsServer() then
		-- local p = self:GetParent()
		-- if self:GetParent():PassivesDisabled() then return end
		-- if p == params.unit then
		-- 	local ability = params.ability
		-- 	local cost = params.cost
		-- 	local buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
		-- 	local cursorpos = params.ability:GetCursorPosition()
			
		-- 	local manacost = ability:GetManaCost(ability:GetLevel()) --[[Returns:int
		-- 	No Description Set
		-- 	]]
		-- 	local duration = ability:GetSpecialValueFor("buff_duration")

		-- 	if manacost <= 0 then return end

		-- 	if ability == self:GetAbility() then return end
			
		-- 	if ability:IsItem() then return end

		-- 	local abilityKV = params.ability:GetAbilityKeyValues()
		-- 	if not string.find(abilityKV['AbilityBehavior'], 'DOTA_ABILITY_BEHAVIOR_POINT')
		-- 	and not string.find(abilityKV['AbilityBehavior'], 'DOTA_ABILITY_BEHAVIOR_UNIT_TARGET') then
		-- 		if cursorpos ~= nil then cursorpos = nil end
		-- 	end

		-- 	self:Activate(cursorpos)
		-- end
	end
end

function modifier_spark:IsHidden()
	if self:GetStackCount() <= 0 then
		return true
	end
	return false
end

modifier_spark_debuff = class({})

function modifier_spark_debuff:IsAura()
	return true
end

function modifier_spark_debuff:GetModifierAura()
	return "modifier_spark_slow"
end

function modifier_spark_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_spark_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_spark_debuff:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_spark_debuff:GetAuraSearchFlags()
	return 0
end

function modifier_spark_debuff:IsHidden()
	return false
end

modifier_spark_charge = class({})

function modifier_spark_charge:OnDestroy()
	self:GetAbility():Spark(self:GetStackCount())
end

modifier_spark_buff = class({})

function modifier_spark_buff:OnCreated(event)
	if IsServer() then
		self:StartIntervalThink(0.25)
	end

	if not IsServer() then
		-- self:GetParent():EmitSound("Lightning.Spark") --[[Returns:void
	 
	-- ]]
	end
	
end

function modifier_spark_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_spark_buff:GetEffectName()
	return "particles/spark_unit.vpcf"
end

function modifier_spark_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movement_speed_per_stack") * self:GetStackCount()
end

function modifier_spark_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed_per_stack") * self:GetStackCount()
end

function modifier_spark_buff:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen_per_stack") * self:GetStackCount()
end

function modifier_spark_buff:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("damage_reduction_per_stack") * self:GetStackCount()
end

-- function modifier_spark_buff:GetModifierPercentageCooldownOngoing()
-- 	print("COOLDOWN REDUCED")
-- 	print(self:GetAbility():GetSpecialValueFor("cooldown_reduction_per_stack") * self:GetStackCount())
-- 	return -self:GetAbility():GetSpecialValueFor("cooldown_reduction_per_stack") * self:GetStackCount() * 2
-- end

function modifier_spark_buff:IsHidden()
	return false
end

modifier_spark_slow = class({})

function modifier_spark_slow:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_spark_slow:OnIntervalThink()
	local damage = self:GetAbility():GetSpecialValueFor("damage") * 0.2
	local damage_type = DAMAGE_TYPE_MAGICAL

	self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,damage_type)
end

function modifier_spark_slow:GetEffectName()
	return "particles/spark_unit_damage.vpcf"
end

function modifier_spark_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_spark_slow:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lightning_4") or 0
	return -(self:GetAbility():GetSpecialValueFor("slow") + bonus)
end

function modifier_spark_slow:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lightning_4") or 0
	return -(self:GetAbility():GetSpecialValueFor("slow") + bonus)
end