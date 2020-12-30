item_crystal_focus = class({})

LinkLuaModifier("modifier_crystal_focus","lua/items/item_crystal_focus",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystal_focus_prismancy","lua/items/item_crystal_focus",LUA_MODIFIER_MOTION_NONE)

function item_crystal_focus:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:EmitSound("CrystalFocus.Prismancy")

	caster:AddNewModifier(caster,self,"modifier_crystal_focus_prismancy",{Duration=duration})
end

function item_crystal_focus:GetIntrinsicModifierName()
	return "modifier_crystal_focus"
end

modifier_crystal_focus = class({})

function modifier_crystal_focus:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
	return func
end

function modifier_crystal_focus:GetModifierCastRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_cast_range")
end

function modifier_crystal_focus:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_total")
end

function modifier_crystal_focus:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_crystal_focus:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
end

function modifier_crystal_focus:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intelligence")
end

function modifier_crystal_focus:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_crystal_focus:IsHidden()
	return true
end

modifier_crystal_focus_prismancy = class({})

function modifier_crystal_focus_prismancy:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return func
end

function modifier_crystal_focus_prismancy:OnAbilityFullyCast(params)
	if IsServer() then
		local p = self:GetParent()
		local c = params.unit

		if p == c then
			local ability = params.ability

			if ability:IsSubability() then return end

			if ability:IsItem() then return end

			local is_ultimate = ability:GetAbilityType() == 1

			if is_ultimate then return end

			if ability:GetManaCost(ability:GetLevel()) <= 0 then return end

			local mana = self:GetParent():GetMana()
			local percent = self:GetAbility():GetSpecialValueFor("mana_percentage") / 100
			local cost = mana * percent

			c:EmitSound("CrystalFocus.Prismancy.Cast")
			
			local cdr = ability:GetCooldownTimeRemaining() - self:GetAbility():GetSpecialValueFor("cdr")
			ability:EndCooldown()

			if cdr > 0 then ability:StartCooldown(cdr) end

			self:GetParent():ReduceMana(cost)

			self:SetStackCount(self:GetStackCount()-1)

			if self:GetStackCount() <= 0 then

				self:Destroy()

			end
		end
	end
end

function modifier_crystal_focus_prismancy:OnCreated(kv)
	if IsServer() then
		local p = ParticleManager:CreateParticle("particles/items/focusing_scepter_prismancy.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

		self:AddParticle( p, false, false, 1, false, false )

		self:SetStackCount(1)
	end
end