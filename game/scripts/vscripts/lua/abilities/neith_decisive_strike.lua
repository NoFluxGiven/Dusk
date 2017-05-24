neith_decisive_strike = class({})

LinkLuaModifier("modifier_decisive_strike_slow","lua/abilities/neith_decisive_strike",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_decisive_strike_buff","lua/abilities/neith_decisive_strike",LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	function neith_decisive_strike:OnSpellStart()
		local c = self:GetCaster()
		local r = self:GetSpecialValueFor("hit_radius")
		local d = self:GetAbilityDamage()
		local dtype = self:GetAbilityDamageType()
		local s = self:GetSpecialValueFor("stun")
		local duration = self:GetSpecialValueFor("duration")

		local t

		local en = FindEnemiesRandom(c,c:GetAbsOrigin(),r)

		t = en[1]

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_neith/neith_decisive_blow.vpcf", PATTACH_ABSORIGIN_FOLLOW, c) --[[Returns:int
		Creates a new particle effect
		]]
		ParticleManager:SetParticleControl(p, 2, Vector(0,1,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		c:EmitSound("Hero_LegionCommander.Courage")

		if t then
			t:AddNewModifier(c, self, "modifier_stunned", {Duration = s}) --[[Returns:void
			No Description Set
			]]
			t:AddNewModifier(c, self, "modifier_decisive_strike_slow", {Duration = duration}) --[[Returns:void
			No Description Set
			]]
			c:AddNewModifier(c, self, "modifier_decisive_strike_buff", {Duration = duration}) --[[Returns:void
			No Description Set
			]]
			self:InflictDamage(t,c,d,dtype)
			if self:FetchTalent() then
				c:PerformAttack( t, true, true, true, true, false, false, true )
			end
		end
	end
end

modifier_decisive_strike_buff = class({})

function modifier_decisive_strike_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_decisive_strike_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor")
end

modifier_decisive_strike_slow = class({})

function modifier_decisive_strike_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_decisive_strike_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_decisive_strike_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_decisive_strike_slow:GetModifierPhysicalArmorBonus()
	return -self:GetAbility():GetSpecialValueFor("armor")
end
