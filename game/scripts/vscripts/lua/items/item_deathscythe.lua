item_deathscythe = class({})

LinkLuaModifier("modifier_deathscythe","lua/items/item_deathscythe",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deathscythe_slow","lua/items/item_deathscythe",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deathscythe_onattack","lua/items/item_deathscythe",LUA_MODIFIER_MOTION_NONE)

function item_deathscythe:GetIntrinsicModifierName()
	return "modifier_deathscythe"
end

modifier_deathscythe = class({})

function modifier_deathscythe:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_deathscythe:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

-- function modifier_deathscythe:GetAlwaysAllowAttack()
-- 	return 1
-- end

function modifier_deathscythe:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_deathscythe:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_deathscythe:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intelligence")
end

function modifier_deathscythe:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_deathscythe:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_deathscythe:IsHidden()
	return true
end

function modifier_deathscythe:OnCreated(kv)
	if IsServer() then
		self:CreateSubModifier("modifier_deathscythe_onattack",{})
	end
end

function modifier_deathscythe:OnDestroy()
	if IsServer() then
		self:DestroySubModifiers()
	end
end

modifier_deathscythe_onattack = class({})

function modifier_deathscythe_onattack:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local defender = kv.unit or kv.target

		local slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")

		if not defender:IsHero() then return end

		if attacker == self:GetParent() then

			if self:GetAbility():IsCooldownReady() then
				local hp = defender:GetMaxHealth()

				local chp = defender:GetHealth()
				
				local pct = self:GetAbility():GetSpecialValueFor("percent_damage") / 100
				local damage = chp * pct
				print("Dealing "..damage.." unreducible damage")
				defender:ModifyHealth(chp - damage, self:GetAbility(), false, 0)

				defender:Purge(true, false, false, false, false)

				defender:AddNewModifier(attacker, self:GetAbility(), "modifier_deathscythe_slow", {Duration=slow_duration})

				CreateParticleHitloc(defender,"particles/items/deathscythe_strike.vpcf")
				attacker:EmitSound("Deathscythe.Attack")

				self:GetAbility():UseResources(true, true, true)

			end
		end
	end
end

function modifier_deathscythe_onattack:IsHidden()
	return true
end

modifier_deathscythe_slow = class({})

function modifier_deathscythe_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_deathscythe_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end