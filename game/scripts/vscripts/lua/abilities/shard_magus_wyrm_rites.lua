shard_magus_wyrm_rites = class({})

function shard_magus_wyrm_rites:OnSpellStart()
	local caster = self:GetCaster()
	local origin = self:GetCursorPosition()

	local delay = self:GetSpecialValueFor("delay")
	local duration = self:GetSpecialValueFor("duration")

	local t_lvl_bonus = FetchTalent("special_bonus_shard_magus_5")

	local lvl = self:GetSpecialValueFor("level")
	local radius = self:GetSpecialValueFor("radius")

	-- local t_damage_bonus = FetchTalent("special_bonus_shard_magus_6") or 0

	local unit_name = "npc_dota_unit_ice_wyrm"
	local player = caster:GetPlayerID()

	local u = CreateModifierThinker( self:GetCaster(), self, "modifier_true_sight",
		{Duration=delay+1},
		origin, self:GetCaster():GetTeamNumber(), false)

	u:EmitSound("ShardMagus.WyrmRites.Start")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/wyrm_rites.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)

	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	Timers:CreateTimer(delay,function()

		local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_shard_magus/wyrm_rites_summon.vpcf", PATTACH_ABSORIGIN_FOLLOW, u)

		u:EmitSound("ShardMagus.WyrmRites")

		ParticleManager:DestroyParticle(p,false)

		local unit = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		-- unit:SetPlayerID(caster:GetPlayerID())
		unit:SetOwner(caster)
		unit:SetControllableByPlayer(player, true)
		unit:AddNewModifier(caster, nil, "modifier_kill", {Duration=duration})
		unit:AddNewModifier(caster, nil, "modifier_phased", {Duration=1})

		unit:CreatureLevelUp(lvl-1)

		unit:EmitSound("Hero_Ancient_Apparition.IceVortex")

		local bdmax = unit:GetBaseDamageMax()
		local bdmin = unit:GetBaseDamageMin()

		-- unit:SetBaseDamageMax(bdmax+t_damage_bonus)
		-- unit:SetBaseDamageMin(bdmin+t_damage_bonus)

		local ab1,ab2,ab3 = unit:FindAbilityByName("ice_wyrm_winters_breath"), unit:FindAbilityByName("ice_wyrm_glacial_impact"), unit:FindAbilityByName("ice_wyrm_frostfall")

		ab1:SetLevel(self:GetLevel())
		ab2:SetLevel(self:GetLevel())
		ab3:SetLevel(self:GetLevel())

	end)
end