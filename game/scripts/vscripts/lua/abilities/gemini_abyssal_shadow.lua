gemini_abyssal_shadow = class({})

LinkLuaModifier("modifier_abyssal_shadow","lua/abilities/gemini_abyssal_shadow",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_shadow_off","lua/abilities/gemini_abyssal_shadow",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abyssal_shadow_stick","lua/abilities/gemini_abyssal_shadow",LUA_MODIFIER_MOTION_NONE)

function gemini_abyssal_shadow:OnSpellStart()
	local c = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	c:AddNewModifier(c, self, "modifier_abyssal_shadow", {Duration=duration})
end

modifier_abyssal_shadow = class({})

function modifier_abyssal_shadow:OnCreated()
	self:SummonUnit()
end

function modifier_abyssal_shadow:OnRefresh()
	self:SummonUnit()
end

function modifier_abyssal_shadow:SummonUnit()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local offset = caster:GetForwardVector() * -50
		local origin = caster:GetAbsOrigin() + offset
		local player = caster:GetPlayerID()
		local unit_name = "npc_dota_unit_abyssal_shadow"

		if caster.abyssal_shadow_unit then
			self:RemoveUnit()
		end

		local lvl = self:GetAbility():GetSpecialValueFor("level")

		local unit = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		-- unit:SetPlayerID(caster:GetPlayerID())
		unit:SetOwner(caster)
		unit:CreatureLevelUp(lvl-1)
		-- unit:SetControllableByPlayer(player, true)

		CreateParticleHitloc(unit,"particles/units/heroes/hero_gemini/abyssal_shadow_summon.vpcf")
		unit:EmitSound("Hero_Terrorblade.Metamorphosis")

		local ab1 = unit:FindAbilityByName("abyssal_shadow_void_strikes")

		ab1:SetLevel(lvl)

		unit:AddNewModifier(caster, self, "modifier_abyssal_shadow_stick", {}) --[[Returns:void
		No Description Set
		]]



		unit.stick_to = caster
		caster.abyssal_shadow_unit = unit
	end
end

function modifier_abyssal_shadow:RemoveUnit()
	if self:GetParent().abyssal_shadow_unit then
		if not self:GetParent().abyssal_shadow_unit:IsNull() then
			self:GetParent().abyssal_shadow_unit:EmitSound("Hero_Nevermore.Death")
			self:GetParent().abyssal_shadow_unit:Kill(self, self:GetParent())
		end

		self:GetParent().abyssal_shadow_unit = nil
	end
end

function modifier_abyssal_shadow:OnDestroy()
	-- Particle
	self:RemoveUnit()
end

function modifier_abyssal_shadow:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_DEATH
	}
	return func
end

function modifier_abyssal_shadow:OnDeath(params)
	if params.unit == self:GetParent() then
		-- Particle
		self:RemoveUnit()
	end
end

modifier_abyssal_shadow_off = class({})

function modifier_abyssal_shadow_off:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

modifier_abyssal_shadow_stick = class({})

function modifier_abyssal_shadow_stick:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_abyssal_shadow_stick:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()
		if p.stick_to then
			local cont = p.stick_to
			local fv = cont:GetForwardVector()
			local offset = fv * -50
			local height = Vector(0,0,85)
			p:SetAbsOrigin(cont:GetAbsOrigin()+offset+height)

			if not p:IsAttacking() then
				p:SetForwardVector(fv)
			end

			if cont:IsAttacking() then
				local attack_target = cont:GetAttackTarget()
				local attack_range = p:GetAttackRange()

				if attack_target:IsHero() or attack_target:IsCreep() or attack_target:IsCreature() then

					if p:GetRangeToUnit(attack_target) <= attack_range then
						p:SetForceAttackTarget(attack_target)
					else
						p:SetForceAttackTarget(nil)
					end
					
				end
			else
				p:SetForceAttackTarget(nil)
			end
		end
	end
end

function modifier_abyssal_shadow_stick:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
	return state
end