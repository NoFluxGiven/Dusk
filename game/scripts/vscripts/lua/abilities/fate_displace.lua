fate_displace = class({})

LinkLuaModifier("modifier_displace","lua/abilities/fate_displace",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_displace_heal","lua/abilities/fate_displace",LUA_MODIFIER_MOTION_NONE)

function fate_displace:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_fate_1") or 0

	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus

	target:AddNewModifier(caster, self, "modifier_displace", {Duration=duration})
end

modifier_displace = class({})

function modifier_displace:GetEffectName()
	return "particles/units/heroes/hero_fate/fate_displace_buff.vpcf"
end

function modifier_displace:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_displace:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK
	}
	return func
end

function modifier_displace:GetDisableAutoAttack()
	return 1
end

function modifier_displace:CheckState()
	local state = {
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}

	return state
end

function modifier_displace:OnCreated()
	if IsServer() then
		ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_displace.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		self:GetParent():EmitSound("Fate.Displace.Start")
		self:GetParent():EmitSound("Fate.Displace.Ambience")

		ProjectileManager:ProjectileDodge(self:GetParent())
		self:GetParent():Purge(false,true,false,true,false)

		self.displace_stored_hp = self:GetParent():GetHealth()
	end
end

function modifier_displace:OnRefresh()
	if IsServer() then
		ParticleManager:CreateParticle("particles/units/heroes/hero_fate/fate_displace.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		self:GetParent():EmitSound("Fate.Displace.Start")
		self:GetParent():EmitSound("Fate.Displace.Ambience")

		ProjectileManager:ProjectileDodge(self:GetParent())
		self:GetParent():Purge(false,true,false,true,false)

		self.displace_stored_hp = self:GetParent():GetHealth()
	end
end

function modifier_displace:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Fate.Displace.Ambience")
	end
	-- 	local hp = self.displace_stored_hp
	-- 	local chp = self:GetParent():GetHealth()
	-- 	local diff = hp - chp

	-- 	local heal = 0

	-- 	local mult = self:GetAbility():GetSpecialValueFor("heal") / 100

	-- 	if diff > 0 then

	-- 		heal = diff * mult

	-- 	end

	-- 	local mod = self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_displace_heal", {Duration=self:GetAbility():GetSpecialValueFor("duration"),displace_heal=heal})
	-- end
end

function modifier_displace:IsPurgable()
	return false
end

modifier_displace_heal = class({})

function modifier_displace_heal:GetEffectName()
	return "particles/units/heroes/hero_fate/fate_displace_debuff.vpcf"
end

function modifier_displace_heal:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_displace_heal:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return func
end

function modifier_displace_heal:GetModifierConstantHealthRegen()
	local regen = self:GetStackCount()

	return regen
end

function modifier_displace_heal:OnCreated(kv)
	if IsServer() then
		self:GetParent():EmitSound("Fate.Displace.Debuff")
		if kv.displace_heal then
			self:SetStackCount(math.ceil(kv.displace_heal/self:GetDuration()))
		end
	end
end

function modifier_displace_heal:IsPurgable()
	return false
end