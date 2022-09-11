mifune_zanmato = class({})

-- LinkLuaModifier("modifier_zanmato_target","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_main_target","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_zanmato_target_hero","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_caster","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_permanent_agility","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_zanmato_dummy","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)

function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function mifune_zanmato:OnSpellStart()
	-- sound

	local caster = self:GetCaster()

	local target = self:GetCursorTarget()

	-- local p = ParticleManager:CreateParticle(HeroParticle("mifune", "bushido_counter_attack_flash"), PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(p, 0, target:GetCenter())

	-- CreateParticleHitloc( target, HeroParticle("mifune", "bushido_counter_attack_flash") )

	local threshold = self:GetSpecialValueFor("threshold")
	local delay = self:GetSpecialValueFor("delay")

	local start_pos = caster:GetAbsOrigin()+Vector(0,0,75)
	local end_pos = target:GetAbsOrigin() + caster:GetForwardVector() * 275

	local caster_time = 0.36

	local base_percent_damage = (self:GetSpecialValueFor("base_percent_damage") / 100) * target:GetHealth()

	local slash = "slash_weak"

	local sound = "Mifune.Zanmato.Failure"

	if ( target:GetHealthPercent() < threshold ) then
		target:AddNewModifier(caster, self, "modifier_zanmato_main_target", {duration=delay})
		caster:AddActivityModifier("mask_lord")
		caster:StartGestureWithPlaybackRate(ACT_DOTA_SPAWN, 0.85)
		caster:AddNewModifier(caster, self, "modifier_zanmato_caster", {duration=delay+caster_time})
		caster:Purge(false, true, false, true, false)
		Timers:CreateTimer(delay+caster_time, function()
			caster:FadeGesture(ACT_DOTA_SPAWN)
			caster:ClearActivityModifiers()
		end)
		slash = "slash_2"
		sound = "Mifune.Zanmato.Success"
	end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_mifune/zanmato_" .. slash .. ".vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p, 0, start_pos)
		ParticleManager:SetParticleControl(p, 1, end_pos)

	self:InflictDamage(target, caster, base_percent_damage, DAMAGE_TYPE_PURE )
	target:EmitSound(sound)
	FindClearSpaceForUnit(caster, end_pos, true)
end

modifier_zanmato_main_target = class({})

function modifier_zanmato_main_target:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end

function modifier_zanmato_main_target:GetModifierMoveSpeed_Absolute()
	return 0
end

function modifier_zanmato_main_target:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true
	}
	return state
end

function modifier_zanmato_main_target:OnDestroy()

	if not IsServer() then return end
	local target = self:GetParent()

	local start_pos = target:GetAbsOrigin() + Vector(0,0,-325)
	local end_pos = target:GetAbsOrigin() + Vector(0,0,450)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_mifune/zanmato_slash_2.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p, 0, start_pos)
		ParticleManager:SetParticleControl(p, 1, end_pos)

	target:Purge(true, false, false, false, true)
	target:Kill(self:GetAbility(), self:GetAbility():GetCaster())
	target:EmitSound("Mifune.Zanmato.Kill")
	if target:IsRealHero() then
		self:GetAbility():GetCaster():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_zanmato_permanent_agility", {})
	end
end

function modifier_zanmato_main_target:GetModifierMoveSpeed_Absolute()
	return 0
end

modifier_zanmato_caster = class({})

function modifier_zanmato_caster:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end

modifier_zanmato_permanent_agility = class({})

function modifier_zanmato_permanent_agility:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_zanmato_permanent_agility:IsPurgeException() return false end
function modifier_zanmato_permanent_agility:IsPurgable() return false end

function modifier_zanmato_permanent_agility:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_zanmato_permanent_agility:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function modifier_zanmato_permanent_agility:OnCreated()
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_agility"))
end

function modifier_zanmato_permanent_agility:OnRefresh()
	self:SetStackCount(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("bonus_agility"))
end