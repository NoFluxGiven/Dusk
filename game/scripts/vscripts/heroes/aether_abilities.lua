function teleport_start(keys)
	local caster = keys.caster
	local target = keys.target

	local delay = keys.delay

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

	if not IsValidEntity(target) then keys.ability:RefundManaCost() keys.ability:EndCooldown() return end

	local unit = FastDummy(casterpos,caster:GetTeam(),delay,200)

	ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	target.teleport_position = casterpos

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_teleport_start_up", {Duration=delay}) --[[Returns:void
	No Description Set
	]]

	caster:EmitSound("Hero_Wisp.Relocate")

end

function teleport_start_range_check(keys)
	return
end

function teleport_end(keys)
	local caster = keys.caster
	local target = keys.target

	-- particle

	if target:IsSilenced() then return end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_POINT, target) --[[Returns:int
	Creates a new particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_POINT, target) --[[Returns:int
	Creates a new particle effect
	]]

	target:EmitSound("Hero_Wisp.TeleportIn")

	ParticleManager:SetParticleControl(p, 0, target.teleport_position) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	ParticleManager:SetParticleControl(p2, 0, target:GetAbsOrigin()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	FindClearSpaceForUnit(target, target.teleport_position, true)

	target:EmitSound("Hero_Wisp.TeleportIn")


end

function reality_shift(keys)
	local caster = keys.caster
	local radius = keys.radius
	local duration = keys.duration

	local m = "modifier_reality_shift_unit"
	local m2 = "modifier_reality_shift_show"

	local predamage = keys.damage

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
				keys.ability:ApplyDataDrivenModifier(caster, v, m2, {Duration=duration-0.1}) --[[Returns:void
				No Description Set
				]]
				keys.ability:ApplyDataDrivenModifier(caster, v, m, {Duration=duration}) --[[Returns:void
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

function Show(keys)
	local caster = keys.caster
	local target = keys.target

	print("C: "..caster:GetName().." T: "..target:GetName())

	local dmg = keys.damage
	local stun = keys.stun

	local radius = keys.radius

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

	ScreenShake(caster:GetCenter(), 1200, 170, delay, 1200, 0, true)
 
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
end