fate_chains_of_fate = class({})

LinkLuaModifier("modifier_chains_of_fate","lua/abilities/fate_chains_of_fate",LUA_MODIFIER_MOTION_NONE)

function fate_chains_of_fate:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local t_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_fate_2") or 0

	local duration = self:GetSpecialValueFor("duration") + t_duration_bonus

	target:AddNewModifier(caster, self, "modifier_chains_of_fate", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_chains_of_fate = class({})

function modifier_chains_of_fate:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return func
end

function modifier_chains_of_fate:GetEffectName()
	return "particles/units/heroes/hero_fate/fate_chains_of_fate_buff.vpcf"
end

function modifier_chains_of_fate:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Fate.ChainsOfFate.Start")
		self:GetParent():EmitSound("Fate.ChainsOfFate.Ambience")
	end
end

function modifier_chains_of_fate:OnRefresh()
	if IsServer() then
		self:GetParent():EmitSound("Fate.ChainsOfFate.Start")
		self:GetParent():EmitSound("Fate.ChainsOfFate.Ambience")
	end
end

function modifier_chains_of_fate:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_chains_of_fate:OnTakeDamage(params)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local cpos = caster:GetAbsOrigin()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()

		local received = params.original_damage

		local unit = params.unit

		if unit == parent then return end

		local damage_hero = self:GetAbility():GetSpecialValueFor("damage_hero") / 100
		local damage_creep = self:GetAbility():GetSpecialValueFor("damage_creep") / 100

		local damage = damage_hero

		if parent:GetRangeToUnit(unit) < radius then
			if not unit:IsRealHero() then
				damage = damage_creep
			end
			self:GetAbility():InflictDamage(parent,caster,received*damage,DAMAGE_TYPE_MAGICAL)
			--Particle
			--Sound
		end
	end
end