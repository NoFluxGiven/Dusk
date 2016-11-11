function Capture(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local maxcharge = keys.maxcharge
	local charges = 0
	local health_perc = keys.health_perc/100
	local mana_perc = keys.mana_perc/100

	if target:IsAncient() then return end

	if target:IsHero() or CheckClass(target,"npc_dota_roshan") then
		charges = keys.ability:GetCurrentCharges()
		if charges > 0 then
			target:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target")
			ParticleManager:CreateParticle("particles/items/grim_gauntlet_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			local final_dmg = charges*damage
			Timers:CreateTimer(0.75,function()
				DealDamage(target,caster,final_dmg/5,DAMAGE_TYPE_MAGICAL)

			end)
			local n = 0
			Timers:CreateTimer(0.75,function()
				target:EmitSound("Hero_WitchDoctor.Maledict_CastFail")
				ParticleManager:CreateParticle("particles/items/grim_gauntlet_hero_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				n = n+1
				DealDamage(target,caster,final_dmg/5,DAMAGE_TYPE_MAGICAL)
				if n < 4 then
					return 0.25
				end
			end
			)
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_grim_gauntlet_slow", {Duration=charges*0.75}) --[[Returns:void
			No Description Set
			]]
			local mod = target:FindModifierByName("modifier_grim_gauntlet_slow")

			mod:SetStackCount(charges)

			keys.ability:SetCurrentCharges(0)
		else
			keys.ability:RefundManaCost()
			keys.ability:EndCooldown()
			return
		end
	else
		charges = keys.ability:GetCurrentCharges()
		local hp = target:GetHealth()
		local amt_health = hp*health_perc
		local amt_mana = hp*mana_perc

		target:EmitSound("Hero_Warlock.FatalBonds")

		caster:Heal(amt_health, caster)
		caster:GiveMana(amt_mana)

		target:Kill(keys.ability, caster) --[[Returns:void
		Kills this NPC, with the params Ability and Attacker
		]]

		ParticleManager:CreateParticle("particles/items/grim_gauntlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]

		if charges < 4 then

			keys.ability:SetCurrentCharges(charges+1)

		end
	end
end