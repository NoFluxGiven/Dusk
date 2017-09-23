function Shatter(keys)
	local caster = keys.caster
	local target = keys.target

	local attackdamage = caster:GetAttackDamage()
	ToolsPrint(attackdamage.." DAMAGE")
	local mult = keys.mult

	local damage = attackdamage * mult

	if caster:PassivesDisabled() then return end

	if keys.ability:IsCooldownReady() then
		if caster:IsIllusion() then return end
		if CheckClass(target,"npc_dota_building") then return end
		if caster:GetTeam() == target:GetTeam() then return end
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_alroth_shatter", {}) --[[Returns:void
		No Description Set
		]]
		DealDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
		target:ReduceMana(damage*2)
		caster:RemoveModifierByName("modifier_alroth_shatter_user")
		keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()-1))
		caster:EmitSound("Alroth.Shatter")
	end
end

function ShatterCheck(keys)
	local caster = keys.caster
	if keys.ability:IsCooldownReady() then
		if caster:IsIllusion() then return end
		keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_alroth_shatter_user",{})
	end
end

function SolchargeStart(keys)
	local caster = keys.caster
	local target = caster:GetCursorPosition()

	local dir = (target - caster:GetAbsOrigin()):Normalized()

	local dist = (target - caster:GetAbsOrigin()):Length2D()

	caster.solcharge_target = target

	--caster:AddNoDraw()

	caster.solcharge_counter = 0

	caster:EmitSound("Alroth.Solcharge")

	keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_alroth_solcharge_core",{})

	caster:SetModelScale(0.1)

	local speed = 1250

	local time = dist/speed

	if time < 0.5 then
		time = 0.5

		speed = dist*time
	end

	Physics:Unit(caster)
  caster:SetPhysicsFriction(0)
  caster:PreventDI(true)
  -- To allow going through walls / cliffs add the following:
  caster:FollowNavMesh(false)
  caster:SetAutoUnstuck(false)
  caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
  
  caster:SetPhysicsVelocity(dir*speed)
  caster:SetPhysicsAcceleration(Vector(0,0,-speed))

  Timers:CreateTimer(time,function()
  		caster:SetPhysicsVelocity(Vector(0,0,0))
  		caster:SetPhysicsAcceleration(Vector(0,0,0))
  		caster:PreventDI(false)
  		caster:RemoveModifierByName("modifier_alroth_solcharge_core")
  		--caster:RemoveNoDraw()
  		caster:SetModelScale(0.8)
  		caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
  	end)
end

function Solcharge(keys)
	local caster = keys.caster
	local target = caster.solcharge_target

	local dir = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()

	local maxtime = 2

	caster.solcharge_counter = caster.solcharge_counter+0.1

	if caster.solcharge_counter > maxtime then caster:SetAbsOrigin(target:GetAbsOrigin()) end

  if caster:GetRangeToUnit(target) < 60 then
  	caster:SetAbsOrigin(target:GetAbsOrigin())
  	caster:SetPhysicsVelocity(Vector(0,0,0))
  	caster:PreventDI(false)
  	caster:RemoveModifierByName("modifier_alroth_solcharge_core")
  	caster:RemoveNoDraw()
  end

  if target:IsAlive() == false then
  	caster:SetPhysicsVelocity(Vector(0,0,0))
  	caster:PreventDI(false)
  	caster:RemoveModifierByName("modifier_alroth_solcharge_core")
  	caster:RemoveNoDraw()
  end
end

function SolchargeEnd(keys)
	local caster = keys.caster

	caster:StopSound("Alroth.Solcharge")
end