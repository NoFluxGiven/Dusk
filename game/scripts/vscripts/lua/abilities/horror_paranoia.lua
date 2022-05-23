horror_paranoia = class({})

LinkLuaModifier("modifier_paranoia","lua/abilities/horror_paranoia",LUA_MODIFIER_MOTION_NONE)

function horror_paranoia:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	if target:TriggerSpellAbsorb(self) then return end

	target:EmitSound("Horror.Paranoia")

	target:AddNewModifier(caster, self, "modifier_paranoia", {Duration=duration})
end

modifier_paranoia = class({})

function modifier_paranoia:GetEffectName()
	return "particles/units/heroes/hero_horror/paranoia_overhead.vpcf"
end

function modifier_paranoia:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

if IsServer() then

	function modifier_paranoia:OnCreated()
		self:StartIntervalThink(1.0)
	end

	function modifier_paranoia:OnIntervalThink()
		local target = self:GetParent()
		local t_damage_mult = self:GetAbility():GetCaster():FindTalentValue("special_bonus_horror_4") or 1
		local damage_hero = self:GetAbility():GetSpecialValueFor("hero_damage") * t_damage_mult
		local damage_creep = self:GetAbility():GetSpecialValueFor("creep_damage") * t_damage_mult
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		print(damage_hero,damage_creep)

		local enemies = FindEnemies(self:GetAbility():GetCaster(), self:GetParent():GetAbsOrigin(), radius)

		local hn = 0
		local cn = 0

		for k,v in pairs(enemies) do
			if v == target then hn = hn - 0.5 end
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_horror/paranoia_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, v) --[[Returns:int
			Creates a new particle effect
			]]

			ParticleManager:SetParticleControlEnt(p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(p, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)

			if v:IsHero() then
				hn = hn + 1
			else
				cn = cn + 1
			end
		end

		local damage = damage_hero * hn + damage_creep * cn

		local n = RandomInt(1,4)

		if damage > 0 then
			target:EmitSound("Horror.Paranoia.Damage"..n)
			self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		end
	end

end