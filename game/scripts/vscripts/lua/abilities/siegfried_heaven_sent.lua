siegfried_heaven_sent = class({})

LinkLuaModifier("modifier_heaven_sent","lua/abilities/siegfried_heaven_sent",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heaven_sent_caster","lua/abilities/siegfried_heaven_sent",LUA_MODIFIER_MOTION_NONE)

function siegfried_heaven_sent:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()

		local duration = self:GetSpecialValueFor("duration")

		local tmod = target:AddNewModifier(caster, self, "modifier_heaven_sent", {Duration=duration})
		local mod = caster:AddNewModifier(caster, self, "modifier_heaven_sent_caster", {Duration=duration})

		mod.original_pos = caster:GetAbsOrigin()
		mod.target_mod = tmod

		--caster:StopGesture()

		caster:StartGesture(ACT_DOTA_SPAWN)
		Timers:CreateTimer(0.2,function()
			caster:FadeGesture(ACT_DOTA_SPAWN)
		end)

		ScreenShake(target:GetAbsOrigin(), 1000, 3, 0.75, 1500, 0, true)

		local pstart = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/heaven_sent_teleport.vpcf", PATTACH_WORLDORIGIN, nil) 
		local pend = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/heaven_sent_teleport.vpcf", PATTACH_WORLDORIGIN, nil) 

		ParticleManager:SetParticleControl(pstart, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pend, 0, target:GetAbsOrigin())

		FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true)
		self:GetCaster():EmitSound("Siegfried.HeavenSent")
		--self:GetCaster():EmitSound("Hero_Omniknight.GuardianAngel.Cast")
	end
end

modifier_heaven_sent = class({})

function modifier_heaven_sent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_heaven_sent:GetModifierConstantHealthRegen()
	local aghs = self:GetAbility():GetCaster():HasScepter()
	if aghs then
		return self:GetAbility():GetSpecialValueFor("scepter_health_regen")
	end
end

function modifier_heaven_sent:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end

function modifier_heaven_sent:IsPurgable()
	return false
end

function modifier_heaven_sent:OnCreated(kv)
	if IsServer() then
		self:GetParent():AddNoDraw()

		local duration = self:GetAbility():GetSpecialValueFor("duration")

		self.unit = CreateModifierThinker( self:GetAbility():GetCaster(),
			self, "", {Duration=duration+0.03}, self:GetParent():GetAbsOrigin(),
			self:GetAbility():GetCaster():GetTeamNumber(), false)

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/heaven_sent_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.unit) 
	end
end

function modifier_heaven_sent:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()

		ParticleManager:DestroyParticle(self.particle, false)
	end
end

function modifier_heaven_sent:IsHidden()
	return true
end

modifier_heaven_sent_caster = class({})

function modifier_heaven_sent_caster:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return func
end

function modifier_heaven_sent_caster:GetModifierConstantHealthRegen()
	local aghs = self:GetParent():HasScepter()
	if aghs then
		return self:GetAbility():GetSpecialValueFor("scepter_health_regen")
	end
end

function modifier_heaven_sent_caster:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()

		local pstart = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/heaven_sent_teleport.vpcf", PATTACH_WORLDORIGIN, nil) 
		local pend = ParticleManager:CreateParticle("particles/units/heroes/hero_siegfried/heaven_sent_teleport.vpcf", PATTACH_WORLDORIGIN, nil) 

		ParticleManager:SetParticleControl(pstart, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pend, 0, self.original_pos)

		caster:EmitSound("Siegfried.HeavenSent.Return")

		if self.target_mod then
			if not self.target_mod:IsNull() then
				self.target_mod:Destroy()
			end
		end

		FindClearSpaceForUnit(caster, self.original_pos, true)
		caster:StartGesture(ACT_DOTA_SPAWN)
		Timers:CreateTimer(0.2,function()
			caster:FadeGesture(ACT_DOTA_SPAWN)
		end)
	end
end