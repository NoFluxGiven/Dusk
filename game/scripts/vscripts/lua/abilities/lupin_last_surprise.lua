lupin_last_surprise = class({})

LinkLuaModifier("modifier_last_surprise","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_surprise_movespeed_boost","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)

-- name: Last Surprise
-- desc: Lupin teleports immediately to a nearby location, gaining status resistance and reducing the cooldown of his on-cooldown abilities.

function lupin_last_surprise:OnSpellStart()
	-- if IsServer() then
		local caster = self:GetCaster()
		local pos = self:GetCursorPosition()
		local duration = self:GetSpecialValueFor("duration")
		-- local status_res = self:GetSpecialValueFor("status_res")
		local movespeed = self:GetSpecialValueFor("movespeed")
		local cdr = self:GetSpecialValueFor("cooldown_reduction")

		-- local p = CreateParticleHitloc(self:GetCaster(), "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf")
		-- CreateParticleWorld(self:GetCaster():GetAbsOrigin(), "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf")

		local p = CreateParticleHitloc(self:GetCaster(), "particles/units/heroes/hero_lupin/ephemera.vpcf")
		CreateParticleWorld(self:GetCaster():GetAbsOrigin(), "particles/units/heroes/hero_lupin/ephemera.vpcf")
		--CreateParticleWo

		---@todo particles
		FindClearSpaceForUnit(caster, pos, true)
		ProjectileManager:ProjectileDodge(caster)

		caster:AddNewModifier(caster, self, "modifier_last_surprise", {duration=duration, cdr=cdr, movespeed=movespeed})
		---ReduceHeroCooldowns( caster, cdr, {self} )
	-- end
end

modifier_last_surprise = class({})

-- function modifier_last_surprise:IsHidden() return true end

function modifier_last_surprise:OnCreated(kv)
	-- self.status_res = kv.status_res
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
	self.purge_interval = self:GetAbility():GetSpecialValueFor("purge_interval") or 1.0
	self:StartIntervalThink(self.purge_interval)

	self:PurgeSelf()

end

function modifier_last_surprise:PurgeSelf()
	if IsServer() then
		local p = CreateParticleHitloc(self:GetCaster(), "particles/units/heroes/hero_lupin/last_surprise.vpcf")
		local p = CreateParticleWorld(self:GetCaster():GetAbsOrigin(), "particles/units/heroes/hero_lupin/ephemera.vpcf")
		-- local pct = self.health_recovery
		-- pct = 4 / 100
		-- if self.attacked_target then
			-- local amt = self.attacked_target:GetMaxHealth()*pct
			-- local amt = self:GetParent():GetMaxHealth()*pct
			-- self:GetParent():Heal(amt, self:GetAbility():GetCaster())
			-- self:GetAbility():InflictDamage(self.attacked_target, amt, DAMAGE_TYPE_MAGICAL, 0)
		-- end
		-- ParticleManager:SetParticleControl(p, 1, self:GetCaster():GetAbsOrigin())
		self:GetCaster():Purge(false, true, false, true, false)
		-- ReduceHeroCooldowns( self:GetCaster(), self.cooldown_reduction, {self:GetAbility()})
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_last_surprise_movespeed_boost", {Duration=self.purge_interval})
	end
end

function modifier_last_surprise:OnIntervalThink()
	---@todo particle
	---@todo sound
	self:PurgeSelf()
end

function modifier_last_surprise:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_FINISHED
	}
	return funcs
end

function modifier_last_surprise:OnAbilityFullyCast(e)
	if e.caster == self:GetParent() then
		self:Destroy()
	end
end

function modifier_last_surprise:OnAttackFinished(e)
	if e.attacker == self:GetParent() then
		self:Destroy()
	end
end

function modifier_last_surprise:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_last_surprise:GetModifierInvisibilityLevel()
	return 1
end

function modifier_last_surprise:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
	}
	return state
end

-- function modifier_last_surprise:GetEffectName()
-- 	return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf"
-- end

-- function modifier_last_surprise:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

modifier_last_surprise_movespeed_boost = class({})

function modifier_last_surprise_movespeed_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
	return funcs
end

function modifier_last_surprise_movespeed_boost:OnCreated()
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_last_surprise_movespeed_boost:GetModifierMoveSpeed_Absolute()
	return 900 * math.max(self:GetRemainingTime() / self:GetDuration(),0.6)
end

function modifier_last_surprise_movespeed_boost:GetModifierEvasion_Constant()
	return 100
end

-- function modifier_last_surprise:GetModifierPercentageCooldown()


-- 	return self.cdr
-- end