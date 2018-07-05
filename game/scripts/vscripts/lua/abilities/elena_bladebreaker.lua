elena_bladebreaker = class({})

LinkLuaModifier("modifier_bladebreaker","lua/abilities/elena_bladebreaker",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bladebreaker_effect","lua/abilities/elena_bladebreaker",LUA_MODIFIER_MOTION_NONE)

function elena_bladebreaker:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local f = FindEnemies(caster,caster:GetAbsOrigin(),radius)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_elena/bladebreaker_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	caster:EmitSound("Elena.Bladebreaker.Cast")

	for k,v in pairs(f) do
		v:AddNewModifier(caster, self, "modifier_bladebreaker", {Duration=duration}) --[[Returns:void
		No Description Set
		]]
	end
end

modifier_bladebreaker = class({})

function modifier_bladebreaker:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

if IsServer() then

	function modifier_bladebreaker:OnCreated()
		CreateParticleHitloc(self:GetParent(),"particles/units/heroes/hero_elena/bladebreaker.vpcf")
		self:StartIntervalThink(0.1)
	end

	function modifier_bladebreaker:OnIntervalThink()
		if self:GetParent():IsDisarmed() then
			self:SetDuration(self:GetRemainingTime()+0.1,true)
		end
	end

	function modifier_bladebreaker:OnAttackLanded(params)
		local attacker = params.attacker
		local damage = self:GetAbility():GetSpecialValueFor("base_damage")
		local t_adamage_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_elena_4") or 0
		local adamage = (self:GetAbility():GetSpecialValueFor("attack_damage")+t_adamage_bonus)/100

		local duration = self:GetAbility():GetSpecialValueFor("disarm_duration")

		local att = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())

		adamage = att * adamage

		damage = damage+adamage

		if attacker == self:GetParent() then
			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_PURE)
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_bladebreaker_effect", {Duration=duration})
			--self:SetDuration(self:GetRemainingTime()+duration,true)
			CreateParticleHitloc(self:GetParent(),"particles/units/heroes/hero_elena/bladebreaker_damage.vpcf")
			self:GetParent():EmitSound("Elena.Bladebreaker.Damage")
		end
	end

end

modifier_bladebreaker_effect = class({})

function modifier_bladebreaker_effect:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

function modifier_bladebreaker_effect:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_bladebreaker_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end