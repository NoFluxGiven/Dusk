aether_disrupt = class({})

LinkLuaModifier("modifier_disrupt_slow_effect","lua/modifiers/modifier_disrupt_slow_effect",LUA_MODIFIER_MOTION_NONE)

function aether_disrupt:OnSpellStart()
	local caster = self:GetCaster()
	local range = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")

	-- if caster:HasTalent("aether_disrupt") then
	-- 	damage = damage + 60
	-- end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_aether/aether_disrupt.vpcf", PATTACH_ROOTBONE_FOLLOW, caster)

	caster:EmitSound("Hero_Wisp.Spirits.Target")

	local found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                                range,
                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,
                                false)

	for k,v in pairs(found) do
		ProjectileManager:ProjectileDodge(v)
	end

	local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                              caster:GetAbsOrigin(),
                              nil,
                                range,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,
                                false)

	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,damage,self:GetAbilityDamageType())
		v:AddNewModifier(caster, self, "modifier_disrupt_slow_effect", {Duration = duration}) --[[Returns:void
		No Description Set
		]]
	end

	if caster:IsHero() then

		local found_2 = FindUnitsInRadius( caster:GetTeamNumber(),
	                              caster:GetAbsOrigin(),
	                              nil,
	                                FIND_UNITS_EVERYWHERE,
	                                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	                                DOTA_UNIT_TARGET_ALL,
	                                DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	                                FIND_ANY_ORDER,
	                                false)

		for k,v in pairs(found_2) do
			if v:HasModifier("modifier_monolith_slow_area_ally") then
				-- print("FOUND A UNIT WITH PREREQUISITES")
				local ab = v:FindAbilityByName("aether_disrupt")
				ab:SetLevel(self:GetLevel())
				ab:OnSpellStart()
			end
		end

	end
end