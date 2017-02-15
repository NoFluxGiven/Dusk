function dilation(keys)
	local caster = keys.caster
	local target = keys.target
	local cooldown_increase = (keys.cooldown_increase or 0)/100

	

	-- if target:HasModifier("modifier_chaos_wave_freeze") then
	-- 	target:RemoveModifierByName("modifier_chaos_wave_freeze")
	-- 	target:RemoveModifierByName("modifier_dilation_silence")
	-- 	keys.ability:EndCooldown()
	-- 	keys.ability:StartCooldown(1)
	-- 	return
	-- end

	-- if target:GetTeam() == caster:GetTeam() then
	-- 	keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_dilation_haste",{})
	-- 	target:AddNewModifier(caster, nil, "modifier_bloodseeker_thirst", {Duration=4.5}) --[[Returns:void
	-- 	No Description Set
	-- 	]]
	-- 	return
	-- end

	keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_dilation_slow",{})
end

function dilation_cooldown(keys)
	local caster = keys.caster
	local target = keys.target

	for i=0,target:GetAbilityCount()-1 do
		local ab = target:GetAbilityByIndex(i) --[[Returns:handle
		Retrieve an ability by index from the unit.
		]]
		if ab ~= nil then
			if ab:GetLevel() > 0 then
				if not ab:IsCooldownReady() then
					local tr = ab:GetCooldownTimeRemaining()
					ab:EndCooldown()
					ab:StartCooldown(tr+0.06)
				end
			end
		end
	end
end

function change_respawn(keys)
	local caster = keys.caster
	local target = keys.unit

	local respawn = keys.respawn_change

	if not target:IsRealHero() then return end

	print("[Dilation] Respawn time constant is "..respawn)



	-- Modify the respawn time
	target:SetTimeUntilRespawn(target:GetRespawnTime() * respawn)
end

function chaos_wave2(keys)
	local caster = keys.caster
	local radius = 3000
	local time = 3
	local interval = 0.1
	local instances = time/interval
	local radius_per_instance = radius/instances

	print("Instances: "..instances.." radius: "..radius_per_instance)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chaos_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(particle, 0, Vector(0,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

		local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_BOTH,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_BUILDING,
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,
                            false)
			for k,v in pairs(enemy) do
				if v ~= caster then
					keys.ability:ApplyDataDrivenModifier(caster, v, "modifier_chaos_wave_freeze", {}) --[[Returns:void
					No Description Set
					]]
				end
			end
end

function chaos_wave_cooldown_freeze(keys)
	local caster = keys.caster
	local v = keys.target

	if keys.target:GetTeam() ~= caster:GetTeam() then

		for i=0,v:GetAbilityCount()-1 do
				local ab = v:GetAbilityByIndex(i) --[[Returns:handle
				Retrieve an ability by index from the unit.
				]]
				if ab ~= nil then
					local cooldown = ab:GetCooldownTimeRemaining()
						ab:EndCooldown() -- so that we can start the cooldown again
						ab:StartCooldown(cooldown+0.2)
				end
		end
		for i=0,5 do
				local item = v:GetItemInSlot(i)

				if item ~= nil then
					local cooldown = item:GetCooldownTimeRemaining()
						item:EndCooldown() -- so that we can start the cooldown again
						item:StartCooldown(cooldown+0.2)
				end
		end

	end
	if keys.target:GetTeam() == caster:GetTeam() then

		for i=0,v:GetAbilityCount()-1 do
				local ab = v:GetAbilityByIndex(i) --[[Returns:handle
				Retrieve an ability by index from the unit.
				]]
				if ab ~= nil then
					local cooldown = ab:GetCooldownTimeRemaining()
						ab:EndCooldown() -- so that we can start the cooldown again
						ab:StartCooldown(cooldown-0.1)
				end
		end
		for i=0,5 do
				local item = v:GetItemInSlot(i)

				if item ~= nil then
					local cooldown = item:GetCooldownTimeRemaining()
						item:EndCooldown() -- so that we can start the cooldown again
						item:StartCooldown(cooldown-0.1)
				end
		end

	end
end

function chaos_wave(keys)
	local caster = keys.caster
	local radius = keys.radius
	local reduction = 1-(keys.reduction/100)
	local total = keys.total/100
	local cooldown_increase = caster:FindAbilityByName("timekeeper_dilation"):GetLevelSpecialValueFor("cooldown_increase", caster:FindAbilityByName("timekeeper_dilation"):GetLevel())/100 --[[Returns:table
	No Description Set
	]]

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)

	local ally = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chaos_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(particle, 0, Vector(0,0,-200)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	for k,v in pairs(enemy) do
		for i=0,v:GetAbilityCount()-1 do
			local ab = v:GetAbilityByIndex(i) --[[Returns:handle
			Retrieve an ability by index from the unit.
			]]
			if ab ~= nil then
				
				if ab:IsCooldownReady() then
					ab:EndCooldown() -- so that we can start the cooldown again
					ab:StartCooldown(ab:GetCooldown(ab:GetLevel()-1)*total)
				else
					if ab:GetCooldownTimeRemaining() <= ab:GetCooldown(ab:GetLevel()-1) then -- if the cooldown is larger than the default cooldown, do nothing
						ab:EndCooldown() -- so that we can start the cooldown again
						ab:StartCooldown(ab:GetCooldown(ab:GetLevel()-1))
					end
				end
			end
		end
		for i=0,5 do
			local item = v:GetItemInSlot(i)

			if item ~= nil then
				if item:IsCooldownReady() then
					item:EndCooldown()
					item:StartCooldown(item:GetCooldown(1)*total)
				else
					if item:GetCooldownTimeRemaining() <= item:GetCooldown(item:GetLevel()-1) then 
						item:EndCooldown()
						item:StartCooldown(item:GetCooldown(1))
					end
				end
			end
		end
		if caster:HasScepter() then
			for i=0,v:GetAbilityCount()-1 do
				local ab = v:GetAbilityByIndex(i) --[[Returns:handle
				Retrieve an ability by index from the unit.
				]]
				if ab ~= nil then
					if not ab:IsCooldownReady() then 
						local tr = ab:GetCooldownTimeRemaining()
						if tr < 300 then -- the cooldown cannot exceed 300 seconds or the ability ignores it
							local newcooldown = tr*(1+cooldown_increase)
							ab:EndCooldown()
							ab:StartCooldown(newcooldown)
						end
					end
				end
			end
			caster:FindAbilityByName("timekeeper_dilation"):ApplyDataDrivenModifier(caster,v,"modifier_dilation_slow",{})
		end
	end
	for k,v in pairs(ally) do
		for i=0,v:GetAbilityCount()-1 do
			local ab = v:GetAbilityByIndex(i) --[[Returns:handle
			Retrieve an ability by index from the unit.
			]]
			if ab ~= nil then
				local tr = ab:GetCooldownTimeRemaining()
				ab:EndCooldown() -- so that we can start the cooldown again
				ab:StartCooldown(tr*reduction)
			end
		end
		for i=0,5 do
			local item = v:GetItemInSlot(i)

			if item ~= nil then
				local tr = item:GetCooldownTimeRemaining()
				item:EndCooldown() -- so that we can start the cooldown again
				item:StartCooldown(tr*reduction)
			end
		end
	end
end

function echo(keys)
	local caster = keys.caster
	local target = keys.unit

	local attacker = keys.attacker

	local n = RandomInt(0, keys.max_echo)

	local r = 1-(keys.reduction/100)

	local damage = keys.damage

	for i=0,n do

		Timers:CreateTimer(0.40+0.40*i,function()
			local hp = target:GetHealth()
			local d = (damage*(r/(2^i)))
			if hp > d then
				target:SetHealth(hp-d)
			else
				target:SetHealth(1)
			end
			
		end
		)
	end
end

function parallels_start(keys)
	local caster = keys.caster

	caster:Purge(false,true,false,true,false)

	if not caster:HasModifier("modifier_parallels") then

		local hp = caster:GetHealth()
		local mp = caster:GetMana()

		caster.parallels_hp = hp
		caster.parallels_mp = mp

	end

	caster:SetHealth(caster:GetMaxHealth())
	caster:SetMana(caster:GetMaxMana())
end

function parallels_end(keys)
	local caster = keys.caster

	if not caster:IsAlive() then return end

	if caster.parallels_hp == nil or caster.parallels_mp == nil then return end

	caster:SetHealth(caster.parallels_hp)
	caster:SetMana(caster.parallels_mp)
end

function chronoshift(keys)
	local caster = keys.caster
	local time = keys.time
	local target = keys.target

	print(caster:GetAbsOrigin(),caster:GetForwardVector())

	caster:EmitSound("Hero_FacelessVoid.TimeWalk") --[[Returns:void
		Play named sound for all players
		]]
	target:EmitSound("Hero_FacelessVoid.Chronosphere") --[[Returns:void
	 
	]]
	target.chronoshift_health = target:GetHealth()
	target.chronoshift_mana = target:GetMana()
	target.chronoshift_vector = target:GetAbsOrigin()
	ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chronoshift.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_chronoshift", {}) --[[Returns:void
		No Description Set
		]]
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_chronoshift_caster", {}) --[[Returns:void
		No Description Set
		]]
end

function chronoshift_end(keys)
	local caster = keys.caster

	caster:EmitSound("Hero_Weaver.TimeLapse")

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
                            99999,
                            DOTA_UNIT_TARGET_TEAM_BOTH,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)

	for k,v in pairs(found) do
		if v:IsAlive() then
			if v:HasModifier("modifier_chronoshift") then
					v:SetHealth(v.chronoshift_health)
					v:SetMana(v.chronoshift_mana)
					FindClearSpaceForUnit(v, v.chronoshift_vector, true) --[[Returns:void
					Place a unit somewhere not already occupied.
					]]
					v:Purge(false,true,false,true,false)
					ProjectileManager:ProjectileDodge(v) --[[Returns:void
					Makes the specified unit dodge projectiles
					]]
					ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chronoshift_resume.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
					Creates a new particle effect
					]]
					v:RemoveModifierByName("modifier_chronoshift") --[[Returns:void
					Removes a modifier
					]]
				end
			end
		end
	caster:RemoveModifierByName("modifier_chronoshift_caster")
end

function chronoshift_swap_abilities(keys)
	local caster = keys.caster

	print("SWAPPING!")

	local ab1 = caster:FindAbilityByName("timekeeper_chronoshift") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]
	local ab2 = caster:FindAbilityByName("timekeeper_chronoshift_end") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]

	if ab1:IsHidden() then
		print("Chronoshift hidden, Chronoshift End shown")
		ab1:SetHidden(false) --[[Returns:void
		No Description Set
		]]
		ab2:SetHidden(true)
	else
		print("Chronoshift shown, Chronoshift End hide")
		ab1:SetHidden(true)
		ab2:SetHidden(false)
		ab2:SetLevel(1)
	end
end

function parallels(keys)
	local caster = keys.caster
	local target = keys.target

	local duration = keys.duration

	local pos = caster:GetCursorPosition()

	local unit = FastDummy(pos,caster:GetTeam(),duration,500)

	unit:SetOwner(caster)

	unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,120))

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_parallels.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	Timers:CreateTimer(duration-1,function() ParticleManager:DestroyParticle(p,false) end)

	unit.parallels_connected_unit = target

	caster.parallels_unit = unit
end

function parallels_check_and_cast(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local parallels_ability = caster:FindAbilityByName("timekeeper_echoes")
	local radius = parallels_ability:GetLevelSpecialValueFor("radius", parallels_ability:GetLevel()-1)

	if caster.parallels_cast == true then caster.parallels_cast = false return end

	if IsNull(caster.parallels_unit) then return end

	if caster.parallels_unit ~= nil then
		local found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster.parallels_unit:GetCenter(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)
		for k,v in pairs(found) do
			print("Start loop")
			if v ~= target then
				caster.parallels_cast = true
				caster:SetCursorCastTarget(v)
				print("Firing the spell!")
				ability:OnSpellStart()
				Timers:CreateTimer(0.06,function() caster.parallels_cast = false end)
			end
		end
	end
end

function futurestrike(keys)
	local caster = keys.caster
	local target = keys.target
	local min_damage = keys.min_damage
	local max_damage = keys.max_damage
	local min_delay = keys.min_delay
	local max_delay = keys.max_delay
	local delay = RandomInt(min_delay, max_delay)
	local pct = delay/max_delay
	local damage = math.ceil(max_damage*pct)
	if damage < min_damage then damage = min_damage end

	local mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_futurestrike", {Duration=delay}) --[[Returns:void
	No Description Set
	]]

	if not target.futurestrike_table then

		target.futurestrike_table = {}

	end

	local end_time = math.floor(GameRules:GetGameTime() + delay)

	local bonus_time = 0

	for k,v in pairs(target.futurestrike_table) do
		if end_time == v["end_time"] then
			bonus_time = bonus_time + 0.05
		end
	end

	end_time = bonus_time+end_time

	local t = {
		["damage"] = damage,
		["particle"] = ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_futurestrike.vpcf", PATTACH_OVERHEAD_FOLLOW, target),
		["end_time"] = end_time, -- so we know which particle to destroy
		["bonus_time"] = bonus_time
	}



	print(t["end_time"])

	target:EmitSound("Timekeeper.Futurestrike")

	table.insert(target.futurestrike_table,t)

	ParticleManager:SetParticleControl(t["particle"], 1, Vector(delay,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end

function futurestrike_end(keys)
	local caster = keys.caster
	local target = keys.target

	local t = target.futurestrike_table
	local time = math.floor(GameRules:GetGameTime())

	print(time)

	local damage = 0
	local particle = -1
	local n = 0

	for k,v in pairs(t) do
		if v["end_time"] == time+v["bonus_time"] then
			particle = v["particle"]
			damage = v["damage"]
			--n = k
		end
	end

	if particle ~= -1 then

		target:EmitSound("Timekeeper.Futurestrike.Boom")

		target:StopSound("Timekeeper.Futurestrike")

		ParticleManager:DestroyParticle(particle,false)

		--table.remove(target.futurestrike_table,n)

		if target:IsMagicImmune() then return end

		if not target:IsRealHero() and not CheckClass(target,"npc_dota_roshan") then damage = damage * 4 end

		DealDamage(target,caster,damage,DAMAGE_TYPE_PURE)

		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.4}) --[[Returns:void
		No Description Set
		]]

		Timers:CreateTimer(0.06,function()
			if not target:HasModifier("modifier_futurestrike") then
				-- clear the table
				print("CLEARING TABLE")
				target.futurestrike_table = nil
				for k,v in pairs(t) do
					ParticleManager:DestroyParticle(v["particle"],false)
				end
			end
		end)

	else

		for k,v in pairs(t) do
			ParticleManager:DestroyParticle(v["particle"],false)
		end

		target:StopSound("Timekeeper.Futurestrike")
		target:EmitSound("Timekeeper.Futurestrike.Boom")

		target.futurestrike_table = {}

	end
	
end