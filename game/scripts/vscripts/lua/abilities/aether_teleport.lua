aether_teleport = class({})

LinkLuaModifier("modifier_teleport_start_up","lua/abilities/aether_teleport",LUA_MODIFIER_MOTION_NONE)

function aether_teleport:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local delay = self:GetSpecialValueFor("delay")

	local casterpos = caster:GetAbsOrigin()

	-- particle

	if caster == target then
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                                FIND_UNITS_EVERYWHERE,
	                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                                DOTA_UNIT_TARGET_ALL,
	                                DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	                                FIND_CLOSEST,
	                                false)

		target = nil

		print("Target is now nil.")

		for k,v in pairs(found) do
			if v:HasModifier("modifier_monolith_slow_area") then
				target = caster
				casterpos = v:GetAbsOrigin()
				delay = delay*2
				break
			end
		end
	end

	if not IsValidEntity(target) then self:RefundManaCost() self:EndCooldown() return end

	local unit = FastDummy(casterpos,caster:GetTeam(),delay,200)

	ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	target.teleport_position = casterpos

	target:AddNewModifier(caster, self, "modifier_teleport_start_up", {Duration = delay})

	caster:EmitSound("Hero_Wisp.Relocate")
end

function aether_teleport:GetCastRange()
	local cast_range = self.BaseClass.GetCastRange(self, self:GetCaster():GetAbsOrigin(), self:GetCursorTarget())
	if self:GetCaster():GetHasTalent("special_bonus_aether_teleport") then
		return cast_range + 875
	else
		return cast_range
	end
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_teleport_start_up = class({})

function modifier_teleport_start_up:IsPurgable()
	return true
end

function modifier_teleport_start_up:IsPurgeException()
	return true
end

function modifier_teleport_start_up:GetEffectName()
	return "particles/units/heroes/hero_wisp/wisp_relocate_channel.vpcf"
end

function modifier_teleport_start_up:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_teleport_start_up:OnDestroy()
	local caster = self:GetAbility():GetCaster()
	local target = self:GetParent()

	-- particle

	if target:IsSilenced() then return end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_POINT, target) --[[Returns:int
	Creates a new particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_POINT, target) --[[Returns:int
	Creates a new particle effect
	]]

	if IsServer() then target:EmitSound("Hero_Wisp.TeleportIn") end

	ParticleManager:SetParticleControl(p, 0, target.teleport_position) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	ParticleManager:SetParticleControl(p2, 0, target:GetAbsOrigin()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	FindClearSpaceForUnit(target, target.teleport_position, true)

	if IsServer() then target:EmitSound("Hero_Wisp.TeleportIn") end
end