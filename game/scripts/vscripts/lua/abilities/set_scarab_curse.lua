set_scarab_curse = class({})

LinkLuaModifier("modifier_scarab_curse","lua/abilities/set_scarab_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scarab_curse_display","lua/abilities/set_scarab_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scarab_curse_damage_steal","lua/abilities/set_scarab_curse",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scarab_curse_damage_steal_display","lua/abilities/set_scarab_curse",LUA_MODIFIER_MOTION_NONE)

function set_scarab_curse:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		local ab = caster:FindAbilityByName("set_switch_scarab_targets")

		ab:SetLevel(1)

		ab:SetActivated(false)
	end
end

function set_scarab_curse:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		local ab = caster:FindAbilityByName("set_switch_scarab_targets")

		local duration = self:GetSpecialValueFor("duration")

		ab:SetActivated(true)

		Timers:CreateTimer(duration,function() ab:SetActivated(false) end)

		target:AddNewModifier(caster, self, "modifier_scarab_curse", {Duration=duration})
	end
end

modifier_scarab_curse = class({})

function modifier_scarab_curse:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return func
end

function modifier_scarab_curse:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_scarab_curse:GetModifierProvidesFOWVision()
	return 1
end

function modifier_scarab_curse:OnDeath(params)
	if IsServer() then
		local target = params.unit
		if target == self:GetParent() then
			local enemies = FindEnemiesRandom(self:GetAbility():GetCaster(),target:GetAbsOrigin(),700)

			if #enemies > 0 then
				self:TransferDebuff(target,enemies[1])
			end
		end
	end
end

function modifier_scarab_curse:TransferDebuff(source,target)
	if IsServer() then
		if source and target then
			local mod_kv = {
				Duration = self:GetRemainingTime(),
				stack = self:GetStackCount(),
				transfer = true
			}

			target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_scarab_curse", mod_kv)
			target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_scarab_curse_display", {Duration=self:GetRemainingTime()})

			local mod = source:FindModifierByName("modifier_scarab_curse_display")

			mod:Destroy()
			self:Destroy()
		end
	end
end

function modifier_scarab_curse:OnCreated(kv)
	if IsServer() then

		local p = self:GetParent()

		if not kv.transfer then
			-- First cast
			-- Grab attack damage
			
			local admg = math.ceil(p:GetAverageTrueAttackDamage(p))
			local bdmg = self:GetAbility():GetSpecialValueFor("base_damage")

			local pct = self:GetAbility():GetSpecialValueFor("percent_damage_reduction") / 100

			local t_interval_reduction = self:GetAbility():GetCaster():FindTalentValue("special_bonus_set_4") or 0
			local interval = self:GetAbility():GetSpecialValueFor("interval") + t_interval_reduction

			local stack = math.ceil(pct * admg) + bdmg

			local mod_kv = {
				Duration=self:GetDuration(),
				stack=stack
			}

			p:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_scarab_curse_display", {Duration=self:GetDuration()})
			p:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_scarab_curse_damage_steal_display", {Duration=self:GetDuration()})

			p:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_scarab_curse_damage_steal", mod_kv)

			self:SetStackCount(stack)

			self:StartIntervalThink(interval)
		else
			local t_interval_reduction = self:GetAbility():GetCaster():FindTalentValue("special_bonus_set_4") or 0
			local interval = self:GetAbility():GetSpecialValueFor("interval") + t_interval_reduction
			local stack = kv.stack

			self:StartIntervalThink(interval)
			self:SetStackCount(stack)
		end

		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_set/scarab_curse_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
		ParticleManager:SetParticleControl(part, 1, Vector(150,0,0))

		self:AddParticle( part, false, false, 10, false, false )

		p:EmitSound("Set.ScarabCurse")
	end
end

function modifier_scarab_curse:OnDestroy()
	if IsServer() then
		local p = self:GetParent()

		p:StopSound("Set.ScarabCurse")
	end
end

function modifier_scarab_curse:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()
		self:GetAbility():InflictDamage(p,self:GetAbility():GetCaster(),self:GetStackCount(),DAMAGE_TYPE_PHYSICAL)

		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_set/scarab_curse_ring_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, p)
		ParticleManager:SetParticleControl(part, 1, Vector(150,0,0))
		p:EmitSound("Set.ScarabCurse.Damage")
	end
end

function modifier_scarab_curse:IsHidden()
	return true
end

modifier_scarab_curse_display = class({})

modifier_scarab_curse_damage_steal = class({})

function modifier_scarab_curse_damage_steal:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return func
end

function modifier_scarab_curse_damage_steal:GetModifierPreAttack_BonusDamage()
	return -self:GetStackCount()
end

function modifier_scarab_curse_damage_steal:IsHidden()
	return true
end

function modifier_scarab_curse_damage_steal:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

modifier_scarab_curse_damage_steal_display = class({})