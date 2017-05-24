aether_reality_shift = class({})

LinkLuaModifier("modifier_reality_shift_unit","lua/abilities/aether_reality_shift",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reality_shift_show","lua/abilities/aether_reality_shift",LUA_MODIFIER_MOTION_NONE)

function aether_reality_shift:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local m = "modifier_reality_shift_unit"
	local m2 = "modifier_reality_shift_show"

	local predamage = self:GetSpecialValueFor("predamage")

	local delay = 0.4

	caster.teleport_to_monolith = false

	ScreenShake(caster:GetCenter(), 1200, 170, delay, 1200, 0, true)

	local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),3,200)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_aether/aether_reality_shift.vpcf", PATTACH_POINT, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(p, 0, caster:GetCenter()+Vector(0,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	--caster:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.End")
	caster:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment")

	Timers:CreateTimer(delay,function()
		ParticleManager:DestroyParticle(p,false)
	end)

	Timers:CreateTimer(0.17,function()
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_BOTH,
	                                DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
	                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                                FIND_ANY_ORDER,
	                                false)

		-- if #found == 1 then
		-- 	caster.teleport_to_monolith = true
		-- 	keys.ability:EndCooldown()
		-- 	keys.ability:StartCooldown(25)
		-- 	duration = 2
		-- end

		for k,v in pairs(found) do
			print("====================")
			print("UNIT: "..v:GetUnitName())
			print("KEY: "..k.."/"..#found)
			if v ~= unit and v:GetUnitName() ~= "npc_dummy_unit" then
				v:Interrupt()
				if v:GetTeam() ~= caster:GetTeam() then
					DealDamage(v,caster,predamage,DAMAGE_TYPE_MAGICAL)
				end
				v:AddNewModifier(caster, self, m2, {Duration=duration-0.1}) --[[Returns:void
				No Description Set
				]]
				v:AddNewModifier(caster, self, m, {Duration=duration}) --[[Returns:void
				No Description Set
				]]
				if v:HasModifier(m) then
					print(m.." was applied to "..v:GetName()..".")
				end
				if v:HasModifier(m2) then
					print(m2.." was applied to "..v:GetName()..".")
				end
				v:AddNoDraw()
				print("NoDraw applied to "..v:GetName()..".")
			end
		end
	end)
end

function aether_reality_shift:GetCooldown()
	local base_cooldown = self.BaseClass.GetCooldown(self, self:GetLevel())
	if not self:GetCaster():GetHasTalent("special_bonus_aether_reality_shift") then
		return base_cooldown
	else
		return base_cooldown - 60
	end
	return base_cooldown - 60
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_reality_shift_unit = class({})

function modifier_reality_shift_unit:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_reality_shift_unit:CheckState()

	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}

	return state

end

function modifier_reality_shift_unit:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_reality_shift_show = class({})

function modifier_reality_shift_show:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_reality_shift_show:OnDestroy()

	--if IsServer() then

		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()

		print("C: "..caster:GetName().." T: "..target:GetName())

		local dmg = self:GetAbility():GetSpecialValueFor("damage")
		local stun = self:GetAbility():GetSpecialValueFor("stun")

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local delay = 0.4

		local pos = caster:GetAbsOrigin()

		-- if caster.teleport_to_monolith then
		-- 	local found_2 = FindUnitsInRadius( caster:GetTeamNumber(),
		--                               caster:GetAbsOrigin(),
		--                               nil,
		--                                 FIND_UNITS_EVERYWHERE,
		--                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		--                                 DOTA_UNIT_TARGET_ALL,
		--                                 DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		--                                 FIND_CLOSEST,
		--                                 false)

		-- 	for k,v in pairs(found_2) do
		-- 		if v:HasModifier("modifier_monolith_slow_area_ally") then
		-- 			print("FOUND A UNIT WITH PREREQUISITES")
		-- 			p = v:GetAbsOrigin()
		-- 		end
		-- 	end
		-- 	FindClearSpaceForUnit(caster, p, true) --[[Returns:void
		-- 	Place a unit somewhere not already occupied.
		-- 	]]
		-- end

		local p = 0

		ScreenShake(caster:GetAbsOrigin(), 1200, 170, delay, 1200, 0, true)
	 
		if target:GetTeam() ~= caster:GetTeam() then
			DealDamage(target,caster,50,DAMAGE_TYPE_MAGICAL)
		end

		if caster == target then

			local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),3,200)

			caster:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.End")

			p = ParticleManager:CreateParticle("particles/units/heroes/hero_aether/aether_reality_shift.vpcf", PATTACH_POINT, unit) --[[Returns:int
			Creates a new particle effect
			]]

			ParticleManager:SetParticleControl(p, 0, caster:GetCenter()+Vector(0,0,0)) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]

			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
			                              caster:GetAbsOrigin(),
			                              nil,
			                                radius,
			                                DOTA_UNIT_TARGET_TEAM_ENEMY,
			                                DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
			                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			                                FIND_ANY_ORDER,
			                                false)

			for k,v in pairs(enemy_found) do
				v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
				No Description Set
				]]
				DealDamage(v,caster,dmg,DAMAGE_TYPE_PURE)
			end

		end

		Timers:CreateTimer(delay,function()
			print("Removing NoDraw for "..target:GetName()..".")
			ParticleManager:DestroyParticle(p,false)
			target:RemoveNoDraw()
		end)

	--end
end

function modifier_reality_shift_show:IsHidden()
	return true
end