ironfist_lightning_strike = class({})

LinkLuaModifier("modifier_lightning_strike","lua/abilities/ironfist_lightning_strike",LUA_MODIFIER_MOTION_NONE)

if IsServer() then

	function ironfist_lightning_strike:OnSpellStart()
		local c = self:GetCaster()
		local d = self:GetSpecialValueFor("duration")
		local s = self:GetSpecialValueFor("attacks")

		c:EmitSound("Ironfist.LightningStrike")

		c:AddNewModifier(c,self,"modifier_lightning_strike",{Duration=d, stacks = s})
	end

	function ironfist_lightning_strike:OnUpgrade()
		local linkedAbilities = {
			"ironfist_dragon_fist",
			-- "ironfist_lightning_strike",
			"ironfist_quake"
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

modifier_lightning_strike = class({})

function modifier_lightning_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_lightning_strike:GetEffectName()
	return "particles/units/heroes/hero_ironfist/lightning_strike.vpcf"
end

function modifier_lightning_strike:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

if IsServer() then

	function modifier_lightning_strike:OnCreated(kv)
		local stacks = kv.stacks

		self:SetStackCount(stacks)
	end

	function modifier_lightning_strike:OnAttackLanded(params)
		local p = self:GetParent()
		local a = params.attacker

		if a == p then
			self:SetStackCount(self:GetStackCount()-1)
			if self:GetStackCount() <= 0 then
				self:Destroy()
			end
		end
	end

	function modifier_lightning_strike:GetModifierBaseAttackTimeConstant()
		local bat = self:GetAbility():GetSpecialValueFor("bat")
		return bat
	end

end