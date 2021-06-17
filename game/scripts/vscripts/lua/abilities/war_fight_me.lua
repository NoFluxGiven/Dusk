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
		end
	end

	caster:AddNewModifier(caster, self, mod2, {Duration=duration, stacks=1}) --[[Returns:void
	No Description Set
	]]
end

modifier_fight_me = class({})

function modifier_fight_me:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_FINISHED
	}
	return funcs
end

function modifier_fight_me:CheckState()
	local state = self.state
	return state
end

function modifier_fight_me:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") --[[Returns:table
	No Description Set
	]]
end

function modifier_fight_me:OnCreated(params)
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

		self.state = {
			[MODIFIER_STATE_COMMAND_RESTRICTED] = target:IsAttacking() and true or false,
			[MODIFIER_STATE_TAUNTED] = true
		}
	end
end

function modifier_fight_me:OnAttackFinished(params)
	if ( params.attacker == self:GetParent() ) then
		if params.target:HasModifier("modifier_fight_me_regen") and params.attacker:IsRealHero() then
			local mod = params.target:FindModifierByName("modifier_fight_me_regen")

			mod:IncrementStackCount()
		end
	end
end

function modifier_fight_me:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()

		target:SetForceAttackTarget(nil)
	end
end

function modifier_fight_me:IsPurgable()
	return false
end

modifier_fight_me_regen = class({})

function modifier_fight_me_regen:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
		local additional_damage = self:GetAbility():GetSpecialValueFor("damage_per_attack") * self:GetStackCount()

		local dmg = base_damage + additional_damage

		-- Remove the modifier from all enemies with it

		local all = FindEnemies(caster,caster:GetAbsOrigin(),99999)

		for k,v in pairs(all) do
			if v:HasModifier("modifier_fight_me") then
				v:RemoveModifierByName("modifier_fight_me")
			end
		end

		if not caster:IsAlive() then return end

		-- Deal AOE damage

		local enemy_found = FindEnemies(caster,caster:GetAbsOrigin(),radius)
		
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				  ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

		caster:EmitSound("Hero_Axe.Berserkers_Call")

		for k,v in pairs(enemy_found) do
			self:GetAbility():InflictDamage(v,caster,dmg,self:GetAbility():GetAbilityDamageType())
			
		end
	end
end

function modifier_fight_me_regen:OnCreated(params)
	self:SetStackCount(params.stacks)
end

function modifier_fight_me_regen:IsPurgable()
	return false
end