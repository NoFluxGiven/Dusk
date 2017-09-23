ironfist_reversal = class({})

LinkLuaModifier("modifier_reversal","lua/abilities/ironfist_reversal",LUA_MODIFIER_MOTION_NONE)

function ironfist_reversal:OnSpellStart()
	local c = self:GetCaster()
	local counter_time = self:GetSpecialValueFor("counter_time")

	c:AddNewModifier(c, self, "modifier_reversal", {Duration=counter_time}) --[[Returns:void
	No Description Set
	]]
end

if IsServer() then
	function ironfist_reversal:OnUpgrade()
		local linkedAbilities = {
			-- "ironfist_reversal",
			"ironfist_typhoon",
			"ironfist_boulder_throw"
		}

		if self.ignoreUpgrade then return end

		for k,v in pairs(linkedAbilities) do
			local ab = self:GetCaster():FindAbilityByName(v)
			local lvl = self:GetLevel()
			if ab then
				ab.ignoreUpgrade = true
				ab:SetLevel(lvl)
				ab.ignoreUpgrade = false
			end
		end
	end
end

modifier_reversal = class({})

function modifier_reversal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

if IsServer() then

	function modifier_reversal:OnCreated(kv)
		ParticleManager:CreateParticle("particles/units/heroes/hero_ironfist/counter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		self:GetParent():EmitSound("Hero_Sven.WarCry")
	end


	function modifier_reversal:OnAttackLanded(params)
		local p = self:GetParent()
		local a = params.attacker

		local u = params.unit or params.target

		if a:IsMagicImmune() then return end

		if a:IsBuilding() then return end

		if u == p then
			local dmg = self:GetAbility():GetSpecialValueFor("damage")/100
			local pdmg = self:GetAbility():GetSpecialValueFor("perfect_damage")/100

			local admg = a:GetAverageTrueAttackDamage(a)

			local bdmg = self:GetAbility():GetSpecialValueFor("base_damage")

			local stun = self:GetAbility():GetSpecialValueFor("stun")
			local pstun = self:GetAbility():GetSpecialValueFor("perfect_stun")
			local part = "particles/units/heroes/hero_ironfist/counter_enemy.vpcf"
			local ppart = "particles/units/heroes/hero_ironfist/counter_enemy_perfect.vpcf"

			local perfect = self:GetAbility():GetSpecialValueFor("perfect_time")

			local perfect_counter = self:GetElapsedTime() <= perfect

			if perfect_counter then
				stun, dmg, part = pstun, pdmg, ppart
			end

			dmg = admg*dmg + bdmg

			a:EmitSound("Hero_Silencer.LastWord.Damage")

			p:EmitSound("Hero_Axe.CounterHelix")

			a:AddNewModifier(p, self:GetAbility(), "modifier_stunned", {Duration=stun}) --[[Returns:void
			No Description Set
			]]
			local remaining = self:GetDuration()-self:GetElapsedTime()
			a:AddNewModifier(p, self:GetAbility(), "modifier_reversal_grace", {Duration=remaining})

			ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, a) --[[Returns:int
			Creates a new particle effect
			]]

			self:GetAbility():InflictDamage(a,p,dmg,DAMAGE_TYPE_MAGICAL)
		end
	end

end

function modifier_reversal:GetModifierIncomingDamage_Percentage()
	local reduction = self:GetAbility():GetSpecialValueFor("reduction")
	local perfect = self:GetAbility():GetSpecialValueFor("perfect_time")

	local perfect_counter = self:GetElapsedTime() < perfect

	if perfect_counter then reduction = reduction*2 end

	return -reduction
end