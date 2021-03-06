aether_teleport = class({})

LinkLuaModifier("modifier_teleport_start_up","lua/abilities/aether_teleport",LUA_MODIFIER_MOTION_NONE)

function aether_teleport:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_delay_bonus = caster:FetchTalent("special_bonus_aether_2") or 0

	local delay_change = 1-(t_delay_bonus/100)

	local delay = self:GetSpecialValueFor("delay") * delay_change

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

		ToolsPrint("Target is now nil.")

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

-- function aether_teleport:GetCastRange()
-- 	local cast_range = self.BaseClass.GetCastRange(self, self:GetCaster():GetAbsOrigin(), self:GetCursorTarget())
-- 	-- local t_cast_range_bonus = self:GetCaster():FetchTalent("special_bonus_aether_3") or 0

-- 	return cast_range -- + t_cast_range_bonus
-- end

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

	if IsServer() then
		target:EmitSound("Hero_Wisp.TeleportIn")

		ParticleManager:SetParticleControl(p, 0, target.teleport_position) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		ParticleManager:SetParticleControl(p2, 0, target:GetAbsOrigin()) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		FindClearSpaceForUnit(target, target.teleport_position, true)

	end

	if IsServer() then target:EmitSound("Hero_Wisp.TeleportIn") end
end