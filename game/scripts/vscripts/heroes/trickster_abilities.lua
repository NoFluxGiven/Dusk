function poofstart(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local target = keys.target

	local who = nil
	local ae_table = {
		[1] = DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING,
		[2] = DOTA_MINIMAP_EVENT_ENEMY_TELEPORTING,
		[3] = DOTA_MINIMAP_EVENT_HINT_LOCATION
	}

	if target:GetTeam() == caster:GetTeam() then who = 1 else who = 2 end

	local position = target:GetAbsOrigin()+RandomVector(RandomInt(400, 600+(100*keys.ability:GetLevel())))

	local part2 = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", PATTACH_ABSORIGIN, target) --[[Returns:int
	Creates a new particle effect that only plays for the specified player
	]]

	ParticleManager:SetParticleControl(part2, 0, target:GetAbsOrigin()) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(part2, 1, Vector(200,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	target:AddNoDraw()

	target:EmitSound("Hero_Meepo.Earthbind.Target")

	if not target:IsRealHero() then target:Kill(keys.ability, caster) return end

	target.poofposition = position -- set the position they're going to appear at

	MinimapEvent(caster:GetTeamNumber(), caster, position["x"], position["y"],ae_table[who],3.8)

	local part = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_meepo/meepo_poof_start.vpcf", PATTACH_CUSTOMORIGIN, caster, player) --[[Returns:int
	Creates a new particle effect that only plays for the specified player
	]]

	ParticleManager:SetParticleControl(part, 0, position) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(part, 1, Vector(200,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	keys.ability:CreateVisibilityNode(position, 200, 4) --[[Returns:void
	No Description Set
	]]
end

function poofend(keys)
	local caster = keys.caster
	local target = keys.target

	if not target:IsAlive() then return end

	target:EmitSound("Hero_Meepo.Earthbind.Target")

	target:RemoveNoDraw()

	local part2 = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", PATTACH_ABSORIGIN, target) --[[Returns:int
	Creates a new particle effect that only plays for the specified player
	]]

	ParticleManager:SetParticleControl(part2, 0, target.poofposition) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(part2, 1, Vector(200,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	FindClearSpaceForUnit(target, target.poofposition, true)
end

function encorestart(keys)
	local caster = keys.caster
end