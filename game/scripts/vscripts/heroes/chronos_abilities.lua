function Warp(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()
	local origin = caster:GetAbsOrigin()

	local damage = keys.damage
	local radius = keys.radius
	local delay = keys.delay

	local unit = FastDummy(target+Vector(0,0,75),caster:GetTeam(),5,250)
	local unit_orig = FastDummy(origin+Vector(0,0,75),caster:GetTeam(),5,250)

	ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/warp.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
	Creates a new particle effect
	]]

	caster:EmitSound("Hero_Dark_Seer.Surge")

	-- damage the origin and the target locations in an AoE

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              origin,
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_chronos_warp_slow", {}) --[[Returns:void
		No Description Set
		]]
	end

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              target,
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_chronos_warp_slow", {}) --[[Returns:void
		No Description Set
		]]
	end

	local partdelay = delay-3

	if delay < 3 then partdelay = 0 end

	Timers:CreateTimer(partdelay,function() 
			ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/unwarp.vpcf", PATTACH_ABSORIGIN, unit_orig)
		end)

	FindClearSpaceForUnit(caster, target, true) --[[Returns:void
	Place a unit somewhere not already occupied.
	]]

	ProjectileManager:ProjectileDodge(caster) --[[Returns:void
	Makes the specified unit dodge projectiles
	]]

	ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/warp.vpcf", PATTACH_ABSORIGIN, unit_orig) --[[Returns:int
	Creates a new particle effect
	]]

	Timers:CreateTimer(delay,function()
			local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),4,250)
			ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/warp.vpcf", PATTACH_ABSORIGIN, unit_orig) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/warp.vpcf", PATTACH_ABSORIGIN, unit) --[[Returns:int
			Creates a new particle effect
			]]
			FindClearSpaceForUnit(caster, origin, true) --[[Returns:void
			Place a unit somewhere not already occupied.
			]]
			ProjectileManager:ProjectileDodge(caster) --[[Returns:void
			Makes the specified unit dodge projectiles
			]]
			caster:EmitSound("Hero_Dark_Seer.Surge")
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              origin,
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
			for k,v in pairs(enemy_found) do
				DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_chronos_warp_slow", {}) --[[Returns:void
				No Description Set
				]]
			end

			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              unit:GetAbsOrigin(),
                              nil,
                                radius,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
			for k,v in pairs(enemy_found) do
				DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
				keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_chronos_warp_slow", {}) --[[Returns:void
				No Description Set
				]]
			end
		end
		)
end

function SyncBegin(keys)
	local caster = keys.caster
	local tick = "modifier_chronos_tick"
	local tock = "modifier_chronos_tock"
	local full_duration = 60
	local half_duration = full_duration/2

	-- particles

	if not caster.sync_particle then

		caster.sync_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/sync.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	else

		ParticleManager:DestroyParticle(caster.sync_particle,false)
		ParticleManager:ReleaseParticleIndex(caster.sync_particle) --[[Returns:void
		Frees the specified particle index
		]]

		caster.sync_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/sync.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	end

	if not caster.sync_clock_particle then

		caster.sync_clock_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/sync_clock_face_aggressive.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	else

		ParticleManager:DestroyParticle(caster.sync_clock_particle,false)
		ParticleManager:ReleaseParticleIndex(caster.sync_clock_particle) --[[Returns:void
		Frees the specified particle index
		]]

		caster.sync_clock_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chronos/sync_clock_face_aggressive.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	end

end

function Sync(keys)
	local caster = keys.caster
	local tick = "modifier_chronos_tick"
	local tock = "modifier_chronos_tock"
	local tick_part = "particles/units/heroes/hero_chronos/sync_clock_face_aggressive.vpcf"
	local tock_part = "particles/units/heroes/hero_chronos/sync_clock_face_defensive.vpcf"
	local go = -1
	local go_part = -1
	local change_part = "particles/units/heroes/hero_chronos/sync_change.vpcf"
	local show = -1
	local tick_show = "modifier_show_tick"
	local tock_show = "modifier_show_tock"

	--if caster:HasModifier("modifier_chronos_sync_override") then return end

	if caster:HasModifier(tick) then
		go = tock
		go_part = tock_part
		show = tock_show
	elseif caster:HasModifier(tock) then
		go = tick
		go_part = tick_part
		show = tick_show
	else
		go = tick
		go_part = tick_part
		show = tick_show
	end

	caster:RemoveModifierByName(tick)
	caster:RemoveModifierByName(tock)
	caster:RemoveModifierByName(tick_show)
	caster:RemoveModifierByName(tock_show)

	keys.ability:ApplyDataDrivenModifier(caster, caster, go, {}) --[[Returns:void
	No Description Set
	]]

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_chronos_sync_timer", {Duration=60}) --[[Returns:void
	No Description Set
	]]

	ParticleManager:CreateParticle(change_part, PATTACH_ABSORIGIN_FOLLOW, caster)

	if not caster.sync_clock_particle then

		caster.sync_clock_particle = ParticleManager:CreateParticle(go_part, PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	else

		ParticleManager:DestroyParticle(caster.sync_clock_particle,false)
		ParticleManager:ReleaseParticleIndex(caster.sync_clock_particle) --[[Returns:void
		Frees the specified particle index
		]]

		caster.sync_clock_particle = ParticleManager:CreateParticle(go_part, PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

	end

	caster:RemoveModifierByName(show)
	keys.ability:ApplyDataDrivenModifier(caster, caster, show, {Duration=60}) --[[Returns:void
	No Description Set
	]]
end

function SyncOnDeath(keys)
	local caster = keys.caster

	if caster.sync_clock_particle then
		ParticleManager:DestroyParticle(caster.sync_clock_particle,false)
		ParticleManager:ReleaseParticleIndex(caster.sync_clock_particle) --[[Returns:void
		Frees the specified particle index
		]]
	end
	if caster.sync_particle then
		ParticleManager:DestroyParticle(caster.sync_particle,false)
		ParticleManager:ReleaseParticleIndex(caster.sync_particle) --[[Returns:void
		Frees the specified particle index
		]]
	end
end

function SyncUpgrade(keys)
	local caster = keys.caster
	local tick = "modifier_chronos_tick"
	local tock = "modifier_chronos_tock"
	local applytick = caster:HasModifier(tick)
	local applytock = caster:HasModifier(tock)

	caster:RemoveModifierByName(tick) --[[Returns:void
	Removes a modifier
	]]
	caster:RemoveModifierByName(tock) --[[Returns:void
	Removes a modifier
	]]

	if applytick then
		keys.ability:ApplyDataDrivenModifier(caster, caster, tick, {}) --[[Returns:void
		No Description Set
		]]
	elseif applytock then
		keys.ability:ApplyDataDrivenModifier(caster, caster, tock, {}) --[[Returns:void
		No Description Set
		]]
	end
end

function TimeCrystalRecovery(keys)
	local caster = keys.caster
	local target = keys.target
	local recovery = keys.recovery/100
	local aghs_recovery = keys.aghs_recovery/100
	local enemy_recovery = 3/100
	local interval = 0.1
	if caster:HasScepter() then recovery = aghs_recovery end
	local recovery_per_tick = recovery*interval
	local hp = target:GetMaxHealth()
	local mp = target:GetMaxMana()

	if target:GetTeam() == caster:GetTeam() then recovery_per_tick = recovery_per_tick else recovery_per_tick = enemy_recovery*interval end

	local hp_per_tick = hp*recovery_per_tick
	local mp_per_tick = mp*recovery_per_tick

	target:Heal(hp_per_tick, caster)
	target:GiveMana(mp_per_tick)
end