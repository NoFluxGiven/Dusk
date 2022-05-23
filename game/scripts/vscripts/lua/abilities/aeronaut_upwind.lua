aeronaut_upwind = class({})

LinkLuaModifier("modifier_upwind","lua/abilities/aeronaut_upwind",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upwind_root","lua/abilities/aeronaut_upwind",LUA_MODIFIER_MOTION_NONE)

function aeronaut_upwind:OnAbilityPhaseStart()
	local caster = self:GetCaster()

	local pos = caster:GetAbsOrigin()

	local radius = self:GetSpecialValueFor("radius")

	WorldParticle("particles/units/heroes/hero_aeronaut/aeronaut_upwind_precast.vpcf",pos,{ [1] = Vector(radius,0,0) })
	caster:EmitSound("Hero_Invoker.Tornado.Cast")

	return true
end

function aeronaut_upwind:OnSpellStart()
	local caster = self:GetCaster()

	local pos = caster:GetAbsOrigin()

	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")

	local t_c_duration_bonus = self:GetCaster():FindTalentValue("special_bonus_aeronaut_5") or 0
	local c_duration = self:GetSpecialValueFor("bonus_duration") + duration + t_c_duration_bonus

	local enemies = FindEnemies(caster,pos,radius)

	local p = WorldParticle("particles/units/heroes/hero_aeronaut/aeronaut_upwind.vpcf",pos,{ [1] = Vector(radius,0,0) })
	
	caster:EmitSound("Hero_Invoker.Tornado")

	caster:FadeGesture(ACT_DOTA_RUN)

	StartAnimation(caster,{duration=0.75,activity=ACT_DOTA_RUN,rate=2.8})

	Timers:CreateTimer(duration,function()
		ParticleManager:DestroyParticle(p,false)
		caster:StopSound("Hero_Invoker.Tornado")
	end)

	caster:AddNewModifier(caster, self, "modifier_upwind", {Duration=c_duration})

	for k,v in pairs(enemies) do
		v:AddNewModifier(caster, self, "modifier_upwind_root", {Duration=duration})
		self:InflictDamage(v,caster,damage,DAMAGE_TYPE_PURE)
	end
end

function aeronaut_upwind:OnUpgrade()
	local ab = self:GetCaster():FindAbilityByName("aeronaut_land")

	ab:SetLevel(1)
end

modifier_upwind = class({})

function modifier_upwind:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end

function modifier_upwind:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
		--MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

-- function modifier_upwind:GetModifierMoveSpeedBonus_Percentage()
-- 	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
-- end

function modifier_upwind:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_upwind:GetActivityTranslationModifiers()
	return "haste"
end

function modifier_upwind:OnDestroy()
	if IsServer() then
		StartAnimation(self:GetParent(), {duration=1.5, activity=ACT_DOTA_IDLE_RARE, rate=1.25})
	end
end

function modifier_upwind:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target

		local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")

		if target:HasFlyMovementCapability() then
			--Particle
			self:GetAbility():InflictDamage(target,attacker,bonus_damage,DAMAGE_TYPE_MAGICAL)
		end
	end
end

modifier_upwind_root = class({})

function modifier_upwind_root:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end