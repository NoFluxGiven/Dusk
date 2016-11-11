function purge(keys)
	local caster = keys.caster
	local target = keys.target

	if caster:GetTeam() == target:GetTeam() then

		target:Purge(false,true,false,false,false)

	else

		target:Purge(true,false,false,false,false)

	end

	keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1) --[[Returns:void
	Set the number of charges on this item
	]]

	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel()))

	ParticleManager:CreateParticle("particles/items/purging_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]

	target:EmitSound("PurgingDust") --[[Returns:void
	 
	]]

	if keys.ability:GetCurrentCharges() <= 0 then
		keys.ability:RemoveSelf()
	end
end