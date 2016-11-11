function d_waves(keys)
	local caster = keys.caster
	local radius = 1250
	if caster:GetHealthPercent() < 33 then
		if caster:HasModifier("modifier_defensive_wave_warning") ~= true then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_defensive_wave_warning", {}) --[[Returns:void
			No Description Set
			]]
		end
		local mod = caster:FindModifierByName("modifier_defensive_wave_warning")
		caster:SetCustomHealthLabel("Giga Graviton in "..tostring(4-mod:GetStackCount()/10),128,0,0)
		if mod:GetStackCount() >= 40 then
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)
			local enemy_hero_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)
			for k,v in pairs(enemy_found) do
				local hp = v:GetMaxHealth()
				local dmg = hp*0.55
				local time = k*0.25
				local rand = RandomFloat(0, 0.25)
				Timers:CreateTimer(rand+time,function()
					DealDamage(v,caster,dmg,DAMAGE_TYPE_PURE)
					local p = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
					Creates a new particle effect
					]]

					ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 2, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 3, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 4, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 5, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]

					v:EmitSound("Hero_Luna.LucentBeam.Target")
				end)
			end
			-- local n = 7
			-- Timers:CreateTimer(1,function()
			-- 	n = n-1
			-- 	caster:SetCustomHealthLabel(n,255,255,255)
			-- 	return 1
			-- end)
			for k,v in pairs(enemy_hero_found) do
				local hp = v:GetMaxHealth()
				local dmg = hp*0.09
				local time = (k-1)*0.25
				local rand = RandomFloat(0, 0.25)
				if dmg >= v:GetHealth() then
					dmg = v:GetHealth() - 1
				end
				Timers:CreateTimer(rand+time,function()
					DealDamage(v,caster,dmg,DAMAGE_TYPE_PURE)
					local p = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
					Creates a new particle effect
					]]

					ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 1, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 2, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 3, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 4, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]
					ParticleManager:SetParticleControlEnt(p, 5, v, PATTACH_POINT_FOLLOW, "attach_origin", v:GetAbsOrigin(), true) --[[Returns:void
					No Description Set
					]]

					v:EmitSound("Hero_Luna.LucentBeam.Target")
				end)
			end
			mod:SetStackCount(0)
		end
		mod:IncrementStackCount()
	end
end

function last_resort(keys)
	local caster = keys.caster

	local ab = keys.ability
	-- ab:EndCooldown()
	if ab:IsCooldownReady() and caster:GetHealthPercent() <= 10 then
		caster:SetCustomHealthLabel("Warning!",255,0,0)
	end

	if ab:IsCooldownReady() and caster:GetHealthPercent() <= 10 then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_last_resort_invulnerability_aura", {}) --[[Returns:void
		No Description Set
		]]
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_last_resort_invulnerability_building", {Duration=15}) --[[Returns:void
		No Description Set
		]]
		caster:EmitSound("Hero_Omniknight.GuardianAngel.Cast") --[[Returns:void
		Play named sound for all players
		]]
		local messageinfo = {
			message = "Last Resort!",
			duration = 3
		}
		FireGameEvent("show_center_message",messageinfo)
		local teamname = "team"
		if caster:GetTeam() == DOTA_TEAM_GOODGUYS then
			teamname = "Radiant"
		end
		if caster:GetTeam() == DOTA_TEAM_BADGUYS then
			teamname = "Dire"
		end
		GameRules:SendCustomMessage("The "..teamname.."'s Ancient has just used its <font color='#dd3f4e'>Last Resort</font>!", caster:GetTeam(), 0)
		ab:StartCooldown(9999)
		local heroes = HeroList:GetAllHeroes()

		for k,v in pairs(heroes) do
			if v:GetTeam() == caster:GetTeam() then
				if v:IsAlive() ~= true then
					v:RespawnHero(false,false,false)
				end
			end
		end
	end

end

function LastResortParticleCreate(keys)
	local caster = keys.caster
	local target = keys.target

	local rad = target:GetModelRadius()

	target.lr_particle = ParticleManager:CreateParticle("particles/units/building/last_resort_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(target.lr_particle, 1, Vector(rad,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end

function LastResortParticleDestroy(keys)
	local caster = keys.caster
	local target = keys.target

	ParticleManager:DestroyParticle(target.lr_particle,false)
end

function frenzy(keys)
	local caster = keys.caster
	if caster:GetHealthPercent() < 35 and caster:GetHealthPercent() > 26 then
		if caster.show_warning == nil or caster.show_warning == false then
			ParticleManager:CreateParticle("particles/units/building/msg_frenzy_warning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) --[[Returns:int
			Creates a new particle effect
			]]
			caster.show_warning = true
		end
	end

	if caster:GetHealthPercent() < 25 then
		if keys.ability:IsCooldownReady() then
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_frenzy_bonus_effects", {}) --[[Returns:void
			No Description Set
			]]
			keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))
		end
	end

	if caster:GetHealthPercent() < 26 then caster:SetCustomHealthLabel("",0,0,0) end
	if caster:HasModifier("modifier_frenzy_bonus_effects") then caster:SetCustomHealthLabel("FRENZIED!",255,0,0) end
	if caster:GetHealthPercent() < 40 and caster:GetHealthPercent() > 26 then caster:SetCustomHealthLabel("Warning!",128,128,0) end
end