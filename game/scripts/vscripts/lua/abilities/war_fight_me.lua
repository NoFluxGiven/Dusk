war_fight_me = class({})

LinkLuaModifier("modifier_fight_me","lua/abilities/war_fight_me",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fight_me_regen","lua/abilities/war_fight_me",LUA_MODIFIER_MOTION_NONE)

function war_fight_me:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")

	local duration = self:GetSpecialValueFor("duration")

	local mod = "modifier_fight_me"
	local mod2 = "modifier_fight_me_regen"

	local enemy_found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

	caster:Hold()

	caster:EmitSound("War.FightMe")

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	caster.fight_me_damage = caster:GetAverageTrueAttackDamage(caster)

	for k,v in pairs(enemy_found) do
		if not v:IsMagicImmune() then
			v:AddNewModifier(caster, self, mod, {Duration=duration-0.1})
			local atk_dmg = v:GetAverageTrueAttackDamage(v)

			if not v:IsRealHero() then
				atk_dmg = atk_dmg * 0.33
			end
			
			caster.fight_me_damage = caster.fight_me_damage + atk_dmg
		end
	end

	caster:AddNewModifier(caster, self, mod2, {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_fight_me = class({})

function modifier_fight_me:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_fight_me:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") --[[Returns:table
	No Description Set
	]]
end

function modifier_fight_me:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_fight_me:OnIntervalThink()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()

		target:SetForceAttackTarget(nil)
		if caster:IsAlive() then
			Orders:IssueAttackOrder(target,caster)
		else
			local mod = target:FindModifierByName("modifier_fight_me")
			if mod then
				mod:Destroy()
			end
		end
		target:SetForceAttackTarget(target)
	end
end

function modifier_fight_me:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()

		target:SetForceAttackTarget(nil)
	end
end

modifier_fight_me_regen = class({})

function modifier_fight_me_regen:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		if caster.fight_me_damage then
			local all = FindEnemies(caster,caster:GetAbsOrigin(),99999)
			for k,v in pairs(all) do
				if v:HasModifier("modifier_fight_me") then
					v:RemoveModifierByName("modifier_fight_me")
				end
			end

			if not caster:IsAlive() then return end

			caster:EmitSound("Hero_Axe.Berserkers_Call")

			local enemy_found = FindEnemies(caster,caster:GetAbsOrigin(),radius)
			
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
			Creates a new particle effect
			]]

			local dmg = caster.fight_me_damage
			local mult = self:GetAbility():GetSpecialValueFor("mult")/100
			dmg = dmg*mult

			ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
			Set the control point data for a control on a particle effect
			]]
			for k,v in pairs(enemy_found) do
				DealDamage(v,caster,dmg,DAMAGE_TYPE_MAGICAL)
			end

			caster.fight_me_damage = 0
		end
	end
end