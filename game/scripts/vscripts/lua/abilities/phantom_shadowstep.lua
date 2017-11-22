phantom_shadowstep = class({})

LinkLuaModifier("modifier_shadowstep","lua/abilities/phantom_shadowstep",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadowstep_delay","lua/abilities/phantom_shadowstep",LUA_MODIFIER_MOTION_NONE)

function phantom_shadowstep:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local offset = RandomVector(RandomInt(-75,75))

	local pos = target:GetAbsOrigin() + offset

	local duration = self:GetSpecialValueFor("duration")
	local delay = self:GetSpecialValueFor("delay")

	local track = true
	local teleport = true

	local mod = caster:AddNewModifier(caster, self, "modifier_shadowstep_delay", {Duration = delay})

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/phantom_shadowstep_startend.vpcf", PATTACH_WORLDORIGIN, nil)

	Timers:CreateTimer(0.1,function()
		pos = target:GetAbsOrigin() + offset
		ParticleManager:SetParticleControl(p, 0, pos)
		if caster:IsStunned() or caster:IsSilenced() then
			teleport = false
			ParticleManager:DestroyParticle(p,false)
			mod:Destroy()
		end
		if track then
			return 0.1
		end
	end)

	caster:EmitSound("Phantom.Shadowstep.StartUp")
	target:EmitSound("Phantom.Shadowstep.StartUp")

	Timers:CreateTimer(delay,function()
		if teleport then
			caster:AddNewModifier(caster, self, "modifier_shadowstep", {Duration = duration})
			FindClearSpaceForUnit(caster, pos, true)
			ProjectileManager:ProjectileDodge(caster)
			ParticleManager:DestroyParticle(p,false)
			caster:EmitSound("Phantom.Shadowstep.Teleport")
		end
		track = false
	end)
end

modifier_shadowstep_delay = class({})

function modifier_shadowstep_delay:GetEffectName()
	return "particles/units/heroes/hero_phantom/phantom_shadowstep_startup.vpcf"
end

modifier_shadowstep = class({})

function modifier_shadowstep:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return func
end

function modifier_shadowstep:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_shadowstep:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_shadowstep:GetEffectName()
	return "particles/units/heroes/hero_phantom/phantom_shadowstep2.vpcf"
end

function modifier_shadowstep:OnCreated(kv)
	if IsServer() then
		self:GetParent():EmitSound("Phantom.Shadowstep")
	end
end

function modifier_shadowstep:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Phantom.Shadowstep")
	end
end