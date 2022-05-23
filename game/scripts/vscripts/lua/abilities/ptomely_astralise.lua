ptomely_astralise = class({})

LinkLuaModifier("modifier_astralise","lua/abilities/ptomely_astralise",LUA_MODIFIER_MOTION_NONE)

function ptomely_astralise:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_duration_bonus = caster:FindTalentValue("special_bonus_ptomely_3") or 0

	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus
	local damage = self:GetSpecialValueFor("damage")

	local enemy = caster:GetTeam() ~= target:GetTeam()

	if target:TriggerSpellAbsorb(self) then return end

	target:EmitSound("Ptomely.Astralise")

	if enemy then
		self:InflictDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL)
	end

	target:AddNewModifier(caster, self, "modifier_astralise", {Duration=duration})
end

modifier_astralise = class({})

function modifier_astralise:GetEffectName()
	return "particles/units/heroes/hero_ptomely/astralise_unit_buff.vpcf"
end

function modifier_astralise:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_astralise:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	}
	return func
end

function modifier_astralise:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_astralise:GetOverrideAnimationRate()
	return 0.5
end

function modifier_astralise:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_astralise:OnCreated(kv)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()
		local duration = self:GetDuration()
		local loc = target:GetAbsOrigin() + target:GetForwardVector()*-200

		loc = loc + Vector(0,0,90)

		local unit = FastDummy(loc,caster:GetTeam(),duration+0.1,0)

		target.astralise_unit = unit

		ParticleManager:CreateParticle("particles/units/heroes/hero_ptomely/astralise_ghost.vpcf",
			PATTACH_ABSORIGIN_FOLLOW, unit)
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_astralise:OnIntervalThink()
	if IsServer() then
		local target = self:GetParent()
		if target.astralise_unit then
			local loc = target.astralise_unit:GetAbsOrigin()
			local radius = self:GetAbility():GetSpecialValueFor("radius")
			local pct = self:GetAbility():GetSpecialValueFor("pulse_damage")/100
			local heal_pct = self:GetAbility():GetSpecialValueFor("ally_heal")/100

			local damage = 0
			local heal = 0

			if target:IsHero() then
				damage = self:GetParent():GetIntellect() * pct
				heal = self:GetParent():GetIntellect() * heal_pct
			end

			local enemies = FindEnemies(self:GetAbility():GetCaster(), loc, radius)
			local allies = FindAllies(self:GetAbility():GetCaster(), loc, radius)

			for k,v in pairs(enemies) do
				self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
				print(v:GetName())
			end

			for k,v in pairs(allies) do
				v:Heal(heal, self:GetAbility():GetCaster())
			end

			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_ptomely/astralise_pulse.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(p, 0, loc)
			ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

			target.astralise_unit:EmitSound("Ptomely.AstralisePulse")
		end
	end
end