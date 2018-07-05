aeronaut_skirmish_shot = class({})

function aeronaut_skirmish_shot:OnSpellStart()
	if IsServer() then
		-- force the next attack to be a skirmish shot

		self.force_skirmish_shot = true
		self:GetCaster():MoveToTargetToAttack()

		self:RefundManaCost()
	end
end

function aeronaut_skirmish_shot:GetIntrinsicModifierName()
	return "modifier_skirmish_shot_onattack"
end

modifier_skirmish_shot_onattack = class({})

function modifier_skirmish_shot_onattack:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER
	}
	return func
end

function modifier_skirmish_shot_onattack:OnAttackStart(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target

		if attacker:IsIllusion() then
			return
		end

		if self:GetAbility():GetCaster() == attacker then
			local orb_attack = true

			self.auto_cast = self:GetAbility():GetAutoCastState()

			if self:GetAbility():GetCaster():IsSilenced() then
				orb_attack = false
			end

			if target:IsBuilding() then
				orb_attack = false
			end

			if not self:GetAbility().force_skirmish_shot and not self.auto_cast then
				orb_attack = false
			end

			if self:GetAbility():GetCaster():GetMana() < self:GetAbility():GetManaCost() then
				orb_attack = false
			end

			if orb_attack then
				self.skirmish_shot = true
			end
		end
	end
end