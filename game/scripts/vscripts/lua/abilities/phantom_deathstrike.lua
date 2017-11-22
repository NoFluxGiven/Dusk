phantom_deathstrike = class({})

LinkLuaModifier("modifier_deathstrike","lua/abilities/phantom_deathstrike",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deathstrike_hit","lua/abilities/phantom_deathstrike",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deathstrike_debuff","lua/abilities/phantom_deathstrike",LUA_MODIFIER_MOTION_NONE)

function phantom_deathstrike:GetIntrinsicModifierName()
	return "modifier_deathstrike"
end

modifier_deathstrike = class({
	AllowIllusionDuplicate = function(self) return false end,
	IsHidden = function(self) return true end
})

function modifier_deathstrike:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return func
end

function modifier_deathstrike:OnAttackStart(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		if attacker == self:GetParent() then
			attacker:RemoveModifierByName("modifier_deathstrike_hit")

			if not attacker:IsRealHero() then return end

			if not target:IsHero() or not target:IsCreep() then return end

			if not self:GetAbility():IsCooldownReady() then return end

			local r = RandomInt(0, 100)
			local chance = 100 - self:GetAbility():GetSpecialValueFor("chance")

			if r >= chance then
				-- attacker:EmitSound("Hero_ChaosKnight.ChaosStrike")
				attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_deathstrike_hit", {})

				-- ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/deathstrikee.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
			end

		end
	end
end

modifier_deathstrike_hit = class({
	IsHidden = function(self) return true end
})

function modifier_deathstrike_hit:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_deathstrike_hit:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		if attacker == self:GetParent() then
			local hp = target:GetHealth()
			local mhp = target:GetMaxHealth()

			local diff = mhp - hp

			local pct = self:GetAbility():GetSpecialValueFor("bonus_damage") / 100

			local damage = pct * diff

			local duration = self:GetAbility():GetSpecialValueFor("duration")

			if diff > 0 then
				self:GetAbility():InflictDamage(target,attacker,damage,DAMAGE_TYPE_PHYSICAL)
				target:AddNewModifier(attacker, self:GetAbility(), "modifier_deathstrike_debuff", {Duration=duration})
				CreateParticleHitloc(target,"particles/units/heroes/hero_phantom/phantom_crit.vpcf")
				target:EmitSound("Phantom.DeathstrikeCrit")
			end
		end
	end
end

modifier_deathstrike_debuff = class({})

function modifier_deathstrike_debuff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return func
end

function modifier_deathstrike_debuff:GetModifierDamageOutgoing_Percentage()
	local t_reduction_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_phantom_3") or 0
	return -self:GetAbility():GetSpecialValueFor("damage_reduction") + t_reduction_bonus
end