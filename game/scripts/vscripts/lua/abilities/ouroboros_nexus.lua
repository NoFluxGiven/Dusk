ouroboros_nexus = class({})

LinkLuaModifier("modifier_nexus_thinker","lua/abilities/ouroboros_nexus",LUA_MODIFIER_MOTION_NONE)

function ouroboros_nexus:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	CreateModifierThinker(caster, self, "modifier_nexus_thinker", {}, point, caster:GetTeamNumber(), false)
end

modifier_nexus_thinker = class({})

if IsServer() then

	function modifier_nexus_thinker:OnCreated()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		local sound = "Ability.PreLightStrikeArray"
		local sound2 = "Hero_Invoker.SunStrike.Charge.Apex"

		local particle = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"

		local p = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:GetParent():EmitSound(sound)
		self:GetParent():EmitSound(sound2)

		self:StartIntervalThink(delay)
	end

	function modifier_nexus_thinker:OnIntervalThink()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		
		local t_stun_duration_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_ouroboros_1") or 0
		local stun = self:GetAbility():GetSpecialValueFor("stun")+t_stun_duration_bonus

		local t_pure_piercing = self:GetAbility():GetCaster():FindTalentValue("special_bonus_ouroboros_6")
		local damage = self:GetAbility():GetAbilityDamage()
		local dtype = self:GetAbility():GetAbilityDamageType()

		if t_pure_piercing then dtype = DAMAGE_TYPE_PURE end

		local particle = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
		local particle2 = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
		local sound = "Ability.LightStrikeArray"
		local sound2 = "Hero_Invoker.SunStrike.Ignite.Apex"

		local p = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		local p2 = ParticleManager:CreateParticle(particle2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p2, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:GetParent():EmitSound(sound)
		self:GetParent():EmitSound(sound2)

		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), radius, false )
		local f = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),radius)

		for k,v in pairs(f) do
			local block = v:IsMagicImmune() and not t_pure_piercing
			if not block then
				self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,dtype)
				v:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
				No Description Set
				]]
			end
		end

		self:StartIntervalThink(-1)

		Timers:CreateTimer(8,function() UTIL_Remove(self:GetParent()) end)
	end

end