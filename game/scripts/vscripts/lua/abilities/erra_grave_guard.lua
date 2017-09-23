erra_grave_guard = class({})

LinkLuaModifier("modifier_grave_guard","lua/abilities/erra_grave_guard",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grave_guard_recovery","lua/abilities/erra_grave_guard",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_grave_guard_aura","lua/abilities/erra_grave_guard",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grave_guard_talent_cooldown","lua/abilities/erra_grave_guard",LUA_MODIFIER_MOTION_NONE)

function erra_grave_guard:GetIntrinsicModifierName()
	local t_aura = self:GetCaster():FetchTalent("special_bonus_erra_5")

	if t_aura then return "modifier_grave_guard_aura" end

	return "modifier_grave_guard"
end

modifier_grave_guard = class({})

function modifier_grave_guard:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

if IsServer() then

	function modifier_grave_guard:OnTakeDamage(params)
		local threshold = self:GetAbility():GetSpecialValueFor("threshold")

		local caster = self:GetParent()

		if params.unit ~= caster then return end

		local hp = caster:GetHealthPercent()

		local duration = self:GetAbility():GetSpecialValueFor("duration")

		if not caster:IsRealHero() then return end

		local t_aura = self:GetCaster():FetchTalent("special_bonus_erra_5")

		local cast_me = self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough()

		local mana_cost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())

		local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel()-1)

		local apply_talent_cooldown = false

		if t_aura and caster ~= self:GetAbility():GetCaster() then
			if caster:HasModifier("modifier_grave_guard_talent_cooldown") then
				cast_me = false
			else
				cast_me = true
			end
			mana_cost = 0
			apply_talent_cooldown = true
		end

		if hp < threshold then

			if cast_me then
				local duration = self:GetAbility():GetSpecialValueFor("duration")

				if mana_cost > 0 then
					caster:SpendMana(mana_cost, self:GetAbility())
				end

				caster:AddNewModifier(caster, self:GetAbility(), "modifier_grave_guard_recovery", {Duration=duration}) --[[Returns:void
				No Description Set
				]]
				caster:EmitSound("Erra.GraveGuard")

				if apply_talent_cooldown then
					caster:AddNewModifier(caster, self:GetAbility(), "modifier_grave_guard_talent_cooldown", {Duration=cooldown})
				else
					self:GetAbility():StartCooldown(cooldown)
				end
			end

		end
	end

end

modifier_grave_guard_aura = class({})

function modifier_grave_guard_aura:IsAura()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			return true
		end
		return false
	end
end

function modifier_grave_guard_aura:GetAuraRadius()
	return self:GetAbility():GetCaster():FetchTalent("special_bonus_erra_5")
end

function modifier_grave_guard_aura:GetAuraSearchFlags()
	return 0
end

function modifier_grave_guard_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_grave_guard_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_grave_guard_aura:GetModifierAura()
	return "modifier_grave_guard"
end

function modifier_grave_guard_aura:IsHidden()
	return true
end

modifier_grave_guard_talent_cooldown = class({})

function modifier_grave_guard_talent_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

modifier_grave_guard_recovery = class({})

function modifier_grave_guard_recovery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_grave_guard_recovery:GetModifierConstantHealthRegen()
	local t_regen_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_erra_3") or 0
	return self:GetAbility():GetSpecialValueFor("hp_recovery") + t_regen_bonus
end

function modifier_grave_guard_recovery:GetModifierConstantManaRegen()
	local t_regen_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_erra_3") or 0
	return self:GetAbility():GetSpecialValueFor("mp_recovery") + t_regen_bonus
end