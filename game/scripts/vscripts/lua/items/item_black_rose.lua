item_black_rose = class({})

LinkLuaModifier("modifier_black_rose","lua/items/item_black_rose",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_rose_delay","lua/items/item_black_rose",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_rose_delay_master","lua/items/item_black_rose",LUA_MODIFIER_MOTION_NONE)

function item_black_rose:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		if target:HasModifier("modifier_black_rose_delay") or target:HasModifier("modifier_black_rose") then
			return false
		end

		return true
	end
end

function item_black_rose:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		if target:TriggerSpellAbsorb(self) then return end

		local delay = self:GetSpecialValueFor("active_delay")
		local duration = self:GetSpecialValueFor("active_duration")
		local max_distance = self:GetSpecialValueFor("max_distance")

		local mod_caster = caster:AddNewModifier(caster, self, "modifier_black_rose_delay", {Duration=delay})
		local mod_target = target:AddNewModifier(caster, self, "modifier_black_rose_delay", {Duration=delay})

		local pc = CreateParticleHitloc(caster,"particles/items/black_rose_debuff.vpcf")
		local pt = CreateParticleHitloc(target,"particles/items/black_rose_debuff.vpcf")

		mod_caster:AddParticle( pc, false, false, 10, false, false )
		mod_target:AddParticle( pt, false, false, 10, false, false )

		caster:EmitSound("BlackRose.StartUp")
		target:EmitSound("BlackRose.StartUp")

		Timers:CreateTimer(delay,function()
			if caster:GetRangeToUnit(target) < max_distance and caster:IsAlive() and target:IsAlive() then
				local mod_caster = caster:AddNewModifier(caster, self, "modifier_black_rose", {Duration=duration})
				local mod_target = target:AddNewModifier(caster, self, "modifier_black_rose", {Duration=duration})
			end
		end)
	end
end

modifier_black_rose_delay = class({})

-- function modifier_black_rose_delay:OnDestroy()
-- 	if IsServer() then
-- 		if self:WasPurged() then
-- 			if self.linkedTo then
-- 				-- if we were purged, destroy the linked master modifier
-- 				if IsValidEntity(self.linkedTo) then
-- 					self.linkedTo.linkedTo = nil
-- 					self.linkedTo:Destroy()
-- 				end
-- 			end
-- 		end
-- 	end
-- end

function modifier_black_rose_delay:IsPurgable()
	return false
end

modifier_black_rose = class({})

function modifier_black_rose:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return func
end

function modifier_black_rose:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_black_rose:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_black_rose:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("active_damage_increase")
end

function modifier_black_rose:OnCreated(kv)
	if IsServer() then
		if self:GetAbility():GetCaster():GetTeam() ~= self:GetParent():GetTeam() then
			local damage = self:GetAbility():GetSpecialValueFor("damage")

			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_PURE)
		end
		local pt = CreateParticleHitloc(self:GetParent(),"particles/items/black_rose_stun.vpcf")
		self:AddParticle( pt, false, false, 10, false, false )
		self:GetParent():EmitSound("BlackRose.Target")
	end
end

function modifier_black_rose:IsPurgable()
	return false
end
