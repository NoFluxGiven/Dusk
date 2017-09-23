lupin_flashbang = class({})

LinkLuaModifier("modifier_flashbang_dazed","lua/abilities/lupin_flashbang",LUA_MODIFIER_MOTION_NONE)

function lupin_flashbang:OnSpellStart()
	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local t_damage_bonus = FetchTalent("special_bonus_lupin_2") or 0

	damage = damage+t_damage_bonus

	local t_duration_bonus = self:GetCaster():FetchTalent("special_bonus_lupin_4") or 0

	duration = duration + t_duration_bonus

	local found = FindEnemies(caster,caster:GetAbsOrigin(),radius)

	local p = CreateParticleHitloc(caster,"particles/units/heroes/hero_lupin/lupin_flashbang.vpcf")
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	caster:EmitSound("Lupin.Flashbang") --[[Returns:void
	 
	]]

	for k,v in pairs(found) do
		v:AddNewModifier(caster, self, "modifier_flashbang_dazed", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
		self:InflictDamage(v,caster,damage,DAMAGE_TYPE_PHYSICAL)
	end
end

modifier_flashbang_dazed = class({})

function modifier_flashbang_dazed:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_flashbang_dazed:OnTakeDamage(params)
	if self:GetParent() == params.unit then
		if self:GetElapsedTime() > 0.5 then
			if params.damage > 20 then
				self:Destroy()
			end
		end
	end
end

function modifier_flashbang_dazed:GetEffectName()
	return "particles/units/heroes/hero_lupin/dazed.vpcf"
end

function modifier_flashbang_dazed:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_flashbang_dazed:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_flashbang_dazed:IsPurgable()
	return true
end

function modifier_flashbang_dazed:IsDebuff()
	return true
end

function modifier_flashbang_dazed:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end