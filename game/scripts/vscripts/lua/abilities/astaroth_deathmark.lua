astaroth_deathmark = class({})

LinkLuaModifier("modifier_astaroth_deathmark","lua/abilities/astaroth_deathmark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astaroth_deathmark_buff","lua/abilities/astaroth_deathmark",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astaroth_deathmark_stack","lua/abilities/astaroth_deathmark",LUA_MODIFIER_MOTION_NONE)

function astaroth_deathmark:GetIntrinsicModifierName()
	return "modifier_astaroth_deathmark"
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_astaroth_deathmark = class({})

function modifier_astaroth_deathmark:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_astaroth_deathmark:OnAttackLanded(params)

	local attacker = params.attacker
	local target = params.target or params.unit
	local dur = self:GetAbility():GetSpecialValueFor("duration")
	local buff_dur = self:GetAbility():GetSpecialValueFor("bonus_duration")
	local stack = self:GetAbility():GetSpecialValueFor("hits")
	local stun = self:GetAbility():GetSpecialValueFor("stun")
	local base_cooldown = self:GetAbility().BaseClass.GetCooldown(self:GetAbility(), self:GetAbility():GetLevel())
	local mod = self

	if attacker ~= self:GetParent() then return end
	if not self:GetAbility():IsCooldownReady() then return end
	if not target:IsHero() then return end

	if not target.deathmark_particle then
		target.deathmark_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_black_insignia.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(target.deathmark_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)
	end
	
	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_black_insignia_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControlEnt(p2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)

	if not target:HasModifier("modifier_astaroth_deathmark_stack") then
		mod = target:AddNewModifier(attacker, self:GetAbility(), "modifier_astaroth_deathmark_stack", {Duration = dur}) --[[Returns:void
		No Description Set
		]]
		mod:SetStackCount(1)
	else
		mod = target:FindModifierByName("modifier_astaroth_deathmark_stack")
		mod:IncrementStackCount()
		ParticleManager:SetParticleControl(target.deathmark_particle, 1, Vector(mod:GetStackCount(),0,0))
		if mod:GetStackCount() >= stack then
			local hp = target:GetHealth()
			local mult = 1-(self:GetAbility():GetSpecialValueFor("removal")/100)
			-- do particle stuff
			mod:Destroy()
			self:GetAbility():StartCooldown(base_cooldown)
			target:ModifyHealth(hp*mult, self:GetAbility(), false, -1) --[[Returns:void
			Sets the health to a specific value, with optional flags or inflictors.
			]]
			target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
			No Description Set
			]]
			local p = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControlEnt(p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)
			if target.deathmark_particle then ParticleManager:DestroyParticle(target.deathmark_particle,true) target.deathmark_particle = nil end
			attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_astaroth_deathmark_buff", {Duration = buff_dur})
		end
	end
	target:EmitSound("Astaroth.B"..mod:GetStackCount()+2)
end

function modifier_astaroth_deathmark:IsHidden()
	return true
end

modifier_astaroth_deathmark_buff = class({})

function modifier_astaroth_deathmark_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
	return funcs
end

function modifier_astaroth_deathmark_buff:GetModifierAttackSpeedBonus_Constant()
	local bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	if IsServer() then
		if self:GetAbility():GetCaster():GetHasTalent("special_bonus_astaroth_black_insignia") then
			bonus = bonus + 250
		end
	end
	return bonus
end

function modifier_astaroth_deathmark_buff:GetModifierProcAttack_BonusDamage_Pure()
	local r = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if r == 0 then r = self:GetAbility():GetLevel()*10 + 10 end
	return r
end

function modifier_astaroth_deathmark_buff:OnAttackStart(params)
	if IsServer() then
		if self:GetAbility():GetCaster():GetHasTalent("special_bonus_astaroth_black_insignia") then
			if params.attacker == self:GetParent() then
				IncreaseAttackSpeedCap(self:GetParent(),10000)
			end
		end
	end
end

function modifier_astaroth_deathmark_buff:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():EmitSound("Astaroth.BuffHit")
			local target = params.target
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_astaroth/astaroth_buff_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) --[[Returns:int
			Creates a new particle effect
			]]
			ParticleManager:SetParticleControlEnt(p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetCenter(), true)
		end
	end
end

function modifier_astaroth_deathmark_buff:OnDestroy()
	if IsServer() then
		if self:GetAbility():GetCaster():GetHasTalent("special_bonus_astaroth_black_insignia") then
			RevertAttackSpeedCap(self:GetParent())
		end
	end
end

modifier_astaroth_deathmark_stack = class({})

function modifier_astaroth_deathmark_stack:OnDestroy()
	
	if self:GetParent().deathmark_particle then
		ParticleManager:DestroyParticle(self:GetParent().deathmark_particle,false)
	end

end