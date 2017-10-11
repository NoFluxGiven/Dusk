function damage(keys)
	local caster = keys.caster
	local damage = keys.damage
	if caster:HasModifier("modifier_holding_orb_bide") then
		local mod = caster:FindModifierByName("modifier_holding_orb_bide")
		local s = mod:GetStackCount()

		if s > 0 then
			local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetCenter(),
                              nil,
                                500,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_CLOSEST,
                                false)
			for k,v in pairs(enemy_found) do
				DealDamage(v,caster,damage*s,DAMAGE_TYPE_MAGICAL)
			end
		end

		ParticleManager:CreateParticle("particles/items/holding_orb_glyph.vpcf", PATTACH_ABSORIGIN, caster) --[[Returns:int
				Creates a new particle effect
				]]

		caster:EmitSound("Item.LotusOrb.Activate")

		caster:RemoveModifierByName("modifier_holding_orb_bide")
	else
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_holding_orb_block", {}) --[[Returns:void
		No Description Set
		]]
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_holding_orb_bide", {}) --[[Returns:void
		No Description Set
		]]
		local mod = caster:FindModifierByName("modifier_holding_orb_bide")
		mod:IncrementStackCount()
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(2.75)

		caster:EmitSound("Item.LotusOrb.Target")

	end
end