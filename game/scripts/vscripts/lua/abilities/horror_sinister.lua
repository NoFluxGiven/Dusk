horror_sinister = class({})

LinkLuaModifier("modifier_sinister","lua/abilities/horror_sinister",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sinister_crit","lua/abilities/horror_sinister",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sinister_buff","lua/abilities/horror_sinister",LUA_MODIFIER_MOTION_NONE)

function horror_sinister:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_duration_bonus = self:GetCaster():FetchTalent("special_bonus_horror_2") or 0

	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus

	if target:TriggerSpellAbsorb(self) then return end

	target:AddNewModifier(caster, self, "modifier_sinister", {Duration=duration})
	caster:AddNewModifier(caster, self, "modifier_sinister_buff", {Duration=duration})
end

modifier_sinister = class({})

function modifier_sinister:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return func
end

function modifier_sinister:GetEffectName()
	return "particles/units/heroes/hero_horror/sinister.vpcf"
end

function modifier_sinister:OnAttackStart(params)
	if IsServer() then
		local attacker = params.attacker
		local unit = params.unit or params.target

		if attacker == self:GetAbility():GetCaster() then
			attacker:RemoveModifierByName("modifier_sinister_crit")
			if unit == self:GetParent() then
				attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_sinister_crit", {stack=self:GetStackCount()})
			end
		end
	end
end

function modifier_sinister:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local unit = params.unit or params.target

		if attacker == self:GetAbility():GetCaster() then
			if unit == self:GetParent() then
				if self:GetStackCount()	 < self:GetAbility():GetSpecialValueFor("max_stacks") then
					self:IncrementStackCount()
					--Sound
					CreateParticleHitloc(unit,"particles/units/heroes/hero_horror/sinister_attack.vpcf")
				end
			end
		end
	end
end

function modifier_sinister:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster():RemoveModifierByName("modifier_sinister_crit")
	end
end

function modifier_sinister:GetModifierProvidesFOWVision()
	return 1
end

modifier_sinister_crit = class({})

function modifier_sinister_crit:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_sinister_crit:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return func
end

function modifier_sinister_crit:GetModifierPreAttack_CriticalStrike()
	local crit = 100 + ( self:GetAbility():GetSpecialValueFor("crit_bonus") * self:GetStackCount() )

	return crit
end

function modifier_sinister_crit:IsHidden()
	return false
end

modifier_sinister_buff = class({})

function modifier_sinister_buff:OnCreated()
	if IsServer() then
		AddAnimationTranslate(self:GetParent(),"haste")
	end
end

function modifier_sinister_buff:OnDestroy()
	if IsServer() then
		RemoveAnimationTranslate(self:GetParent())
	end
end

function modifier_sinister_buff:CheckState()
	return {[MODIFIER_STATE_FLYING] = true}
end

function modifier_sinister_buff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_sinister_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end