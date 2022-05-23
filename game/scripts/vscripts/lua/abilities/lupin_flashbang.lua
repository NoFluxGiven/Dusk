lupin_flashbang = class({})

LinkLuaModifier("modifier_flashbang_dazed","lua/abilities/lupin_flashbang",LUA_MODIFIER_MOTION_NONE)

function lupin_flashbang:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
		base_cooldown = base_cooldown - self:GetSpecialValueFor("scepter_cdr")
	end
	return base_cooldown
end

function lupin_flashbang:OnSpellStart()
	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local stun_duration = self:GetSpecialValueFor("stun")

	if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
		stun_duration = stun_duration + self:GetSpecialValueFor("scepter_stun")
	end

	local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_lupin_2") or 0

	damage = damage+t_damage_bonus

	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_lupin_4") or 0

	duration = duration + t_duration_bonus

	local found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

	local p = CreateParticleHitloc(caster,"particles/units/heroes/hero_lupin/lupin_flashbang.vpcf")
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	caster:EmitSound("Lupin.Flashbang") --[[Returns:void
	 
	]]

	for k,v in pairs(found) do
		v:AddNewModifier(caster, self, "modifier_flashbang_dazed",
		{
			Duration=duration
		})

		StunTarget(caster, self, v, stun_duration)
		self:InflictDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
	end
end

modifier_flashbang_dazed = class({})

function modifier_flashbang_dazed:OnCreated(kv)
	self.cast_range_reduction = self:GetAbility():GetSpecialValueFor("cast_range_reduction")
	self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
	self.attack_range_reduction = self:GetAbility():GetSpecialValueFor("attack_range_reduction")
	self.cast_point_increase = self:GetAbility():GetSpecialValueFor("cast_point_increase")
	self.movespeed_reduction = self:GetAbility():GetSpecialValueFor("movespeed_reduction")
end

function modifier_flashbang_dazed:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		-- MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
	}
	return funcs
end

-- if IsClient() then
	-- function modifier_flashbang_dazed:GetModifierCastRangeBonusStacking() return -self.cast_range_reduction end
	-- function modifier_flashbang_dazed:GetBonusVisionPercentage() return -self.cast_point_increase end
	function modifier_flashbang_dazed:GetModifierPercentageCasttime()  return -self.cast_point_increase end
	function modifier_flashbang_dazed:GetModifierAttackSpeedBonus_Constant() return -self.attack_speed_reduction end
	function modifier_flashbang_dazed:GetModifierMoveSpeedBonus_Percentage() return -self.movespeed_reduction end
	function modifier_flashbang_dazed:GetModifierAttackRangeBonus() 
		if self:GetParent():IsRangedAttacker() then
			print("RANGED!!!")
			return -self.attack_range_reduction
		end
	end
-- end

function modifier_flashbang_dazed:GetEffectName()
	return "particles/units/heroes/hero_lupin/dazed.vpcf"
end

function modifier_flashbang_dazed:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_flashbang_dazed:IsPurgable()
	return true
end

function modifier_flashbang_dazed:IsDebuff()
	return true
end