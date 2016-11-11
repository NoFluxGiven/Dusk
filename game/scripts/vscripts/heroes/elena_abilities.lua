function convokeUpgrade(keys)
	local caster = keys.caster
	local ab1 = keys.ability
	local ab2 = caster:FindAbilityByName("elena_convoke_2") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]

	--if ab2:GetLevel() ~= ab1:GetLevel() then ab2:SetLevel(ab1:GetLevel()) end
end

function convokeStart(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition() --[[Returns:Vector
	No Description Set
	]]
	local dmg1 = keys.damage
	local radius = keys.range

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)
	local creep = FindUnitsInRadius( caster:GetTeamNumber(), -- find the number of creeps in the area
                          target,
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)
	caster.creepcount = #creep
	for k,v in pairs(enemy)	do
		local info = 
		  {
		  Target = caster,
		  Source = v,
		  Ability = keys.ability,  
		  EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
		  vSpawnOrigin = v:GetAbsOrigin(),
		  fDistance = distance,
		  fStartRadius = 64,
		  fEndRadius = 64,
		  bHasFrontalCone = false,
		  bReplaceExisting = false,
		  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  fExpireTime = GameRules:GetGameTime() + 10.0,
		  bDeleteOnHit = true,
		  iMoveSpeed = 1100,
		  bProvidesVision = true,
		  iVisionRadius = 275,
		  iVisionTeamNumber = caster:GetTeamNumber(),
		  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		  }
		  
		  local projectile = ProjectileManager:CreateTrackingProjectile(info)
		DealDamage(v,caster,dmg1,DAMAGE_TYPE_MAGICAL)
		v:ReduceMana(dmg1*0.5)
	end
	caster:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
end

function convokeHit(keys)
	local caster = keys.caster
	local modifier = "elena_convoke_mod"
	local modifier2 = "elena_convoke_efft_mod"

	if caster.creepcount > 0 then
		caster.creepcount = caster.creepcount-1
		caster:Heal(keys.ability:GetLevel()*5, caster)
		keys.ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		local stacks = caster:GetModifierStackCount(modifier,keys.ability)
		caster:SetModifierStackCount(modifier,keys.ability,stacks+1)
		caster:EmitSound("Hero_Oracle.PreAttack") -- creep sound effect
		return
	end -- decrement the creep count

	keys.ability:ApplyDataDrivenModifier(caster, caster, modifier, {}) --[[Returns:void
	No Description Set
	]]
	-- keys.ability:ApplyDataDrivenModifier(caster, caster, modifier2, {}) --[[Returns:void
	-- No Description Set
	-- ]]

	caster:Heal(keys.ability:GetLevel()*10, caster)

	local stacks = caster:GetModifierStackCount(modifier,keys.ability)

	caster:SetModifierStackCount(modifier,keys.ability,stacks+3)
	caster:EmitSound("Hero_Oracle.Attack") -- hero sound effect
end

function convokeTick(keys)
	local caster = keys.caster
	local modifier = "elena_convoke_mod"
	local modifier2 = "elena_convoke_efft_mod"

	if not caster:HasModifier(modifier) then return end

	local stacks = caster:GetModifierStackCount(modifier,keys.ability)

	keys.ability:ApplyDataDrivenModifier(caster, caster, modifier2, {}) --[[Returns:void
	No Description Set
	]]

	caster:SetModifierStackCount(modifier,keys.ability,stacks-1)

	if stacks-1 <= 0 then
		caster:RemoveModifierByName(modifier)
		caster:RemoveModifierByName(modifier2)
	end
end

function convokeBlast(keys)
	local caster = keys.caster
	local target = keys.target
	local dmg = keys.damage
	local stack = caster:GetModifierStackCount("elena_convoke_mod",keys.ability)

	local amount = dmg*stack

	if amount > keys.max_damage then amount = keys.max_damage end

	if amount <= 0  then keys.ability:EndCooldown() keys.ability:RefundManaCost() return end

	caster:RemoveModifierByName("elena_convoke_mod")

	if target:GetTeam() == caster:GetTeam() then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elena/elena_heal.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) --[[Returns:void
		No Description Set
		]]
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true) --[[Returns:void
		No Description Set
		]]

		target:Heal(amount, caster) --[[Returns:void
		Heal this unit.
		]]
		target:GiveMana(amount*0.5) --[[Returns:void
		Give mana to this unit, this can be used for mana gained by abilities or item usage.
		]]
		caster:EmitSound("Hero_Medusa.MysticSnake.Return")
		return
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elena/elena_damage.vpcf", PATTACH_CUSTOMORIGIN, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) --[[Returns:void
	No Description Set
	]]
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true) --[[Returns:void
	No Description Set
	]]

	DealDamage(target,caster,dmg*stack,DAMAGE_TYPE_MAGICAL)
	target:ReduceMana(amount*0.5) --[[Returns:void
	Remove mana from this unit, this can be used for involuntary mana loss, not for mana that is spent.
	]]
	caster:EmitSound("Hero_Dazzle.Weave")
end

function devotionCheck(keys)
	local caster = keys.caster
	local range = keys.radius

	local _found = FindUnitsInRadius( caster:GetTeamNumber(),
                          caster:GetCenter(),
                          nil,
                            range,
                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                            DOTA_UNIT_TARGET_HERO,
                            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                            FIND_CLOSEST,
                            false)

	if #_found > 1 then
		for k,v in pairs(_found) do
			keys.ability:ApplyDataDrivenModifier(caster, v, "elena_devotion_mod_aura", {}) --[[Returns:void
			No Description Set
			]]
			v:SetModifierStackCount("elena_devotion_mod_aura",keys.ability,#_found)
			keys.ability:ApplyDataDrivenModifier(caster, v, "elena_devotion_mod_remover", {}) --[[Returns:void
			No Description Set
			]]
		end
	end
end

function divergeShow(keys)
	local caster = keys.caster
	local unit = caster.diverge_unit
	if unit.divergeDamage == nil then return end
	PopupSpecDamage(caster,math.ceil(unit.divergeDamage))
end

function divergeCheck(keys)
	local caster = keys.caster
	local unit = caster.diverge_unit
	local target = keys.unit
	local dmg = keys.dmg
	local rd = 1-math.abs(keys.reduction/100)
	print("[divergeCheck] reduction is "..rd)
	local return_damage = keys.return_damage

	local dmg_before_rd = (1/rd) * dmg -- damage before reduction takes place

	print("[divergeCheck] damage is "..dmg_before_rd.." with "..dmg.." being multiplied by "..(1/rd))
	
	if unit.divergeDamage == nil then unit.divergeDamage = 0 else unit.divergeDamage = unit.divergeDamage end

	unit.divergeDamage = unit.divergeDamage+dmg_before_rd

	print("[DIVERGE] Damage is at "..unit.divergeDamage)
end

function divergeCheckforCaster(keys)
	local caster = keys.caster
	local unit = caster.diverge_unit
	local threshold = keys.threshold

	if unit.divergeDamage == nil then return end

	while unit.divergeDamage > threshold do
		local stack = 1
		if unit:HasModifier("elena_diverge_owner_mod") then
			stack = unit:GetModifierStackCount("elena_diverge_owner_mod",keys.ability)
		else
			keys.ability:ApplyDataDrivenModifier(caster, unit, "elena_diverge_owner_mod", {})
		end
		caster:SetModifierStackCount("elena_diverge_owner_mod",keys.ability,stack+1)
		caster.divergeDamage = caster.divergeDamage - threshold
	end
end

function divergeReset(keys)
	local caster = keys.caster
	local unit = caster.diverge_unit
	local radius = keys.rds

	ParticleManager:DestroyParticle(caster.diverge_particle, false)

	unit:RemoveModifierByName("elena_diverge_mod_efft")

	unit:RemoveSelf()

	if unit.divergeDamage == nil or caster.divergeDamage == 0 then return end
end

function divergeDeal(keys)
	local caster = keys.caster
	local unit = caster.diverge_unit
	local radius = keys.rds or keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local return_damage = (keys.return_damage or 100)/100

	if unit.divergeDamage == nil or unit.divergeDamage == 0 then return end

	local enemy = FindUnitsInRadius( caster:GetTeamNumber(),
                          unit:GetCenter(),
                          nil,
                            radius,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_CLOSEST,
                            false)

	for k,v in pairs(enemy) do
		DealDamage(v, caster, unit.divergeDamage*0.1, DAMAGE_TYPE_MAGICAL)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
		Creates a new particle effect
		]]
		--[[ParticleManager:SetParticleControl(particle, 0, Vector(0,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		PopupDamage(v,math.ceil(unit.divergeDamage*0.1))
	end

	caster:EmitSound("Hero_Chen.TestOfFaith") --[[Returns:void
	 
	]]
end

function divergeBlast(keys)
	local caster = keys.caster
	local target = keys.target
	local stack = caster:GetModifierStackCount("elena_diverge_owner_mod",keys.ability)
	local dmg = keys.dmg

	local amt = stack*dmg

	DealDamage(target,caster,amt,DAMAGE_TYPE_MAGICAL)
end

function divergeStart(keys)
	local caster = keys.caster

	local radius = keys.radius or keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel()) --[[Returns:table
	No Description Set
	]]

	local u = FastDummy(caster:GetCursorPosition(),caster:GetTeam(),40,radius)
	caster.diverge_unit = u

	keys.ability:ApplyDataDrivenModifier(caster, u, "elena_diverge_owner_mod", {}) --[[Returns:void
	No Description Set
	]]
	keys.ability:ApplyDataDrivenModifier(caster, u, "elena_diverge_mod_efft", {}) --[[Returns:void
	No Description Set
	]]
	keys.ability:ApplyDataDrivenModifier(caster, u, "elena_modifier_channeling", {}) --[[Returns:void
	No Description Set
	]]

	caster.diverge_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elena/elena_diverge_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) --[[Returns:int
	Creates a new particle effect
	]]
	-- ParticleManager:SetParticleControl(caster.dp, 0, Vector(0,0,0)) --[[Returns:void
	-- Set the control point data for a control on a particle effect
	-- ]]
	ParticleManager:SetParticleControl(caster.diverge_particle, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end


function applyShield(keys)
	local caster = keys.caster
	local target = keys.target

	local pct = keys.pc/100

	local amount = math.ceil(target:GetHealthDeficit() * pct)

	if amount <= 0 then return end

	keys.ability:ApplyDataDrivenModifier(caster, target, "elena_graveguard_mod_shld", {}) --[[Returns:void
	No Description Set
	]]

	target:SetModifierStackCount("elena_graveguard_mod_shld",keys.ability,amount)
end