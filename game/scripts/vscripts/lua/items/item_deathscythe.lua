item_deathscythe = class({})

LinkLuaModifier("modifier_deathscythe","lua/items/item_deathscythe",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deathscythe_stat_reduction","lua/items/item_deathscythe",LUA_MODIFIER_MOTION_NONE)
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
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK,
	}
	return func
end

-- function modifier_deathscythe:GetAlwaysAllowAttack()
-- 	return 1
-- end

function modifier_deathscythe:GetModifierProcAttack_BonusDamage_Physical(keys)

	local mdmg = self:GetAbility():GetSpecialValueFor("mana_damage")
	local illu_mult = self:GetAbility():GetSpecialValueFor("illusion_mana_damage") / 100
	local imdmg = mdmg * illu_mult

	if keys.target:GetMaxMana() <= 0 then return 0 end

	local dmg = self:GetParent():IsRealHero() and mdmg or imdmg

	-- Apply mana burn particle effect
	local particle_manaburn_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)

	dmg = math.min(keys.target:GetMana(), dmg)

	keys.target:ReduceMana( dmg )

	return dmg
end

function modifier_deathscythe:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_deathscythe:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_deathscythe:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_deathscythe:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_deathscythe:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_deathscythe:GetModifierProjectileSpeedBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_proj_speed")
end

function modifier_deathscythe:IsHidden()
	return true
end

function modifier_deathscythe:OnCreated(kv)
	if IsServer() then
		self:CreateSubModifier("modifier_deathscythe_onattack",{Duration=-1})
	end
end

function modifier_deathscythe:OnDestroy()
	if IsServer() then
		self:DestroySubModifiers()
	end
end

modifier_deathscythe_onattack = class({})

function modifier_deathscythe_onattack:DeclareFunctions()
	local func = {
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return func
end

function modifier_deathscythe_onattack:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local defender = kv.unit or kv.target

		local duration = self:GetAbility():GetSpecialValueFor("duration")
		-- local mana_damage = self:GetAbility():GetSpecialValueFor("mana_damage")
		-- local illusion_mana_damage = self:GetAbility():GetSpecialValueFor("illusion_mana_damage")

		-- -- if not attacker:IsRealHero() then
		-- -- 	mana_damage = mana_damage * (illusion_mana_damage / 100)
		-- -- end

		-- -- -- if not defender:IsHero() then return end

		-- -- mana_damage = math.min( defender:GetMana(), mana_damage )

		-- -- self:GetAbility():InflictDamage(defender, attacker, mana_damage, DAMAGE_TYPE_MAGICAL, 0)
		-- -- defender:ReduceMana(mana_damage)

		if not attacker:IsRealHero() then return end
		if defender:IsMagicImmune() then return end
		if defender:IsBuilding() then return end


		if attacker == self:GetParent() then

			if self:GetAbility():IsCooldownReady() then
				local hp = defender:GetMaxHealth()

				local chp = defender:GetMana()
				
				local pct = self:GetAbility():GetSpecialValueFor("mana_steal") / 100
				local damage = chp * pct

				defender:ReduceMana(damage)
				self:GetAbility():InflictDamage(defender, attacker, damage, DAMAGE_TYPE_MAGICAL, 0)
				-- DealDamage(target,caster,self.dot,DAMAGE_TYPE_MAGICAL,self:GetAbility())

				defender:Purge(true, false, false, false, false)

				defender:AddNewModifier(attacker, self:GetAbility(), "modifier_deathscythe_stat_reduction", {Duration=duration})

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

modifier_deathscythe_stat_reduction = class({})

function modifier_deathscythe_stat_reduction:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_deathscythe_stat_reduction:OnCreated()
	if IsServer() then
		self.dot = self:GetAbility():GetCaster():GetIntellect() * (self:GetAbility():GetSpecialValueFor("damage_over_time"))
		print(self.dot)
	end
	self:StartIntervalThink(1.0)
end

function modifier_deathscythe_stat_reduction:OnIntervalThink()
	if IsServer() then
		print(self.dot)
		self:GetAbility():InflictDamage(self:GetParent(), self:GetAbility():GetCaster(), self.dot, DAMAGE_TYPE_MAGICAL, 0 )
	end
end

function modifier_deathscythe_stat_reduction:GetModifierBonusStats_Intellect()
	return -self:GetAbility():GetSpecialValueFor("stat_reduction")
end

function modifier_deathscythe_stat_reduction:GetModifierBonusStats_Strength()
	return -self:GetAbility():GetSpecialValueFor("stat_reduction")
end

function modifier_deathscythe_stat_reduction:GetModifierBonusStats_Agility()
	return -self:GetAbility():GetSpecialValueFor("stat_reduction")
end

function modifier_deathscythe_stat_reduction:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end