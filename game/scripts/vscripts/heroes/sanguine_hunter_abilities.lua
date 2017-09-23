function consume_health(keys)
	local caster = keys.caster
	local dmg = keys.dmg

	local hp = caster:GetMaxHealth()
	local c = caster:GetHealth()

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_claw_damage_bonus", {}) --[[Returns:void
		No Description Set
		]]
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_soul_claw_damage_bonus_show_eff", {}) --[[Returns:void
		No Description Set
		]]

	local s = caster:GetModifierStackCount("modifier_soul_claw_damage_bonus", caster)

	local health_per_tick = hp/(20*3)
	local damage_per_tick = dmg/(2.0)

	caster:SetHealth(c-health_per_tick)

	caster:SetModifierStackCount("modifier_soul_claw_damage_bonus", caster, s+math.ceil(damage_per_tick))

	if caster:GetHealth() < 1 then caster:SetHealth(1) caster:Interrupt() end
end

function soul_claw_charge_end(keys)
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_soul_claw_charge_up")
end

function soul_claw_hit(keys)
	local caster = keys.caster
	local target = keys.target

	local hp = target:GetHealth()

	local steal = (keys.health_steal or 30)/100

	local dmg = caster:GetModifierStackCount("modifier_soul_claw_damage_bonus",caster)

	-- particle effect

	keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_soul_claw_slow", {}) --[[Returns:void
	No Description Set
	]]

	if target:IsHero() then
		caster:Heal(hp*steal,caster)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
		caster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
	elseif CheckClass(target,"npc_dota_building") then
		caster:EmitSound("Hero_Axe.Culling_Blade_Success")
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
	else
		if CheckClass(target,"npc_dota_roshan") then steal = steal *0.25 end
		caster:Heal(hp*steal*0.5,caster)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
		caster:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_sanguine_hunter/sanguine_hunter_soul_claw_hit.vpcf", PATTACH_ROOTBONE_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]

	caster:EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")
	caster:EmitSound("Hero_Axe.Attack")

	caster:RemoveModifierByName("modifier_soul_claw_damage_bonus")
	caster:RemoveModifierByName("modifier_soul_claw_damage_bonus_show_eff")
end

function lifelink_start(keys)
	local caster = keys.caster
	local target = keys.target

	if caster == target then keys.ability:RefundManaCost() keys.ability:EndCooldown() return end

	caster:EmitSound("Hero_Meepo.Poof.Channel.Crystal")

	if caster:GetTeam() == target:GetTeam() then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_lifelink_ally", {}) --[[Returns:void
		No Description Set
		]]
	else
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_lifelink_enemy", {}) --[[Returns:void
		No Description Set
		]]
	end

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_lifelink_caster", {}) --[[Returns:void
		No Description Set
		]]
end

function lifelink_deal(keys)
	local attacker = keys.attacker
	local caster = keys.caster -- owner
	local target = keys.unit
	local dmg = keys.dmg
	local pct = keys.heal / 100

	--if target == caster then return end

	if target:GetHealth() <= dmg*pct then return end

	caster:Heal(dmg*pct,caster)

	ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
end

function lifelink_take(keys)
	local attacker = keys.attacker
	local caster = keys.caster -- owner
	local target = keys.target -- owner
	local dmg = keys.dmg
	local pct = keys.heal / 100

	if target == caster then return end

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetCenter(),
	                              nil,
	                                FIND_UNITS_EVERYWHERE,
	                                DOTA_UNIT_TARGET_TEAM_BOTH,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	                                FIND_CLOSEST,
	                                false)

	for k,v in pairs(enemy_found) do
		if v:HasModifier("modifier_lifelink_ally") then
			v:Heal(dmg*pct,caster)
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,v)
		end
		--if v:HasModifier("modifier_lifelink_enemy") then
			--DealDamage(v,caster,dmg*pct,DAMAGE_TYPE_PURE)
		--end
	end
end

function sadistic_check(keys)
	local caster = keys.caster
	local threshold =  keys.threshold

	local radius = keys.radius

	local modifier = "modifier_sadistic_regen"

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetCenter(),
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO,
	                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
	                                FIND_CLOSEST,
	                                false)

	local count = 0

	for k,v in pairs(enemy_found) do
		if v:GetHealthPercent() < threshold then
			count = count+1
		end
	end

	local s = count

	if s > 0 then
		keys.ability:ApplyDataDrivenModifier(caster, caster, modifier, {}) --[[Returns:void
		No Description Set
		]]
	else
		caster:RemoveModifierByName(modifier) --[[Returns:void
		Removes a modifier
		]]
	end

	caster:SetModifierStackCount(modifier,caster,s)
end

function sadistic_attack(keys)
	local caster = keys.caster
	local lifesteal = keys.lifesteal/100
	local threshold = keys.threshold
	local dmg = keys.dmg

	local target = keys.target

	if not target:IsHero() then lifesteal = lifesteal/2 end

	if target:GetTeam() == caster:GetTeam() then return end

	if CheckClass(target,"npc_dota_building") then return end

	if target:GetHealthPercent() < threshold then
		caster:Heal(dmg*lifesteal,caster)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN,caster)
	end
end

function sadistic_dmg(keys)
	local caster = keys.caster
	local target = keys.target
	local attacker = keys.attacker

	local dmg = keys.dmg
	local regen = keys.regen/100

	local maxregen = keys.maxregen or 100

	local amt = math.ceil(dmg*regen)

	ToolsPrint("REGEN IS "..amt)

	if target == attacker then return end

	local s = caster:GetModifierStackCount("modifier_sadistic_regen",caster)

	ToolsPrint("STACKS ARE "..s)

	if caster.sadistic_table == nil then caster.sadistic_table = {} end

	table.insert(caster.sadistic_table, amt)

	if s+amt > maxregen then 
		caster:SetModifierStackCount("modifier_sadistic_regen",caster,maxregen)
	else
		caster:SetModifierStackCount("modifier_sadistic_regen",caster,s+amt)
	end

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_sadistic_regen_timer", {}) --[[Returns:void
	No Description Set
	]]
end

function sadistic_pop(keys)
	local caster = keys.caster

	if caster.sadistic_table == nil then
		if caster:HasModifier("modifier_sadistic_regen") then
			caster:SetModifierStackCount("modifier_sadistic_regen",caster,0) return
		end
	end

	local s = caster:GetModifierStackCount("modifier_sadistic_regen",caster)

	local amt = table.remove(caster.sadistic_table)

	if s-amt < 0 then amt = s end

	caster:SetModifierStackCount("modifier_sadistic_regen",caster,s-amt)
end

function bloodcall_start(keys)
	local caster = keys.caster
	local target = keys.target

	local hp = caster:GetHealth()

	local consume = keys.consume/100
	local pct = keys.pct/100

	local duration = keys.duration

	local amt = math.ceil(hp-(hp*consume))

	caster:SetHealth(amt)

	caster:EmitSound("Hero_Invoker.Invoke")
	target:EmitSound("Hero_LifeStealer.Infest")

	if target:GetTeam() == caster:GetTeam() then

		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bloodcall_ally_heal", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		target:SetModifierStackCount("modifier_bloodcall_ally_heal",caster,math.ceil(amt*pct))

	else

		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bloodcall_enemy_hurt", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		target:SetModifierStackCount("modifier_bloodcall_enemy_hurt",caster,math.ceil(amt*pct))
	
	end
end

function bloodcall_damage(keys)
	local caster = keys.caster
	local target = keys.target

	local s = target:GetModifierStackCount("modifier_bloodcall_enemy_hurt",caster)

	if s > 0 then
		DealDamage(target,caster,s,DAMAGE_TYPE_MAGICAL)
	end
end