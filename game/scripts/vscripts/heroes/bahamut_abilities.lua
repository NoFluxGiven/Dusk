function Fulmination(keys)
	local caster = keys.caster
	local target = keys.target

	local max_stack = keys.maxs
	local dmg = keys.dmg

	if CheckClass(target,"npc_dota_building") then return end

	if caster:IsIllusion() then return end

	if target:IsMagicImmune() then return end

	if target:HasModifier("modifier_bahamut_fulmination_stack") then
		local stacks = target:GetModifierStackCount("modifier_bahamut_fulmination_stack",caster)
		local mult = math.floor(stacks/4)

		if stacks >= 4 then
			DealDamage(target,caster,dmg*mult,DAMAGE_TYPE_MAGICAL)
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_damage.vpcf", PATTACH_ROOTBONE_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			--ParticleManager:SetParticleControl(p, 0, target:GetCenter())
		end
		if stacks < max_stack then
			target:SetModifierStackCount("modifier_bahamut_fulmination_stack",caster,stacks+1)
			target.fulm_stacks = stacks+1
		end
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bahamut_fulmination_stack", {}) --[[Returns:void
		No Description Set
		]]
	else
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_bahamut_fulmination_stack", {}) --[[Returns:void
		No Description Set
		]]
		target:SetModifierStackCount("modifier_bahamut_fulmination_stack",caster,1)
		target.fulm_stacks = 1
	end
end

function FulminationEnd(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local stacks = target:GetModifierStackCount("modifier_bahamut_fulmination_stack",caster)

	if not target:IsAlive() then return end

	if stacks < 1 then stacks = target.fulm_stacks end

	local dmg = stacks*damage

	local mult = math.floor(stacks/4)

	local percent = keys.percent

	local n = mult
	if n > 0 then
		while n > 0 do
			dmg = dmg*percent
			n = n-1
		end
	end

	if stacks > 0 then
		DealDamage(target,caster,dmg,DAMAGE_TYPE_MAGICAL)
		target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
		if stacks < 4 then
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
		elseif stacks < 8 then
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
		else
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/fulmination_detonate_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
		end
	end
end

function MegaFlare(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()

	local r = keys.radius
	local dmg = keys.damage
	local r2 = keys.radius2
	local dmg2 = keys.damage2

	local min = 750

	local d = (target - caster:GetAbsOrigin()):Normalized()

	local s = keys.speed

	local unit = FastDummy(caster:GetAbsOrigin()+Vector(0,0,350),caster:GetTeamNumber(),8,400)
	local distance_unit = FastDummy(target,caster:GetTeamNumber(),1,0)
	local distance = unit:GetRangeToUnit(distance_unit)
	if distance < min then
		distance = min
		target = caster:GetAbsOrigin()+(d*min)
	end
	local t = distance/s

	unit:EmitSound("Hero_Phoenix.SuperNova.Cast")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_bahamut/mega_flare_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]


	Physics:Unit(unit)
	  unit:SetPhysicsFriction(0)
	  unit:PreventDI(true)
	    -- To allow going through walls / cliffs add the following:
	  unit:FollowNavMesh(false)
	  unit:SetAutoUnstuck(false)
  	  unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)

  	unit:SetPhysicsVelocity(s * d)
  	unit:AddPhysicsVelocity(Vector(0,0,(-250/t)))

  	Timers:CreateTimer(t-0.45,function()
  		unit:EmitSound("Hero_Warlock.RainOfChaos_buildup")
  		unit:EmitSound("Hero_Dark_Seer.Surge")
  		end)

  	Timers:CreateTimer(t,function()
  		unit:EmitSound("Hero_Techies.StasisTrap.Stun")
  		unit:StopSound("Hero_Phoenix.SuperNova.Cast")
  		unit:ForceKill(true)
  		unit:SetPhysicsVelocity(Vector(0,0,0))
  		ParticleManager:DestroyParticle(p,false)
  		local enemy_inner = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        r,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                        FIND_CLOSEST,
                        false)
  		local enemy_outer = FindUnitsInRadius( caster:GetTeamNumber(),
                          target,
                          nil,
                        r2,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                        FIND_CLOSEST,
                        false)

  		for k,v in pairs(enemy_inner) do
  			DealDamage(v,caster,dmg,DAMAGE_TYPE_PURE)
  		end
  		for k,v in pairs(enemy_outer) do
  			DealDamage(v,caster,dmg2,DAMAGE_TYPE_PURE)
  		end

  		ScreenShake(caster:GetCenter(), 2400, 170, 2, 1200, 0, true)
  	end)

  	Timers:CreateTimer(t+2,function()

  	end)
end