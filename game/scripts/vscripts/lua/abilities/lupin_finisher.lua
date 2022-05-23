lupin_finisher = class({})

LinkLuaModifier("modifier_finisher_slow","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finisher_bonus_damage_handler","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finisher_bonus_damage_debuff","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finisher_bonus_damage_timer","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finisher_bonus_damage","lua/abilities/lupin_finisher",LUA_MODIFIER_MOTION_NONE)

function lupin_finisher:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Ability.AssassinateLoad")
	return true
end

function lupin_finisher:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local damage_per_attack = self:GetSpecialValueFor("damage_per_attack")
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")

	local attack_limit = self:GetSpecialValueFor("attack_limit")

	local stun = self:GetSpecialValueFor("stun")

	local duration = self:GetSpecialValueFor("slow_duration")

	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_lupin_3") or 0

	duration = duration + t_duration_bonus
	crit_duration = self:GetSpecialValueFor("bonus_slow_duration")

	local particle = "particles/units/heroes/hero_lupin/lupin_finisher_normal.vpcf"
	local sound = "Lupin.Finisher"

	local damage = damage_per_attack

	if (target:HasModifier("modifier_finisher_bonus_damage_debuff")) then
		damage = target:FindModifierByName("modifier_finisher_bonus_damage_debuff"):GetStackCount() * damage_per_attack
	end

	-- if target:IsStunned()
	-- or target:IsSilenced()
	-- or target:IsMuted()
	-- or target:IsRooted()
	-- or target:PassivesDisabled()
	-- or target:IsDisarmed()
	-- then
	if damage > damage_per_attack then

		if damage >= damage_per_attack * ( attack_limit/2 ) then
			particle = "particles/units/heroes/hero_lupin/lupin_finisher_crit.vpcf"
			sound = "Lupin.Finisher.Crit"

			target:AddNewModifier(target, self, "modifier_stunned", {Duration=stun})
		end
		 --[[Returns:void
		-- No Description Set
		-- ]]
		-- ReduceHeroCooldowns(caster, 25, {})
		duration = duration + crit_duration
	-- ends
	end

	caster:AddNewModifier(caster, self, "modifier_finisher_bonus_damage", {damage=damage})
	caster:PerformAttack( target, 
						true,
						true,
						true,
						true,
						false,
						false,
						true )
	caster:RemoveModifierByName("modifier_finisher_bonus_damage")
	target:RemoveModifierByName("modifier_finisher_bonus_damage_debuff")

	CreateParticleHitloc(target,particle)
	target:EmitSound(sound)
	target:EmitSound("Hero_Sniper.AssassinateDamage")

	-- self:InflictDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
	target:AddNewModifier(caster, self, "modifier_finisher_slow", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

function lupin_finisher:GetIntrinsicModifierName()
	return "modifier_finisher_bonus_damage_handler"
end


modifier_finisher_slow = class({})

function modifier_finisher_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_finisher_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_finisher_slow:IsPurgable()
	return true
end

-------------------------------------------------------------

modifier_finisher_bonus_damage = class({})

function modifier_finisher_bonus_damage:OnCreated(kv)
	self.damage = kv.damage
end

function modifier_finisher_bonus_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_finisher_bonus_damage:GetModifierPreAttack_BonusDamage()
	return self.damage
end

-------------------------------------

modifier_finisher_bonus_damage_handler = class({})

function modifier_finisher_bonus_damage_handler:IsHidden() return true end

function modifier_finisher_bonus_damage_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_finisher_bonus_damage_handler:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		local t = params.target or params.unit
		local attack_duration = self:GetAbility():GetSpecialValueFor("attack_duration")

		t:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_finisher_bonus_damage_debuff", {duration=attack_duration, attack_duration=attack_duration, parent=self})
	end
end

modifier_finisher_bonus_damage_debuff = class({})

function modifier_finisher_bonus_damage_debuff:IsRefreshable() return false end

function modifier_finisher_bonus_damage_debuff:OnCreated(kv)
	self.attack_duration = self:GetAbility():GetSpecialValueFor("attack_duration")
	self.attack_limit = self:GetAbility():GetSpecialValueFor("attack_limit")
	self:SetStackCount(1)
	--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_finisher_bonus_damage_timer", {duration=self.attack_duration, parent=self})
end

function modifier_finisher_bonus_damage_debuff:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_finisher_bonus_damage_debuff:OnAttackLanded(params)
	if params.attacker == self:GetAbility():GetOwner() then
		local t = params.target or params.unit

		if self:GetStackCount() < self.attack_limit then
			self:IncrementStackCount()
		end
	end
end