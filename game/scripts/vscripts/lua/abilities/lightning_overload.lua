lightning_overload = class({})

LinkLuaModifier("modifier_overload_slow","lua/abilities/lightning_overload",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overload_invuln","lua/abilities/lightning_overload",LUA_MODIFIER_MOTION_NONE)

function lightning_overload:OnSpellStart()
	local c = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local slow_duration = self:GetSpecialValueFor("slow_duration")
	--local stun_duration = self:GetSpecialValueFor("ministun")
	local invuln_duration = self:GetSpecialValueFor("invuln_duration")
	local bonus = c:FindTalentValue("special_bonus_lightning_2") or 0
	local damage = self:GetSpecialValueFor("damage") + bonus
	local dtype = self:GetAbilityDamageType()

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_lightning/overload.vpcf", PATTACH_ABSORIGIN_FOLLOW, c)

	--ParticleManager:SetParticleControl(p, 0, c:GetAbsOrigin())
	ParticleManager:SetParticleControl(p, 1, Vector(radius, 0, 0))

	Timers:CreateTimer(invuln_duration,function()
		ParticleManager:DestroyParticle(p,false)
	end)

	c:EmitSound("Lightning.Overload")

	c:AddNewModifier(c, self, "modifier_overload_invuln", {Duration=invuln_duration}) --[[Returns:void
		No Description Set
		]]

	ProjectileManager:ProjectileDodge(c)

	local en = FindEnemies(c,c:GetAbsOrigin(),radius)

	for k,v in pairs(en) do
		self:InflictDamage(v,c,damage,dtype)
		v:AddNewModifier(c, self, "modifier_overload_slow", {Duration=slow_duration}) --[[Returns:void
		No Description Set
		]]
	end
end

modifier_overload_slow = class({})

function modifier_overload_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_overload_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_overload_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

modifier_overload_slow = class({})

function modifier_overload_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_overload_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_overload_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

modifier_overload_invuln = class({})

function modifier_overload_invuln:CheckState()
	local state = {
		--[MODIFIER_STATE_STUNNED] = true,
		--[MODIFIER_STATE_MUTED] = true,
		--[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end

function modifier_overload_invuln:OnCreated(kv)
	if IsServer() then
		--self:GetParent():AddNoDraw()
	end
end

function modifier_overload_invuln:OnDestroy(kv)
	if IsServer() then
		--self:GetParent():RemoveNoDraw()
	end
end

function modifier_overload_invuln:GetStatusEffect()
	return "particles/status_fx/status_effect_goo_crimson.vpcf"
end

function modifier_overload_invuln:IsHidden()
	return true
end