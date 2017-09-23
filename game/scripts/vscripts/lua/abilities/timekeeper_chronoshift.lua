timekeeper_chronoshift = class({})

LinkLuaModifier("modifier_chronoshift","lua/abilities/timekeeper_chronoshift",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chronoshift_caster","lua/abilities/timekeeper_chronoshift",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chronoshift_end","lua/abilities/timekeeper_chronoshift",LUA_MODIFIER_MOTION_NONE)

function timekeeper_chronoshift:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("time")

	local ab = caster:FindAbilityByName("timekeeper_chronoshift_end") --[[Returns:handle
	Retrieve an ability by name from the unit.
	]]

	local mod = self:StartChronoshift(caster,target,duration)

	self:SetHidden(true)
	ab:SetHidden(false)

	ab:SetLevel(1)

	ab.chronoshift_modifier = mod
	ab.chronoshift_ability = self
	ab.chronoshift_target = target
end

function timekeeper_chronoshift:StartChronoshift(caster,target,duration)
	if caster and target then
		caster:EmitSound("Hero_FacelessVoid.TimeWalk")
		target:EmitSound("Hero_FacelessVoid.Chronosphere")
		ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chronoshift.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
		Creates a new particle effect
		]]
		local cmod
		if caster ~= target then
			cmod = caster:AddNewModifier(caster, self, "modifier_chronoshift_caster", {Duration=duration})
		end
		local mod = target:AddNewModifier(caster, self, "modifier_chronoshift", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		mod.chronoshift_data = {
			position = target:GetAbsOrigin(),
			health = target:GetHealth(),
			mana = target:GetMana(),
			caster_mod = cmod
		}

		return mod
	end
end

modifier_chronoshift_caster = class({})

modifier_chronoshift_end = class({})

function modifier_chronoshift_end:GetEffectName()
	return "particles/units/heroes/hero_timekeeper/timekeeper_chronoshift_unit_end.vpcf"
end

if IsServer() then

	function modifier_chronoshift_end:OnDestroy()
		if self.chronoshift_link then
			local mod = self.chronoshift_link

			if self:GetParent():IsAlive() then
				mod:EndChronoshift()
			end
		end
	end

end

modifier_chronoshift = class({})

function modifier_chronoshift:GetEffectName()
	return "particles/units/heroes/hero_timekeeper/timekeeper_chronoshift_unit.vpcf"
end

if IsServer() then

	function modifier_chronoshift:EndChronoshift()
		local p = self:GetParent()

		local pos,hp,mp,cmod

		if self.chronoshift_data then
			pos = self.chronoshift_data.position
			hp = self.chronoshift_data.health
			mp = self.chronoshift_data.mana
			cmod = self.chronoshift_data.caster_mod
		else
			return
		end

		p:EmitSound("Hero_Weaver.TimeLapse")

		p:Purge(false,true,false,true,false)
		ProjectileManager:ProjectileDodge(p) --[[Returns:void
		Makes the specified unit dodge projectiles
		]]

		ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_chronoshift_resume.vpcf", PATTACH_ABSORIGIN_FOLLOW, p) --[[Returns:int
		Creates a new particle effect
		]]

		FindClearSpaceForUnit(p, pos, true)
		
		p:SetHealth(hp)
		p:SetMana(hp)

		if cmod then if not cmod:IsNull() then cmod:Destroy() end end
		self:Destroy()
	end

	function modifier_chronoshift:OnDestroy()
		local cmod
		if self.chronoshift_data then
			-- pos = self.chronoshift_data.position
			-- hp = self.chronoshift_data.health
			-- mp = self.chronoshift_data.mana
			cmod = self.chronoshift_data.caster_mod
		else
			return
		end
		self:GetAbility():GetCaster():FindAbilityByName("timekeeper_chronoshift_end"):SetHidden(true)
		self:GetAbility():SetHidden(false)
		if cmod then if not cmod:IsNull() then cmod:Destroy() end end
	end

end