tek_megaton_induction = class({})

LinkLuaModifier("modifier_megaton_induction","lua/abilities/tek_megaton_induction",LUA_MODIFIER_MOTION_NONE)

function tek_megaton_induction:GetIntrinsicModifierName()
	return "modifier_megaton_induction"
end

modifier_megaton_induction = class({})

function modifier_megaton_induction:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(0)

		self.recorded_attacks = {}

		local interval = self:GetAbility():GetSpecialValueFor("interval")

		self:StartIntervalThink(interval)
	end
end

function modifier_megaton_induction:OnIntervalThink()
	if IsServer() then
		local max = self:GetAbility():GetSpecialValueFor("max_stacks")

		if self:GetStackCount() < max then
			self:IncrementStackCount()
		end
	end
end

function modifier_megaton_induction:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
	return func
end

function modifier_megaton_induction:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		if IsServer() then
			if self:GetStackCount() > 0 then
				if not self.old_projectile then self.old_projectile = self:GetParent():GetRangedProjectileName() end

				self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_tek/megaton_induction.vpcf")
			else
				if self.old_projectile then
					self:GetParent():SetRangedProjectileName(self.old_projectile)
					self.old_projectile = nil
				end
			end
		end
	end
end

function modifier_megaton_induction:OnAttackFinished(params)
	local attacker = params.attacker
	if attacker == self:GetParent() then
		if self:GetStackCount() > 0 then
			table.insert(self.recorded_attacks, params.record)
			self:SetStackCount(self:GetStackCount()-1)
		end
	end
end

function modifier_megaton_induction:GetModifierProcAttack_BonusDamage_Magical(params)
	if IsServer() then
		for k,v in pairs(self.recorded_attacks) do
			if v == params.record then
				table.remove(self.recorded_attacks,k) -- remove this entry
				return self:GetAbility():GetSpecialValueFor("damage")
			end
		end
	end
end

function modifier_megaton_induction:IsHidden()
	if self:GetStackCount() < 1 then
		return true
	end
	return false
end