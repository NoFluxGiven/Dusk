neith_monsoon = class({})

LinkLuaModifier("modifier_monsoon","lua/abilities/neith_monsoon",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monsoon_user","lua/abilities/neith_monsoon",LUA_MODIFIER_MOTION_NONE)

function neith_monsoon:GetCooldown(level)
	local base_cooldown = self.BaseClass.GetCooldown(self, level)
	local t_cooldown_reduction = self:GetCaster():FindTalentValue("special_bonus_neith_5") or 0

	return base_cooldown - t_cooldown_reduction
end

function neith_monsoon:Whirl( damage, dtype, radius )
	local c = self:GetCaster()

	if c:IsStunned() then return end

	local base_damage = damage
	local bonus_damage = 0
	local radius_increase = self:GetSpecialValueFor("radius_increase")
	local damage_increase_heroes = self:GetSpecialValueFor("damage_increase_heroes")
	local damage_increase_creeps = self:GetSpecialValueFor("damage_increase_creeps")

	local p = ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_practos/axe_attack_blur_counterhelix_practos.vpcf", PATTACH_POINT_FOLLOW, c)
	c:EmitSound("Hero_LegionCommander.Courage")

	local en = FindEnemies(c,c:GetAbsOrigin(),radius)

	for k,v in pairs(en) do
		self:InflictDamage(v,c,damage,dtype)

		if v:IsRealHero() then
			bonus_damage = bonus_damage + damage_increase_heroes
		else
			bonus_damage = bonus_damage + damage_increase_creeps
		end
	end

	for k,v in pairs(en) do
		self:InflictDamage(v,c,base_damage + bonus_damage,dtype)
	end
end

function neith_monsoon:OnSpellStart()
	local c = self:GetCaster()
	local radius = self:GetSpecialValueFor("shock_radius")
	local damage = self:GetAbilityDamage()
	local dtype = self:GetAbilityDamageType()

	local interval = self:GetSpecialValueFor("interval")

	local spins = self:GetSpecialValueFor("spins")

	for i=0, spins-1 do
		Timers:CreateTimer(interval * i, function()
			self:Whirl( damage, dtype, radius )
		end)
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