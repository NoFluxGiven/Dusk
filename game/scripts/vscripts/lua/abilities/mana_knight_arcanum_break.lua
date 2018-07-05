mana_knight_arcanum_break = class({})

LinkLuaModifier("modifier_arcanum_break","lua/abilities/mana_knight_arcanum_break",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcanum_break_hit","lua/abilities/mana_knight_arcanum_break",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcanum_break_spell_damage","lua/abilities/mana_knight_arcanum_break",LUA_MODIFIER_MOTION_NONE)

function mana_knight_arcanum_break:GetIntrinsicModifierName()
	return "modifier_arcanum_break"
end

modifier_arcanum_break = class({})

function modifier_arcanum_break:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return func
end

function modifier_arcanum_break:OnAttackStart(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		if attacker:IsIllusion() then return end

		if attacker == self:GetParent() then
			attacker:RemoveModifierByName("modifier_arcanum_break_hit")

			if not self:GetAbility():IsCooldownReady() then return end
			if target:IsBuilding() then return end

			local r = RandomInt(0, 100)
			local chance = 100 - self:GetAbility():GetSpecialValueFor("chance")

			if r >= chance then
				attacker:EmitSound("Hero_ChaosKnight.ChaosStrike")
				attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_arcanum_break_hit", {})

				ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/arcanum_breaker2.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			end

		end
	end
end

function modifier_arcanum_break:IsHidden()
	return true
end

modifier_arcanum_break_hit = class({})

function modifier_arcanum_break_hit:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_arcanum_break_hit:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_mana_knight_2") or 0

		local damage = self:GetAbility():GetSpecialValueFor("bonus_damage") + t_damage_bonus
		local mana_burn = self:GetAbility():GetSpecialValueFor("mana_burn")
		local duration = self:GetAbility():GetSpecialValueFor("duration")

		if attacker == self:GetParent() then
			ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			target:AddNewModifier(attacker, self:GetAbility(), "modifier_arcanum_break_spell_damage", {Duration=duration})
			self:GetAbility():InflictDamage(target,attacker,damage,DAMAGE_TYPE_MAGICAL)
			target:ReduceMana(mana_burn)

			self:GetAbility():UseResources(true, true, true)
			self:Destroy()
		end
	end
end

function modifier_arcanum_break_hit:IsHidden()
	return true
end

modifier_arcanum_break_spell_damage = class({})

function modifier_arcanum_break_spell_damage:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return func
end

function modifier_arcanum_break_spell_damage:GetModifierSpellAmplify_Percentage()
	return -self:GetAbility():GetSpecialValueFor("spell_damage_reduction")
end