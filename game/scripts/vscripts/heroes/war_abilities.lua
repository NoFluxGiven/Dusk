function fight_me(keys)
	local caster = keys.caster
	local radius = keys.radius

	local mod = "modifier_fight_me"
	local mod2 = "modifier_fight_me_regen"

	local enemy_found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

	caster:Hold()

	caster:EmitSound("War.FightMe")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	caster.fight_me_damage = caster:GetAverageTrueAttackDamage(caster)

	for k,v in pairs(enemy_found) do
		keys.ability:ApplyDataDrivenModifier(caster, v, mod, {}) --[[Returns:void
		No Description Set
		]]
		local atk_dmg = v:GetAverageTrueAttackDamage(v)
		caster.fight_me_damage = caster.fight_me_damage + atk_dmg
	end

	keys.ability:ApplyDataDrivenModifier(caster, caster, mod2, {}) --[[Returns:void
	No Description Set
	]]
end

function fight_me_force_attack(keys)
	local caster = keys.caster
	local target = keys.target

	target:SetForceAttackTarget(nil)
	if caster:IsAlive() then
		Orders:IssueAttackOrder(target,caster)
	else
		local mod = target:FindModifierByName("modifier_fight_me")
		if mod then
			mod:Destroy()
		end
	end
	target:SetForceAttackTarget(target)
end

function fight_me_force_attack_end(keys)
	local caster = keys.caster
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function fight_me_gather_damage(keys)
	local caster = keys.target or keys.unit
	local attacker = keys.attacker

	-- if attacker and caster then
	-- 	if caster.fight_me_damage then
	-- 		caster.fight_me_damage = caster.fight_me_damage+(attack_damage*damage)
	-- 		print("Added "..(attack_damage*damage).." for a total of "..caster.fight_me_damage)
	-- 	else
	-- 		caster.fight_me_damage = attack_damage*damage
	-- 	end
	-- end
end

function fight_me_release_damage(keys)
	local caster = keys.caster
	local radius = keys.radius

	if caster.fight_me_damage then
		local enemy_found = FindEnemies(caster,caster:GetAbsOrigin(),radius)
		caster:EmitSound("Hero_Axe.Berserkers_Call") --[[Returns:void
		 
		]]
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		for k,v in pairs(enemy_found) do
			DealDamage(v,caster,caster.fight_me_damage,DAMAGE_TYPE_MAGICAL)
		end

		caster.fight_me_damage = 0

	end
end

function earthbreaker(keys)
	local caster = keys.caster
	local point = caster:GetAbsOrigin()+caster:GetForwardVector()*150

	local damage = keys.damage
	local radius = keys.radius
	local stun = keys.stun

	local unit = FastDummy(point,caster:GetTeam(),2,0)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_war/earthbreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	unit:EmitSound("War.Earthbreaker")

	local enemy_found = FindEnemies(caster,unit:GetAbsOrigin(),radius)

	ScreenShake(unit:GetCenter(), 1000, 3, 0.75, 1500, 0, true)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			DealDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
			v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
			No Description Set
			]]
		end
	end
end

function BerserkerAura(keys)
	local caster = keys.caster
	local target = keys.target

	local dmg = keys.dmg
	local atk = keys.atk

	local pct = 1-target:GetHealthPercent()/100

	if caster:PassivesDisabled() then return end

	local fdmg = math.floor(dmg*pct)
	local fatk = math.floor(atk*pct)

	if fdmg > 0 then

		local dmg_mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_berserker_aura_bonuses_dmg", {}) --[[Returns:void
		No Description Set
		]]
		dmg_mod:SetStackCount(fdmg)

	end

	if fatk > 0 then

		local atk_mod = keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_berserker_aura_bonuses_atk", {}) --[[Returns:void
		No Description Set
		]]
		atk_mod:SetStackCount(fatk)

	end
end