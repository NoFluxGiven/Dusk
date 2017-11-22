phantom_soul_wave = class({})

LinkLuaModifier("modifier_soul_wave","lua/abilities/phantom_soul_wave",LUA_MODIFIER_MOTION_NONE)

function phantom_soul_wave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local enemies = FindEnemies(caster,caster:GetAbsOrigin(),radius)

		local t_slow_duration_bonus = self:GetCaster():FetchTalent("special_bonus_phantom_2") or 0
		local slow_duration = self:GetSpecialValueFor("slow_duration") + t_slow_duration_bonus

		local mult = self:GetSpecialValueFor("mult")

		local damage = ( caster:GetStrength() + caster:GetIntellect() + caster:GetAgility() ) * mult

		caster:EmitSound("Phantom.SoulWave")

		CreateParticleHitloc(caster, "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_explode.vpcf")

		for k,v in pairs(enemies) do
			self:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
			v:AddNewModifier(caster, self, "modifier_soul_wave", {Duration=slow_duration})
		end
	end
end

modifier_soul_wave = class({})

function modifier_soul_wave:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_soul_wave:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end