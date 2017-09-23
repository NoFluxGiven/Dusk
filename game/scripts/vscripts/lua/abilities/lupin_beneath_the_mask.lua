lupin_beneath_the_mask = class({})

LinkLuaModifier("modifier_beneath_the_mask","lua/abilities/lupin_beneath_the_mask",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beneath_the_mask_slow","lua/abilities/lupin_beneath_the_mask",LUA_MODIFIER_MOTION_NONE)

function lupin_beneath_the_mask:GetIntrinsicModifierName()
	return "modifier_beneath_the_mask"
end

-- function lupin_beneath_the_mask:ApplyDebuff(target)
-- 	if IsServer() then
-- 		local caster = self:GetCaster()
-- 		local target = target

-- 		local damage = self:GetSpecialValueFor("damage")		

-- 		local duration = self:GetSpecialValueFor("duration")

-- 		local t_duration_bonus = FetchTalent("special_bonus_lupin_6") or 0

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

		local t_duration_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_lupin_6") or 0

		duration = duration + t_duration_bonus

		if not target:IsHero() then return end

		if not params.attacker:IsRealHero() then return end

		if params.attacker == caster then
			if self:GetAbility():IsCooldownReady() then
				target:AddNewModifier(caster, self:GetAbility(), "modifier_beneath_the_mask_slow", {Duration=duration}) --[[Returns:void
				No Description Set
				]]
				if not caster:HasModifier("modifier_last_surprise") then
					self:GetAbility():UseResources(true, true, true) --[[Returns:void
					No Description Set
					]]
				else
					damage = damage * 0.5
				end
				self:GetAbility():InflictDamage(target,caster,damage,DAMAGE_TYPE_PHYSICAL)
				CreateParticleHitloc(target,"particles/units/heroes/hero_lupin/beneath_the_mask_hit.vpcf")
				target:EmitSound("Lupin.BeneathTheMask")
			end
		end
	end
end

modifier_beneath_the_mask_slow = class({})

function modifier_beneath_the_mask_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
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
	local t_slow_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_lupin_1") or 0
	return -(self:GetAbility():GetSpecialValueFor("slow")+t_slow_bonus)
end

function modifier_beneath_the_mask_slow:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}
	return state
end

function modifier_beneath_the_mask_slow:IsPurgable()
	return true
end