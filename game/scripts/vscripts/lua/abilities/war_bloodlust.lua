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
		local radius = self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]
		local stacks = self:GetAbility():GetSpecialValueFor("duration") --[[Returns:table
		No Description Set
		]]

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/bloodlust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		local enemy_found = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),radius)

		for k,v in pairs(enemy_found) do
			v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_bloodlust", {Duration=-1, stacks=stacks}) --[[Returns:void
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
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_bloodlust:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_damage") --[[Returns:table
	No Description Set
	]]
end

function modifier_bloodlust:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") --[[Returns:table
	No Description Set
	]]
end

function modifier_bloodlust:OnCreated(kv)
	self:StartIntervalThink(1.0)
	if IsServer() then
		self:SetStackCount(math.floor(kv.stacks))
		local t_damage_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_war_3") or 0
		self.damage = self:GetAbility():GetSpecialValueFor("dot") + t_damage_bonus
	end
end

function modifier_bloodlust:OnIntervalThink()
	if IsServer() then
		local damage = self.damage
		DealDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		self:SetStackCount(self:GetStackCount()-1)
		if self:GetStackCount() <= 0 then self:Destroy() end
	end
end

function modifier_bloodlust:OnAttackLanded(kv)
	-- if IsServer() then
		if kv.attacker == self:GetParent() then
			if self:GetStackCount()-1 > 0 then
				self:SetStackCount(self:GetStackCount()-1)
			else
				self:Destroy()
			end
		end
	-- end
end

function modifier_bloodlust:GetEffectName()
	return "particles/units/heroes/hero_war/bloodlust_unit.vpcf"
end

function modifier_bloodlust:IsPurgable()
	return true
end