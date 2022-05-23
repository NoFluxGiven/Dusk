siegfried_hell_bent = class({})

LinkLuaModifier("modifier_hell_bent","lua/abilities/siegfried_hell_bent",LUA_MODIFIER_MOTION_NONE)

function siegfried_hell_bent:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()

		local duration = self:GetSpecialValueFor("duration")

		local mod = caster:AddNewModifier(caster, self, "modifier_hell_bent", {Duration=duration, attack_target=target})

		ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster()) 
		self:GetCaster():EmitSound("Hero_Sven.GodsStrength")

		mod.attack_target = target
	end
end

modifier_hell_bent = class({})

function modifier_hell_bent:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_hell_bent:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true
	}
	return state
end

function modifier_hell_bent:GetModifierAttackSpeedBonus_Constant()
	local t_attack_speed_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_siegfried_3") or 0
	return self:GetAbility():GetSpecialValueFor("attack_speed") + t_attack_speed_bonus
end

function modifier_hell_bent:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_hell_bent:GetModifierIncomingPhysicalDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_hell_bent:IsPurgable()
	return true
end

function modifier_hell_bent:OnAttackLanded(params)
	if IsServer() then
		if params.attacker ~= self:GetParent() then return end
		--local duration = self:GetAbility():GetSpecialValueFor("ministun") --[[Returns:table
		--No Description Set
		--]]
		local target = params.target or params.unit
		if not target:IsHero() then ToolsPrint("Not a Hero.") return end
	end
end

function modifier_hell_bent:OnCreated(kv)
	if IsServer() then
		local amt = self:GetAbility():GetSpecialValueFor("health_reduction") / 100
		self:StartIntervalThink(0.03)

		self:GetParent():ModifyHealth(self:GetParent():GetHealth()*(1-amt), self:GetAbility(), false, 0)
	end
end

function modifier_hell_bent:OnIntervalThink()
	if IsServer() then
		local target = self:GetParent()

		local caster = self.attack_target

		--target:Purge(false,true,false,true,false)

		target:SetForceAttackTarget(nil)
		if caster:IsAlive() then
			Orders:IssueAttackOrder(target,caster)
		else
			self:Destroy()
			target:SetForceAttackTarget(nil)
			return
		end
		target:SetForceAttackTarget(caster)
	end
end

function modifier_hell_bent:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTarget(nil)
	end
end

function modifier_hell_bent:IsHidden()
	return false
end

function modifier_hell_bent:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end