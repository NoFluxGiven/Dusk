erra_morbid_blade = class({})

if IsServer() then

	function erra_morbid_blade:OnSpellStart()
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()

		local radius = self:GetSpecialValueFor("radius")
		local threshold = self:GetSpecialValueFor("pure_threshold")

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_erra_1") or 0

		local damage = self:GetAbilityDamage() + t_damage_bonus
		local lifesteal = (self:GetSpecialValueFor("lifesteal")/100)

		local sound = "Erra.MorbidBlade"
		local particle = "particles/units/heroes/hero_erra/morbid_blade.vpcf"

		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
	                  point,
	                  nil,
	                    radius,
	                    DOTA_UNIT_TARGET_TEAM_ENEMY,
	                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
	                    DOTA_UNIT_TARGET_FLAG_NONE,
	                    FIND_CLOSEST,
	                    false)
		-- Check for Health amount
		local damage_type = DAMAGE_TYPE_PHYSICAL
		for k,v in pairs(enemy_found) do
			if v:GetHealthPercent() < threshold then
				damage_type = DAMAGE_TYPE_PURE
				local cooldown = self:GetCooldownTimeRemaining()
				self:EndCooldown()
				self:StartCooldown(cooldown*0.5)
				sound = "Erra.MorbidBlade.Pure"
				particle = "particles/units/heroes/hero_erra/morbid_blade_below_threshold.vpcf"
				break
			end
		end

		local unit = FastDummy(point,caster:GetTeam(),2,radius)

		local p = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		unit:EmitSound(sound)

		for k,v in pairs(enemy_found) do
			DealDamage(v,caster,damage,damage_type)

			if v:IsHero() then
				caster:Heal(v:GetHealthDeficit()*lifesteal,caster)
			else
				caster:Heal(v:GetHealthDeficit()*(lifesteal*0.5),caster)
			end
		end
	end

end