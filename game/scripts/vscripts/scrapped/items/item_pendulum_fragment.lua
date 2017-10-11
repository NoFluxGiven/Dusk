function activate(keys)
	local caster = keys.caster

	caster:Interrupt()
	caster:Stop()

	print(caster:GetName())

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_pendulum_fragment_activate", {}) --[[Returns:void
	No Description Set
	]]

	ProjectileManager:ProjectileDodge(caster)

	--keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1)

	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))

	caster:AddNoDraw()

	Timers:CreateTimer(0.5,function() caster:RemoveNoDraw() end)

	local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),1,0)

	unit:EmitSound("PendulumFragment")

	ParticleManager:CreateParticle("particles/items/pendulum_fragment.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	--if keys.ability:GetCurrentCharges() <= 0 then
	--	keys.ability:RemoveSelf()
	--end
end

function activate_elysian(keys)
	local caster = keys.caster

	print(caster:GetName())

	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_elysian_timepiece_activate", {}) --[[Returns:void
	No Description Set
	]]

	ProjectileManager:ProjectileDodge(caster)

	--keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1)

	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))

	caster:AddNoDraw()

	local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),2,0)

	caster.elys_unit = unit

	unit:EmitSound("PendulumFragment")

	caster.elys_part = ParticleManager:CreateParticle("particles/items/elysian_timepiece.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]

	--if keys.ability:GetCurrentCharges() <= 0 then
	--	keys.ability:RemoveSelf()
	--end
end

function stop_elysian(keys)
	local caster = keys.caster
	ParticleManager:DestroyParticle(caster.elys_part,false)
	caster:RemoveNoDraw()
	caster:RemoveModifierByName("modifier_elysian_timepiece_activate")
end

function check_damage(keys)
	local caster = keys.caster

	local dmg = keys.damage

	local attacker = keys.attacker

	if attacker:IsHero() or attacker:GetOwner():IsHero() then

		print("Pendulum Fragment take damage event")

		if dmg > 20 then
			keys.ability:StartCooldown(3)
		end
		
	end
end