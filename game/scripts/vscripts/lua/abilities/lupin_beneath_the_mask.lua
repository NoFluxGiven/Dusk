lupin_beneath_the_mask = class({})

LinkLuaModifier("modifier_beneath_the_mask","lua/abilities/lupin_beneath_the_mask",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beneath_the_mask_slow","lua/abilities/lupin_beneath_the_mask",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beneath_the_mask_bonus","lua/abilities/lupin_beneath_the_mask",LUA_MODIFIER_MOTION_NONE)

function lupin_beneath_the_mask:GetIntrinsicModifierName()
	return "modifier_beneath_the_mask"
end

-- function lupin_beneath_the_mask:ApplyDebuff(target)
-- 	if IsServer() then
-- 		local caster = self:GetCaster()
-- 		local target = target

-- 		local damage = self:GetSpecialValueFor("damage")		

-- 		local duration = self:GetSpecialValueFor("duration")

-- 		local t_duration_bonus = FindTalentValue("special_bonus_lupin_6") or 0

-- 		duration = duration + t_duration_bonus

-- 		if not target:IsHero() then return end
-- 		if self:GetAbility():IsCooldownReady() then
-- 			target:AddNewModifier(caster, self, "modifier_beneath_the_mask_slow", {Duration=duration}) --[[Returns:void
-- 			No Description Set
-- 			]]
-- 			self:GetAbility():InflictDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
-- 			CreateParticleHitloc(target,"particles/units/heroes/hero_lupin/beneath_the_mask_hit.vpcf")
-- 			target:EmitSound("Lupin.BeneathTheMask")
-- 		end
-- 	end
-- end

modifier_beneath_the_mask = class({})

function modifier_beneath_the_mask:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_beneath_the_mask:IsHidden()
	return true
end

function modifier_beneath_the_mask:OnAttackLanded(params)
	if IsServer() then
		local caster = self:GetParent()
		local target = params.target

		local damage = self:GetAbility():GetSpecialValueFor("damage")

		local duration = self:GetAbility():GetSpecialValueFor("duration")

		

		--local t_duration_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lupin_6") or 0

		duration = duration --+ t_duration_bonus

		-- if not target:IsHero() or not target:IsCreep() or not target:IsAncient() or not target:IsRoshan() or not target:IsBui then return end

		if target:IsBuilding() then return end

		if not params.attacker:IsRealHero() then return end

		-- if caster:HasModifier("modifier_last_surprise") then return end

		if params.attacker == caster then
			if self:GetAbility():IsCooldownReady() and not caster:PassivesDisabled() then
				target:AddNewModifier(caster, self:GetAbility(), "modifier_beneath_the_mask_slow", {Duration=duration})
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_beneath_the_mask_bonus", {Duration=duration})
				-- if not caster:HasModifier("modifier_calling_card_caster") then
					self:GetAbility():UseResources(true, true, true)
				-- end
				self:GetAbility():InflictDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
				caster:Heal(damage, caster)
				ExecuteOrderFromTable(
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = target:entindex(),
						Queue = true
					}
				)
				CreateParticleHitloc(target,"particles/units/heroes/hero_lupin/beneath_the_mask_hit.vpcf")
				target:EmitSound("Lupin.BeneathTheMask")
			end
		end
	end
end

modifier_beneath_the_mask_slow = class({})

function modifier_beneath_the_mask_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_beneath_the_mask_slow:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_beneath_the_mask_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_beneath_the_mask_slow:GetModifierMoveSpeedBonus_Percentage()
	local t_slow_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lupin_1") or 0
	local val = -(self:GetAbility():GetSpecialValueFor("slow")+t_slow_bonus)

	return val
end
function modifier_beneath_the_mask_slow:GetModifierAttackSpeedBonus_Constant()
	return -( self:GetAbility():GetSpecialValueFor("attack_speed_steal") )
end

function modifier_beneath_the_mask_slow:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

	if self:GetAbility():GetCaster():FindTalentValue("special_bonus_lupin_6") then
		state[MODIFIER_STATE_MUTED] = true
	end
	return state
end

function modifier_beneath_the_mask_slow:IsPurgable()
	return true
end

modifier_beneath_the_mask_bonus = class({})

function modifier_beneath_the_mask_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
	return funcs
end

function modifier_beneath_the_mask_bonus:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true
	}
	return state
end

function modifier_beneath_the_mask_bonus:GetModifierMoveSpeedBonus_Percentage()
	local t_slow_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_lupin_1") or 0
	return (self:GetAbility():GetSpecialValueFor("slow")+t_slow_bonus)
end
function modifier_beneath_the_mask_bonus:GetModifierAttackSpeedBonus_Constant()
	return ( self:GetAbility():GetSpecialValueFor("attack_speed_steal") )
end
function modifier_beneath_the_mask_bonus:GetModifierInvisibilityLevel()
	return 1
end