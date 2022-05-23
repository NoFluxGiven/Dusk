lightning_spark = class({})

LinkLuaModifier("modifier_spark","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_buff","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spark_slow","lua/abilities/lightning_spark",LUA_MODIFIER_MOTION_NONE)

function lightning_spark:GetIntrinsicModifierName()
	return "modifier_spark"
end

modifier_spark = class({})

function modifier_spark:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_spark:OnAbilityExecuted(params)
	if IsServer() then
		local p = self:GetParent()
		if self:GetParent():PassivesDisabled() then return end
		if p == params.unit then
			local ability = params.ability
			local cost = params.cost
			local manacost = ability:GetManaCost(ability:GetLevel()) --[[Returns:int
			No Description Set
			]]
			local duration = ability:GetSpecialValueFor("buff_duration")

			if manacost <= 0 then return end

			if ability:IsItem() then return end

			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_spark_buff", {Duration=2}) --[[Returns:void
			No Description Set
			]]
		end
	end
end

function modifier_spark:IsHidden()
	return true
end

modifier_spark_buff = class({})

function modifier_spark_buff:OnCreated()
	--[[if IsServer() then
		self:StartIntervalThink(0.25)
	end]]

	self:GetParent():EmitSound("Lightning.Spark") --[[Returns:void
	 
	]]
end

function modifier_spark_buff:OnIntervalThink()
	--[[local cds = self:GetAbility():GetSpecialValueFor("cooldown_speed")

	local abc = self:GetParent():GetAbilityCount()

	for i=0,abc do
		local a = self:GetParent():GetAbilityByIndex(i)

		if (a) then

			if (not a:IsCooldownReady()) then
				local cd = a:GetCooldownTimeRemaining()

				local adjusted_cd = cd - (0.25 * cds)

				a:EndCooldown()

				a:StartCooldown(adjusted_cd)
			end
		end
	end]]
end

function modifier_spark_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_spark_buff:GetEffectName()
	return "particles/spark_unit.vpcf"
end

function modifier_spark_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_spark_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_spark_buff:IsAura()
	return true
end

function modifier_spark_buff:GetModifierAura()
	return "modifier_spark_slow"
end

function modifier_spark_buff:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
	No Description Set
	]]
end

function modifier_spark_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end

function modifier_spark_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_spark_buff:GetAuraSearchFlags()
	return 0
end

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
	return self:GetAbility():GetSpecialValueFor("slow")+bonus
end

function modifier_spark_slow:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lightning_4") or 0
	return self:GetAbility():GetSpecialValueFor("slow")+bonus
end