war_bloodlust = class({})

LinkLuaModifier("modifier_bloodlust_thinker_area","lua/abilities/war_bloodlust",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodlust","lua/abilities/war_bloodlust",LUA_MODIFIER_MOTION_NONE)

function war_bloodlust:OnSpellStart()
	CreateModifierThinker( self:GetCaster(), self, "modifier_bloodlust_thinker_area", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

-- MODIFIERS

modifier_bloodlust_thinker_area = class({})

function modifier_bloodlust_thinker_area:OnCreated()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local stacks = self:GetAbility():GetSpecialValueFor("attacks")
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local interval = self:GetAbility():GetSpecialValueFor("interval")
		local attack_damage_pct = self:GetAbility():GetSpecialValueFor("attack_damage")

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/bloodlust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		local enemy_found = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),radius)

		for k,v in pairs(enemy_found) do
			v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_bloodlust", {Duration=duration, stacks=0, interval=interval, attack_damage_pct=attack_damage_pct}) --[[Returns:void
			No Description Set
			]]
		end

		self:GetParent():EmitSound("War.Bloodlust")

		Timers:CreateTimer(2,function() UTIL_Remove(self:GetParent()) end)
	end
end

modifier_bloodlust = class({})

function modifier_bloodlust:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
	return func
end

-- function modifier_bloodlust:GetModifierPreAttack_BonusDamage()
-- 	return self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
-- end

function modifier_bloodlust:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_bloodlust:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_bloodlust:OnCreated(kv)
	self:StartIntervalThink(kv.interval)
	self.interval = kv.interval
	self.attack_damage_pct = kv.attack_damage_pct

	if IsServer() then
		self:SetStackCount(math.floor(kv.stacks))
		local t_damage_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_war_3") or 0
		self.damage = self:GetAbility():GetSpecialValueFor("dot") + t_damage_bonus
	end
end

function modifier_bloodlust:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(math.floor(kv.stacks))
		local t_damage_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_war_3") or 0

		local new_damage = self:GetAbility():GetSpecialValueFor("dot") + t_damage_bonus

		if (self.damage < new_damage) then
			self.damage = new_damage
		end
	end
end

function modifier_bloodlust:OnIntervalThink()
	if IsServer() then
		local base_damage = self.damage + self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * (self.attack_damage_pct/100)
		local damage = base_damage * self.interval
		local is_creep = self:GetParent():IsCreep()

		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,self:GetAbility():GetAbilityDamageType())

		--if self:GetStackCount() <= 0 then self:Destroy() end
	end
end

function modifier_bloodlust:OnAttackLanded(kv)
	-- if IsServer() then
		if kv.attacker == self:GetParent() then
			-- if kv.attacker:HasModifier("modifier_fight_me") then return end
			if not kv.attacker:IsHero() then return end

			-- increase duration on attack
			self:SetDuration(self:GetRemainingTime()+2.00, true)

			-- if self:GetStackCount()-1 > 0 then
			-- 	self:SetStackCount(self:GetStackCount()-1)
			-- else
			-- 	self:Destroy()
			-- end
		end
	-- end
end

-- function modifier_bloodlust:OnDeath(params)
-- 	if params.attacker == self:GetParent() and params.unit:IsRealHero() or params.unit == self:GetAbility():GetCaster() then
-- 		self:Destroy()
-- 	end
-- end

function modifier_bloodlust:GetEffectName()
	return "particles/units/heroes/hero_war/bloodlust_unit.vpcf"
end

function modifier_bloodlust:IsPurgable()
	return true
end