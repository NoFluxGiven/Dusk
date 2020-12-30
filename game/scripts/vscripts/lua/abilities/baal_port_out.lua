baal_port_out = class({})

function baal_port_out:OnSpellStart()
	local caster = self:GetCaster()
	local unit = caster.spatial_rift_unit

	local main_ability = caster:FindAbilityByName("baal_spatial_rift")

	if unit and main_ability then
		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		
		point = unit:GetAbsOrigin()

		local temp_unit = FastDummy(caster:GetCenter(),caster:GetTeam(),2,350)

		ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_rift_shockwave_port.vpcf",PATTACH_ROOTBONE_FOLLOW,temp_unit)

		unit:EmitSound("Hero_Puck.EtherealJaunt")

		Timers:CreateTimer(0.06, function()
			ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_rift_shockwave_port.vpcf",PATTACH_ROOTBONE_FOLLOW,caster)

			FindClearSpaceForUnit(caster, point, true) --[[Returns:void
			Place a unit somewhere not already occupied.
			]]

			ProjectileManager:ProjectileDodge(caster) --[[Returns:void
			Makes the specified unit dodge projectiles
			]]

			caster:RemoveModifierByName("modifier_spatial_rift_display")

			main_ability:EndRift(false)
		end)
	end
end