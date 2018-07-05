neith_monsoon = class({})

LinkLuaModifier("modifier_monsoon","lua/abilities/neith_monsoon",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monsoon_user","lua/abilities/neith_monsoon",LUA_MODIFIER_MOTION_NONE)

function neith_monsoon:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FetchTalent("special_bonus_neith_5") or 0

	return base_cooldown - t_cooldown_reduction
end

function neith_monsoon:OnSpellStart()
	local c = self:GetCaster()
	local radius = self:GetSpecialValueFor("shock_radius")
	local t_attack_steal_bonus = c:FetchTalent("special_bonus_neith_4") or 0
	local attack_steal = self:GetSpecialValueFor("attack_steal") + t_attack_steal_bonus
	local duration = self:GetSpecialValueFor("duration")
	local damage = self:GetAbilityDamage()
	local dtype = self:GetAbilityDamageType()

	local p = ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_practos/axe_attack_blur_counterhelix_practos.vpcf", PATTACH_POINT_FOLLOW, c)
	c:EmitSound("Hero_LegionCommander.Courage")

	local en = FindEnemies(c,c:GetAbsOrigin(),radius)

	for k,v in pairs(en) do
		self:InflictDamage(v,c,damage,dtype)
		v:AddNewModifier(c, self, "modifier_monsoon", {Duration=duration, stacks=attack_steal})
		c:AddNewModifier(c, self, "modifier_monsoon_user", {Duration=duration, stacks=attack_steal})
	end
end

modifier_monsoon = class({})

function modifier_monsoon:OnCreated(kv)
	if IsServer() then
		local stacks = kv.stacks

		self:SetStackCount(stacks)
	end
end

function modifier_monsoon:OnRefresh(kv)
	if IsServer() then
		local stacks = kv.stacks

		self:SetStackCount(self:GetStackCount()+stacks)
	end
end

function modifier_monsoon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_monsoon:GetModifierPreAttack_BonusDamage()
	return -self:GetStackCount()
end

function modifier_monsoon:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_monsoon:IsPurgable()
	return true
end

function modifier_monsoon:IsDebuff()
	return true
end

modifier_monsoon_user = class({})

function modifier_monsoon_user:OnCreated(kv)
	if IsServer() then
		local stacks = kv.stacks

		self:SetStackCount(stacks)
	end
end

function modifier_monsoon_user:OnRefresh(kv)
	if IsServer() then
		local stacks = kv.stacks

		self:SetStackCount(self:GetStackCount()+stacks)
	end
end

function modifier_monsoon_user:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_monsoon_user:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_monsoon_user:IsPurgable()
	return true
end