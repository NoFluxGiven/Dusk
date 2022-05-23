timekeeper_futurestrike = class({})

LinkLuaModifier("modifier_futurestrike","lua/abilities/timekeeper_futurestrike",LUA_MODIFIER_MOTION_NONE)

function timekeeper_futurestrike:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FindTalentValue("special_bonus_timekeeper_5") or 0
	return base_cooldown - t_cooldown_reduction
end

function timekeeper_futurestrike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_max_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_timekeeper_2") or 0

	local min_damage = self:GetSpecialValueFor("min_damage")
	local max_damage = self:GetSpecialValueFor("max_damage") + t_max_damage_bonus

	local min_delay = self:GetSpecialValueFor("min_delay")
	local max_delay = self:GetSpecialValueFor("max_delay")

	local delay = RandomInt(min_delay, max_delay)

	local pct = delay/max_delay

	local dmg = math.ceil(max_damage*pct)

	if dmg < min_damage then dmg = min_damage end

	local end_time = math.floor(GameRules:GetGameTime() + delay)

	if not target:IsRealHero() then delay = delay/2 end

	local fs_table = {
		Duration = delay,
		fs_damage = dmg,
		fs_end_time = end_time
	}

	local mod = target:AddNewModifier(caster, self, "modifier_futurestrike", fs_table)

	target:EmitSound("Timekeeper.Futurestrike")
end

modifier_futurestrike = class({})

function modifier_futurestrike:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

if IsServer() then
	
	function modifier_futurestrike:OnCreated(kv)
		if kv then
			self.damage = kv.fs_damage
			self.end_time = fs_end_time
			self.dtype = self:GetAbility():GetAbilityDamageType()
		end

		local dur = self:GetDuration()

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_timekeeper/timekeeper_futurestrike.vpcf",
			PATTACH_OVERHEAD_FOLLOW,
			self:GetParent())

		ParticleManager:SetParticleControl(p, 1, Vector(dur,0,0))

		self:AddParticle( p, false, false, 1, false, true )

	end

	function modifier_futurestrike:OnDestroy()
		local target = self:GetParent()

		target:EmitSound("Timekeeper.Futurestrike.Boom")

		target:StopSound("Timekeeper.Futurestrike")

		if target:IsMagicImmune() then return end
		
		if self.damage then
			self:GetAbility():InflictDamage(target,self:GetAbility():GetCaster(),self.damage,self.dtype)
			target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.4})
		end
	end

end