alexander_godfall = class({})

LinkLuaModifier("modifier_godfall","lua/abilities/alexander_godfall",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_godfall_bolts","lua/abilities/alexander_godfall",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_godfall_debuff","lua/abilities/alexander_godfall",LUA_MODIFIER_MOTION_NONE)

function alexander_godfall:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local aghanims_cooldown = self:GetSpecialValueFor("scepter_cooldown")
	if self:GetCaster():HasScepter() then return aghanims_cooldown end
	return base_cooldown
end

function alexander_godfall:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Alexander.Godfall.Charge")
	local p = "particles/units/heroes/hero_alexander/godfall_start.vpcf"
	self.p_index = ParticleManager:CreateParticle(p, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster()) --[[Returns:int
		Creates a new particle effect
		]]
	ParticleManager:SetParticleControlEnt(self.p_index,0,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetCaster():GetCenter(),true)
	return true
end

function alexander_godfall:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	
	ParticleManager:DestroyParticle(self.p_index,false)
	caster:StopSound("Alexander.Godfall.Charge") --[[Returns:void
	Stops a named sound playing from this entity.
	]]
end

function alexander_godfall:OnSpellStart(interrupted)
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration")--[[Returns:table
	No Description Set
	]]

	local ps = "particles/units/heroes/hero_alexander/godfall_success.vpcf"
	local p = ParticleManager:CreateParticle(ps, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster()) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p,0,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetCaster():GetCenter(),true)

	-- caster:AddNewModifier(caster, self, "modifier_godfall", {Duration = duration}) --[[Returns:void
	-- No Description Set
	-- ]]

	-- Create thinker that:
		-- Periodically creates damaging AoEs (with particles)
		-- AoEs purge off buffs
		-- AoEs heal allies as well
		-- Lasts for duration

	self.bolt_origin = caster:GetAbsOrigin()

	self.thinker = CreateModifierThinker(caster, self, "modifier_godfall_bolts", {Duration=duration}, self.bolt_origin, caster:GetTeamNumber(), false)

	self.thinker:EmitSound("Alexander.Godfall.Bolts")

	self.godfall_formation_particle_name = "particles/units/heroes/hero_alexander/raise_the_shield_formation.vpcf"
	self.godfall_formation_particle = CreateParticleWorld( self.bolt_origin, self.godfall_formation_particle_name ) 
	-- self.godfall_formation_particle = ParticleManager:CreateParticle(self.godfall_formation_particle_name, PATTACH_ABSORIGIN_FOLLOW, caster ) 

	ParticleManager:SetParticleControl(self.godfall_formation_particle, 1, Vector(1,0,0))
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

modifier_godfall_bolts = class({})

function modifier_godfall_bolts:IsHidden() return true end
function modifier_godfall_bolts:IsPurgable() return false end

function modifier_godfall_bolts:OnCreated(kv)
	self.bolt_radius = self:GetAbility():GetSpecialValueFor("bolt_radius")
	-- self.bolt_radius = 175
	self.bolt_damage = self:GetAbility():GetSpecialValueFor("bolt_damage")
	self.bolt_interval = self:GetAbility():GetSpecialValueFor("bolt_interval")
	-- self.bolt_interval = 0.1
	self.bolt_debuff_duration = self:GetAbility():GetSpecialValueFor("bolt_debuff_duration")
	self.bolt_count = self:GetAbility():GetSpecialValueFor("bolt_count")
	-- self.bolt_count = 4
	self.bolt_damage_type = DAMAGE_TYPE_PURE
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	-- self.radius = 225
	self.min_radius = self.bolt_radius

	local total_radius = self.radius * self.bolt_count

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetAbility().bolt_origin, total_radius, self:GetDuration() + 2.0, false)

	self.bolts_over_duration = self:GetDuration() / self.bolt_interval

	self.ticks = 0

	self:StartIntervalThink(self.bolt_interval)
end

function modifier_godfall_bolts:FireBolt(position,damage)
	if not IsServer() then return end
	-- local origin = self:GetAbility().bolt_origin
	local origin = self:GetAbility():GetCaster():GetAbsOrigin()
	local radius = self.radius
	local min_radius = self.min_radius
	local pct = self:GetRemainingTime() / self:GetDuration()
	-- local pct = 1
	-- local final_radius = math.max(radius*pct, min_radius)
	-- local final_radius = math.max(min_radius, RandomInt(0, radius * pct * 2))
	-- local final_radius = math.max(min_radius, radius * pct)
	local final_radius = radius

	-- -- Calculate the angle between each point on the circle
	-- -- (This is in radians, the full circle is 2*pi radians)
	-- local angle = 2 * math.pi / self.bolt_count
	-- local radius = final_radius

	-- for i=1,self.bolt_count do
	-- 	-- Create direction vector from the angle
	-- 	local direction = Vector(math.cos(angle * i), math.sin(angle * i))
	-- 	-- Multiply the direction (length 1) with the desired radius of the circle
	-- 	local circlePoint = direction * radius

	-- 	-- Add the calculated green vector to the player position and do something
	-- 	placement = origin + circlePoint
	-- end

	-- local placement = origin + RandomVector(final_radius)
	local placement = position

	self.bolt_particle = CreateParticleWorld(placement+Vector(0,0,25), "particles/units/heroes/hero_alexander/godfall_ground_hit.vpcf")
	-- sound

	-- RotatePosition(origin + Vector(), 75, origin)

	local found = FindEnemies(self:GetAbility():GetCaster(), placement, self.bolt_radius)
	-- local found_ally = FindAllies(self:GetAbility():GetCaster(), placement, self.bolt_radius)

	for k,v in pairs(found) do
		DealDamage(v,self:GetAbility():GetCaster(),damage,self.bolt_damage_type,self:GetAbility(),0)
		-- v:Purge(true, false, false, false, false)
		v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_godfall_debuff", {Duration=self.bolt_debuff_duration})
	end

	-- for k,v in pairs(found_ally) do
	-- 	v:Heal(self.bolt_damage / 2, self:GetAbility():GetCaster())
	-- end
end

function modifier_godfall_bolts:OnIntervalThink()

	if not IsServer() then return end

	local pct = self:GetRemainingTime() / self:GetDuration()

	ParticleManager:SetParticleControl(self:GetAbility().godfall_formation_particle, 1, Vector(pct*100,0,0))

	self.ticks = self.ticks + 1

	local n_base = 1
	local n = n_base

	repeat
		-- Timers:CreateTimer(self.ticks * 0.06, function()
			-- local origin = self:GetAbility():GetCaster():GetAbsOrigin()
			local origin = self:GetAbility().bolt_origin
			local radius = self.radius * n
			local bolts = 10 * n
			-- local pct = 1
			-- local final_radius = math.max(radius*pct, min_radius)
			-- local final_radius = math.max(min_radius, RandomInt(0, radius * pct * 2))
			-- local final_radius = math.max(min_radius, radius * pct)

			-- Calculate the angle between each point on the circle
			-- (This is in radians, the full circle is 2*pi radians)
			local angle = 2 * math.pi / bolts

			local rotate = 1
			if n % 2 == 0 then rotate = -rotate end

			-- rotate = rotate / (1/n)

			-- for i=1,self.bolt_count do
				-- Create direction vector from the angle
				local direction = Vector(math.cos(angle * (self.ticks) * rotate), math.sin(angle * (self.ticks) * rotate))
				local direction2 = Vector(math.cos(angle * (self.ticks + bolts/2) * rotate), math.sin(angle * (self.ticks + bolts/2) * rotate))
				-- Multiply the direction (length 1) with the desired radius of the circle
				local circlePoint = direction * radius
				local circlePoint2 = direction2 * radius

				-- Add the calculated green vector to the player position and do something
				local placement = origin + circlePoint
				local placement2 = origin + circlePoint2
			-- end

			-- Timers:CreateTimer(n * 0.06, function()
				self:FireBolt(placement, self.bolt_damage)
				self:FireBolt(placement2, self.bolt_damage)
			-- end)
		-- end)
		n = n+1
	until n >= self.bolt_count + n_base

	-- self.bolt_count = self.bolt_count + 1
end

function modifier_godfall_bolts:OnDestroy()
	-- self:GetAbility():GetCaster():StopSound("Alexander.Godfall.Charged")
	if not IsServer() then return end
	self:GetAbility().thinker:StopSound("Alexander.Godfall.Bolts")
	StartSoundEventFromPosition("Alexander.Godfall.Bolts.End", self:GetAbility().bolt_origin)
	ParticleManager:DestroyParticle(self:GetAbility().godfall_formation_particle, false)
end

modifier_godfall = class({})

function modifier_godfall:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_godfall:GetEffectName()
	return "particles/units/heroes/hero_alexander/godfall_charged.vpcf"
end

function modifier_godfall:OnAttackLanded(params)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local parent = self:GetParent()
		local attacker = params.attacker
		local target = params.target

		if attacker ~= parent then return end

		local damage = attacker:GetAverageTrueAttackDamage(attacker)

		local t_multiplier_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_alexander_3") or 0

		local m = (self:GetAbility():GetSpecialValueFor("damage")+t_multiplier_bonus) / 100

		damage = damage * m

		if target:IsIllusion() then damage = damage * 5 end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alexander/godfall_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, Vector(0,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) --[[Returns:void
		No Description Set
		]]

		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.5}) --[[Returns:void
		No Description Set
		]]

		target:Purge(true,false,false,false,false)

		self:GetAbility():InflictDamage(target,caster,damage,DAMAGE_TYPE_PURE)

		target:EmitSound("Alexander.Godfall")

		if target:IsRealHero() then attacker:Heal(damage, caster) end
		if caster:HasScepter() then
			local soulseal = caster:FindAbilityByName("alexander_soulseal")
			local scepter_radius = self:GetAbility():GetSpecialValueFor("scepter_radius")
			local enemies = FindEnemies( caster, target:GetAbsOrigin(), scepter_radius )
			for k,v in pairs(enemies) do
				soulseal:SetCursorCastTarget(v)
				soulseal:OnSpellStart()
			end
		end

		self:Destroy()
	end
end

--------------------------------------------------------------------------------------------------------------

modifier_godfall_debuff = class({})

function modifier_godfall_debuff:IsHidden() return false end
function modifier_godfall_debuff:IsPurgable() return true end

function modifier_godfall_debuff:OnCreated(kv)
	self.bolt_damage_reduction = self:GetAbility():GetSpecialValueFor("bolt_damage_reduction")
	self.bolt_damage_reduction_maximum = self:GetAbility():GetSpecialValueFor("bolt_damage_reduction_maximum")
end

function modifier_godfall_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_godfall_debuff:GetModifierDamageOutgoing_Percentage()
	return -self:GetStackCount()
end

function modifier_godfall_debuff:OnRefresh()
	self:SetStackCount(
		math.min(
			self:GetStackCount() + self.bolt_damage_reduction,
			self.bolt_damage_reduction_maximum
		)
	)
end