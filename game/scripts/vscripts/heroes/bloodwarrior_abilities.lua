function CheckBloodfiend(keys)
	local caster = keys.caster
	local lvl = keys.ability:GetLevel()
	local player = caster:GetPlayerID()
	local aghs_bonus = 0
	if caster:HasScepter() then aghs_bonus = math.ceil((lvl)*2) end
	if caster:IsIllusion() then return end
	if keys.ability:IsCooldownReady() ~= true then return end
	if caster.summonBloodFiend ~= nil and caster.summonBloodFiend == true then
		if caster.hasBeenSummoned == false or caster.hasBeenSummoned == nil then
			print("Summoning bloodfiend!")
			ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/blood_curse_activate.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
			Creates a new particle effect
			]]
			keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_blood_curse_hide", {}) --[[Returns:void
			No Description Set
			]]
			caster:AddNoDraw()
			caster.summonBloodFiend = false
			caster.hasBeenSummoned = true
			local v = CreateUnitByName("npc_dota_unit_blood_fiend", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
			--v:SetPlayerID(caster:GetPlayerID())
			v:SetControllableByPlayer(player, true)
			--v:SetOwner(caster)
			v:CreatureLevelUp(lvl-1+aghs_bonus)
			v:AddNewModifier(caster, nil, "modifier_kill", {Duration=50}) --[[Returns:void
			No Description Set
			]]
			v:EmitSound("Hero_LifeStealer.Consume") --[[Returns:void
			 
			]]
			v:EmitSound("bloodseeker_blod_laugh_02") --[[Returns:void
			 
			]]
			local ab1 = v:FindAbilityByName("bloodfiend_feast")
			local ab2 = v:FindAbilityByName("bloodfiend_dive")
			ab1:SetLevel(1)
			ab2:SetLevel(1)
			if aghs_bonus > 0 then
				local ab3 = v:AddAbility("bloodfiend_berserk")
				ab3:SetLevel(1)
			end

			PlayerResource:SetDefaultSelectionEntity(player,v)
			PlayerResource:ResetSelection(player)
			if caster:GetTeam() == DOTA_TEAM_GOODGUYS then
				FindClearSpaceForUnit(caster, Vector(-7156,-6615,520), true)
			elseif caster:GetTeam() == DOTA_TEAM_BADGUYS then
				FindClearSpaceForUnit(caster, Vector(7042,6603,516), true) --[   VScript              ]: 7042.123046875	6603.5639648438	516.06188964844
			end

			caster:SetCursorTargetingNothing(true)
			ab2:OnSpellStart()

			ab2:StartCooldown(2)
		end
	end


end

function deadBloodfiend(keys) -- run by the Blood Fiend
	local caster = keys.caster:GetOwner()
	local attacker = keys.attacker
	local player = caster:GetPlayerID()

	local ab = caster:FindAbilityByName("bloodwarrior_blood_curse")
	ab:StartCooldown(ab:GetCooldown(ab:GetLevel()-1))

	if attacker == caster or attacker == caster:GetOwner() then attacker = caster.bloodfiendKiller end
	if attacker:IsNeutralUnitType() == true then attacker = caster.bloodfiendKiller end
	caster:RemoveModifierByName("modifier_blood_curse_hide") --[[Returns:void
	Removes a modifier
	]]
	print("Bloodfiend has died...")
	caster:RemoveNoDraw()
	PlayerResource:SetDefaultSelectionEntity(player,-1)
	caster:Kill(keys.ability, attacker)
	caster.hasBeenSummoned = false
end

function reviveBloodfiend(keys) -- run by the Blood Fiend
	local caster = keys.caster:GetOwner()
	local unit = keys.caster
	local player = caster:GetPlayerID()
	local noinc = keys.noincrement or 0

	if caster.ignoreKill then return end

	local mod = unit:FindModifierByName("modifier_blood_fiend_revive")

	if noinc ~= 1 then mod:SetStackCount(mod:GetStackCount()-1) end

	if mod:GetStackCount() <= 0 then

		local unit2 = FastDummy(unit:GetAbsOrigin(),caster:GetTeam(),4,0)

		local ab = caster:FindAbilityByName("bloodwarrior_blood_curse")
		ab:StartCooldown(ab:GetCooldown(ab:GetLevel()-1))

		keys.ability:ApplyDataDrivenModifier(caster, unit, "modifier_bloodfiend_protection", {}) --[[Returns:void
		No Description Set
		]]

		ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/blood_curse_revive.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit2) --[[Returns:int
			Creates a new particle effect
			]]
		unit:AddNewModifier(caster, nil, "modifier_stunned", {}) --[[Returns:void
		No Description Set
		]]
		unit:AddNewModifier(caster, nil, "modifier_kill", {}) --[[Returns:void
		No Description Set
		]]
		unit:EmitSound("Hero_Bloodseeker.BloodRite.Cast") --[[Returns:void
		 
		]]
		Timers:CreateTimer(1,function() unit:EmitSound("DOTAMusic_Hero.Reincarnate") end)
		Timers:CreateTimer(2,function()
			if caster:IsAlive() then
				local d = 2

				if caster:HasScepter() then d = 1 end

				caster:SetHealth(math.floor(caster:GetMaxHealth()/d))
				caster:SetMana(math.floor(caster:GetMaxMana()/d))
				caster:RemoveModifierByName("modifier_blood_curse_hide") --[[Returns:void
				Removes a modifier
				]]
				caster:RemoveNoDraw()
				local pos = unit:GetAbsOrigin()
				unit:RemoveSelf()
				FindClearSpaceForUnit(caster, pos, true) --[[Returns:void
				Place a unit somewhere not already occupied.
				]]

				PlayerResource:SetDefaultSelectionEntity(player,-1)

				caster.hasBeenSummoned = false
			end
		end)

	end
end

function bloodfiendInitialise(keys)
	local caster = keys.caster

	local mod1 = caster:FindModifierByName("modifier_blood_fiend_revive")
	mod1:SetStackCount(4)
end

function bloodfiendKill(keys)
	local caster = keys.caster
	if caster.ignoreKill then return end
	local target = keys.unit or keys.target
	local attacker = keys.attacker

	if target:IsRealHero() then
		local mod = caster:FindModifierByName("modifier_blood_fiend_revive")

		mod:SetStackCount(0)
		caster:SetHealth(caster:GetMaxHealth())
		caster:SetMana(caster:GetMaxMana())
	end
end

function feastKill(keys)
	local caster = keys.caster
	local target = keys.target
	caster.ignoreKill = true
	target:Kill(keys.ability,caster)
	caster.ignoreKill = false
	caster:SetHealth(caster:GetMaxHealth())
	caster:SetMana(caster:GetMaxMana())
end

function grapple(keys)
	local caster = keys.caster
	local target = keys.target
	local dmg = keys.dmg

	

	if target:IsHero() then dmg = keys.dmg end
	if target:IsHero() ~= true then dmg = keys.creepdmg end
	if target:HasModifier("modifier_bloodmark") then dmg = keys.markeddmg end

	print(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z)

	dmg = dmg/100

	local r = math.ceil(math.random(100))
	--if r < 10 then
		caster:EmitSound("Hero_Pudge.Dismember") --[[Returns:void
		 
		]]
	--end

	local hp = target:GetMaxHealth()
	local mp = target:GetMaxMana()

	local i = 0.1

	local hpdrain = hp*dmg*i
	local mpdrain = mp*dmg*i*0.5
	
	caster:Heal(hpdrain*1.5, caster) --[[Returns:void
	Heal this unit.
	]]

	DealDamage(target,caster,hpdrain,DAMAGE_TYPE_PURE)
	--target:SetHealth(target:GetHealth()-hpdrain)
	--if target:GetHealth() <= hpdrain then
	--	target:Kill(keys.ability, attacker) --[[Returns:void
	--	Kills this NPC, with the params Ability and Attacker
	--	]]
	--end

	caster:GiveMana(mpdrain*1.5)

	target:ReduceMana(mpdrain)
end

function redRitualStartDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local dmg = keys.dmg
	local stun = keys.stun

	if tgt(target) then target:RemoveModifierByName("modifier_bloodwarrior_red_ritual") return end

	local p = "particles/units/heroes/hero_bloodwarrior/red_ritual.vpcf"

	if target:HasModifier("modifier_bloodmark") then
		p = "particles/units/heroes/hero_bloodwarrior/red_ritual_marked_unit.vpcf"
		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun})
	end

	target:EmitSound("Hero_OgreMagi.Bloodlust.Target")
	target:EmitSound("hero_bloodseeker.rupture.cast")

	DealDamage(target,caster,dmg,DAMAGE_TYPE_MAGICAL)

	local pp = ParticleManager:CreateParticle(p, PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
end

function redRitualTickDamage(keys)	
	local caster = keys.caster
	local target = keys.target
	local dmg = keys.dmg
	local mdmg = keys.mdmg

	local fdmg = 0

	if target:HasModifier("modifier_bloodmark") then fdmg = mdmg else fdmg = dmg end

	DealDamage(target,caster,fdmg,DAMAGE_TYPE_MAGICAL)
end

function redRitualEnd(keys)
	local caster = keys.caster
	local target = keys.target

	if target:IsAncient() == true then return end


	if target:HasModifier("modifier_bloodmark") then target:RemoveModifierByName("modifier_bloodmark") else keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bloodmark", {Duration=12}) end
end

function bloodmarkAttacks(keys)
	local caster = keys.caster
	local target = keys.target

	local amt = keys.attack_damage*0.40

	if target:HasModifier("modifier_bloodmark") then
		--target:RemoveModifierByName("modifier_bloodmark")
		caster:Heal(amt, caster)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]
	end
end

function DanceOfDeath(keys)
	local caster = keys.caster
	local target = keys.target

	local team = target:GetTeam()

	if target == caster then keys.ability:EndCooldown() keys.ability:RefundManaCost() return end

	local pos = target:GetAbsOrigin()
	local dmg = keys.damage

	caster:EmitSound("Hero_PhantomLancer.SpiritLance.Throw") --[[Returns:void
	 
	]]

	if target:HasModifier("modifier_bloodmark") then
		keys.ability:EndCooldown()
		target:RemoveModifierByName("modifier_bloodmark")
		dmg = keys.mdamage
	end

	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/dod_end.vpcf", PATTACH_ABSORIGIN, caster) --[[Returns:int
	Creates a new particle effect
	]]

	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/dod_end.vpcf", PATTACH_ABSORIGIN, target) --[[Returns:int
	Creates a new particle effect
	]]

	ProjectileManager:ProjectileDodge(caster) --[[Returns:void
	Makes the specified unit dodge projectiles
	]]

	Timers:CreateTimer(0.06,function()
		FindClearSpaceForUnit(caster, pos, true)
		if target:GetTeam() ~= caster:GetTeam() then
			DealDamage(target,caster,dmg,DAMAGE_TYPE_MAGICAL)
		end
	end)
end