reus_gaias_fury = class({})

LinkLuaModifier("modifier_gaias_fury","lua/abilities/reus_gaias_fury",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gaias_fury_slow","lua/abilities/reus_gaias_fury",LUA_MODIFIER_MOTION_NONE)

function reus_gaias_fury:OnSpellStart()
	local caster = self:GetCaster()

	local duration = 10 --self:GetSpecialValueFor("duration")

	--Particle
	caster:EmitSound("Hero_EarthSpirit.Magnetize.Cast")	

	caster:AddNewModifier(caster, self, "modifier_gaias_fury", {Duration=duration})
end

modifier_gaias_fury = class({})

function modifier_gaias_fury:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return func
end

function modifier_gaias_fury:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	return state
end

function modifier_gaias_fury:GetEffectName()
	return "particles/units/heroes/hero_reus/gaias_fury.vpcf"
end

function modifier_gaias_fury:OnAttackStart(params)
	local attacker = params.attacker

	if attacker == self:GetParent() then
		--Particle
		attacker:EmitSound("Hero_EarthShaker.Whoosh")
	end
end

function modifier_gaias_fury:OnAttackLanded(params)
	local attacker = params.attacker
	local target = params.target or params.unit

	if attacker == self:GetParent() then

		local t_stun_bonus = attacker:FindTalentValue("special_bonus_reus_2") or 0

		local stun = self:GetAbility():GetSpecialValueFor("stun") + t_stun_bonus
		local slow = self:GetAbility():GetSpecialValueFor("slow_duration")
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local damage_mult = self:GetAbility():GetSpecialValueFor("damage")

		local damage = attacker:GetStrength() * damage_mult

		local outer_damage = ( self:GetAbility():GetSpecialValueFor("cleave_damage") / 100 ) * damage

		if target:IsBuilding() then damage,stun = damage/4,stun/2 end

		local p = CreateParticleHitloc(target,"particles/units/heroes/hero_reus/gaias_fury_unit.vpcf")
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))
		--target:EmitSound("Hero_EarthShaker.EchoSlamSmall")
		target:EmitSound("Hero_EarthShaker.Fissure")
		
		Timers:CreateTimer(0.05,function()
			target:EmitSound("Hero_EarthSpirit.RollingBoulder.Target")
		end)
		

		self:GetAbility():InflictDamage(target,attacker,damage,DAMAGE_TYPE_PHYSICAL)

		target:AddNewModifier(attacker, nil, "modifier_stunned", {Duration=stun})

		self:Destroy()

		ScreenShake(attacker:GetCenter(), 1200, 350, 1, 1200, 0, true)

		local enemies = FindEnemies(attacker,target:GetAbsOrigin(),radius)

		for k,v in pairs(enemies) do
			if v ~= target then
				self:GetAbility():InflictDamage(v,attacker,outer_damage,DAMAGE_TYPE_PHYSICAL)
				v:AddNewModifier(attacker, self:GetAbility(), "modifier_gaias_fury_slow", {Duration=slow})
			end
		end

	end


end

modifier_gaias_fury_slow = class({})

function modifier_gaias_fury_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_gaias_fury_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end